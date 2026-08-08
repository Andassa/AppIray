# AppIray

Application d'apprentissage du malgache (Duolingo-like) + publications culturelles.

## Dossiers du projet

- [`appiray-backend/`](./appiray-backend/) — l'API (FastAPI) : auth, cours, progression, gamification, social, contenu, audio, notifications.
- [`appiray-audio-pipeline/`](./appiray-audio-pipeline/) — outil batch (indépendant du backend) de génération audio TTS malgache, puis upload des fichiers vers l'API.
