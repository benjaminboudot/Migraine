/// Custom database exceptions
class DatabaseException implements Exception {
  /// Error message
  final String message;
  
  /// Error code
  final String? code;
  
  /// Additional data
  final Map<String, dynamic>? data;

  /// Inner exception
  final dynamic innerException;

  /// Create a new DatabaseException
  const DatabaseException({
    required this.message,
    this.code,
    this.data,
    this.innerException,
  });

  @override
  String toString() => 'DatabaseException: $message (Code: $code)';
}

/// Custom repository exceptions
class RepositoryException implements Exception {
  /// Error message
  final String message;
  
  /// Error code
  final String? code;
  
  /// Additional data
  final Map<String, dynamic>? data;

  /// Inner exception
  final dynamic innerException;

  /// Create a new RepositoryException
  const RepositoryException({
    required this.message,
    this.code,
    this.data,
    this.innerException,
  });

  @override
  String toString() => 'RepositoryException: $message (Code: $code)';
}

/// Not found exception
class NotFoundException extends RepositoryException {
  const NotFoundException([
    String? message = 'Ressource non trouvée',
    String? code = 'not-found',
  ]) : super(message: message, code: code);
}

/// Already exists exception
class AlreadyExistsException extends RepositoryException {
  const AlreadyExistsException([
    String? message = 'Ressource déjà existante',
    String? code = 'already-exists',
  ]) : super(message: message, code: code);
}

/// Invalid data exception
class InvalidDataException extends RepositoryException {
  final List<String> errors;

  const InvalidDataException([
    this.errors = const [],
    String? message = 'Données invalides',
    String? code = 'invalid-data',
  ]) : super(message: message, code: code);
}

/// Unauthorized exception
class UnauthorizedException extends RepositoryException {
  const UnauthorizedException([
    String? message = 'Non autorisé',
    String? code = 'unauthorized',
  ]) : super(message: message, code: code);
}

/// Conflict exception
class ConflictException extends RepositoryException {
  const ConflictException([
    String? message = 'Conflit de données',
    String? code = 'conflict',
  ]) : super(message: message, code: code);
}

/// Rate limit exception
class RateLimitException extends RepositoryException {
  const RateLimitException([
    String? message = 'Trop de requêtes. Veuillez réessayer plus tard.',
    String? code = 'rate-limit-exceeded',
  ]) : super(message: message, code: code);
}

/// Offline exception
class OfflineException extends RepositoryException {
  const OfflineException([
    String? message = 'Vous êtes hors ligne. Les modifications seront synchronisées lorsque vous serez de retour en ligne.',
    String? code = 'offline',
  ]) : super(message: message, code: code);
}

/// Sync exception
class SyncException extends RepositoryException {
  const SyncException([
    String? message = 'Erreur de synchronisation',
    String? code = 'sync-failed',
  ]) : super(message: message, code: code);
}
