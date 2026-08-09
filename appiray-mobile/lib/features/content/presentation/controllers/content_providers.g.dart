// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$feedHash() => r'b0cfc91d9878a9fde68de7899793c2737cc9a3c3';

/// Fil des publications publiées.
///
/// Copied from [feed].
@ProviderFor(feed)
final feedProvider = AutoDisposeFutureProvider<List<Publication>>.internal(
  feed,
  name: r'feedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$feedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FeedRef = AutoDisposeFutureProviderRef<List<Publication>>;
String _$publicationDetailControllerHash() =>
    r'e1e5d0381db408bb8471aadec29f37137c063b2e';

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

abstract class _$PublicationDetailController
    extends BuildlessAutoDisposeAsyncNotifier<PublicationDetailState> {
  late final String publicationId;

  FutureOr<PublicationDetailState> build(String publicationId);
}

/// See also [PublicationDetailController].
@ProviderFor(PublicationDetailController)
const publicationDetailControllerProvider = PublicationDetailControllerFamily();

/// See also [PublicationDetailController].
class PublicationDetailControllerFamily
    extends Family<AsyncValue<PublicationDetailState>> {
  /// See also [PublicationDetailController].
  const PublicationDetailControllerFamily();

  /// See also [PublicationDetailController].
  PublicationDetailControllerProvider call(String publicationId) {
    return PublicationDetailControllerProvider(publicationId);
  }

  @override
  PublicationDetailControllerProvider getProviderOverride(
    covariant PublicationDetailControllerProvider provider,
  ) {
    return call(provider.publicationId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'publicationDetailControllerProvider';
}

/// See also [PublicationDetailController].
class PublicationDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          PublicationDetailController,
          PublicationDetailState
        > {
  /// See also [PublicationDetailController].
  PublicationDetailControllerProvider(String publicationId)
    : this._internal(
        () => PublicationDetailController()..publicationId = publicationId,
        from: publicationDetailControllerProvider,
        name: r'publicationDetailControllerProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$publicationDetailControllerHash,
        dependencies: PublicationDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            PublicationDetailControllerFamily._allTransitiveDependencies,
        publicationId: publicationId,
      );

  PublicationDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.publicationId,
  }) : super.internal();

  final String publicationId;

  @override
  FutureOr<PublicationDetailState> runNotifierBuild(
    covariant PublicationDetailController notifier,
  ) {
    return notifier.build(publicationId);
  }

  @override
  Override overrideWith(PublicationDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: PublicationDetailControllerProvider._internal(
        () => create()..publicationId = publicationId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        publicationId: publicationId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    PublicationDetailController,
    PublicationDetailState
  >
  createElement() {
    return _PublicationDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PublicationDetailControllerProvider &&
        other.publicationId == publicationId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, publicationId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin PublicationDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<PublicationDetailState> {
  /// The parameter `publicationId` of this provider.
  String get publicationId;
}

class _PublicationDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          PublicationDetailController,
          PublicationDetailState
        >
    with PublicationDetailControllerRef {
  _PublicationDetailControllerProviderElement(super.provider);

  @override
  String get publicationId =>
      (origin as PublicationDetailControllerProvider).publicationId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
