import 'package:flutter/material.dart';

import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

/// Exercice de prononciation. Structure fonctionnelle uniquement.
///
/// NOTE : la reconnaissance vocale (STT) sera branchée plus tard. En attendant,
/// on saisit la transcription manuellement pour valider tout le flux de session.
class SpeakExerciseWidget extends StatefulWidget {
  const SpeakExerciseWidget({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onAnswerChanged,
  });

  final Exercise exercise;
  final bool enabled;
  final ValueChanged<String?> onAnswerChanged;

  @override
  State<SpeakExerciseWidget> createState() => _SpeakExerciseWidgetState();
}

class _SpeakExerciseWidgetState extends State<SpeakExerciseWidget> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.exercise.prompt),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          // TODO(design/stt): brancher la reconnaissance vocale.
          onPressed: widget.enabled ? () {} : null,
          icon: const Icon(Icons.mic),
          label: const Text('Parler (STT à brancher)'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          decoration: const InputDecoration(labelText: 'Transcription'),
          onChanged: (value) =>
              widget.onAnswerChanged(value.trim().isEmpty ? null : value),
        ),
      ],
    );
  }
}
