import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/core/audio/audio_player_service.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/presentation/controllers/lesson_session_controller.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/listen_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/mcq_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/speak_exercise_widget.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/translate_exercise_widget.dart';
import 'package:appiray/features/practice/presentation/controllers/practice_controller.dart';

/// Mode révision. Réutilise les widgets d'exercice de lesson_player. UI minimale.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({super.key});

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen>
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

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(practiceControllerProvider);
    final controller = ref.read(practiceControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Révision')),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$e', textAlign: TextAlign.center),
            ),
          ),
          data: (state) {
            if (state.phase == SessionPhase.finished) {
              return Center(
                child: Text(state.total == 0
                    ? 'Rien à réviser pour le moment.'
                    : 'Révision terminée : ${state.correctCount}/${state.total}'),
              );
            }
            final exercise = state.currentExercise;
            if (exercise == null) {
              return const Center(child: Text('Aucun exercice.'));
            }
            final isFeedback = state.phase == SessionPhase.feedback;
            return Column(
              children: [
                LinearProgressIndicator(
                  value: (state.currentIndex + (isFeedback ? 1 : 0)) /
                      (state.total == 0 ? 1 : state.total),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: _buildExercise(
                      exercise,
                      enabled: !isFeedback && !state.submitting,
                    ),
                  ),
                ),
                if (isFeedback && state.lastOutcome != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(state.lastOutcome!.isCorrect
                        ? 'Correct !'
                        : 'Incorrect.'),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: isFeedback
                        ? FilledButton(
                            onPressed: () {
                              setState(() => _currentAnswer = null);
                              controller.next();
                            },
                            child: Text(state.isLast ? 'Terminer' : 'Continuer'),
                          )
                        : FilledButton(
                            onPressed:
                                (_currentAnswer == null || state.submitting)
                                    ? null
                                    : () =>
                                        controller.submitAnswer(_currentAnswer!),
                            child: const Text('Vérifier'),
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExercise(Exercise exercise, {required bool enabled}) {
    void onChanged(String? a) => setState(() => _currentAnswer = a);
    return switch (exercise.type) {
      ExerciseType.mcq => McqExerciseWidget(
          key: ValueKey(exercise.id),
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onChanged,
        ),
      ExerciseType.translate => TranslateExerciseWidget(
          key: ValueKey(exercise.id),
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onChanged,
        ),
      ExerciseType.listen => ListenExerciseWidget(
          key: ValueKey(exercise.id),
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onChanged,
        ),
      ExerciseType.speak => SpeakExerciseWidget(
          key: ValueKey(exercise.id),
          exercise: exercise,
          enabled: enabled,
          onAnswerChanged: onChanged,
        ),
      ExerciseType.unknown =>
        Text("Type d'exercice non supporté : ${exercise.type}"),
    };
  }
}
