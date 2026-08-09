import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_audio_player.g.dart';

/// Abstraction au-dessus de `just_audio` pour permettre les mocks (mocktail).
abstract class AppAudioPlayer {
  Future<Duration?> setUrl(String url);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Stream<PlayerState> get playerStateStream;
  Future<void> dispose();
}

/// Implémentation réelle basée sur [AudioPlayer] (just_audio).
class JustAudioPlayer implements AppAudioPlayer {
  JustAudioPlayer([AudioPlayer? player]) : _player = player ?? AudioPlayer();

  final AudioPlayer _player;

  @override
  Future<Duration?> setUrl(String url) => _player.setUrl(url);

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  @override
  Future<void> dispose() => _player.dispose();
}

/// Lecteur unique partagé (un seul actif dans toute l'app).
@Riverpod(keepAlive: true)
AppAudioPlayer appAudioPlayer(AppAudioPlayerRef ref) {
  final player = JustAudioPlayer();
  ref.onDispose(() {
    player.dispose();
  });
  return player;
}
