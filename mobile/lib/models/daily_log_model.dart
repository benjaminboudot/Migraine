import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'daily_log_model.freezed.dart';
part 'daily_log_model.g.dart';

/// Daily log model for tracking various health and lifestyle factors
@freezed
class DailyLogModel with _$DailyLogModel {
  const factory DailyLogModel({
    /// Unique daily log ID
    String? id,
    
    /// User ID (reference to user)
    required String userId,
    
    /// Date of the log (date only, no time)
    required DateTime date,
    
    // Sleep information
    SleepLog? sleep,
    
    // Hydration information
    HydrationLog? hydration,
    
    // Caffeine information
    CaffeineLog? caffeine,
    
    // Alcohol information
    AlcoholLog? alcohol,
    
    // Food information
    FoodLog? food,
    
    // Stress information
    StressLog? stress,
    
    // Fatigue information
    FatigueLog? fatigue,
    
    // Physical activity information
    PhysicalActivityLog? physicalActivity,
    
    // Screen time information
    ScreenTimeLog? screenTime,
    
    // Environment information
    EnvironmentLog? environment,
    
    // Medication information
    @Default([]) List<MedicationLog> medications,
    
    // Mood information
    MoodLog? mood,
    
    // Menstrual cycle information (optional)
    MenstrualLog? menstrual,
    
    // Work information
    WorkLog? work,
    
    // Weather information (auto-filled)
    WeatherLog? weather,
    
    // Notes
    String? notes,
    
    /// Whether a migraine occurred on this day
    @Default(false) bool hadMigraine,
    
    /// Reference to migraine ID (if migraine occurred)
    String? migraineId,
    
    /// Record creation timestamp
    required DateTime createdAt,
    
    /// Record last update timestamp
    DateTime? updatedAt,
    
    /// Whether the record is synced with the cloud
    @Default(false) bool isSynced,
    
    /// Whether the record is marked as deleted (soft delete)
    @Default(false) bool isDeleted,
    
    /// Local ID for offline storage
    String? localId,
  }) = _DailyLogModel;

  factory DailyLogModel.fromJson(Map<String, dynamic> json) =>
      _$DailyLogModelFromJson(json);

  factory DailyLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyLogModel.fromJson({...data, 'id': doc.id});
  }
}

/// Sleep log
@freezed
class SleepLog with _$SleepLog {
  const factory SleepLog({
    /// Bedtime
    String? bedtime,
    
    /// Wake-up time
    String? wakeupTime,
    
    /// Total sleep duration in minutes
    int? durationMinutes,
    
    /// Sleep quality (1-5)
    int? quality,
    
    /// Number of nighttime awakenings
    int? nighttimeAwakenings,
    
    /// Time to fall asleep (in minutes)
    int? timeToFallAsleep,
    
    /// Whether had difficulty falling asleep
    bool? hadDifficultyFallingAsleep,
    
    /// Whether had difficulty staying asleep
    bool? hadDifficultyStayingAsleep,
    
    /// Whether woke up refreshed
    bool? wokeUpRefreshed,
    
    /// Whether took sleep medication
    bool? tookSleepMedication,
    
    /// Sleep medication name
    String? sleepMedication,
    
    /// Whether had nightmares
    bool? hadNightmares,
    
    /// Whether had snoring
    bool? hadSnoring,
    
    /// Notes about sleep
    String? notes,
  }) = _SleepLog;

  factory SleepLog.fromJson(Map<String, dynamic> json) =>
      _$SleepLogFromJson(json);
}

/// Hydration log
@freezed
class HydrationLog with _$HydrationLog {
  const factory HydrationLog({
    /// Total water consumption in ml
    int? totalWaterMl,
    
    /// Number of glasses
    int? glassesCount,
    
    /// Other beverages consumption in ml
    int? otherBeveragesMl,
    
    /// Hydration level (1-5)
    int? level,
    
    /// Whether felt dehydrated
    bool? feltDehydrated,
    
    /// Notes about hydration
    String? notes,
  }) = _HydrationLog;

  factory HydrationLog.fromJson(Map<String, dynamic> json) =>
      _$HydrationLogFromJson(json);
}

/// Caffeine log
@freezed
class CaffeineLog with _$CaffeineLog {
  const factory CaffeineLog({
    /// Total caffeine in mg
    int? totalCaffeineMg,
    
    /// Number of cups
    int? cupsCount,
    
    /// List of caffeine entries
    @Default([]) List<CaffeineEntry> entries,
    
    /// Whether consumption was typical
    bool? wasTypicalConsumption,
    
    /// Notes about caffeine
    String? notes,
  }) = _CaffeineLog;

  factory CaffeineLog.fromJson(Map<String, dynamic> json) =>
      _$CaffeineLogFromJson(json);
}

/// Caffeine entry (single consumption)
@freezed
class CaffeineEntry with _$CaffeineEntry {
  const factory CaffeineEntry({
    /// Type of caffeine source
    required String type,
    
    /// Quantity (e.g., number of cups)
    double? quantity,
    
    /// Caffeine content per unit in mg
    int? caffeinePerUnitMg,
    
    /// Total caffeine for this entry in mg
    int? totalCaffeineMg,
    
    /// Time of consumption
    String? time,
    
    /// Notes
    String? notes,
  }) = _CaffeineEntry;

  factory CaffeineEntry.fromJson(Map<String, dynamic> json) =>
      _$CaffeineEntryFromJson(json);
}

/// Alcohol log
@freezed
class AlcoholLog with _$AlcoholLog {
  const factory AlcoholLog({
    /// Whether alcohol was consumed
    @Default(false) bool consumed,
    
    /// List of alcohol entries
    @Default([]) List<AlcoholEntry> entries,
    
    /// Total alcohol in grams
    double? totalAlcoholG,
    
    /// Notes about alcohol
    String? notes,
  }) = _AlcoholLog;

  factory AlcoholLog.fromJson(Map<String, dynamic> json) =>
      _$AlcoholLogFromJson(json);
}

/// Alcohol entry (single consumption)
@freezed
class AlcoholEntry with _$AlcoholEntry {
  const factory AlcoholEntry({
    /// Type of alcohol
    required String type,
    
    /// Quantity in standard drinks
    double? quantity,
    
    /// Volume in ml
    int? volumeMl,
    
    /// Alcohol percentage
    double? alcoholPercentage,
    
    /// Time of consumption
    String? time,
    
    /// Notes
    String? notes,
  }) = _AlcoholEntry;

  factory AlcoholEntry.fromJson(Map<String, dynamic> json) =>
      _$AlcoholEntryFromJson(json);
}

/// Food log
@freezed
class FoodLog with _$FoodLog {
  const factory FoodLog({
    /// List of meals
    @Default([]) List<MealEntry> meals,
    
    /// Whether any meals were skipped
    @Default(false) bool skippedMeals,
    
    /// Which meals were skipped
    @Default([]) List<String> skippedMealTypes,
    
    /// Whether had unusual food
    bool? hadUnusualFood,
    
    /// Unusual food description
    String? unusualFoodDescription,
    
    /// Whether had potential trigger foods
    bool? hadTriggerFoods,
    
    /// Trigger foods description
    String? triggerFoodsDescription,
    
    /// Notes about food
    String? notes,
  }) = _FoodLog;

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);
}

/// Meal entry
@freezed
class MealEntry with _$MealEntry {
  const factory MealEntry({
    /// Meal type (breakfast, lunch, dinner, snack)
    required String type,
    
    /// Time of meal
    String? time,
    
    /// Food items consumed
    @Default([]) List<String> items,
    
    /// Portion size
    String? portionSize,
    
    /// Whether was a full meal
    bool? wasFullMeal,
    
    /// Notes
    String? notes,
  }) = _MealEntry;

  factory MealEntry.fromJson(Map<String, dynamic> json) =>
      _$MealEntryFromJson(json);
}

/// Stress log
@freezed
class StressLog with _$StressLog {
  const factory StressLog({
    /// Stress level (0-10)
    int? level,
    
    /// Main stress sources
    @Default([]) List<String> sources,
    
    /// Whether had significant stress
    bool? hadSignificantStress,
    
    /// Notes about stress
    String? notes,
  }) = _StressLog;

  factory StressLog.fromJson(Map<String, dynamic> json) =>
      _$StressLogFromJson(json);
}

/// Fatigue log
@freezed
class FatigueLog with _$FatigueLog {
  const factory FatigueLog({
    /// Fatigue level (0-10)
    int? level,
    
    /// Whether felt unusually tired
    bool? feltUnusuallyTired,
    
    /// Notes about fatigue
    String? notes,
  }) = _FatigueLog;

  factory FatigueLog.fromJson(Map<String, dynamic> json) =>
      _$FatigueLogFromJson(json);
}

/// Physical activity log
@freezed
class PhysicalActivityLog with _$PhysicalActivityLog {
  const factory PhysicalActivityLog({
    /// Whether had physical activity
    @Default(false) bool hadActivity,
    
    /// List of activity entries
    @Default([]) List<ActivityEntry> entries,
    
    /// Total activity duration in minutes
    int? totalDurationMinutes,
    
    /// Notes about physical activity
    String? notes,
  }) = _PhysicalActivityLog;

  factory PhysicalActivityLog.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityLogFromJson(json);
}

/// Activity entry
@freezed
class ActivityEntry with _$ActivityEntry {
  const factory ActivityEntry({
    /// Activity type
    required String type,
    
    /// Duration in minutes
    int? durationMinutes,
    
    /// Intensity (1-5)
    int? intensity,
    
    /// Time of activity
    String? time,
    
    /// Notes
    String? notes,
  }) = _ActivityEntry;

  factory ActivityEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityEntryFromJson(json);
}

/// Screen time log
@freezed
class ScreenTimeLog with _$ScreenTimeLog {
  const factory ScreenTimeLog({
    /// Total screen time in minutes
    int? totalMinutes,
    
    /// Screen time by device type
    @Default({}) Map<String, int> byDeviceType,
    
    /// Whether had late night screen time
    bool? hadLateNightScreenTime,
    
    /// Late night screen time end
    String? lateNightScreenTimeEnd,
    
    /// Notes about screen time
    String? notes,
  }) = _ScreenTimeLog;

  factory ScreenTimeLog.fromJson(Map<String, dynamic> json) =>
      _$ScreenTimeLogFromJson(json);
}

/// Environment log
@freezed
class EnvironmentLog with _$EnvironmentLog {
  const factory EnvironmentLog({
    /// Noise level (1-5)
    int? noiseLevel,
    
    /// Light level (1-5)
    int? lightLevel,
    
    /// Temperature perception (1-5, where 1=cold, 5=hot)
    int? temperaturePerception,
    
    /// Whether exposed to strong odors
    bool? exposedToStrongOdors,
    
    /// Whether exposed to bright lights
    bool? exposedToBrightLights,
    
    /// Whether exposed to loud noises
    bool? exposedToLoudNoises,
    
    /// Notes about environment
    String? notes,
  }) = _EnvironmentLog;

  factory EnvironmentLog.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentLogFromJson(json);
}

/// Medication log
@freezed
class MedicationLog with _$MedicationLog {
  const factory MedicationLog({
    /// Medication name
    required String name,
    
    /// Medication type
    String? type,
    
    /// Dosage
    String? dosage,
    
    /// Time taken
    String? time,
    
    /// Whether was for migraine
    bool? forMigraine,
    
    /// Effectiveness (0-5)
    int? effectiveness,
    
    /// Side effects
    @Default([]) List<String> sideEffects,
    
    /// Notes
    String? notes,
  }) = _MedicationLog;

  factory MedicationLog.fromJson(Map<String, dynamic> json) =>
      _$MedicationLogFromJson(json);
}

/// Mood log
@freezed
class MoodLog with _$MoodLog {
  const factory MoodLog({
    /// Mood level (1-5)
    int? level,
    
    /// Mood description
    String? description,
    
    /// Notes about mood
    String? notes,
  }) = _MoodLog;

  factory MoodLog.fromJson(Map<String, dynamic> json) =>
      _$MoodLogFromJson(json);
}

/// Menstrual log
@freezed
class MenstrualLog with _$MenstrualLog {
  const factory MenstrualLog({
    /// Whether is menstruating
    bool? isMenstruating,
    
    /// Menstrual cycle day (1-28+)
    int? cycleDay,
    
    /// Whether is in fertile window
    bool? isFertileWindow,
    
    /// Whether is in pre-menstrual phase
    bool? isPreMenstrual,
    
    /// Whether using hormonal contraception
    bool? usingHormonalContraception,
    
    /// Notes about menstrual cycle
    String? notes,
  }) = _MenstrualLog;

  factory MenstrualLog.fromJson(Map<String, dynamic> json) =>
      _$MenstrualLogFromJson(json);
}

/// Work log
@freezed
class WorkLog with _$WorkLog {
  const factory WorkLog({
    /// Whether was a work day
    bool? wasWorkDay,
    
    /// Work start time
    String? startTime,
    
    /// Work end time
    String? endTime,
    
    /// Work type
    String? type,
    
    /// Stress level at work (0-10)
    int? stressLevel,
    
    /// Whether worked from home
    bool? workedFromHome,
    
    /// Notes about work
    String? notes,
  }) = _WorkLog;

  factory WorkLog.fromJson(Map<String, dynamic> json) =>
      _$WorkLogFromJson(json);
}

/// Weather log (auto-filled from weather API)
@freezed
class WeatherLog with _$WeatherLog {
  const factory WeatherLog({
    /// Date for weather data
    DateTime? date,
    
    /// Temperature in Celsius
    double? temperatureC,
    
    /// Feels like temperature in Celsius
    double? feelsLikeC,
    
    /// Humidity percentage
    int? humidity,
    
    /// Pressure in hPa
    int? pressure,
    
    /// Pressure change in hPa (from previous reading)
    int? pressureChange,
    
    /// Weather condition (e.g., "clear", "rain", "cloudy")
    String? condition,
    
    /// Condition description
    String? conditionDescription,
    
    /// Wind speed in km/h
    double? windSpeedKph,
    
    /// Wind direction
    String? windDirection,
    
    /// Precipitation in mm
    double? precipitationMm,
    
    /// Cloud cover percentage
    int? cloudCover,
    
    /// UV index
    int? uvIndex,
    
    /// Visibility in km
    int? visibilityKm,
    
    /// Sunrise time
    String? sunrise,
    
    /// Sunset time
    String? sunset,
    
    /// Moon phase
    String? moonPhase,
    
    /// Moon illumination percentage
    int? moonIllumination,
  }) = _WeatherLog;

  factory WeatherLog.fromJson(Map<String, dynamic> json) =>
      _$WeatherLogFromJson(json);
}

// Hive type adapters for local storage
class DailyLogModelAdapter extends TypeAdapter<DailyLogModel> {
  @override
  final int typeId = 3;

  @override
  DailyLogModel read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return DailyLogModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, DailyLogModel obj) {
    writer.writeMap(obj.toJson());
  }
}

class SleepLogAdapter extends TypeAdapter<SleepLog> {
  @override
  final int typeId = 4;

  @override
  SleepLog read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return SleepLog.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, SleepLog obj) {
    writer.writeMap(obj.toJson());
  }
}

class HydrationLogAdapter extends TypeAdapter<HydrationLog> {
  @override
  final int typeId = 5;

  @override
  HydrationLog read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return HydrationLog.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, HydrationLog obj) {
    writer.writeMap(obj.toJson());
  }
}

class CaffeineLogAdapter extends TypeAdapter<CaffeineLog> {
  @override
  final int typeId = 6;

  @override
  CaffeineLog read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return CaffeineLog.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, CaffeineLog obj) {
    writer.writeMap(obj.toJson());
  }
}

class CaffeineEntryAdapter extends TypeAdapter<CaffeineEntry> {
  @override
  final int typeId = 7;

  @override
  CaffeineEntry read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return CaffeineEntry.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, CaffeineEntry obj) {
    writer.writeMap(obj.toJson());
  }
}

// Register Hive adapters
void registerDailyLogAdapters() {
  Hive.registerAdapter(DailyLogModelAdapter());
  Hive.registerAdapter(SleepLogAdapter());
  Hive.registerAdapter(HydrationLogAdapter());
  Hive.registerAdapter(CaffeineLogAdapter());
  Hive.registerAdapter(CaffeineEntryAdapter());
}

// Extension methods for DailyLogModel
extension DailyLogModelExtensions on DailyLogModel {
  /// Check if log is complete
  bool get isComplete {
    // Consider log complete if it has at least sleep, stress, and fatigue
    return sleep != null && stress != null && fatigue != null;
  }

  /// Get completion percentage
  double get completionPercentage {
    int completed = 0;
    int total = 0;
    
    if (sleep != null) completed++;
    total++;
    if (hydration != null) completed++;
    total++;
    if (caffeine != null) completed++;
    total++;
    if (alcohol != null) completed++;
    total++;
    if (food != null) completed++;
    total++;
    if (stress != null) completed++;
    total++;
    if (fatigue != null) completed++;
    total++;
    if (physicalActivity != null) completed++;
    total++;
    if (screenTime != null) completed++;
    total++;
    if (mood != null) completed++;
    total++;
    
    return total > 0 ? (completed / total) * 100 : 0;
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in Firestore
    json.remove('localId'); // Don't store local ID in Firestore
    return json;
  }

  /// Create a copy with updated sync status
  DailyLogModel copyWithSync(bool synced) {
    return copyWith(isSynced: synced);
  }

  /// Create a copy with local ID
  DailyLogModel copyWithLocalId(String id) {
    return copyWith(localId: id);
  }

  /// Get total caffeine consumption
  int get totalCaffeineMg {
    return caffeine?.totalCaffeineMg ?? 0;
  }

  /// Get total water consumption in ml
  int get totalWaterMl {
    return hydration?.totalWaterMl ?? 0;
  }

  /// Get sleep duration in hours
  double get sleepDurationHours {
    if (sleep?.durationMinutes == null) return 0;
    return sleep!.durationMinutes! / 60.0;
  }

  /// Get average stress level
  int get stressLevel {
    return stress?.level ?? 0;
  }

  /// Get average fatigue level
  int get fatigueLevel {
    return fatigue?.level ?? 0;
  }
}

// Helper methods for creating DailyLogModel
extension DailyLogModelCreator on DailyLogModel {
  /// Create a new daily log for today
  static DailyLogModel createNew({
    required String userId,
    DateTime? date,
    SleepLog? sleep,
    HydrationLog? hydration,
    CaffeineLog? caffeine,
    AlcoholLog? alcohol,
    FoodLog? food,
    StressLog? stress,
    FatigueLog? fatigue,
    PhysicalActivityLog? physicalActivity,
    ScreenTimeLog? screenTime,
    EnvironmentLog? environment,
    List<MedicationLog>? medications,
    MoodLog? mood,
    MenstrualLog? menstrual,
    WorkLog? work,
    WeatherLog? weather,
    String? notes,
    bool? hadMigraine,
    String? migraineId,
  }) {
    return DailyLogModel(
      userId: userId,
      date: date ?? DateTime.now(),
      sleep: sleep,
      hydration: hydration,
      caffeine: caffeine,
      alcohol: alcohol,
      food: food,
      stress: stress,
      fatigue: fatigue,
      physicalActivity: physicalActivity,
      screenTime: screenTime,
      environment: environment,
      medications: medications ?? [],
      mood: mood,
      menstrual: menstrual,
      work: work,
      weather: weather,
      notes: notes,
      hadMigraine: hadMigraine ?? false,
      migraineId: migraineId,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Create a minimal daily log with just the date
  static DailyLogModel createMinimal({
    required String userId,
    DateTime? date,
  }) {
    return DailyLogModel(
      userId: userId,
      date: date ?? DateTime.now(),
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }
}
