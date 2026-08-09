// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_player_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$audioPlayerServiceHash() =>
    r'c5553cdc0bf28162e671409c30d57b8bfbc49100';

/// Service de lecture audio unique pour l'app.
///
/// - Un seul lecteur actif : un nouvel appel à [play] stoppe le précédent.
/// - État observable via [audioPlayerServiceProvider] (`AudioPlaybackState`).
/// - Erreurs réseau / URL invalide → état `error` (pas de crash).
///
/// Copied from [AudioPlayerService].
@ProviderFor(AudioPlayerService)
final audioPlayerServiceProvider =
    NotifierProvider<AudioPlayerService, AudioPlaybackState>.internal(
      AudioPlayerService.new,
      name: r'audioPlayerServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$audioPlayerServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AudioPlayerService = Notifier<AudioPlaybackState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
