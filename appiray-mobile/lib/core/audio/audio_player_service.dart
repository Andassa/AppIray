import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/audio/app_audio_player.dart';
import 'package:appiray/core/audio/audio_playback_state.dart';

part 'audio_player_service.g.dart';

/// Service de lecture audio unique pour l'app.
///
/// - Un seul lecteur actif : un nouvel appel à [play] stoppe le précédent.
/// - État observable via [audioPlayerServiceProvider] (`AudioPlaybackState`).
/// - Erreurs réseau / URL invalide → état `error` (pas de crash).
@Riverpod(keepAlive: true)
class AudioPlayerService extends _$AudioPlayerService {
  StreamSubscription<PlayerState>? _subscription;
  String? _currentUrl;
  bool _disposed = false;

  AppAudioPlayer get _player => ref.read(appAudioPlayerProvider);

  @override
  AudioPlaybackState build() {
    _disposed = false;
    _subscription?.cancel();
    _subscription = _player.playerStateStream.listen(
      _onPlayerState,
      onError: (Object e, StackTrace _) {
        if (_disposed) return;
        state = AudioPlaybackState(
          status: AudioPlaybackStatus.error,
          url: _currentUrl,
          errorMessage: _friendlyError(e),
        );
      },
    );
    ref.onDispose(() {
      _disposed = true;
      _subscription?.cancel();
      _subscription = null;
    });
    return const AudioPlaybackState.idle();
  }

  /// Charge et joue [url]. Stoppe proprement toute lecture en cours.
  Future<void> play(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      state = const AudioPlaybackState(
        status: AudioPlaybackStatus.error,
        errorMessage: 'Audio indisponible pour cet exercice.',
      );
      return;
    }

    state = AudioPlaybackState(
      status: AudioPlaybackStatus.loading,
      url: trimmed,
    );

    try {
      // Un seul lecteur : on coupe toujours avant de charger une nouvelle source
      // (ou de recharger la même).
      await _player.stop();
      await _player.setUrl(trimmed);
      _currentUrl = trimmed;
      if (_disposed) return;
      await _player.play();
      // L'état `playing` sera confirmé via playerStateStream ; on pose un
      // fallback immédiat pour l'UI (évite un flash loading trop long).
      if (!_disposed && state.status == AudioPlaybackStatus.loading) {
        state = AudioPlaybackState(
          status: AudioPlaybackStatus.playing,
          url: trimmed,
        );
      }
    } catch (e) {
      if (_disposed) return;
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.error,
        url: trimmed,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> pause() async {
    try {
      await _player.pause();
      if (!_disposed) {
        state = state.copyWith(
          status: AudioPlaybackStatus.paused,
          clearError: true,
        );
      }
    } catch (e) {
      if (_disposed) return;
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.error,
        url: _currentUrl,
        errorMessage: _friendlyError(e),
      );
    }
  }

  Future<void> resume() async {
    final url = _currentUrl ?? state.url;
    if (url == null || url.isEmpty) return;
    try {
      state = state.copyWith(
        status: AudioPlaybackStatus.loading,
        clearError: true,
      );
      await _player.play();
      if (!_disposed) {
        state = AudioPlaybackState(
          status: AudioPlaybackStatus.playing,
          url: url,
        );
      }
    } catch (e) {
      if (_disposed) return;
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.error,
        url: url,
        errorMessage: _friendlyError(e),
      );
    }
  }

  /// Relance depuis le début (même URL).
  Future<void> replay() async {
    final url = _currentUrl ?? state.url;
    if (url == null || url.isEmpty) {
      state = const AudioPlaybackState(
        status: AudioPlaybackStatus.error,
        errorMessage: 'Audio indisponible pour cet exercice.',
      );
      return;
    }
    try {
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.loading,
        url: url,
      );
      await _player.seek(Duration.zero);
      await _player.play();
      if (!_disposed) {
        state = AudioPlaybackState(
          status: AudioPlaybackStatus.playing,
          url: url,
        );
      }
    } catch (e) {
      // Si seek échoue (source non chargée), on retente un play complet.
      await play(url);
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (_) {
      // Best-effort : on force l'état idle même si stop échoue.
    }
    _currentUrl = null;
    if (!_disposed) {
      state = const AudioPlaybackState.idle();
    }
  }

  void _onPlayerState(PlayerState playerState) {
    if (_disposed) return;
    // Ne pas écraser un état d'erreur applicatif (ex: setUrl a échoué).
    if (state.hasError) return;

    final processing = playerState.processingState;
    if (processing == ProcessingState.loading ||
        processing == ProcessingState.buffering) {
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.loading,
        url: _currentUrl ?? state.url,
      );
      return;
    }

    if (processing == ProcessingState.completed) {
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.idle,
        url: _currentUrl ?? state.url,
      );
      return;
    }

    if (playerState.playing) {
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.playing,
        url: _currentUrl ?? state.url,
      );
    } else if (processing == ProcessingState.ready &&
        state.status == AudioPlaybackStatus.playing) {
      state = AudioPlaybackState(
        status: AudioPlaybackStatus.paused,
        url: _currentUrl ?? state.url,
      );
    }
  }

  String _friendlyError(Object e) {
    final raw = e.toString();
    if (raw.contains('SocketException') ||
        raw.contains('Failed host lookup') ||
        raw.contains('Connection')) {
      return 'Impossible de charger l\'audio. Vérifie ta connexion.';
    }
    if (raw.contains('Timeout') || raw.contains('timeout')) {
      return 'Délai dépassé lors du chargement de l\'audio.';
    }
    return 'Lecture audio impossible. Réessaie.';
  }
}
