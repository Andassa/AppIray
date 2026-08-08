# AppIray — Pipeline de génération audio (TTS malgache)

Pipeline en 2 étapes, volontairement séparées de l'API AppIray (jamais d'inférence
TTS en temps réel derrière une requête utilisateur).

```
phrases.csv  →  [generate_audio_batch.py]  →  fichiers .mp3/.ogg/.wav + manifest.json
                                              →  [upload_to_appiray.py]  →  audio_assets (API AppIray)
```

## Prérequis

- Python 3.10+
- **`ffmpeg`** — requis dès que `--output-format` vaut autre chose que `wav` (soit
  le cas par défaut, `mp3`). La conversion `pydub` s'appuie dessus.
  - macOS : `brew install ffmpeg`
  - Linux : `sudo apt install ffmpeg`
  - Windows : https://ffmpeg.org/download.html (ajouter au PATH)

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

Options : `--model-name`, `--voice-version`, `--skip-existing`, `--output-format`, `--keep-wav`.

### Format de sortie (`--output-format`)

Choix : `wav`, `mp3` (défaut), `ogg`.

Le WAV brut du modèle est **trop lourd pour du streaming mobile** en contexte de
connexion limitée (Madagascar). Par défaut on produit donc du **MP3** (bitrate voix
~80 kbps), ou de l'**OGG/Opus** (~64 kbps, encore plus léger) :

```bash
# MP3 par défaut
python generate_audio_batch.py --input phrases_sample.csv

# OGG/Opus
python generate_audio_batch.py --input phrases_sample.csv --output-format ogg

# WAV brut (aucune conversion, aucun ffmpeg requis)
python generate_audio_batch.py --input phrases_sample.csv --output-format wav
```

Comportement :
- Le `.wav` intermédiaire est **supprimé après conversion réussie** (utilise
  `--keep-wav` pour le conserver).
- Le `manifest.json` reflète le format final : chaque entrée porte un champ `format`
  et un `filename`/`path` pointant vers le fichier réellement produit.
- **Fallback honnête** : si la conversion d'une phrase échoue, le batch continue, le
  `.wav` de cette phrase est conservé, l'entrée du manifest indique `format: "wav"`,
  et l'échec est consigné dans `conversion_failures.json`.

## Étape 2 — Uploader vers AppIray

```bash
python upload_to_appiray.py --manifest ./generated_audio/manifest.json
```

### Dédoublonnage

Par défaut, le script évite de renvoyer un audio déjà présent, via deux mécanismes :

1. **Serveur (best-effort)** : au démarrage, il liste les `audio_assets` existants
   (`GET /audio/assets`) et saute toute entrée dont le couple
   (`voice_model_version`, texte) est déjà en base.
   ⚠️ Le endpoint de listing **ne pagine pas** (plafond à 200 entrées côté backend) :
   au-delà, la dédup serveur peut être **incomplète** (un avertissement est affiché).
2. **Local (`uploaded.json`)** : un fichier `uploaded.json` est maintenu à côté du
   manifest et mis à jour **après chaque upload réussi**. Il permet une reprise rapide
   après une coupure réseau sans ré-interroger l'API. S'il existe déjà au démarrage,
   ses `id` sont sautés automatiquement.
   ⚠️ Cette dédup locale n'est **pas fiable entre plusieurs machines** (le fichier est
   local au dossier) : dans ce cas, seule la dédup serveur fait foi.

Le flag **`--force`** désactive **tout** le dédoublonnage (serveur + local) et force le
renvoi de chaque entrée — utile pour **remplacer** un audio existant :

```bash
python upload_to_appiray.py --manifest ./generated_audio/manifest.json --force
```

## Pour un gros volume

Lance `generate_audio_batch.py` sur Google Colab (GPU gratuit), utilise
`--skip-existing` pour reprendre la génération après interruption, et côté upload
`uploaded.json` permet de reprendre là où tu t'es arrêté.

## Une fois ton propre modèle fine-tuné prêt

Remplace `--model-name facebook/mms-tts-mlg` par le chemin de ton checkpoint,
augmente `--voice-version` pour distinguer les générations.
