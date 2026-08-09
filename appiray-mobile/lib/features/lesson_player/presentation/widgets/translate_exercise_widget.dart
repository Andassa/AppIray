import 'package:flutter/material.dart';

import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

/// Exercice de traduction. Structure fonctionnelle uniquement.
class TranslateExerciseWidget extends StatefulWidget {
  const TranslateExerciseWidget({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onAnswerChanged,
  });

  final Exercise exercise;
  final bool enabled;
  final ValueChanged<String?> onAnswerChanged;

  @override
  State<TranslateExerciseWidget> createState() =>
      _TranslateExerciseWidgetState();
}

class _TranslateExerciseWidgetState extends State<TranslateExerciseWidget> {
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
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          minLines: 1,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Ta traduction'),
          onChanged: (value) =>
              widget.onAnswerChanged(value.trim().isEmpty ? null : value),
        ),
      ],
    );
  }
}
