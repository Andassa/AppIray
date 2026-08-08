"""
Génère en batch les fichiers audio malgaches à partir d'un CSV de phrases,
en utilisant un modèle VITS de la famille MMS (Meta) via Hugging Face Transformers.

Usage:
    python generate_audio_batch.py --input phrases_sample.csv --output-dir ./generated_audio

Le script ne pousse RIEN vers un serveur — il produit uniquement des fichiers
.wav locaux + un manifest.json. L'upload se fait ensuite avec upload_to_appiray.py.
"""

import argparse
import csv
import json
import os
import re
import sys
import unicodedata
from pathlib import Path

from dotenv import load_dotenv
from tqdm import tqdm

load_dotenv()


def detect_device():
    """Choisit le meilleur device dispo (cuda > mps > cpu) et prévient si cpu."""
    import torch

    if torch.cuda.is_available():
        return "cuda"
    if torch.backends.mps.is_available():
        return "mps"
    print(
        "[ATTENTION] Aucun GPU détecté (ni CUDA ni MPS). "
        "La génération va tourner sur CPU : c'est lent, prévois un petit lot "
        "pour tester, ou utilise Google Colab pour un gros volume.",
        file=sys.stderr,
    )
    return "cpu"


def slugify(text: str, max_len: int = 40) -> str:
    """Transforme un texte en nom de fichier propre (fallback si pas d'id fourni)."""
    normalized = unicodedata.normalize("NFKD", text).encode("ascii", "ignore").decode()
    slug = re.sub(r"[^a-zA-Z0-9]+", "_", normalized).strip("_").lower()
    return slug[:max_len] or "phrase"


def load_phrases(input_path: Path) -> list[dict]:
    phrases = []
    with open(input_path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        required = {"id", "text"}
        if not required.issubset(reader.fieldnames or []):
            raise ValueError(
                f"Le CSV doit contenir au minimum les colonnes {required}, "
                f"trouvé: {reader.fieldnames}"
            )
        for row in reader:
            text = row["text"].strip()
            phrase_id = row["id"].strip()
            if not text or not phrase_id:
                continue
            phrases.append({"id": phrase_id, "text": text})
    return phrases


def main():
    parser = argparse.ArgumentParser(description="Génération audio batch MMS-TTS malgache")
    parser.add_argument("--input", type=Path, required=True, help="CSV avec colonnes id,text")
    parser.add_argument(
        "--output-dir", type=Path, default=Path("./generated_audio"), help="Dossier de sortie"
    )
    parser.add_argument(
        "--model-name",
        default=os.getenv("TTS_MODEL_NAME", "facebook/mms-tts-mlg"),
        help="Checkpoint Hugging Face à utiliser",
    )
    parser.add_argument(
        "--voice-version",
        default=os.getenv("VOICE_MODEL_VERSION", "mms-base-v1"),
        help="Étiquette de version stockée dans le manifest (et plus tard dans audio_assets)",
    )
    parser.add_argument(
        "--skip-existing",
        action="store_true",
        help="Ne régénère pas un fichier déjà présent dans output-dir",
    )
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)

    print(f"Chargement du modèle '{args.model_name}'...")
    import torch
    import scipy.io.wavfile
    from transformers import VitsModel, AutoTokenizer

    device = detect_device()
    model = VitsModel.from_pretrained(args.model_name).to(device)
    model.eval()
    tokenizer = AutoTokenizer.from_pretrained(args.model_name)
    sampling_rate = model.config.sampling_rate

    phrases = load_phrases(args.input)
    print(f"{len(phrases)} phrases à traiter.")

    manifest_entries = []
    failures = []

    for phrase in tqdm(phrases, desc="Génération audio"):
        filename = f"{slugify(phrase['id'])}.wav"
        filepath = args.output_dir / filename

        if args.skip_existing and filepath.exists():
            manifest_entries.append(
                {
                    "id": phrase["id"],
                    "text": phrase["text"],
                    "filename": filename,
                    "path": str(filepath),
                    "sampling_rate": sampling_rate,
                    "voice_model_version": args.voice_version,
                    "skipped": True,
                }
            )
            continue

        try:
            inputs = tokenizer(phrase["text"], return_tensors="pt").to(device)
            with torch.no_grad():
                output = model(**inputs).waveform

            waveform = output.squeeze().cpu().numpy()
            # normalisation simple en amplitude pour éviter les niveaux trop bas/écrêtés
            peak = max(abs(waveform.max()), abs(waveform.min()), 1e-8)
            waveform = waveform / peak * 0.95

            scipy.io.wavfile.write(filepath, rate=sampling_rate, data=waveform)

            manifest_entries.append(
                {
                    "id": phrase["id"],
                    "text": phrase["text"],
                    "filename": filename,
                    "path": str(filepath),
                    "sampling_rate": sampling_rate,
                    "voice_model_version": args.voice_version,
                    "skipped": False,
                }
            )
        except Exception as exc:  # on continue le batch même si une phrase échoue
            failures.append({"id": phrase["id"], "text": phrase["text"], "error": str(exc)})

    manifest_path = args.output_dir / "manifest.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest_entries, f, ensure_ascii=False, indent=2)

    print(f"\nTerminé : {len(manifest_entries)} fichiers générés/skip, {len(failures)} échecs.")
    print(f"Manifest écrit dans : {manifest_path}")

    if failures:
        failures_path = args.output_dir / "failures.json"
        with open(failures_path, "w", encoding="utf-8") as f:
            json.dump(failures, f, ensure_ascii=False, indent=2)
        print(f"Détail des échecs dans : {failures_path}")


if __name__ == "__main__":
    main()
