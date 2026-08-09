import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/core/audio/audio_playback_state.dart';
import 'package:appiray/core/audio/audio_player_service.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';

/// Exercice d'écoute avec lecture réelle via [AudioPlayerService].
///
/// - Auto-play à l'apparition (comportement type Duolingo).
/// - Stop à la disparition (question suivante / sortie d'écran).
/// - URL lue via [Exercise.audioUrl] (`content['audio_url']` / `audioUrl`).
class ListenExerciseWidget extends ConsumerStatefulWidget {
  const ListenExerciseWidget({
    super.key,
    required this.exercise,
    required this.enabled,
    required this.onAnswerChanged,
  });

  final Exercise exercise;
  final bool enabled;
  final ValueChanged<String?> onAnswerChanged;

  @override
  ConsumerState<ListenExerciseWidget> createState() =>
      _ListenExerciseWidgetState();
}

class _ListenExerciseWidgetState extends ConsumerState<ListenExerciseWidget> {
  final _controller = TextEditingController();
  var _autoPlayStarted = false;

  String? get _audioUrl {
    final url = widget.exercise.audioUrl;
    if (url == null || url.trim().isEmpty) return null;
    return url.trim();
  }

  @override
  void initState() {
    super.initState();
    // Auto-play dès l'affichage de la question (après le premier frame).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _autoPlayStarted) return;
      _autoPlayStarted = true;
      final url = _audioUrl;
      if (url != null) {
        ref.read(audioPlayerServiceProvider.notifier).play(url);
      }
    });
  }

  @override
  void deactivate() {
    // Coupe le son en quittant la question (next / feedback / pop).
    // `deactivate` est sûr pour `ref` (avant dispose du Element).
    ref.read(audioPlayerServiceProvider.notifier).stop();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onPlayPause(AudioPlaybackState playback) async {
    final url = _audioUrl;
    if (url == null) return;
    final notifier = ref.read(audioPlayerServiceProvider.notifier);
    switch (playback.status) {
      case AudioPlaybackStatus.playing:
        await notifier.pause();
      case AudioPlaybackStatus.paused:
        await notifier.resume();
      case AudioPlaybackStatus.loading:
        return;
      case AudioPlaybackStatus.idle:
      case AudioPlaybackStatus.error:
        await notifier.play(url);
    }
  }

  Future<void> _onReplay() async {
    final url = _audioUrl;
    if (url == null) return;
    await ref.read(audioPlayerServiceProvider.notifier).replay();
  }

  @override
  Widget build(BuildContext context) {
    final playback = ref.watch(audioPlayerServiceProvider);
    final url = _audioUrl;
    final unavailable = url == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.exercise.prompt.isNotEmpty) Text(widget.exercise.prompt),
        const SizedBox(height: 12),
        if (unavailable)
          const Text('Audio indisponible pour cet exercice.')
        else ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('listen_play_pause'),
                  onPressed: widget.enabled && !playback.isLoading
                      ? () => _onPlayPause(playback)
                      : null,
                  icon: _PlayIcon(status: playback.status),
                  label: Text(_labelFor(playback.status)),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                key: const Key('listen_replay'),
                tooltip: 'Réécouter',
                onPressed: widget.enabled && !playback.isLoading
                    ? _onReplay
                    : null,
                icon: const Icon(Icons.replay),
              ),
            ],
          ),
          if (playback.isLoading) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(),
          ],
          if (playback.hasError) ...[
            const SizedBox(height: 8),
            Text(
              playback.errorMessage ?? 'Lecture audio impossible.',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 4),
            TextButton(
              key: const Key('listen_retry'),
              onPressed: widget.enabled
                  ? () =>
                      ref.read(audioPlayerServiceProvider.notifier).play(url)
                  : null,
              child: const Text('Réessayer'),
            ),
          ],
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          decoration: const InputDecoration(labelText: 'Ce que tu as entendu'),
          onChanged: (value) =>
              widget.onAnswerChanged(value.trim().isEmpty ? null : value),
        ),
      ],
    );
  }

  String _labelFor(AudioPlaybackStatus status) => switch (status) {
        AudioPlaybackStatus.loading => 'Chargement…',
        AudioPlaybackStatus.playing => 'Pause',
        AudioPlaybackStatus.paused => 'Reprendre',
        AudioPlaybackStatus.error => 'Réessayer',
        AudioPlaybackStatus.idle => 'Écouter',
      };
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon({required this.status});
  final AudioPlaybackStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      AudioPlaybackStatus.loading => const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      AudioPlaybackStatus.playing => const Icon(Icons.pause),
      AudioPlaybackStatus.paused => const Icon(Icons.play_arrow),
      AudioPlaybackStatus.error => const Icon(Icons.error_outline),
      AudioPlaybackStatus.idle => const Icon(Icons.volume_up),
    };
  }
}
