// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lessonSessionControllerHash() =>
    r'6dc81fc3bccd4400bdd708146fad7d4bc7748f87';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$LessonSessionController
    extends BuildlessAutoDisposeAsyncNotifier<LessonSessionState> {
  late final String lessonId;

  FutureOr<LessonSessionState> build(String lessonId);
}

/// Contrôleur de session pour une leçon donnée (`lessonId`).
///
/// Copied from [LessonSessionController].
@ProviderFor(LessonSessionController)
const lessonSessionControllerProvider = LessonSessionControllerFamily();

/// Contrôleur de session pour une leçon donnée (`lessonId`).
///
/// Copied from [LessonSessionController].
class LessonSessionControllerFamily
    extends Family<AsyncValue<LessonSessionState>> {
  /// Contrôleur de session pour une leçon donnée (`lessonId`).
  ///
  /// Copied from [LessonSessionController].
  const LessonSessionControllerFamily();

  /// Contrôleur de session pour une leçon donnée (`lessonId`).
  ///
  /// Copied from [LessonSessionController].
  LessonSessionControllerProvider call(String lessonId) {
    return LessonSessionControllerProvider(lessonId);
  }

  @override
  LessonSessionControllerProvider getProviderOverride(
    covariant LessonSessionControllerProvider provider,
  ) {
    return call(provider.lessonId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'lessonSessionControllerProvider';
}

/// Contrôleur de session pour une leçon donnée (`lessonId`).
///
/// Copied from [LessonSessionController].
class LessonSessionControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          LessonSessionController,
          LessonSessionState
        > {
  /// Contrôleur de session pour une leçon donnée (`lessonId`).
  ///
  /// Copied from [LessonSessionController].
  LessonSessionControllerProvider(String lessonId)
    : this._internal(
        () => LessonSessionController()..lessonId = lessonId,
        from: lessonSessionControllerProvider,
        name: r'lessonSessionControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$lessonSessionControllerHash,
        dependencies: LessonSessionControllerFamily._dependencies,
        allTransitiveDependencies:
            LessonSessionControllerFamily._allTransitiveDependencies,
        lessonId: lessonId,
      );

  LessonSessionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.lessonId,
  }) : super.internal();

  final String lessonId;

  @override
  FutureOr<LessonSessionState> runNotifierBuild(
    covariant LessonSessionController notifier,
  ) {
    return notifier.build(lessonId);
  }

  @override
  Override overrideWith(LessonSessionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: LessonSessionControllerProvider._internal(
        () => create()..lessonId = lessonId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        lessonId: lessonId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    LessonSessionController,
    LessonSessionState
  >
  createElement() {
    return _LessonSessionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LessonSessionControllerProvider &&
        other.lessonId == lessonId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, lessonId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LessonSessionControllerRef
    on AutoDisposeAsyncNotifierProviderRef<LessonSessionState> {
  /// The parameter `lessonId` of this provider.
  String get lessonId;
}

class _LessonSessionControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          LessonSessionController,
          LessonSessionState
        >
    with LessonSessionControllerRef {
  _LessonSessionControllerProviderElement(super.provider);

  @override
  String get lessonId => (origin as LessonSessionControllerProvider).lessonId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
