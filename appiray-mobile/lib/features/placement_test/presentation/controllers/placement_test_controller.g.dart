// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'placement_test_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$placementTestControllerHash() =>
    r'9de719b7a10d398cb048e3a635d3ea77bf1ecc73';

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

abstract class _$PlacementTestController
    extends BuildlessAutoDisposeAsyncNotifier<PlacementSessionState> {
  late final String courseId;

  FutureOr<PlacementSessionState> build(String courseId);
}

/// Contrôleur de session pour un cours donné (`courseId`).
///
/// Copied from [PlacementTestController].
@ProviderFor(PlacementTestController)
const placementTestControllerProvider = PlacementTestControllerFamily();

/// Contrôleur de session pour un cours donné (`courseId`).
///
/// Copied from [PlacementTestController].
class PlacementTestControllerFamily
    extends Family<AsyncValue<PlacementSessionState>> {
  /// Contrôleur de session pour un cours donné (`courseId`).
  ///
  /// Copied from [PlacementTestController].
  const PlacementTestControllerFamily();

  /// Contrôleur de session pour un cours donné (`courseId`).
  ///
  /// Copied from [PlacementTestController].
  PlacementTestControllerProvider call(String courseId) {
    return PlacementTestControllerProvider(courseId);
  }

  @override
  PlacementTestControllerProvider getProviderOverride(
    covariant PlacementTestControllerProvider provider,
  ) {
    return call(provider.courseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'placementTestControllerProvider';
}

/// Contrôleur de session pour un cours donné (`courseId`).
///
/// Copied from [PlacementTestController].
class PlacementTestControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PlacementTestController,
          PlacementSessionState
        > {
  /// Contrôleur de session pour un cours donné (`courseId`).
  ///
  /// Copied from [PlacementTestController].
  PlacementTestControllerProvider(String courseId)
    : this._internal(
        () => PlacementTestController()..courseId = courseId,
        from: placementTestControllerProvider,
        name: r'placementTestControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$placementTestControllerHash,
        dependencies: PlacementTestControllerFamily._dependencies,
        allTransitiveDependencies:
            PlacementTestControllerFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  PlacementTestControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String courseId;

  @override
  FutureOr<PlacementSessionState> runNotifierBuild(
    covariant PlacementTestController notifier,
  ) {
    return notifier.build(courseId);
  }

  @override
  Override overrideWith(PlacementTestController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PlacementTestControllerProvider._internal(
        () => create()..courseId = courseId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PlacementTestController,
    PlacementSessionState
  >
  createElement() {
    return _PlacementTestControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PlacementTestControllerProvider &&
        other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PlacementTestControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PlacementSessionState> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _PlacementTestControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PlacementTestController,
          PlacementSessionState
        >
    with PlacementTestControllerRef {
  _PlacementTestControllerProviderElement(super.provider);

  @override
  String get courseId => (origin as PlacementTestControllerProvider).courseId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
