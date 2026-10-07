import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/auth/auth_service.dart';
import '../services/auth/auth_exceptions.dart';

/// Auth state enum
enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  loading,
  error,
}

/// Auth state model
class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? errorMessage,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    // Initialize auth state
    _initialize();
  }

  /// Initialize auth state by checking current user
  Future<void> _initialize() async {
    try {
      // Set loading state
      state = state.copyWith(status: AuthStatus.loading, isLoading: true);
      
      // Check current user
      final user = _authService.currentUser;
      
      if (user != null) {
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        );
      } else {
        // Check if there's a user in Firebase
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null) {
          // Try to get user from database
          try {
            final user = await _authService.getUser(firebaseUser.uid);
            state = AuthState(
              status: AuthStatus.authenticated,
              user: user,
              isLoading: false,
            );
          } catch (e) {
            // If we can't get user from database, still consider authenticated
            state = AuthState(
              status: AuthStatus.authenticated,
              user: UserModel(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? '',
                displayName: firebaseUser.displayName,
                createdAt: DateTime.now(),
              ),
              isLoading: false,
            );
          }
        } else {
          state = AuthState(
            status: AuthStatus.unauthenticated,
            isLoading: false,
          );
        }
      }
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur d\'initialisation: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de connexion: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    int? age,
    String? gender,
    int? height,
    double? weight,
    String? timezone,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: _parseGender(gender),
        height: height,
        weight: weight,
        timezone: timezone,
      );
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur d\'inscription: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authService.signInWithGoogle();
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de connexion Google: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      final user = await _authService.signInWithApple();
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de connexion Apple: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.signOut();
      
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de déconnexion: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Delete account
  Future<void> deleteAccount() async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.deleteAccount();
      
      state = const AuthState(
        status: AuthStatus.unauthenticated,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de suppression du compte: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      await _authService.sendPasswordResetEmail(email);
      
      // Don't change auth state for password reset
      state = state.copyWith(isLoading: false);
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur d\'envoi de l\'email: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.updateProfile(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      
      // Refresh user data
      final user = _authService.currentUser;
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de mise à jour du profil: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.updateEmail(newEmail);
      
      // Refresh user data
      final user = _authService.currentUser;
      
      state = AuthState(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de mise à jour de l\'email: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      state = state.copyWith(isLoading: true);
      
      await _authService.updatePassword(newPassword);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erreur de mise à jour du mot de passe: ${e.toString()}',
        isLoading: false,
      );
      rethrow;
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Parse gender string to enum
  UserGender? _parseGender(String? gender) {
    if (gender == null) return null;
    
    switch (gender.toLowerCase()) {
      case 'male':
      case 'homme':
        return UserGender.male;
      case 'female':
      case 'femme':
        return UserGender.female;
      case 'other':
      case 'autre':
        return UserGender.other;
      case 'prefer not to say':
      case 'préfère ne pas dire':
        return UserGender.preferNotToSay;
      default:
        return null;
    }
  }
}

/// Auth state provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

/// Current user provider
final currentUserProvider = Provider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

/// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.status == AuthStatus.authenticated;
});

/// Is loading provider
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isLoading;
});

/// Error message provider
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.errorMessage;
});

/// User ID provider
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id;
});
