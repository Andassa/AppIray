import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/home/data/courses_repository_impl.dart';
import 'package:appiray/features/home/domain/course_entities.dart';

/// Intro du test de positionnement — Commencer ou Passer vers home.
class PlacementTestIntroScreen extends ConsumerStatefulWidget {
  const PlacementTestIntroScreen({super.key});

  @override
  ConsumerState<PlacementTestIntroScreen> createState() =>
      _PlacementTestIntroScreenState();
}

class _PlacementTestIntroScreenState
    extends ConsumerState<PlacementTestIntroScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _skip() async {
    setState(() => _busy = true);
    await ref.read(localCacheServiceProvider).setPlacementTestSeen(true);
    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  Future<void> _start() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    final result =
        await ref.read(coursesRepositoryProvider).listCourses();
    if (!mounted) return;

    switch (result) {
      case Success<List<Course>>(:final value):
        if (value.isEmpty) {
          // Pas de cours → on saute proprement vers home.
          await ref.read(localCacheServiceProvider).setPlacementTestSeen(true);
          if (!mounted) return;
          context.go(RoutePaths.home);
          return;
        }
        context.go(RoutePaths.placementSessionFor(value.first.id));
      case FailureResult<List<Course>>(:final failure):
        setState(() {
          _busy = false;
          _error = failure.message;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test de niveau'),
        actions: [
          TextButton(
            key: const Key('placement_skip'),
            onPressed: _busy ? null : _skip,
            child: const Text('Passer'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Ce test nous aide à te placer au bon niveau',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Quelques questions rapides pour débloquer les unités '
                'qui correspondent à ton niveau. Tu peux passer à tout moment.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ],
              const Spacer(),
              FilledButton(
                key: const Key('placement_start'),
                onPressed: _busy ? null : _start,
                child: _busy
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Commencer'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                key: const Key('placement_skip_bottom'),
                onPressed: _busy ? null : _skip,
                child: const Text('Passer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
