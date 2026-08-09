import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/audio/audio_player_service.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/presentation/controllers/lesson_session_controller.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/listen_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/mcq_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/speak_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/translate_exercise_widget.dart';

/// Écran de jeu d'une leçon. Toute la logique est dans le
/// [LessonSessionController] ; ici on ne fait que rendre l'état.
class LessonPlayerScreen extends ConsumerStatefulWidget {
  const LessonPlayerScreen({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends ConsumerState<LessonPlayerScreen>
    with WidgetsBindingObserver {
  String? _currentAnswer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void deactivate() {
    // Quitte la leçon (retour arrière / navigation) → coupe l'audio.
    ref.read(audioPlayerServiceProvider.notifier).stop();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Coupe le son si l'app passe en arrière-plan.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      ref.read(audioPlayerServiceProvider.notifier).pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = lessonSessionControllerProvider(widget.lessonId);
    final asyncState = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(asyncState.valueOrNull?.lessonTitle ?? 'Leçon'),
      ),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(message: '$e'),
          data: (state) => _buildContent(context, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, LessonSessionState state) {
    return switch (state.phase) {
      SessionPhase.finished => _SummaryView(state: state, onClose: _close),
      SessionPhase.gameOver => _GameOverView(state: state, onClose: _close),
      _ => _PlayingView(
          state: state,
          currentAnswer: _currentAnswer,
          onAnswerChanged: (a) => setState(() => _currentAnswer = a),
          onSubmit: () => ref
              .read(lessonSessionControllerProvider(widget.lessonId).notifier)
              .submitAnswer(_currentAnswer ?? ''),
          onNext: () {
            setState(() => _currentAnswer = null);
            ref
                .read(lessonSessionControllerProvider(widget.lessonId).notifier)
                .next();
          },
        ),
    };
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }
}

class _PlayingView extends StatelessWidget {
  const _PlayingView({
    required this.state,
    required this.currentAnswer,
    required this.onAnswerChanged,
    required this.onSubmit,
    required this.onNext,
  });

  final LessonSessionState state;
  final String? currentAnswer;
  final ValueChanged<String?> onAnswerChanged;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final exercise = state.currentExercise;
    if (exercise == null) {
      return const Center(child: Text('Aucun exercice.'));
    }

    final total = state.total == 0 ? 1 : state.total;
    final isFeedback = state.phase == SessionPhase.feedback;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: (state.currentIndex + (isFeedback ? 1 : 0)) / total,
                ),
              ),
              const SizedBox(width: 12),
              if (!state.practice) ...[
                const Icon(Icons.favorite, size: 18),
                const SizedBox(width: 4),
                Text('${state.heartsRemaining}'),
              ],
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _ExerciseByType(
              key: ValueKey(exercise.id),
              exercise: exercise,
              enabled: !isFeedback && !state.submitting,
              onAnswerChanged: onAnswerChanged,
            ),
          ),
        ),
        if (isFeedback) _FeedbackBanner(outcome: state.lastOutcome),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: isFeedback
                ? FilledButton(
                    onPressed: onNext,
                    child: Text(state.isLast ? 'Terminer' : 'Continuer'),
                  )
                : FilledButton(
                    onPressed: (currentAnswer == null || state.submitting)
                        ? null
                        : onSubmit,
                    child: state.submitting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Vérifier'),
                  ),
          ),
        ),
      ],
    );
  }
}

/// Sélectionne le widget d'exercice selon le type.
class _ExerciseByType extends StatelessWidget {
  const _ExerciseByType({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onAnswerChanged,
  });

  final Exercise exercise;
  final bool enabled;
  final ValueChanged<String?> onAnswerChanged;

  @override
  Widget build(BuildContext context) {
    return switch (exercise.type) {
      ExerciseType.mcq => McqExerciseWidget(
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onAnswerChanged,
        ),
      ExerciseType.translate => TranslateExerciseWidget(
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onAnswerChanged,
        ),
      ExerciseType.listen => ListenExerciseWidget(
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onAnswerChanged,
        ),
      ExerciseType.speak => SpeakExerciseWidget(
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onAnswerChanged,
        ),
      ExerciseType.unknown => Text(
          "Type d'exercice non supporté : ${exercise.type}",
        ),
    };
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.outcome});
  final AnswerOutcome? outcome;

  @override
  Widget build(BuildContext context) {
    if (outcome == null) return const SizedBox.shrink();
    final correct = outcome!.isCorrect;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: correct
          ? Colors.green.withValues(alpha: 0.15)
          : Colors.red.withValues(alpha: 0.15),
      child: Text(
        correct
            ? 'Correct ! +${outcome!.xpGained} XP'
            : 'Incorrect. Cœurs restants : ${outcome!.hearts}',
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  const _SummaryView({required this.state, required this.onClose});
  final LessonSessionState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Leçon terminée'),
            const SizedBox(height: 8),
            Text('Bonnes réponses : ${state.correctCount} / ${state.total}'),
            Text('XP gagné : ${state.xpGained}'),
            const SizedBox(height: 16),
            FilledButton(onPressed: onClose, child: const Text('Continuer')),
          ],
        ),
      ),
    );
  }
}

class _GameOverView extends StatelessWidget {
  const _GameOverView({required this.state, required this.onClose});
  final LessonSessionState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Plus de cœurs'),
            const SizedBox(height: 8),
            const Text(
              'Tu as épuisé tes cœurs. Attends la régénération, utilise des '
              'gemmes, ou réessaie plus tard.',
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onClose, child: const Text('Fermer')),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
