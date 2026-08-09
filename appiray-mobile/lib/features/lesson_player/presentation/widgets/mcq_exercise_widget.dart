import 'package:flutter/material.dart';

import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

/// Exercice QCM. Structure fonctionnelle uniquement (pas de style).
///
/// Widget "contrôlé" : il ne soumet pas lui-même, il remonte la réponse choisie
/// via [onAnswerChanged]. La soumission est centralisée par l'écran/parent
/// (donc par le controller de session).
class McqExerciseWidget extends StatefulWidget {
  const McqExerciseWidget({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onAnswerChanged,
  });

  final Exercise exercise;
  final bool enabled;
  final ValueChanged<String?> onAnswerChanged;

  @override
  State<McqExerciseWidget> createState() => _McqExerciseWidgetState();
}

class _McqExerciseWidgetState extends State<McqExerciseWidget> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final options = widget.exercise.options;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(widget.exercise.prompt),
        const SizedBox(height: 12),
        RadioGroup<String>(
          groupValue: _selected,
          onChanged: (value) {
            if (!widget.enabled) return;
            setState(() => _selected = value);
            widget.onAnswerChanged(value);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final option in options)
                RadioListTile<String>(
                  title: Text(option),
                  value: option,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
