# AppIray — Pipeline de génération audio (TTS malgache)

Pipeline en 2 étapes, volontairement séparées de l'API AppIray (jamais d'inférence
TTS en temps réel derrière une requête utilisateur).

```
phrases.csv  →  [generate_audio_batch.py]  →  fichiers .wav + manifest.json
                                              →  [upload_to_appiray.py]  →  audio_assets (API AppIray)
```

## Installation

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
# édite .env : mets l'email/mot de passe d'un compte admin AppIray existant
```

## Étape 1 — Générer l'audio

```bash
python generate_audio_batch.py --input phrases_sample.csv --output-dir ./generated_audio
```

Options : `--model-name`, `--voice-version`, `--skip-existing`.

## Étape 2 — Uploader vers AppIray

```bash
python upload_to_appiray.py --manifest ./generated_audio/manifest.json
```

## Pour un gros volume

Lance `generate_audio_batch.py` sur Google Colab (GPU gratuit), utilise
`--skip-existing` pour reprendre après interruption.

## Une fois ton propre modèle fine-tuné prêt

Remplace `--model-name facebook/mms-tts-mlg` par le chemin de ton checkpoint,
augmente `--voice-version` pour distinguer les générations.
