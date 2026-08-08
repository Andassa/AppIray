import 'package:appiray/core/network/api_exception.dart';

/// Wrapper `Result<T>` pour uniformiser la gestion d'erreur.
///
/// Toute méthode de repository retourne un `Result<T>` : soit [Success] avec la
/// valeur, soit [FailureResult] avec un [Failure]. Les widgets n'ont donc jamais
/// à faire de try/catch : ils font un `switch` (ou utilisent [when]).
sealed class Result<T> {
  const Result();

  /// Construit un succès.
  const factory Result.success(T value) = Success<T>;

  /// Construit un échec.
  const factory Result.failure(Failure failure) = FailureResult<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  /// Valeur si succès, sinon null.
  T? get valueOrNull => switch (this) {
        Success<T>(:final value) => value,
        FailureResult<T>() => null,
      };

  /// Échec si échec, sinon null.
  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        FailureResult<T>(:final failure) => failure,
      };

  /// Pattern-matching exhaustif.
  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    return switch (this) {
      Success<T>(:final value) => success(value),
      FailureResult<T>(failure: final f) => failure(f),
    };
  }

  /// Transforme la valeur en cas de succès, propage l'échec sinon.
  Result<R> map<R>(R Function(T value) transform) {
    return switch (this) {
      Success<T>(:final value) => Result.success(transform(value)),
      FailureResult<T>(:final failure) => Result.failure(failure),
    };
  }
}

class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

class FailureResult<T> extends Result<T> {
  const FailureResult(this.failure);
  final Failure failure;
}

/// Erreur métier normalisée, présentable à l'utilisateur.
class Failure {
  const Failure(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  /// Construit un [Failure] lisible à partir d'une [ApiException].
  factory Failure.fromApiException(ApiException e) =>
      Failure(e.message, statusCode: e.statusCode, cause: e);

  /// Échec inattendu (exception non typée).
  factory Failure.unexpected([Object? cause]) =>
      Failure('Une erreur inattendue est survenue.', cause: cause);

  @override
  String toString() => 'Failure($statusCode): $message';
}
