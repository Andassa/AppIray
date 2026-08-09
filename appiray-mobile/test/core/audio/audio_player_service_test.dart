import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/audio/app_audio_player.dart';
import 'package:appiray/core/audio/audio_playback_state.dart';
import 'package:appiray/core/audio/audio_player_service.dart';

class MockAppAudioPlayer extends Mock implements AppAudioPlayer {}

void main() {
  late MockAppAudioPlayer player;
  late StreamController<PlayerState> states;

  ProviderContainer makeContainer() {
    final container = ProviderContainer(
      overrides: [
        appAudioPlayerProvider.overrideWithValue(player),
      ],
    );
    addTearDown(container.dispose);
    // Force build du service (abonnement au stream).
    container.read(audioPlayerServiceProvider);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    player = MockAppAudioPlayer();
    states = StreamController<PlayerState>.broadcast();
    when(() => player.playerStateStream).thenAnswer((_) => states.stream);
    when(() => player.stop()).thenAnswer((_) async {});
    when(() => player.setUrl(any())).thenAnswer((_) async => Duration.zero);
    when(() => player.play()).thenAnswer((_) async {});
    when(() => player.pause()).thenAnswer((_) async {});
    when(() => player.seek(any())).thenAnswer((_) async {});
    when(() => player.dispose()).thenAnswer((_) async {});
  });

  tearDown(() async {
    await states.close();
  });

  test('play() passe par loading puis playing', () async {
    final container = makeContainer();
    final notifier = container.read(audioPlayerServiceProvider.notifier);

    final future = notifier.play('https://cdn.example.com/a.mp3');
    // Pendant l'await, l'état doit déjà être loading.
    expect(
      container.read(audioPlayerServiceProvider).status,
      AudioPlaybackStatus.loading,
    );

    await future;

    expect(
      container.read(audioPlayerServiceProvider).status,
      AudioPlaybackStatus.playing,
    );
    expect(
      container.read(audioPlayerServiceProvider).url,
      'https://cdn.example.com/a.mp3',
    );
    verify(() => player.stop()).called(greaterThanOrEqualTo(1));
    verify(() => player.setUrl('https://cdn.example.com/a.mp3')).called(1);
    verify(() => player.play()).called(1);
  });

  test('erreur réseau → état error avec message clair', () async {
    when(() => player.setUrl(any())).thenThrow(
      Exception('SocketException: Failed host lookup'),
    );

    final container = makeContainer();
    await container
        .read(audioPlayerServiceProvider.notifier)
        .play('https://bad.example.com/x.mp3');

    final state = container.read(audioPlayerServiceProvider);
    expect(state.status, AudioPlaybackStatus.error);
    expect(state.errorMessage, contains('connexion'));
  });

  test('play() avec URL vide → error sans appeler le player', () async {
    final container = makeContainer();
    await container.read(audioPlayerServiceProvider.notifier).play('   ');

    final state = container.read(audioPlayerServiceProvider);
    expect(state.status, AudioPlaybackStatus.error);
    expect(state.errorMessage, contains('indisponible'));
    verifyNever(() => player.setUrl(any()));
  });

  test('stop() remet idle', () async {
    final container = makeContainer();
    await container
        .read(audioPlayerServiceProvider.notifier)
        .play('https://cdn.example.com/a.mp3');
    await container.read(audioPlayerServiceProvider.notifier).stop();

    expect(
      container.read(audioPlayerServiceProvider).status,
      AudioPlaybackStatus.idle,
    );
  });
}
