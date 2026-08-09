import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/core/storage/local_cache_service.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/data/courses_repository_impl.dart';
import 'package:appiray/features/home/domain/course_entities.dart';
import 'package:appiray/features/home/domain/courses_repository.dart';
import 'package:appiray/features/placement_test/presentation/screens/placement_test_intro_screen.dart';

class MockCoursesRepository extends Mock implements CoursesRepository {}

void main() {
  late MockCoursesRepository courses;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    courses = MockCoursesRepository();
  });

  Future<GoRouter> pumpIntro(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: RoutePaths.placementIntro,
      routes: [
        GoRoute(
          path: RoutePaths.placementIntro,
          builder: (_, _) => const PlacementTestIntroScreen(),
        ),
        GoRoute(
          path: RoutePaths.home,
          builder: (_, _) => const Scaffold(
            body: Text('home'),
          ),
        ),
        GoRoute(
          path: RoutePaths.placementSession,
          builder: (_, state) => Scaffold(
            body: Text('session:${state.pathParameters['courseId']}'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          localCacheServiceProvider.overrideWithValue(
            LocalCacheService(prefs),
          ),
          coursesRepositoryProvider.overrideWithValue(courses),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('affiche Commencer et Passer', (tester) async {
    await pumpIntro(tester);

    expect(find.byKey(const Key('placement_start')), findsOneWidget);
    expect(find.byKey(const Key('placement_skip')), findsOneWidget);
    expect(find.byKey(const Key('placement_skip_bottom')), findsOneWidget);
    expect(
      find.text('Ce test nous aide à te placer au bon niveau'),
      findsOneWidget,
    );
  });

  testWidgets('Passer -> home + flag placement vu', (tester) async {
    final router = await pumpIntro(tester);

    await tester.tap(find.byKey(const Key('placement_skip')));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
    expect(router.state.uri.path, RoutePaths.home);
    expect(LocalCacheService(prefs).placementTestSeen, isTrue);
  });

  testWidgets('Commencer -> session du premier cours', (tester) async {
    when(() => courses.listCourses()).thenAnswer(
      (_) async => const Result.success([
        Course(id: 'course-1', title: 'Malagasy 1'),
      ]),
    );

    final router = await pumpIntro(tester);

    await tester.tap(find.byKey(const Key('placement_start')));
    await tester.pumpAndSettle();

    expect(find.text('session:course-1'), findsOneWidget);
    expect(router.state.uri.path, '/placement-test/course-1');
    expect(LocalCacheService(prefs).placementTestSeen, isFalse);
  });
}
