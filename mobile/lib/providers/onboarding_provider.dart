import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/database/user_repository.dart';

/// Onboarding step enum
enum OnboardingStep {
  welcome,
  personalInfo,
  medicalInfo,
  lifestyleInfo,
  preferences,
  completed,
}

/// Onboarding state model
class OnboardingState {
  final OnboardingStep currentStep;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final Map<String, dynamic> formData;
  final int progressPercentage;

  const OnboardingState({
    this.currentStep = OnboardingStep.welcome,
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.formData = const {},
    this.progressPercentage = 0,
  });

  OnboardingState copyWith({
    OnboardingStep? currentStep,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    Map<String, dynamic>? formData,
    int? progressPercentage,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      formData: formData ?? this.formData,
      progressPercentage: progressPercentage ?? this.progressPercentage,
    );
  }
}

/// Onboarding notifier
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final UserRepository _userRepository;
  
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _onboardingStepKey = 'onboarding_step';
  static const String _onboardingDataKey = 'onboarding_data';

  OnboardingNotifier(this._userRepository) : super(const OnboardingState()) {
    _loadOnboardingState();
  }

  /// Load onboarding state from shared preferences
  Future<void> _loadOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    
    final isCompleted = prefs.getBool(_onboardingCompletedKey) ?? false;
    final stepIndex = prefs.getInt(_onboardingStepKey) ?? 0;
    final formDataJson = prefs.getString(_onboardingDataKey);
    
    if (isCompleted) {
      state = state.copyWith(
        currentStep: OnboardingStep.completed,
        progressPercentage: 100,
      );
    } else {
      final step = OnboardingStep.values[stepIndex.clamp(0, OnboardingStep.values.length - 1)];
      final progress = _calculateProgress(step);
      
      Map<String, dynamic> formData = {};
      if (formDataJson != null) {
        try {
          // Simple JSON parsing - in real app use json.decode
          formData = _parseFormData(formDataJson);
        } catch (e) {
          // Ignore parsing errors
        }
      }
      
      state = state.copyWith(
        currentStep: step,
        formData: formData,
        progressPercentage: progress,
      );
    }
  }

  /// Calculate progress percentage
  int _calculateProgress(OnboardingStep step) {
    return ((step.index + 1) / OnboardingStep.values.length * 100).round();
  }

  /// Parse form data from JSON string
  Map<String, dynamic> _parseFormData(String json) {
    // Simple parsing - in real app use json.decode
    final data = <String, dynamic>{};
    
    // This is a simplified version
    // In a real app, use proper JSON parsing
    return data;
  }

  /// Save onboarding state
  Future<void> _saveOnboardingState() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (state.currentStep == OnboardingStep.completed) {
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.remove(_onboardingStepKey);
      await prefs.remove(_onboardingDataKey);
    } else {
      await prefs.setInt(_onboardingStepKey, state.currentStep.index);
      await prefs.setString(_onboardingDataKey, _formDataToJson(state.formData));
    }
  }

  /// Convert form data to JSON string
  String _formDataToJson(Map<String, dynamic> data) {
    // Simple JSON string creation - in real app use json.encode
    return data.toString();
  }

  /// Go to next step
  Future<void> nextStep() async {
    if (state.currentStep.index < OnboardingStep.values.length - 1) {
      final nextStep = OnboardingStep.values[state.currentStep.index + 1];
      state = state.copyWith(
        currentStep: nextStep,
        progressPercentage: _calculateProgress(nextStep),
      );
      await _saveOnboardingState();
    }
  }

  /// Go to previous step
  Future<void> previousStep() async {
    if (state.currentStep.index > 0) {
      final prevStep = OnboardingStep.values[state.currentStep.index - 1];
      state = state.copyWith(
        currentStep: prevStep,
        progressPercentage: _calculateProgress(prevStep),
      );
      await _saveOnboardingState();
    }
  }

  /// Go to specific step
  Future<void> goToStep(OnboardingStep step) async {
    state = state.copyWith(
      currentStep: step,
      progressPercentage: _calculateProgress(step),
    );
    await _saveOnboardingState();
  }

  /// Update form data
  void updateFormData(String key, dynamic value) {
    final newFormData = Map<String, dynamic>.from(state.formData);
    newFormData[key] = value;
    
    state = state.copyWith(formData: newFormData);
  }

  /// Update multiple form fields
  void updateFormFields(Map<String, dynamic> fields) {
    final newFormData = Map<String, dynamic>.from(state.formData);
    newFormData.addAll(fields);
    
    state = state.copyWith(formData: newFormData);
  }

  /// Save personal information
  Future<void> savePersonalInfo({
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
      
      // Update form data
      updateFormFields({
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
        'gender': gender,
        'height': height,
        'weight': weight,
        'timezone': timezone,
      });
      
      await _saveOnboardingState();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de sauvegarde des informations personnelles: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Save medical information
  Future<void> saveMedicalInfo({
    int? yearsWithMigraines,
    int? typicalMigraineFrequency,
    double? typicalMigraineDuration,
    int? typicalMigraineIntensity,
    List<String>? identifiedTriggers,
    List<UserTreatment>? treatments,
    bool? familyHistory,
    List<String>? otherConditions,
    List<UserMedication>? currentMedications,
    List<String>? allergies,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Update form data
      updateFormFields({
        'yearsWithMigraines': yearsWithMigraines,
        'typicalMigraineFrequency': typicalMigraineFrequency,
        'typicalMigraineDuration': typicalMigraineDuration,
        'typicalMigraineIntensity': typicalMigraineIntensity,
        'identifiedTriggers': identifiedTriggers,
        'treatments': treatments?.map((t) => t.toJson()).toList(),
        'familyHistory': familyHistory,
        'otherConditions': otherConditions,
        'currentMedications': currentMedications?.map((m) => m.toJson()).toList(),
        'allergies': allergies,
      });
      
      await _saveOnboardingState();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de sauvegarde des informations médicales: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Save lifestyle information
  Future<void> saveLifestyleInfo({
    SleepSchedule? typicalSleepSchedule,
    CaffeineConsumption? typicalCaffeineConsumption,
    AlcoholConsumption? typicalAlcoholConsumption,
    WorkSchedule? workSchedule,
    double? typicalWaterConsumption,
    int? typicalActivityLevel,
    int? typicalStressLevel,
    List<String>? dietPreferences,
    List<String>? foodIntolerances,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Update form data
      updateFormFields({
        'typicalSleepSchedule': typicalSleepSchedule?.toJson(),
        'typicalCaffeineConsumption': typicalCaffeineConsumption?.toJson(),
        'typicalAlcoholConsumption': typicalAlcoholConsumption?.toJson(),
        'workSchedule': workSchedule?.toJson(),
        'typicalWaterConsumption': typicalWaterConsumption,
        'typicalActivityLevel': typicalActivityLevel,
        'typicalStressLevel': typicalStressLevel,
        'dietPreferences': dietPreferences,
        'foodIntolerances': foodIntolerances,
      });
      
      await _saveOnboardingState();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de sauvegarde des informations de style de vie: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Save preferences
  Future<void> savePreferences({
    String? dateFormat,
    String? timeFormat,
    bool? showMigraineModeConfirmation,
    bool? enableHapticFeedback,
    bool? enableSoundEffects,
    double? defaultMigraineDuration,
    String? defaultDashboardView,
    String? defaultCalendarView,
    bool? showMedicalDisclaimer,
  }) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Update form data
      updateFormFields({
        'dateFormat': dateFormat,
        'timeFormat': timeFormat,
        'showMigraineModeConfirmation': showMigraineModeConfirmation,
        'enableHapticFeedback': enableHapticFeedback,
        'enableSoundEffects': enableSoundEffects,
        'defaultMigraineDuration': defaultMigraineDuration,
        'defaultDashboardView': defaultDashboardView,
        'defaultCalendarView': defaultCalendarView,
        'showMedicalDisclaimer': showMedicalDisclaimer,
      });
      
      await _saveOnboardingState();
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de sauvegarde des préférences: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Complete onboarding
  Future<void> completeOnboarding() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      
      // Create user from form data
      final userId = _userRepository.currentUserId;
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      // Build user model from form data
      final user = UserModel(
        id: userId,
        email: state.formData['email'] ?? '',
        firstName: state.formData['firstName'],
        lastName: state.formData['lastName'],
        age: state.formData['age'],
        gender: _parseGender(state.formData['gender']),
        height: state.formData['height'],
        weight: state.formData['weight'],
        timezone: state.formData['timezone'],
        createdAt: DateTime.now(),
        onboardingCompleted: true,
        medicalInfo: _buildMedicalInfo(),
        lifestyleInfo: _buildLifestyleInfo(),
        preferences: _buildPreferences(),
      );
      
      // Save user
      await _userRepository.updateUser(user);
      
      // Mark onboarding as completed
      state = state.copyWith(
        currentStep: OnboardingStep.completed,
        progressPercentage: 100,
        isLoading: false,
      );
      
      await _saveOnboardingState();
      
      // Update user's onboarding status in database
      await _userRepository.updateOnboardingCompleted(true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur de finalisation de l\'onboarding: ${e.toString()}',
      );
      rethrow;
    }
  }

  /// Build medical info from form data
  UserMedicalInfo? _buildMedicalInfo() {
    if (!state.formData.containsKey('yearsWithMigraines')) return null;
    
    return UserMedicalInfo(
      yearsWithMigraines: state.formData['yearsWithMigraines'],
      typicalMigraineFrequency: state.formData['typicalMigraineFrequency'],
      typicalMigraineDuration: state.formData['typicalMigraineDuration'],
      typicalMigraineIntensity: state.formData['typicalMigraineIntensity'],
      identifiedTriggers: state.formData['identifiedTriggers'] != null
          ? List<String>.from(state.formData['identifiedTriggers'])
          : null,
      treatments: state.formData['treatments'] != null
          ? (state.formData['treatments'] as List<dynamic>)
              .map((t) => UserTreatment.fromJson(t as Map<String, dynamic>))
              .toList()
          : null,
      familyHistory: state.formData['familyHistory'],
      otherConditions: state.formData['otherConditions'] != null
          ? List<String>.from(state.formData['otherConditions'])
          : null,
      currentMedications: state.formData['currentMedications'] != null
          ? (state.formData['currentMedications'] as List<dynamic>)
              .map((m) => UserMedication.fromJson(m as Map<String, dynamic>))
              .toList()
          : null,
      allergies: state.formData['allergies'] != null
          ? List<String>.from(state.formData['allergies'])
          : null,
    );
  }

  /// Build lifestyle info from form data
  UserLifestyleInfo? _buildLifestyleInfo() {
    if (!state.formData.containsKey('typicalSleepSchedule')) return null;
    
    return UserLifestyleInfo(
      typicalSleepSchedule: state.formData['typicalSleepSchedule'] != null
          ? SleepSchedule.fromJson(state.formData['typicalSleepSchedule'] as Map<String, dynamic>)
          : null,
      typicalCaffeineConsumption: state.formData['typicalCaffeineConsumption'] != null
          ? CaffeineConsumption.fromJson(state.formData['typicalCaffeineConsumption'] as Map<String, dynamic>)
          : null,
      typicalAlcoholConsumption: state.formData['typicalAlcoholConsumption'] != null
          ? AlcoholConsumption.fromJson(state.formData['typicalAlcoholConsumption'] as Map<String, dynamic>)
          : null,
      workSchedule: state.formData['workSchedule'] != null
          ? WorkSchedule.fromJson(state.formData['workSchedule'] as Map<String, dynamic>)
          : null,
      typicalWaterConsumption: state.formData['typicalWaterConsumption'],
      typicalActivityLevel: state.formData['typicalActivityLevel'],
      typicalStressLevel: state.formData['typicalStressLevel'],
      dietPreferences: state.formData['dietPreferences'] != null
          ? List<String>.from(state.formData['dietPreferences'])
          : null,
      foodIntolerances: state.formData['foodIntolerances'] != null
          ? List<String>.from(state.formData['foodIntolerances'])
          : null,
    );
  }

  /// Build preferences from form data
  UserPreferences? _buildPreferences() {
    if (!state.formData.containsKey('dateFormat')) return null;
    
    return UserPreferences(
      dateFormat: state.formData['dateFormat'] ?? 'dd/MM/yyyy',
      timeFormat: state.formData['timeFormat'] ?? 'HH:mm',
      showMigraineModeConfirmation: state.formData['showMigraineModeConfirmation'] ?? true,
      enableHapticFeedback: state.formData['enableHapticFeedback'] ?? true,
      enableSoundEffects: state.formData['enableSoundEffects'] ?? true,
      defaultMigraineDuration: state.formData['defaultMigraineDuration'],
      defaultDashboardView: state.formData['defaultDashboardView'] ?? 'summary',
      defaultCalendarView: state.formData['defaultCalendarView'] ?? 'month',
      showMedicalDisclaimer: state.formData['showMedicalDisclaimer'] ?? true,
    );
  }

  /// Parse gender string to enum
  UserGender? _parseGender(dynamic gender) {
    if (gender == null) return null;
    
    if (gender is UserGender) return gender;
    if (gender is String) {
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
    
    return null;
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// Check if onboarding is completed
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  /// Reset onboarding
  Future<void> resetOnboarding() async {
    state = const OnboardingState();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
    await prefs.remove(_onboardingStepKey);
    await prefs.remove(_onboardingDataKey);
  }
}

/// Onboarding provider
final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return OnboardingNotifier(userRepository);
});

/// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

/// Current onboarding step provider
final currentOnboardingStepProvider = Provider<OnboardingStep>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.currentStep;
});

/// Onboarding progress provider
final onboardingProgressProvider = Provider<int>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.progressPercentage;
});

/// Onboarding form data provider
final onboardingFormDataProvider = Provider<Map<String, dynamic>>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.formData;
});

/// Is onboarding loading provider
final isOnboardingLoadingProvider = Provider<bool>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.isLoading;
});

/// Onboarding error provider
final onboardingErrorProvider = Provider<String?>((ref) {
  final onboardingState = ref.watch(onboardingProvider);
  return onboardingState.errorMessage;
});
