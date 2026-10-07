/// Custom authentication exceptions
class AuthException implements Exception {
  /// Error message
  final String message;
  
  /// Error code
  final String? code;
  
  /// Additional data
  final Map<String, dynamic>? data;

  /// Create a new AuthException
  const AuthException({
    required this.message,
    this.code,
    this.data,
  });

  /// Create AuthException from FirebaseAuthException
  factory AuthException.fromFirebaseException(dynamic exception) {
    final message = _getErrorMessage(exception);
    final code = _getErrorCode(exception);
    
    return AuthException(
      message: message,
      code: code,
    );
  }

  @override
  String toString() => 'AuthException: $message (Code: $code)';

  /// Get error message from FirebaseAuthException
  static String _getErrorMessage(dynamic exception) {
    if (exception is Exception) {
      final message = exception.toString();
      
      // Common Firebase auth error messages
      if (message.contains('user-not-found')) {
        return 'Utilisateur non trouvé. Vérifiez votre email.';
      }
      if (message.contains('wrong-password')) {
        return 'Mot de passe incorrect.';
      }
      if (message.contains('email-already-in-use')) {
        return 'Cet email est déjà utilisé par un autre compte.';
      }
      if (message.contains('invalid-email')) {
        return 'Adresse email invalide.';
      }
      if (message.contains('weak-password')) {
        return 'Le mot de passe doit comporter au moins 6 caractères.';
      }
      if (message.contains('operation-not-allowed')) {
        return 'Cette méthode de connexion n\'est pas autorisée.';
      }
      if (message.contains('user-disabled')) {
        return 'Ce compte a été désactivé.';
      }
      if (message.contains('too-many-requests')) {
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      }
      if (message.contains('network-request-failed')) {
        return 'Erreur réseau. Vérifiez votre connexion internet.';
      }
      if (message.contains('requires-recent-login')) {
        return 'Veuillez vous reconnecter pour effectuer cette action.';
      }
      if (message.contains('credential-already-in-use')) {
        return 'Ces informations d\'identification sont déjà utilisées.';
      }
      if (message.contains('invalid-credential')) {
        return 'Informations d\'identification invalides.';
      }
    }
    
    return 'Une erreur d\'authentification est survenue.';
  }

  /// Get error code from FirebaseAuthException
  static String? _getErrorCode(dynamic exception) {
    if (exception is Exception) {
      final message = exception.toString();
      
      if (message.contains('user-not-found')) return 'user-not-found';
      if (message.contains('wrong-password')) return 'wrong-password';
      if (message.contains('email-already-in-use')) return 'email-already-in-use';
      if (message.contains('invalid-email')) return 'invalid-email';
      if (message.contains('weak-password')) return 'weak-password';
      if (message.contains('operation-not-allowed')) return 'operation-not-allowed';
      if (message.contains('user-disabled')) return 'user-disabled';
      if (message.contains('too-many-requests')) return 'too-many-requests';
      if (message.contains('network-request-failed')) return 'network-request-failed';
      if (message.contains('requires-recent-login')) return 'requires-recent-login';
      if (message.contains('credential-already-in-use')) return 'credential-already-in-use';
      if (message.contains('invalid-credential')) return 'invalid-credential';
    }
    
    return null;
  }
}

/// Invalid email exception
class InvalidEmailException extends AuthException {
  const InvalidEmailException([String? message]) 
      : super(message: message ?? 'Adresse email invalide.');
}

/// Weak password exception
class WeakPasswordException extends AuthException {
  const WeakPasswordException([String? message]) 
      : super(message: message ?? 'Le mot de passe doit comporter au moins 6 caractères.');
}

/// Email already in use exception
class EmailAlreadyInUseException extends AuthException {
  final String email;
  
  const EmailAlreadyInUseException(this.email) 
      : super(message: 'L\'adresse email $email est déjà utilisée.');
}

/// User not found exception
class UserNotFoundException extends AuthException {
  const UserNotFoundException([String? message]) 
      : super(message: message ?? 'Utilisateur non trouvé.');
}

/// Wrong password exception
class WrongPasswordException extends AuthException {
  const WrongPasswordException([String? message]) 
      : super(message: message ?? 'Mot de passe incorrect.');
}

/// Account disabled exception
class AccountDisabledException extends AuthException {
  const AccountDisabledException([String? message]) 
      : super(message: message ?? 'Ce compte a été désactivé.');
}

/// Too many requests exception
class TooManyRequestsException extends AuthException {
  const TooManyRequestsException([String? message]) 
      : super(message: message ?? 'Trop de tentatives. Veuillez réessayer plus tard.');
}

/// Network error exception
class NetworkAuthException extends AuthException {
  const NetworkAuthException([String? message]) 
      : super(message: message ?? 'Erreur réseau. Vérifiez votre connexion internet.');
}

/// Reauthentication required exception
class ReauthenticationRequiredException extends AuthException {
  const ReauthenticationRequiredException([String? message]) 
      : super(message: message ?? 'Veuillez vous reconnecter pour effectuer cette action.');
}
