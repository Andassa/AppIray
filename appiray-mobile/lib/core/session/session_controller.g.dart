// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionControllerHash() => r'2aa82d40f6e19c00b7b658f195542b8b2733c7b1';

/// Source de vérité unique de l'état d'auth.
///
/// - Le router `go_router` écoute ce provider pour rediriger automatiquement.
/// - L'intercepteur Dio appelle [markExpired] quand le refresh token échoue.
/// - Le contrôleur d'auth (feature) appelle [onAuthenticated] / [logout].
///
/// Volontairement indépendant de Dio et des repositories pour éviter tout cycle
/// de dépendances.
///
/// Copied from [SessionController].
@ProviderFor(SessionController)
final sessionControllerProvider =
    NotifierProvider<SessionController, AuthStatus>.internal(
      SessionController.new,
      name: r'sessionControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sessionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SessionController = Notifier<AuthStatus>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
