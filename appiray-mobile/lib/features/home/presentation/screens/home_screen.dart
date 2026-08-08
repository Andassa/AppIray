import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/home/domain/course_entities.dart';
import 'package:appiray/features/home/presentation/controllers/home_controller.dart';

/// Accueil : liste des unités/leçons avec statut. UI minimale.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AppIray'),
        actions: [
          IconButton(
            icon: const Icon(Icons.local_fire_department),
            tooltip: 'Progression',
            onPressed: () => context.push(RoutePaths.progress),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => context.push(RoutePaths.profile),
          ),
        ],
      ),
      bottomNavigationBar: const _HomeNav(),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$e', textAlign: TextAlign.center),
            ),
          ),
          data: (state) => _CourseView(state: state),
        ),
      ),
    );
  }
}

class _CourseView extends ConsumerWidget {
  const _CourseView({required this.state});
  final HomeState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final course = state.selectedCourse;
    if (course == null) {
      return const Center(child: Text('Aucun cours disponible.'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(homeControllerProvider.future),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(course.title, style: Theme.of(context).textTheme.titleLarge),
          if (course.description != null) ...[
            const SizedBox(height: 4),
            Text(course.description!),
          ],
          const SizedBox(height: 16),
          for (final unit in course.units) ...[
            Text(unit.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            for (final lesson in unit.lessons)
              _LessonTile(
                lesson: lesson,
                status: state.statusFor(lesson.id),
              ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  const _LessonTile({required this.lesson, required this.status});
  final Lesson lesson;
  final LessonUiStatus status;

  @override
  Widget build(BuildContext context) {
    final locked = status == LessonUiStatus.locked;
    return ListTile(
      leading: Icon(_iconFor(status)),
      title: Text(lesson.title),
      subtitle: Text('${lesson.xpReward} XP · ${_label(status)}'),
      enabled: !locked,
      onTap: locked
          ? null
          : () => context.push(RoutePaths.lessonPlayerFor(lesson.id)),
    );
  }

  IconData _iconFor(LessonUiStatus s) => switch (s) {
        LessonUiStatus.completed => Icons.check_circle,
        LessonUiStatus.inProgress => Icons.play_circle,
        LessonUiStatus.available => Icons.radio_button_unchecked,
        LessonUiStatus.locked => Icons.lock,
      };

  String _label(LessonUiStatus s) => switch (s) {
        LessonUiStatus.completed => 'Terminée',
        LessonUiStatus.inProgress => 'En cours',
        LessonUiStatus.available => 'Disponible',
        LessonUiStatus.locked => 'Verrouillée',
      };
}

/// Barre de navigation basique vers les sections principales.
class _HomeNav extends StatelessWidget {
  const _HomeNav();

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 1:
            context.push(RoutePaths.practice);
          case 2:
            context.push(RoutePaths.leaderboard);
          case 3:
            context.push(RoutePaths.feed);
          case 4:
            context.push(RoutePaths.friends);
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Pratique'),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Ligue'),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Contenu'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Amis'),
      ],
    );
  }
}
