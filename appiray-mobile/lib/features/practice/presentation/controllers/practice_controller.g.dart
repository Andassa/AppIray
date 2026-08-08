// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$practiceControllerHash() =>
    r'e8bdce14192f30ebb9ab5f980b2b048e13a34d94';

/// Session de révision. Réutilise [LessonSessionState] et les widgets
/// d'exercice de lesson_player. La pratique ne consomme pas de cœur.
///
/// Copied from [PracticeController].
@ProviderFor(PracticeController)
final practiceControllerProvider =
    AutoDisposeAsyncNotifierProvider<
      PracticeController,
      LessonSessionState
    >.internal(
      PracticeController.new,
      name: r'practiceControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$practiceControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PracticeController = AutoDisposeAsyncNotifier<LessonSessionState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
