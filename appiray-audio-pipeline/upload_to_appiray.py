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

MAX_RETRIES = 3
RETRY_BACKOFF_SECONDS = 2


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
                files = {"file": (entry["filename"], audio_file, "audio/wav")}
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

    print(f"{len(entries)} fichiers à uploader vers {args.api_base}")
    print("Connexion admin...")
    token = get_admin_token(args.api_base, args.email, args.password)

    success_count = 0
    failed = []

    with httpx.Client() as client:
        for i, entry in enumerate(entries, 1):
            ok, message = upload_one(client, args.api_base, token, entry)
            status = "OK" if ok else "ECHEC"
            print(f"[{i}/{len(entries)}] {entry['id']} — {status}" + ("" if ok else f" ({message})"))
            if ok:
                success_count += 1
            else:
                failed.append({"id": entry["id"], "error": message})

    print(f"\nTerminé : {success_count} réussis, {len(failed)} échecs.")

    if failed:
        failed_path = args.manifest.parent / "upload_failures.json"
        with open(failed_path, "w", encoding="utf-8") as f:
            json.dump(failed, f, ensure_ascii=False, indent=2)
        print(f"Détail des échecs dans : {failed_path}")


if __name__ == "__main__":
    main()
