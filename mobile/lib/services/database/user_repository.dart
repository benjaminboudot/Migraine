import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import 'database_service.dart';
import 'database_exceptions.dart';

/// User repository for managing user data
class UserRepository {
  final DatabaseService _databaseService;
  final FirebaseAuth _auth;

  /// Create a new UserRepository instance
  UserRepository({
    DatabaseService? databaseService,
    FirebaseAuth? auth,
  })  : _databaseService = databaseService ?? DatabaseService(),
        _auth = auth ?? FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Create a new user
  Future<UserModel> createUser(UserModel user) async {
    try {
      // Validate user
      if (user.id.isEmpty) {
        throw RepositoryException(
          message: 'L\'ID utilisateur ne peut pas être vide',
          code: 'invalid-user-id',
        );
      }
      
      // Set creation timestamp if not set
      final userToCreate = user.copyWith(
        createdAt: user.createdAt ?? DateTime.now(),
      );
      
      return await _databaseService.createUser(userToCreate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de création de l\'utilisateur: ${e.toString()}',
        code: 'create-user-failed',
        innerException: e,
      );
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      return await _databaseService.getUser(userId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération de l\'utilisateur: ${e.toString()}',
        code: 'get-user-failed',
        innerException: e,
      );
    }
  }

  /// Get current user
  Future<UserModel?> getCurrentUser() async {
    final userId = currentUserId;
    if (userId == null) return null;
    
    return await getUser(userId);
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      // Update last modified timestamp
      final userToUpdate = user.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(userToUpdate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour de l\'utilisateur: ${e.toString()}',
        code: 'update-user-failed',
        innerException: e,
      );
    }
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? displayName,
    int? age,
    UserGender? gender,
    int? height,
    double? weight,
    String? timezone,
    DateTime? dateOfBirth,
    String? profilePictureUrl,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        firstName: firstName ?? user.firstName,
        lastName: lastName ?? user.lastName,
        displayName: displayName ?? user.displayName,
        age: age ?? user.age,
        gender: gender ?? user.gender,
        height: height ?? user.height,
        weight: weight ?? user.weight,
        timezone: timezone ?? user.timezone,
        dateOfBirth: dateOfBirth ?? user.dateOfBirth,
        profilePictureUrl: profilePictureUrl ?? user.profilePictureUrl,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour du profil: ${e.toString()}',
        code: 'update-profile-failed',
        innerException: e,
      );
    }
  }

  /// Update user medical information
  Future<void> updateUserMedicalInfo(UserMedicalInfo medicalInfo) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        medicalInfo: medicalInfo,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour des informations médicales: ${e.toString()}',
        code: 'update-medical-info-failed',
        innerException: e,
      );
    }
  }

  /// Update user lifestyle information
  Future<void> updateUserLifestyleInfo(UserLifestyleInfo lifestyleInfo) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        lifestyleInfo: lifestyleInfo,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour des informations de style de vie: ${e.toString()}',
        code: 'update-lifestyle-info-failed',
        innerException: e,
      );
    }
  }

  /// Update user preferences
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        preferences: preferences,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour des préférences: ${e.toString()}',
        code: 'update-preferences-failed',
        innerException: e,
      );
    }
  }

  /// Update onboarding completion status
  Future<void> updateOnboardingCompleted(bool completed) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        onboardingCompleted: completed,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour du statut onboarding: ${e.toString()}',
        code: 'update-onboarding-failed',
        innerException: e,
      );
    }
  }

  /// Add custom trigger
  Future<void> addCustomTrigger(String trigger) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      // Check if trigger already exists
      if (!user.customTriggers.contains(trigger)) {
        final updatedUser = user.copyWith(
          customTriggers: [...user.customTriggers, trigger],
          updatedAt: DateTime.now(),
        );
        
        await _databaseService.updateUser(updatedUser);
      }
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur d\'ajout du déclencheur personnalisé: ${e.toString()}',
        code: 'add-trigger-failed',
        innerException: e,
      );
    }
  }

  /// Remove custom trigger
  Future<void> removeCustomTrigger(String trigger) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        customTriggers: user.customTriggers.where((t) => t != trigger).toList(),
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de suppression du déclencheur personnalisé: ${e.toString()}',
        code: 'remove-trigger-failed',
        innerException: e,
      );
    }
  }

  /// Add custom symptom
  Future<void> addCustomSymptom(String symptom) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      // Check if symptom already exists
      if (!user.customSymptoms.contains(symptom)) {
        final updatedUser = user.copyWith(
          customSymptoms: [...user.customSymptoms, symptom],
          updatedAt: DateTime.now(),
        );
        
        await _databaseService.updateUser(updatedUser);
      }
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur d\'ajout du symptôme personnalisé: ${e.toString()}',
        code: 'add-symptom-failed',
        innerException: e,
      );
    }
  }

  /// Remove custom symptom
  Future<void> removeCustomSymptom(String symptom) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final user = await getUser(userId);
      if (user == null) {
        throw RepositoryException(
          message: 'Utilisateur non trouvé',
          code: 'user-not-found',
        );
      }
      
      final updatedUser = user.copyWith(
        customSymptoms: user.customSymptoms.where((s) => s != symptom).toList(),
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de suppression du symptôme personnalisé: ${e.toString()}',
        code: 'remove-symptom-failed',
        innerException: e,
      );
    }
  }

  /// Delete user
  Future<void> deleteUser() async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      await _databaseService.deleteUser(userId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de suppression de l\'utilisateur: ${e.toString()}',
        code: 'delete-user-failed',
        innerException: e,
      );
    }
  }

  /// Stream user data
  Stream<UserModel?> streamUser() {
    final userId = currentUserId;
    if (userId == null) {
      throw RepositoryException(
        message: 'Utilisateur non authentifié',
        code: 'unauthenticated',
      );
    }
    
    return _databaseService.streamUser(userId);
  }

  /// Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final user = await getUser(userId);
      return user != null;
    } catch (e) {
      return false;
    }
  }

  /// Update last login time
  Future<void> updateLastLoginTime() async {
    try {
      final userId = currentUserId;
      if (userId == null) return;
      
      final user = await getUser(userId);
      if (user == null) return;
      
      final updatedUser = user.copyWith(
        lastLoginAt: DateTime.now(),
      );
      
      await _databaseService.updateUser(updatedUser);
    } catch (e) {
      // Silently fail - not critical
      debugPrint('Failed to update last login time: ${e.toString()}');
    }
  }
}
