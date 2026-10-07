import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../models/user_model.dart';
import '../database/user_repository.dart';
import 'auth_exceptions.dart';

/// Authentication service for handling user authentication
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  /// Create a new AuthService instance
  AuthService({
    FirebaseAuth? firebaseAuth,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();

  /// Get the current authenticated user
  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    
    // Try to get user from cache first
    // In a real implementation, you would fetch from your database
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      profilePictureUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
  }

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      // Fetch user data from database
      try {
        final user = await _userRepository.getUser(firebaseUser.uid);
        return user ?? UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
        );
      } catch (e) {
        // If user doesn't exist in database, create a basic user model
        return UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
        );
      }
    });
  }

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user!;
      
      // Fetch or create user in database
      var user = await _userRepository.getUser(firebaseUser.uid);
      
      if (user == null) {
        // Create new user in database
        user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? email,
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _userRepository.createUser(user);
      } else {
        // Update last login time
        user = user.copyWith(lastLoginAt: DateTime.now());
        await _userRepository.updateUser(user);
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de connexion: ${e.toString()}');
    }
  }

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    int? age,
    UserGender? gender,
    int? height,
    double? weight,
    String? timezone,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final firebaseUser = userCredential.user!;
      
      // Create user in database
      final user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        displayName: firstName != null && lastName != null 
            ? '$firstName $lastName' 
            : firstName ?? lastName,
        firstName: firstName,
        lastName: lastName,
        age: age,
        gender: gender,
        height: height,
        weight: weight,
        timezone: timezone,
        profilePictureUrl: firebaseUser.photoURL,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        onboardingCompleted: false,
      );
      
      await _userRepository.createUser(user);
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur d\'inscription: ${e.toString()}');
    }
  }

  /// Sign in with Google
  Future<UserModel> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();
      
      if (googleUser == null) {
        throw AuthException(message: 'Connexion Google annulée');
      }
      
      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;
      
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Once signed in, return the UserCredential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user!;
      
      // Fetch or create user in database
      var user = await _userRepository.getUser(firebaseUser.uid);
      
      if (user == null) {
        // Create new user in database
        user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName ?? googleUser.displayName,
          firstName: googleUser.displayName?.split(' ').first,
          lastName: googleUser.displayName?.split(' ').last,
          profilePictureUrl: firebaseUser.photoURL ?? googleUser.photoUrl,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _userRepository.createUser(user);
      } else {
        // Update last login time
        user = user.copyWith(lastLoginAt: DateTime.now());
        await _userRepository.updateUser(user);
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } on PlatformException catch (e) {
      throw AuthException(message: 'Erreur de connexion Google: ${e.message}');
    } catch (e) {
      throw AuthException(message: 'Erreur de connexion Google: ${e.toString()}');
    }
  }

  /// Sign in with Apple
  Future<UserModel> signInWithApple() async {
    try {
      // Configure Sign in with Apple
      final appleProvider = AppleAuthProvider();
      
      if (defaultTargetPlatform == TargetPlatform.android) {
        appleProvider.addScope('email');
        appleProvider.addScope('fullName');
      }
      
      // Perform the sign-in
      final userCredential = await _firebaseAuth.signInWithProvider(appleProvider);
      final firebaseUser = userCredential.user!;
      
      // Fetch or create user in database
      var user = await _userRepository.getUser(firebaseUser.uid);
      
      if (user == null) {
        // Create new user in database
        user = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          displayName: firebaseUser.displayName,
          profilePictureUrl: firebaseUser.photoURL,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );
        await _userRepository.createUser(user);
      } else {
        // Update last login time
        user = user.copyWith(lastLoginAt: DateTime.now());
        await _userRepository.updateUser(user);
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } on PlatformException catch (e) {
      throw AuthException(message: 'Erreur de connexion Apple: ${e.message}');
    } catch (e) {
      throw AuthException(message: 'Erreur de connexion Apple: ${e.toString()}');
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      
      // Also sign out from Google if signed in with Google
      if (defaultTargetPlatform == TargetPlatform.android || 
          defaultTargetPlatform == TargetPlatform.iOS) {
        await GoogleSignIn().signOut();
      }
    } catch (e) {
      throw AuthException(message: 'Erreur de déconnexion: ${e.toString()}');
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException(message: 'Aucun utilisateur connecté');
      }
      
      // Delete user from database first
      await _userRepository.deleteUser(firebaseUser.uid);
      
      // Then delete from Firebase Auth
      await firebaseUser.delete();
      
      // Also sign out from Google if signed in with Google
      if (defaultTargetPlatform == TargetPlatform.android || 
          defaultTargetPlatform == TargetPlatform.iOS) {
        await GoogleSignIn().signOut();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de suppression du compte: ${e.toString()}');
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur d\'envoi de l\'email de réinitialisation: ${e.toString()}');
    }
  }

  /// Update user email
  Future<void> updateEmail(String newEmail) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException(message: 'Aucun utilisateur connecté');
      }
      
      await firebaseUser.updateEmail(newEmail);
      
      // Update in database
      final user = await _userRepository.getUser(firebaseUser.uid);
      if (user != null) {
        await _userRepository.updateUser(
          user.copyWith(email: newEmail),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de mise à jour de l\'email: ${e.toString()}');
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException(message: 'Aucun utilisateur connecté');
      }
      
      await firebaseUser.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de mise à jour du mot de passe: ${e.toString()}');
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException(message: 'Aucun utilisateur connecté');
      }
      
      if (displayName != null) {
        await firebaseUser.updateDisplayName(displayName);
      }
      
      if (photoUrl != null) {
        await firebaseUser.updatePhotoURL(photoUrl);
      }
      
      // Update in database
      final user = await _userRepository.getUser(firebaseUser.uid);
      if (user != null) {
        await _userRepository.updateUser(
          user.copyWith(
            displayName: displayName,
            profilePictureUrl: photoUrl,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de mise à jour du profil: ${e.toString()}');
    }
  }

  /// Reauthenticate user (required for sensitive operations)
  Future<void> reauthenticateWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw AuthException(message: 'Aucun utilisateur connecté');
      }
      
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      await firebaseUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de réauthentification: ${e.toString()}');
    }
  }

  /// Get user ID token (for backend API calls)
  Future<String?> getIdToken() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      
      return await firebaseUser.getIdToken();
    } catch (e) {
      throw AuthException(message: 'Erreur de récupération du token: ${e.toString()}');
    }
  }

  /// Get user ID token with refresh
  Future<String?> getIdTokenWithRefresh(bool forceRefresh) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return null;
      
      return await firebaseUser.getIdToken(forceRefresh);
    } catch (e) {
      throw AuthException(message: 'Erreur de récupération du token: ${e.toString()}');
    }
  }

  /// Check if user is anonymous
  bool get isAnonymous {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser?.isAnonymous ?? false;
  }

  /// Convert anonymous user to permanent user
  Future<UserModel> convertAnonymousToPermanent({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null || !firebaseUser.isAnonymous) {
        throw AuthException(message: 'Aucun utilisateur anonyme connecté');
      }
      
      // Create credentials
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      
      // Link the anonymous user with the permanent account
      await firebaseUser.linkWithCredential(credential);
      
      // Update user in database
      final user = UserModel(
        id: firebaseUser.uid,
        email: email,
        displayName: firstName != null && lastName != null 
            ? '$firstName $lastName' 
            : firstName ?? lastName,
        firstName: firstName,
        lastName: lastName,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
      );
      
      await _userRepository.updateUser(user);
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseException(e);
    } catch (e) {
      throw AuthException(message: 'Erreur de conversion de compte: ${e.toString()}');
    }
  }
}
