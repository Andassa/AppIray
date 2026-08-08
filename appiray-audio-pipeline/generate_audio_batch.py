"""
Génère en batch les fichiers audio malgaches à partir d'un CSV de phrases,
en utilisant un modèle VITS de la famille MMS (Meta) via Hugging Face Transformers.

Usage:
    python generate_audio_batch.py --input phrases_sample.csv --output-dir ./generated_audio

Le script ne pousse RIEN vers un serveur — il produit uniquement des fichiers
audio locaux (WAV, ou MP3/OGG plus légers pour le mobile) + un manifest.json.
L'upload se fait ensuite avec upload_to_appiray.py.
"""

import argparse
import csv
import json
import os
import re
import shutil
import sys
import unicodedata
from pathlib import Path

from dotenv import load_dotenv
from tqdm import tqdm

load_dotenv()

# Bitrates volontairement bas : c'est de la voix, pas de la musique. Objectif =
# fichiers légers pour du streaming mobile en contexte de connexion limitée.
MP3_BITRATE = "80k"
OGG_BITRATE = "64k"


def check_ffmpeg() -> None:
    """Vérifie que ffmpeg est installé (requis par pydub pour tout format != wav)."""
    if shutil.which("ffmpeg") is not None:
        return
    if sys.platform == "darwin":
        hint = "installe-le avec `brew install ffmpeg`"
    elif sys.platform.startswith("linux"):
        hint = "installe-le avec `sudo apt install ffmpeg` (ou l'équivalent de ta distro)"
    else:
        hint = "installe-le depuis https://ffmpeg.org/download.html et ajoute-le au PATH"
    print(
        f"[ERREUR] ffmpeg introuvable — requis pour la conversion audio, {hint}. "
        "Sinon, relance avec `--output-format wav` pour désactiver la conversion.",
        file=sys.stderr,
    )
    sys.exit(1)


def convert_audio(wav_path: Path, target_path: Path, output_format: str) -> None:
    """Convertit un WAV vers mp3/ogg via pydub+ffmpeg. Lève une exception si échec."""
    from pydub import AudioSegment

    audio = AudioSegment.from_wav(wav_path)
    if output_format == "mp3":
        audio.export(target_path, format="mp3", bitrate=MP3_BITRATE)
    elif output_format == "ogg":
        # OGG/Opus : très bon rapport qualité/taille pour la voix.
        audio.export(target_path, format="ogg", codec="libopus", bitrate=OGG_BITRATE)
    else:
        raise ValueError(f"Format de conversion non supporté: {output_format}")


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
        "--output-format",
        choices=["wav", "mp3", "ogg"],
        default="mp3",
        help=(
            "Format audio final. Défaut mp3 (le WAV est trop lourd pour du streaming "
            "mobile en connexion limitée). mp3/ogg nécessitent ffmpeg."
        ),
    )
    parser.add_argument(
        "--keep-wav",
        action="store_true",
        help="Conserve le .wav intermédiaire après conversion (par défaut il est supprimé)",
    )
    parser.add_argument(
        "--skip-existing",
        action="store_true",
        help="Ne régénère pas un fichier déjà présent dans output-dir",
    )
    args = parser.parse_args()

    # Fail fast : si conversion demandée, ffmpeg doit être présent AVANT de charger le modèle.
    if args.output_format != "wav":
        check_ffmpeg()

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
    conversion_failures = []

    for phrase in tqdm(phrases, desc="Génération audio"):
        base = slugify(phrase["id"])
        wav_name = f"{base}.wav"
        wav_path = args.output_dir / wav_name
        final_name = f"{base}.{args.output_format}"
        final_path = args.output_dir / final_name

        if args.skip_existing and final_path.exists():
            manifest_entries.append(
                {
                    "id": phrase["id"],
                    "text": phrase["text"],
                    "filename": final_name,
                    "path": str(final_path),
                    "format": args.output_format,
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

            scipy.io.wavfile.write(wav_path, rate=sampling_rate, data=waveform)
        except Exception as exc:  # on continue le batch même si une phrase échoue
            failures.append({"id": phrase["id"], "text": phrase["text"], "error": str(exc)})
            continue

        # Format final : soit on garde le WAV, soit on convertit (fallback honnête si échec).
        entry_filename = wav_name
        entry_path = wav_path
        entry_format = "wav"

        if args.output_format != "wav":
            try:
                convert_audio(wav_path, final_path, args.output_format)
                entry_filename = final_name
                entry_path = final_path
                entry_format = args.output_format
                if not args.keep_wav:
                    wav_path.unlink(missing_ok=True)
            except Exception as exc:
                # Conversion ratée : on garde le .wav pour cette entrée et on le signale.
                conversion_failures.append(
                    {"id": phrase["id"], "text": phrase["text"], "error": str(exc)}
                )

        manifest_entries.append(
            {
                "id": phrase["id"],
                "text": phrase["text"],
                "filename": entry_filename,
                "path": str(entry_path),
                "format": entry_format,
                "sampling_rate": sampling_rate,
                "voice_model_version": args.voice_version,
                "skipped": False,
            }
        )

    manifest_path = args.output_dir / "manifest.json"
    with open(manifest_path, "w", encoding="utf-8") as f:
        json.dump(manifest_entries, f, ensure_ascii=False, indent=2)

    print(
        f"\nTerminé : {len(manifest_entries)} fichiers générés/skip, "
        f"{len(failures)} échecs de génération, "
        f"{len(conversion_failures)} échecs de conversion (fallback WAV)."
    )
    print(f"Manifest écrit dans : {manifest_path}")

    if failures:
        failures_path = args.output_dir / "failures.json"
        with open(failures_path, "w", encoding="utf-8") as f:
            json.dump(failures, f, ensure_ascii=False, indent=2)
        print(f"Détail des échecs de génération dans : {failures_path}")

    if conversion_failures:
        conversion_failures_path = args.output_dir / "conversion_failures.json"
        with open(conversion_failures_path, "w", encoding="utf-8") as f:
            json.dump(conversion_failures, f, ensure_ascii=False, indent=2)
        print(
            "Certaines conversions ont échoué (WAV conservé pour ces entrées). "
            f"Détail dans : {conversion_failures_path}"
        )


if __name__ == "__main__":
    main()
