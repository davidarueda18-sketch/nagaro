sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Error de red. Verifica tu conexión.']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error al acceder al almacenamiento local.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'No autorizado. Inicia sesión nuevamente.']);
}

final class ServerFailure extends Failure {
  const ServerFailure({
    this.statusCode,
    String message = 'Error del servidor. Intenta más tarde.',
  }) : super(message);

  final int? statusCode;
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Ocurrió un error inesperado.']);
}
