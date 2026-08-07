# AppIray Backend

Backend FastAPI (monolithe modulaire) pour **AppIray** — apprentissage du malgache façon Duolingo, avec fil de publications culturelles (histoire, géographie, culture).

## Stack

- FastAPI (async) + SQLAlchemy 2.0 async + Alembic
- PostgreSQL + Redis
- JWT (access + refresh, blacklist Redis)
- Storage abstrait (local / S3-compatible Cloudflare R2)
- TaskQueue abstrait (APScheduler in-process → Celery plus tard)

## Démarrage local (Docker)

```bash
cd appiray-backend
cp .env.example .env
docker compose up --build
```

Services :

| Service  | URL |
|----------|-----|
| API      | http://localhost:8000 |
| Swagger  | http://localhost:8000/docs |
| Postgres | localhost:5432 |
| Redis    | localhost:6379 |

Les migrations Alembic sont appliquées au démarrage du conteneur `api`.

### Admin bootstrap (optionnel)

Dans `.env` :

```env
BOOTSTRAP_ADMIN_EMAIL=admin@example.com
BOOTSTRAP_ADMIN_PASSWORD=change-me
BOOTSTRAP_ADMIN_USERNAME=admin
```

## Migrations (hors Docker)

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
alembic revision --autogenerate -m "describe change"
```

## Tests

```bash
pip install -r requirements.txt
pytest -q
```

Les tests utilisent SQLite en mémoire + un faux Redis (pas besoin de Docker).

## Règles métier MVP (cœurs / streak / XP)

Documentées aussi dans `ProgressService` :

- **Cœurs** : départ à `MAX_HEARTS` (5). Mauvaise réponse = −1. Impossible de répondre si cœurs = 0.
- **XP** : `XP_PER_CORRECT_ANSWER` (10) par bonne réponse + `lesson.xp_reward` à la complétion de leçon.
- **Niveau** : `level = (xp_total // 100) + 1`.
- **Streak** : +1 si activité hier ; inchangé si déjà actif aujourd’hui ; reset par job quotidien si inactif > `STREAK_GRACE_HOURS`.

Si tu veux une autre logique (régénération temporelle des cœurs, etc.), on l’ajuste sans toucher à l’architecture.

## Structure

```
app/
  core/           # config, DB, JWT, Redis, storage, rate limit
  modules/
    auth/
    users/
    courses/
    progress/
    gamification/
    social/
    content/
    audio/
    notifications/
  workers/        # TaskQueue + jobs planifiés
  main.py
```

## API (aperçu)

Préfixe : `/api/v1`

- Auth : `POST /auth/register|login|refresh|logout`
- Users : `GET/PATCH /users/me`, `POST /users/me/avatar`
- Courses : CRUD admin + lecture leçons/exercices
- Progress : `POST /progress/answer`, `GET /progress/me`
- Gamification : ligue + leaderboard Redis, badges
- Social : amis + classement entre amis
- Content : publications publiques, likes/commentaires, CRUD admin
- Audio : CRUD `audio_assets` (pas de TTS temps réel)
- Notifications : liste + marquage lu

OpenAPI généré → base idéale pour générer un client Dart/Flutter.

## Passage Phase 2 (prod / traction)

### Cloudflare R2 (stockage)

1. Créer un bucket R2 + API token S3-compatible.
2. Dans `.env` :

```env
STORAGE_BACKEND=s3
S3_ENDPOINT_URL=https://<ACCOUNT_ID>.r2.cloudflarestorage.com
S3_ACCESS_KEY_ID=...
S3_SECRET_ACCESS_KEY=...
S3_BUCKET_NAME=appiray
S3_REGION=auto
PUBLIC_ASSET_BASE_URL=https://cdn.example.com
```

Le code appelant (`StorageBackend`) ne change pas.

### Celery (workers)

1. Ajouter un worker Celery + broker Redis dédié.
2. Implémenter `CeleryTaskQueue(TaskQueue)` dans `app/workers/`.
3. Brancher via `set_task_queue(...)` au démarrage.
4. Les jobs (`reset_inactive_streaks`, `close_weekly_leagues`) restent les mêmes fonctions.

### Scaling API

L’auth JWT est stateless → plusieurs instances derrière un load balancer, avec Redis partagé pour blacklist / rate limit / leaderboards.

## Pipeline audio (hors API)

Le fine-tuning / génération MMS-TTS (`facebook/mms-tts-mlg`) reste **offline en batch**.  
Ensuite : upload des fichiers via `POST /api/v1/audio/assets/upload` (admin) et liaison `audio_asset_id` sur les exercices.
