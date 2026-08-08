// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'5b665a3944e8f01007b09a14c5b609505bbd899c';

/// Instance de [SharedPreferences] — surchargée dans `main()` après init async.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$secureStorageServiceHash() =>
    r'977e09a031697444060df5ea90e1560d13b5feb1';

/// See also [secureStorageService].
@ProviderFor(secureStorageService)
final secureStorageServiceProvider = Provider<SecureStorageService>.internal(
  secureStorageService,
  name: r'secureStorageServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$secureStorageServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageServiceRef = ProviderRef<SecureStorageService>;
String _$localCacheServiceHash() => r'33d06e3ef9587cef0632aa04500329071249a785';

/// See also [localCacheService].
@ProviderFor(localCacheService)
final localCacheServiceProvider = Provider<LocalCacheService>.internal(
  localCacheService,
  name: r'localCacheServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$localCacheServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LocalCacheServiceRef = ProviderRef<LocalCacheService>;
String _$dioClientHash() => r'ceb552022c414e8be8d9db2eae42f82b9ae3d797';

/// Client HTTP applicatif (Dio) partagé.
///
/// Branche l'intercepteur d'auth/refresh sur le [SessionController] : la
/// dépendance n'est lue qu'au runtime (dans le callback), donc pas de cycle.
///
/// Copied from [dioClient].
@ProviderFor(dioClient)
final dioClientProvider = Provider<Dio>.internal(
  dioClient,
  name: r'dioClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$dioClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DioClientRef = ProviderRef<Dio>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
