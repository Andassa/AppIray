# AppIray Mobile

Application mobile Flutter pour apprendre le malgache. Ce projet est **indépendant**
du backend (`../appiray-backend`) et du pipeline audio (`../appiray-audio-pipeline`),
et communique avec le backend via son API REST.

> ⚠️ **Design volontairement minimal.** Le theming (couleurs, typographie, assets)
> n'est PAS encore intégré : les écrans utilisent Material par défaut. La structure
> des composants est faite pour qu'on puisse brancher le design Figma plus tard sans
> toucher à la logique. Voir `lib/core/theme/app_theme.dart` (placeholder neutre).

## Stack technique

- **Flutter** (stable, null-safety)
- **Riverpod** (`flutter_riverpod` + `riverpod_annotation` / `riverpod_generator`) — seul gestionnaire d'état
- **go_router** — navigation avec redirection réactive selon l'auth
- **Dio** — client HTTP avec intercepteur (token + refresh automatique sur 401)
- **freezed** + **json_serializable** — DTOs (mapping snake_case ↔ camelCase)
- **flutter_secure_storage** — tokens JWT
- **shared_preferences** — préférences légères
- **mocktail** — mocks dans les tests

## Architecture — clean architecture par feature

```
lib/
  core/          # network, storage, router, theme, providers, utils, session
  features/
    <feature>/
      data/        # datasources, models (freezed), repository_impl
      domain/      # entités + interfaces de repository (aucune dépendance à Dio)
      presentation/# screens, widgets, controllers (Riverpod)
```

Principes appliqués :

1. Le **domain** ne connaît ni Dio ni les DTOs bruts (uniquement entités + interfaces).
2. **Aucun appel réseau depuis un widget** : toujours via un controller Riverpod → repository.
3. **Gestion d'erreur uniforme** : chaque méthode de repository renvoie `Result<T>`
   (`Success` / `FailureResult`) — voir `lib/core/utils/result.dart`. Pas de try/catch
   dispersés dans l'UI.
4. **Refresh token automatique** : l'intercepteur Dio (`lib/core/network/dio_client.dart`)
   attache le token, tente un refresh sur 401, rejoue la requête, et déclenche une
   déconnexion propre si le refresh échoue.
5. **Redirection réactive** : le router écoute `SessionController`
   (`lib/core/session/session_controller.dart`) et renvoie vers `/welcome` dès que la
   session devient invalide, à tout moment.
6. **Modèles alignés backend** : les DTOs mappent explicitement le snake_case via
   `@JsonKey(name: 'xp_total')`, etc.

## Prérequis : génération de code (obligatoire)

Les modèles `freezed` et les providers `riverpod` reposent sur de la génération de code.
Après un `pub get`, il faut **toujours** lancer `build_runner` avant d'analyser, tester
ou lancer l'app (sinon les fichiers `*.g.dart` / `*.freezed.dart` manquent) :

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Pendant le développement, tu peux laisser tourner :

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Configuration de l'URL de l'API

Pas de package `.env` complexe : un simple `AppConfig` statique
(`lib/core/config/app_config.dart`) lit une variable de compilation.

- Valeur par défaut (dev local) : `http://localhost:8000/api/v1`
- Pour surcharger (ex. prod) :

```bash
flutter run --dart-define=API_BASE_URL=https://api.appiray.mg/api/v1
```

Note émulateurs : Android utilise `http://10.0.2.2:8000/api/v1` pour joindre le
`localhost` de la machine hôte.

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

## Lancer l'app

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run   # ajoute --dart-define=API_BASE_URL=... si besoin
```

## Lancer les tests

Les tests de controllers (auth, home, lesson_player, progress, placement_test)
mockent les repositories via mocktail et valident la logique d'état
indépendamment de l'UI.

```bash
dart run build_runner build --delete-conflicting-outputs   # requis avant les tests
flutter test
```

## Notes

- Aucune donnée visuelle n'est mockée en dur : les écrans passent toujours par les
  repositories. Si le backend est vide, les écrans affichent simplement un état
  vide/chargement — c'est attendu à ce stade.
- Reconnaissance vocale (`speak`) : point d'entrée stub, STT à brancher plus tard.

## Placement test

Feature `lib/features/placement_test/` : après inscription (ou premier login
si le flag local n'est pas encore posé), l'utilisateur peut passer un test de
niveau (`GET/POST /courses/{id}/placement-test`) ou le **Passer** pour aller
directement sur home. Réutilise les widgets d'exercice de `lesson_player`
(sans cœurs / XP). Le résultat affiche `correct_count` et `units_unlocked`.

## Audio — exercices `listen`

Dépendance : **`just_audio`** (seul package de lecture audio du projet).

- Service partagé : `lib/core/audio/audio_player_service.dart` (un seul lecteur
  actif dans l'app, état `idle/loading/playing/paused/error`).
- URL lue via `Exercise.audioUrl` → `content['audio_url']` (fallback `audioUrl`).
- **Auto-play** : dès qu'une question `listen` s'affiche, l'audio démarre sans
  clic (comportement type Duolingo). L'utilisateur peut pause / réécouter / retry.
- La lecture est stoppée en changeant de question, en quittant la leçon, ou
  mise en pause si l'app passe en arrière-plan.

