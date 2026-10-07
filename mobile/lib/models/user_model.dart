import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User gender enum
enum UserGender {
  male,
  female,
  other,
  preferNotToSay,
}

/// User model representing a user in the system
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    /// Unique user ID (Firebase UID)
    required String id,
    
    /// User's email address
    required String email,
    
    /// User's display name (optional)
    String? displayName,
    
    /// User's first name (optional)
    String? firstName,
    
    /// User's last name (optional)
    String? lastName,
    
    /// User's age in years
    int? age,
    
    /// User's gender
    UserGender? gender,
    
    /// User's height in cm
    int? height,
    
    /// User's weight in kg
    double? weight,
    
    /// User's timezone (e.g., "Europe/Paris")
    String? timezone,
    
    /// User's date of birth
    DateTime? dateOfBirth,
    
    /// User's profile picture URL
    String? profilePictureUrl,
    
    /// User's subscription status
    @Default(false) bool isPremium,
    
    /// User's subscription type (monthly, yearly, lifetime)
    String? subscriptionType,
    
    /// User's subscription expiry date
    DateTime? subscriptionExpiry,
    
    /// User's trial status
    @Default(false) bool isTrial,
    
    /// User's trial expiry date
    DateTime? trialExpiry,
    
    /// User's onboarding completion status
    @Default(false) bool onboardingCompleted,
    
    /// User's account creation date
    required DateTime createdAt,
    
    /// User's last update date
    DateTime? updatedAt,
    
    /// User's last login date
    DateTime? lastLoginAt,
    
    /// User's preferred language
    @Default('fr') String language,
    
    /// User's currency preference
    @Default('EUR') String currency,
    
    /// User's notification preferences
    @Default({}) Map<String, bool> notificationPreferences,
    
    /// User's data sharing preferences
    @Default(false) bool shareDataForResearch,
    
    /// User's data export preferences
    @Default(true) bool allowDataExport,
    
    /// User's medical information (for analysis)
    UserMedicalInfo? medicalInfo,
    
    /// User's lifestyle information (for analysis)
    UserLifestyleInfo? lifestyleInfo,
    
    /// User's preferences
    UserPreferences? preferences,
    
    /// User's custom triggers
    @Default([]) List<String> customTriggers,
    
    /// User's custom symptoms
    @Default([]) List<String> customSymptoms,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel.fromJson({...data, 'id': doc.id});
  }
}

/// Medical information for analysis
@freezed
class UserMedicalInfo with _$UserMedicalInfo {
  const factory UserMedicalInfo({
    /// How long the user has been experiencing migraines (in years)
    int? yearsWithMigraines,
    
    /// User's typical migraine frequency (per month)
    int? typicalMigraineFrequency,
    
    /// User's typical migraine duration (in hours)
    double? typicalMigraineDuration,
    
    /// User's typical migraine intensity (0-10)
    int? typicalMigraineIntensity,
    
    /// User's already identified triggers
    @Default([]) List<String> identifiedTriggers,
    
    /// User's current treatments
    @Default([]) List<UserTreatment> treatments,
    
    /// User's family history of migraines
    bool? familyHistory,
    
    /// User's other medical conditions
    @Default([]) List<String> otherConditions,
    
    /// User's current medications
    @Default([]) List<UserMedication> currentMedications,
    
    /// User's allergies
    @Default([]) List<String> allergies,
  }) = _UserMedicalInfo;

  factory UserMedicalInfo.fromJson(Map<String, dynamic> json) =>
      _$UserMedicalInfoFromJson(json);
}

/// User treatment information
@freezed
class UserTreatment with _$UserTreatment {
  const factory UserTreatment({
    /// Treatment name
    required String name,
    
    /// Treatment type
    String? type,
    
    /// Treatment dosage
    String? dosage,
    
    /// Treatment frequency
    String? frequency,
    
    /// Treatment effectiveness (0-5)
    int? effectiveness,
    
    /// Treatment start date
    DateTime? startDate,
    
    /// Treatment end date (if stopped)
    DateTime? endDate,
    
    /// Notes about the treatment
    String? notes,
  }) = _UserTreatment;

  factory UserTreatment.fromJson(Map<String, dynamic> json) =>
      _$UserTreatmentFromJson(json);
}

/// User medication information
@freezed
class UserMedication with _$UserMedication {
  const factory UserMedication({
    /// Medication name
    required String name,
    
    /// Medication type
    String? type,
    
    /// Medication dosage
    String? dosage,
    
    /// Medication frequency
    String? frequency,
    
    /// Medication start date
    DateTime? startDate,
    
    /// Medication end date (if stopped)
    DateTime? endDate,
    
    /// Medication notes
    String? notes,
  }) = _UserMedication;

  factory UserMedication.fromJson(Map<String, dynamic> json) =>
      _$UserMedicationFromJson(json);
}

/// Lifestyle information for analysis
@freezed
class UserLifestyleInfo with _$UserLifestyleInfo {
  const factory UserLifestyleInfo({
    /// User's typical sleep schedule
    SleepSchedule? typicalSleepSchedule,
    
    /// User's typical caffeine consumption
    CaffeineConsumption? typicalCaffeineConsumption,
    
    /// User's typical alcohol consumption
    AlcoholConsumption? typicalAlcoholConsumption,
    
    /// User's work schedule
    WorkSchedule? workSchedule,
    
    /// User's typical water consumption (in liters)
    double? typicalWaterConsumption,
    
    /// User's typical physical activity level (0-5)
    int? typicalActivityLevel,
    
    /// User's typical stress level (0-10)
    int? typicalStressLevel,
    
    /// User's diet preferences
    @Default([]) List<String> dietPreferences,
    
    /// User's food intolerances
    @Default([]) List<String> foodIntolerances,
  }) = _UserLifestyleInfo;

  factory UserLifestyleInfo.fromJson(Map<String, dynamic> json) =>
      _$UserLifestyleInfoFromJson(json);
}

/// Sleep schedule information
@freezed
class SleepSchedule with _$SleepSchedule {
  const factory SleepSchedule({
    /// Typical bedtime
    String? bedtime,
    
    /// Typical wake-up time
    String? wakeupTime,
    
    /// Typical sleep duration (in hours)
    double? duration,
    
    /// Typical sleep quality (1-5)
    int? quality,
    
    /// Days of the week with typical schedule
    @Default([]) List<int> typicalDays,
  }) = _SleepSchedule;

  factory SleepSchedule.fromJson(Map<String, dynamic> json) =>
      _$SleepScheduleFromJson(json);
}

/// Caffeine consumption information
@freezed
class CaffeineConsumption with _$CaffeineConsumption {
  const factory CaffeineConsumption({
    /// Typical number of cups per day
    int? cupsPerDay,
    
    /// Typical caffeine sources
    @Default([]) List<String> sources,
    
    /// Typical total caffeine (in mg)
    int? totalMg,
    
    /// Typical first cup time
    String? firstCupTime,
    
    /// Typical last cup time
    String? lastCupTime,
  }) = _CaffeineConsumption;

  factory CaffeineConsumption.fromJson(Map<String, dynamic> json) =>
      _$CaffeineConsumptionFromJson(json);
}

/// Alcohol consumption information
@freezed
class AlcoholConsumption with _$AlcoholConsumption {
  const factory AlcoholConsumption({
    /// Typical frequency (e.g., "weekly", "monthly", "rarely")
    String? frequency,
    
    /// Typical types consumed
    @Default([]) List<String> types,
    
    /// Typical quantity per occasion
    int? quantity,
  }) = _AlcoholConsumption;

  factory AlcoholConsumption.fromJson(Map<String, dynamic> json) =>
      _$AlcoholConsumptionFromJson(json);
}

/// Work schedule information
@freezed
class WorkSchedule with _$WorkSchedule {
  const factory WorkSchedule({
    /// Typical work days (0-6, where 0 is Monday)
    @Default([]) List<int> workDays,
    
    /// Typical work start time
    String? startTime,
    
    /// Typical work end time
    String? endTime,
    
    /// Work from home frequency
    String? workFromHomeFrequency,
    
    /// Typical stress level at work (0-10)
    int? stressLevel,
  }) = _WorkSchedule;

  factory WorkSchedule.fromJson(Map<String, dynamic> json) =>
      _$WorkScheduleFromJson(json);
}

/// User preferences
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// Preferred date format
    @Default('dd/MM/yyyy') String dateFormat,
    
    /// Preferred time format
    @Default('HH:mm') String timeFormat,
    
    /// Show migraine mode confirmation
    @Default(true) bool showMigraineModeConfirmation,
    
    /// Enable haptic feedback
    @Default(true) bool enableHapticFeedback,
    
    /// Enable sound effects
    @Default(true) bool enableSoundEffects,
    
    /// Default migraine duration (in hours)
    double? defaultMigraineDuration,
    
    /// Default view for dashboard
    @Default('summary') String defaultDashboardView,
    
    /// Default view for calendar
    @Default('month') String defaultCalendarView,
    
    /// Show medical disclaimer
    @Default(true) bool showMedicalDisclaimer,
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);
}

// Hive type adapters for local storage
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return UserModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeMap(obj.toJson());
  }
}

// Register Hive adapters
void registerUserAdapters() {
  Hive.registerAdapter(UserModelAdapter());
}

// Extension methods for UserModel
extension UserModelExtensions on UserModel {
  /// Check if user has premium subscription
  bool get hasPremium => isPremium;

  /// Check if user has active trial
  bool get hasActiveTrial {
    if (!isTrial) return false;
    if (trialExpiry == null) return false;
    return DateTime.now().isBefore(trialExpiry!);
  }

  /// Check if user has active subscription
  bool get hasActiveSubscription {
    if (!isPremium) return false;
    if (subscriptionExpiry == null) return false;
    return DateTime.now().isBefore(subscriptionExpiry!);
  }

  /// Get user's full name
  String get fullName {
    final parts = [firstName, lastName].whereType<String>().toList();
    return parts.isNotEmpty ? parts.join(' ') : displayName ?? email;
  }

  /// Get user's initials
  String get initials {
    final first = firstName?.isNotEmpty == true ? firstName![0] : '';
    final last = lastName?.isNotEmpty == true ? lastName![0] : '';
    return '${first}${last}'.toUpperCase();
    
  }

  /// Get user's age display
  String get ageDisplay {
    if (age != null) return '$age ans';
    if (dateOfBirth != null) {
      final now = DateTime.now();
      final years = now.year - dateOfBirth!.year;
      if (now.month < dateOfBirth!.month || 
          (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
        return '${years - 1} ans';
      }
      return '$years ans';
    }
    return 'Non spécifié';
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in Firestore
    return json;
  }
}
