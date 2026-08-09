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

## Règles métier MVP (cœurs / streak / XP / gemmes)

Documentées aussi dans `ProgressService` :

- **Cœurs** : départ à `MAX_HEARTS` (5). Mauvaise réponse = −1. Impossible de répondre si cœurs = 0 (hors mode pratique).
- **Régénération des cœurs** : à la volée (pas de cron). Un cœur regagné toutes les `HEART_REFILL_MINUTES` ; `heart_refill_at` porte l’horodatage du prochain cœur, recalculé à chaque lecture du profil / de la progression.
- **XP** : `XP_PER_CORRECT_ANSWER` (10) par bonne réponse + `lesson.xp_reward` à la complétion de leçon.
- **Gemmes** : `+GEMS_PER_LESSON` par leçon terminée, `+GEMS_PER_DAILY_GOAL` quand l’objectif quotidien est atteint (une fois par jour).
- **Objectif quotidien** : `daily_xp_goal` (défaut `DEFAULT_DAILY_XP_GOAL`), modifiable via `PATCH /progress/daily-goal`.
- **Recharge instantanée** : `POST /progress/hearts/refill-with-gems` dépense `GEM_COST_HEART_REFILL` gemmes.
- **Streak freeze** : `POST /progress/streak/freeze` dépense `GEM_COST_STREAK_FREEZE` gemmes et protège la série pendant `STREAK_FREEZE_DAYS` jour(s). Le job de reset consomme un freeze actif avant de casser la série.
- **Mode pratique** : `GET /progress/practice` renvoie les exercices à réviser (taux d’erreur ≥ 30 %). Les réponses en pratique (`practice: true`) ne coûtent pas de cœurs et rapportent `PRACTICE_XP_REWARD` / `PRACTICE_GEMS_REWARD`.
- **Niveau** : `level = (xp_total // 100) + 1`.
- **Streak** : +1 si activité hier ; inchangé si déjà actif aujourd’hui ; reset par job quotidien si inactif > `STREAK_GRACE_HOURS` (sauf streak freeze actif).
- **Déverrouillage** : une leçon est accessible si la précédente de l’unité est complétée ; la 1re leçon d’une unité requiert l’unité précédente complète (`is_lesson_unlocked`). Test de positionnement : `GET/POST /courses/{id}/placement-test`.
- **Quêtes quotidiennes** : `GET /gamification/quests/me` génère 2-3 quêtes/jour (pool MVP dans `gamification/quests.py`), avancées automatiquement après chaque réponse.

La logique de sélection de révision et le pool de quêtes sont volontairement isolés (`ProgressService.select_practice_exercises`, `DEFAULT_QUEST_POOL`) pour être remplacés plus tard (répétition espacée, quêtes data-driven) sans refonte.

## Variables d'environnement ajoutées

| Variable | Défaut | Rôle |
|---|---|---|
| `HEART_REFILL_MINUTES` | 240 | Intervalle de régénération d’un cœur |
| `GEM_COST_HEART_REFILL` | 350 | Coût en gemmes pour recharger les cœurs à fond |
| `GEM_COST_STREAK_FREEZE` | 200 | Coût en gemmes d’un streak freeze |
| `STREAK_FREEZE_DAYS` | 1 | Durée de protection d’un streak freeze |
| `DEFAULT_DAILY_XP_GOAL` | 20 | Objectif XP quotidien par défaut |
| `GEMS_PER_LESSON` | 5 | Gemmes par leçon complétée |
| `GEMS_PER_DAILY_GOAL` | 20 | Gemmes à l’atteinte de l’objectif quotidien |
| `PRACTICE_XP_REWARD` | 5 | XP par bonne réponse en pratique |
| `PRACTICE_GEMS_REWARD` | 1 | Gemmes par bonne réponse en pratique |
| `PASSWORD_RESET_TOKEN_EXPIRE_MINUTES` | 30 | Durée de validité d’un token de reset |
| `EMAIL_VERIFICATION_TOKEN_EXPIRE_MINUTES` | 1440 | Durée de validité d’un token de vérification email |
| `PUBLIC_APP_URL` | http://localhost:8000 | Base des liens email (reset / vérification) |
| `EMAIL_SENDER_BACKEND` | log | Backend d’envoi d’emails (`log` par défaut) |
| `PUSH_SENDER_BACKEND` | log | Backend d’envoi de push (`log` par défaut) |

## Interfaces abstraites `EmailSender` et `PushSender`

Même principe que `TaskQueue` et `StorageBackend` : une interface abstraite + une implémentation `log` par défaut (aucun provider requis en dev), remplaçable en prod sans toucher au code appelant.

- `EmailSender` (`app/core/email.py`) — utilisé par `AuthService` (reset password, vérification email). Par défaut `LogEmailSender` écrit le lien dans les logs.
- `PushSender` (`app/core/push.py`) — utilisé par le job `notify_streak_at_risk`. Par défaut `LogPushSender` logue l’envoi.

**Brancher un vrai provider (Phase 2) :**

1. Implémenter la sous-classe :

```python
from app.core.email import EmailSender


class ResendEmailSender(EmailSender):
    async def send(
        self, *, to: str, subject: str, body: str
    ) -> None: ...  # appel API Resend/SendGrid/SES
```

2. L’injecter au démarrage (ex. dans le `lifespan` de `app/main.py`) :

```python
from app.core.email import set_email_sender

set_email_sender(ResendEmailSender())
```

Idem pour `PushSender` via `set_push_sender(FcmPushSender())`. Les endpoints et jobs restent inchangés.

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

## CI (GitHub Actions)

Workflow : `.github/workflows/backend_ci.yml` (racine du monorepo).  
Déclenché uniquement sur les changements `appiray-backend/**` (et le workflow lui-même).

### Job `lint-and-test`

| Étape | Commande | Rôle |
|---|---|---|
| Lint | `ruff check .` | Style / bugs courants |
| Format | `ruff format --check .` | Échoue si le code n'est pas formaté (ne reformate pas en CI) |
| Types | `mypy app/` | **Non bloquant** pour l'instant (`continue-on-error`) — première introduction |
| Tests | `pytest -q --cov=app --cov-report=term-missing` | SQLite mémoire + FakeRedis (pas de Docker requis) |

### Job `docker`

Build l'image, `docker compose up`, attend `/health`, rejoue `alembic upgrade head` **contre Postgres** (validation des migrations hors SQLite), vérifie HTTP 200, puis `docker compose down -v` (`if: always()`).

### Lancer les mêmes checks en local (avant un push)

```bash
cd appiray-backend
python -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt

ruff check .
ruff format --check .     # ou `ruff format .` pour reformater
mypy app/                 # optionnel / non bloquant pour l'instant
pytest -q --cov=app --cov-report=term-missing
```

Configs : `pyproject.toml` (ruff + mypy + pytest) ; deps outils dans `requirements-dev.txt`.
