import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';

import 'package:appiray/core/audio/app_audio_player.dart';
import 'package:appiray/features/lesson_player/domain/lesson_entities.dart';
import 'package:appiray/features/lesson_player/presentation/widgets/listen_exercise_widget.dart';

class MockAppAudioPlayer extends Mock implements AppAudioPlayer {}

void main() {
  late MockAppAudioPlayer player;
  late StreamController<PlayerState> states;

  const exercise = Exercise(
    id: 'e1',
    lessonId: 'l1',
    type: ExerciseType.listen,
    content: {
      'prompt': 'Écoute et écris',
      'audio_url': 'https://cdn.example.com/phrase.mp3',
    },
  );

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

  Future<void> pumpWidget(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appAudioPlayerProvider.overrideWithValue(player),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ListenExerciseWidget(
              exercise: exercise,
              enabled: true,
              onAnswerChanged: (_) {},
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('auto-play se déclenche à l\'affichage', (tester) async {
    await pumpWidget(tester);
    // Post-frame callback de l'auto-play.
    await tester.pump();
    await tester.pump();

    verify(() => player.setUrl('https://cdn.example.com/phrase.mp3')).called(1);
    verify(() => player.play()).called(1);
  });

  testWidgets('icône volume → pause selon l\'état du service', (tester) async {
    await pumpWidget(tester);
    await tester.pump();
    await tester.pump();

    // Après play() réussi, le service pose l'état playing → icône pause.
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.text('Pause'), findsOneWidget);

    // Simule une pause via le stream player.
    when(() => player.pause()).thenAnswer((_) async {
      states.add(PlayerState(false, ProcessingState.ready));
    });
    await tester.tap(find.byKey(const Key('listen_play_pause')));
    await tester.pump();
    await tester.pump();

    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('erreur réseau : message + bouton réessayer', (tester) async {
    when(() => player.setUrl(any())).thenThrow(
      Exception('SocketException: Failed host lookup'),
    );

    await pumpWidget(tester);
    await tester.pump();
    await tester.pump();

    expect(find.textContaining('connexion'), findsOneWidget);
    expect(find.byKey(const Key('listen_retry')), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
  });
}
