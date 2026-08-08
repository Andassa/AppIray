"""
Envoie les fichiers audio générés (manifest.json produit par generate_audio_batch.py)
vers le backend AppIray, via l'endpoint admin d'upload d'audio_assets.

Usage:
    python upload_to_appiray.py --manifest ./generated_audio/manifest.json

Nécessite un compte admin AppIray valide (variables APPIRAY_ADMIN_EMAIL /
APPIRAY_ADMIN_PASSWORD dans .env, ou passées en argument).

IMPORTANT: vérifie que AUTH_LOGIN_PATH et UPLOAD_PATH ci-dessous correspondent
exactement aux routes réelles du backend appiray-backend (module auth et module
audio). Si les noms de champs du endpoint d'upload diffèrent (ex: le nom du champ
fichier n'est pas "file", ou les noms de champs texte diffèrent), ajuste le
dictionnaire `files`/`data` dans upload_one() en conséquence.
"""

import argparse
import json
import os
import sys
import time
from pathlib import Path

import httpx
from dotenv import load_dotenv

load_dotenv()

AUTH_LOGIN_PATH = "/auth/login"
UPLOAD_PATH = "/audio/assets/upload"
LIST_PATH = "/audio/assets"

# Le endpoint de listing ne pagine pas (il renvoie au plus `limit`, max 200 côté
# backend). La déduplication serveur est donc "best-effort" au-delà de ce plafond.
LIST_LIMIT = 200

MAX_RETRIES = 3
RETRY_BACKOFF_SECONDS = 2

CONTENT_TYPES = {
    "wav": "audio/wav",
    "mp3": "audio/mpeg",
    "ogg": "audio/ogg",
}


def normalize_text(text: str) -> str:
    """Normalisation basique pour comparer des textes (dédoublonnage)."""
    return " ".join(text.strip().lower().split())


def content_type_for(entry: dict) -> str:
    fmt = entry.get("format")
    if not fmt:
        fmt = Path(entry.get("filename", "")).suffix.lstrip(".").lower()
    return CONTENT_TYPES.get(fmt, "application/octet-stream")


def get_admin_token(api_base: str, email: str, password: str) -> str:
    resp = httpx.post(
        f"{api_base}{AUTH_LOGIN_PATH}",
        json={"email": email, "password": password},
        timeout=30,
    )
    resp.raise_for_status()
    data = resp.json()
    token = data.get("access_token") or data.get("accessToken")
    if not token:
        raise RuntimeError(f"Réponse de login inattendue, pas de token trouvé: {data}")
    return token


def upload_one(
    client: httpx.Client, api_base: str, token: str, entry: dict
) -> tuple[bool, str]:
    filepath = Path(entry["path"])
    if not filepath.exists():
        return False, f"fichier introuvable: {filepath}"

    for attempt in range(1, MAX_RETRIES + 1):
        try:
            with open(filepath, "rb") as audio_file:
                files = {"file": (entry["filename"], audio_file, content_type_for(entry))}
                data = {
                    "text_malagasy": entry["text"],
                    "voice_model_version": entry["voice_model_version"],
                }
                resp = client.post(
                    f"{api_base}{UPLOAD_PATH}",
                    headers={"Authorization": f"Bearer {token}"},
                    files=files,
                    data=data,
                    timeout=60,
                )
            if resp.status_code in (200, 201):
                return True, "ok"
            if resp.status_code == 401:
                return False, "token expiré ou invalide (401) — relance le script"
            last_error = f"HTTP {resp.status_code}: {resp.text[:200]}"
        except httpx.HTTPError as exc:
            last_error = str(exc)

        if attempt < MAX_RETRIES:
            time.sleep(RETRY_BACKOFF_SECONDS * attempt)

    return False, last_error


def fetch_server_texts(
    client: httpx.Client, api_base: str, token: str
) -> tuple[set[tuple[str, str]] | None, bool]:
    """Récupère les (voice_model_version, texte normalisé) déjà en base.

    Retourne (set, capped) où `capped` indique que le plafond LIST_LIMIT a été
    atteint (donc dédup serveur potentiellement incomplète). Retourne (None, False)
    si le listing est indisponible → on retombe sur la dédup locale uniquement.
    """
    try:
        resp = client.get(
            f"{api_base}{LIST_PATH}",
            headers={"Authorization": f"Bearer {token}"},
            params={"limit": LIST_LIMIT},
            timeout=30,
        )
    except httpx.HTTPError as exc:
        print(f"[ATTENTION] Listing serveur indisponible ({exc}) — dédup locale seulement.")
        return None, False

    if resp.status_code != 200:
        print(
            f"[ATTENTION] Listing serveur a répondu {resp.status_code} — dédup locale seulement."
        )
        return None, False

    assets = resp.json()
    server_set = {
        (a.get("voice_model_version", ""), normalize_text(a.get("text_malagasy", "")))
        for a in assets
    }
    capped = len(assets) >= LIST_LIMIT
    return server_set, capped


def load_uploaded_ids(uploaded_path: Path) -> set[str]:
    if not uploaded_path.exists():
        return set()
    try:
        with open(uploaded_path, encoding="utf-8") as f:
            return set(json.load(f))
    except (json.JSONDecodeError, ValueError):
        print(f"[ATTENTION] {uploaded_path} illisible — ignoré.")
        return set()


def save_uploaded_ids(uploaded_path: Path, uploaded_ids: set[str]) -> None:
    with open(uploaded_path, "w", encoding="utf-8") as f:
        json.dump(sorted(uploaded_ids), f, ensure_ascii=False, indent=2)


def main():
    parser = argparse.ArgumentParser(description="Upload des audio_assets vers AppIray")
    parser.add_argument("--manifest", type=Path, required=True, help="Chemin du manifest.json")
    parser.add_argument(
        "--api-base", default=os.getenv("APPIRAY_API_BASE", "http://localhost:8000/api/v1")
    )
    parser.add_argument("--email", default=os.getenv("APPIRAY_ADMIN_EMAIL"))
    parser.add_argument("--password", default=os.getenv("APPIRAY_ADMIN_PASSWORD"))
    parser.add_argument(
        "--skip-flagged",
        action="store_true",
        help="Ignore les entrées marquées 'skipped' (déjà générées avant) dans le manifest",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help=(
            "Désactive tout le dédoublonnage (serveur + uploaded.json local) et "
            "force le renvoi de chaque entrée (utile pour remplacer un audio existant)"
        ),
    )
    args = parser.parse_args()

    if not args.email or not args.password:
        print(
            "Erreur: identifiants admin manquants. "
            "Renseigne APPIRAY_ADMIN_EMAIL / APPIRAY_ADMIN_PASSWORD dans .env "
            "ou passe --email/--password.",
            file=sys.stderr,
        )
        sys.exit(1)

    with open(args.manifest, encoding="utf-8") as f:
        entries = json.load(f)

    if args.skip_flagged:
        entries = [e for e in entries if not e.get("skipped")]

    uploaded_path = args.manifest.parent / "uploaded.json"
    uploaded_ids = set() if args.force else load_uploaded_ids(uploaded_path)
    if uploaded_ids:
        print(
            f"{len(uploaded_ids)} id(s) déjà présents dans {uploaded_path.name} "
            "— seront sautés automatiquement (utilise --force pour les renvoyer)."
        )

    print(f"{len(entries)} entrées dans le manifest, cible {args.api_base}")
    print("Connexion admin...")
    token = get_admin_token(args.api_base, args.email, args.password)

    success_count = 0
    skipped_count = 0
    failed = []

    with httpx.Client() as client:
        # Dédup serveur (best-effort) : liste les textes déjà enregistrés.
        server_set = None
        if not args.force:
            server_set, capped = fetch_server_texts(client, args.api_base, token)
            if server_set is not None:
                print(f"{len(server_set)} audio_asset(s) déjà en base pris en compte.")
                if capped:
                    print(
                        f"[ATTENTION] Le listing serveur est plafonné à {LIST_LIMIT} entrées : "
                        "la dédup serveur peut être incomplète au-delà."
                    )

        for i, entry in enumerate(entries, 1):
            prefix = f"[{i}/{len(entries)}] {entry['id']}"

            if not args.force:
                if entry["id"] in uploaded_ids:
                    print(f"{prefix} — IGNORE (déjà présent dans uploaded.json)")
                    skipped_count += 1
                    continue
                key = (
                    entry.get("voice_model_version", ""),
                    normalize_text(entry.get("text", "")),
                )
                if server_set is not None and key in server_set:
                    print(f"{prefix} — IGNORE (déjà présent côté serveur)")
                    skipped_count += 1
                    continue

            ok, message = upload_one(client, args.api_base, token, entry)
            status = "OK" if ok else "ECHEC"
            print(f"{prefix} — {status}" + ("" if ok else f" ({message})"))
            if ok:
                success_count += 1
                # Persiste immédiatement pour permettre une reprise après coupure réseau.
                uploaded_ids.add(entry["id"])
                save_uploaded_ids(uploaded_path, uploaded_ids)
            else:
                failed.append({"id": entry["id"], "error": message})

    print(
        f"\nTerminé : {success_count} réussis, {skipped_count} ignorés (déjà présents), "
        f"{len(failed)} échecs."
    )

    if failed:
        failed_path = args.manifest.parent / "upload_failures.json"
        with open(failed_path, "w", encoding="utf-8") as f:
            json.dump(failed, f, ensure_ascii=False, indent=2)
        print(f"Détail des échecs dans : {failed_path}")


if __name__ == "__main__":
    main()
