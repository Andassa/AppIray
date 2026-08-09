import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/audio/audio_player_service.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/listen_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/mcq_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/speak_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/translate_exercise_widget.dart';
import 'package:appiray/features/placement_test/presentation/controllers/placement_test_controller.dart';

/// Session de test de positionnement (sans cœurs / XP).
class PlacementTestScreen extends ConsumerStatefulWidget {
  const PlacementTestScreen({super.key, required this.courseId});

  final String courseId;

  @override
  ConsumerState<PlacementTestScreen> createState() =>
      _PlacementTestScreenState();
}

class _PlacementTestScreenState extends ConsumerState<PlacementTestScreen>
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
    ref.read(audioPlayerServiceProvider.notifier).stop();
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      ref.read(audioPlayerServiceProvider.notifier).pause();
    }
  }

  Future<void> _skip() async {
    await ref.read(localCacheServiceProvider).setPlacementTestSeen(true);
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  Future<void> _onSubmit() async {
    final answer = _currentAnswer;
    if (answer == null) return;

    final notifier = ref.read(
      placementTestControllerProvider(widget.courseId).notifier,
    );
    await notifier.submitCurrentAnswer(answer);

    if (!mounted) return;
    final state =
        ref.read(placementTestControllerProvider(widget.courseId)).valueOrNull;
    if (state?.phase == PlacementPhase.done && state?.result != null) {
      setState(() => _currentAnswer = null);
      context.go(
        RoutePaths.placementResultFor(widget.courseId),
        extra: state!.result,
      );
    } else {
      setState(() => _currentAnswer = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState =
        ref.watch(placementTestControllerProvider(widget.courseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de niveau'),
        actions: [
          TextButton(
            key: const Key('placement_session_skip'),
            onPressed: _skip,
            child: const Text('Passer'),
          ),
        ],
      ),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => _ErrorView(
            message: '$e',
            onSkip: _skip,
          ),
          data: (state) {
            if (state.exercises.isEmpty) {
              return _EmptyView(onSkip: _skip);
            }
            return _AnsweringView(
              state: state,
              currentAnswer: _currentAnswer,
              onAnswerChanged: (a) => setState(() => _currentAnswer = a),
              onSubmit: _onSubmit,
            );
          },
        ),
      ),
    );
  }
}

class _AnsweringView extends StatelessWidget {
  const _AnsweringView({
    required this.state,
    required this.currentAnswer,
    required this.onAnswerChanged,
    required this.onSubmit,
  });

  final PlacementSessionState state;
  final String? currentAnswer;
  final ValueChanged<String?> onAnswerChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final exercise = state.currentExercise;
    if (exercise == null) {
      return const Center(child: Text('Aucun exercice.'));
    }

    final total = state.total == 0 ? 1 : state.total;
    final submitting = state.phase == PlacementPhase.submitting;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: LinearProgressIndicator(
            value: (state.currentIndex + (submitting ? 1 : 0)) / total,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Question ${state.currentIndex + 1} / ${state.total}',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _ExerciseByType(
              key: ValueKey(exercise.id),
              exercise: exercise,
              enabled: !submitting,
              onAnswerChanged: onAnswerChanged,
            ),
          ),
        ),
        if (state.submitError != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              state.submitError!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed:
                  (currentAnswer == null || submitting) ? null : onSubmit,
              child: submitting
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(state.isLast ? 'Terminer' : 'Suivant'),
            ),
          ),
        ),
      ],
    );
  }
}

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

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onSkip});
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Aucun exercice de positionnement disponible.'),
            const SizedBox(height: 16),
            FilledButton(onPressed: onSkip, child: const Text('Continuer')),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onSkip});
  final String message;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onSkip, child: const Text('Passer')),
          ],
        ),
      ),
    );
  }
}
