import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'migraine_model.freezed.dart';
part 'migraine_model.g.dart';

/// Migraine intensity enum
/// 0 = No pain, 10 = Worst pain imaginable
/// This follows standard pain scale conventions

/// Migraine phase enum
enum MigrainePhase {
  prodrome,    // Early warning signs
  aura,        // Visual or sensory disturbances
  attack,      // The migraine itself
  postdrome,   // Recovery phase
}

/// Migraine side enum
enum MigraineSide {
  left,       // Left side of head
  right,      // Right side of head
  both,       // Both sides
  shifting,   // Shifts from one side to another
  whole,      // Whole head
}

/// Migraine type enum
enum MigraineType {
  unknown,
  withoutAura,    // Most common type
  withAura,       // With visual/sensory disturbances
  chronic,        // 15+ headache days per month
  menstrual,      // Related to menstrual cycle
  vestibular,     // With dizziness/vertigo
  hemiplegic,     // With temporary weakness
  retinal,        // With temporary vision loss
  other,
}

/// Migraine episode model
@freezed
class MigraineModel with _$MigraineModel {
  const factory MigraineModel({
    /// Unique migraine episode ID
    String? id,
    
    /// User ID (reference to user)
    required String userId,
    
    /// Start date and time of the migraine
    required DateTime startTime,
    
    /// End date and time of the migraine (null if ongoing)
    DateTime? endTime,
    
    /// Migraine duration in minutes (calculated from startTime and endTime)
    int? durationMinutes,
    
    /// Maximum intensity (0-10)
    required int intensity,
    
    /// Average intensity (0-10)
    int? averageIntensity,
    
    /// Minimum intensity (0-10)
    int? minIntensity,
    
    /// Migraine type
    @Default(MigraineType.unknown) MigraineType type,
    
    /// Migraine phase
    @Default(MigrainePhase.attack) MigrainePhase phase,
    
    /// Migraine side (location)
    MigraineSide? side,
    
    /// Specific location description (e.g., "temple", "behind eye")
    String? locationDescription,
    
    /// List of symptoms experienced
    @Default([]) List<String> symptoms,
    
    /// List of user-perceived triggers
    @Default([]) List<String> perceivedTriggers,
    
    /// List of medications taken for this migraine
    @Default([]) List<MigraineMedication> medications,
    
    /// Notes about the migraine
    String? notes,
    
    /// Whether the migraine was treated successfully
    bool? treatedSuccessfully,
    
    /// Whether the migraine caused missed work/school
    @Default(false) bool causedMissedWork,
    
    /// Whether the migraine caused missed social activities
    @Default(false) bool causedMissedActivities,
    
    /// Whether the migraine required bed rest
    @Default(false) bool requiredBedRest,
    
    /// Whether the migraine was preceded by aura
    @Default(false) bool hadAura,
    
    /// Aura description (if applicable)
    String? auraDescription,
    
    /// Whether the migraine was related to menstrual cycle
    bool? menstrualRelated,
    
    /// Menstrual cycle day (if applicable)
    int? menstrualCycleDay,
    
    /// Whether the migraine was related to weather
    bool? weatherRelated,
    
    /// Whether the migraine was related to stress
    bool? stressRelated,
    
    /// Whether the migraine was related to sleep
    bool? sleepRelated,
    
    /// Whether the migraine was related to caffeine
    bool? caffeineRelated,
    
    /// Whether the migraine was related to alcohol
    bool? alcoholRelated,
    
    /// Whether the migraine was related to food
    bool? foodRelated,
    
    /// Whether the migraine was related to dehydration
    bool? dehydrationRelated,
    
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
  }) = _MigraineModel;

  factory MigraineModel.fromJson(Map<String, dynamic> json) =>
      _$MigraineModelFromJson(json);

  factory MigraineModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MigraineModel.fromJson({...data, 'id': doc.id});
  }
}

/// Medication taken for a migraine
@freezed
class MigraineMedication with _$MigraineMedication {
  const factory MigraineMedication({
    /// Medication name
    required String name,
    
    /// Medication type
    String? type,
    
    /// Dosage (e.g., "500mg", "1 tablet")
    String? dosage,
    
    /// Time taken
    DateTime? timeTaken,
    
    /// Effectiveness (0-5)
    int? effectiveness,
    
    /// Time until relief (in minutes)
    int? timeUntilRelief,
    
    /// Side effects experienced
    @Default([]) List<String> sideEffects,
    
    /// Notes about the medication
    String? notes,
  }) = _MigraineMedication;

  factory MigraineMedication.fromJson(Map<String, dynamic> json) =>
      _$MigraineMedicationFromJson(json);
}

/// Migraine intensity history (for tracking changes over time)
@freezed
class MigraineIntensityHistory with _$MigraineIntensityHistory {
  const factory MigraineIntensityHistory({
    /// Timestamp of the intensity reading
    required DateTime timestamp,
    
    /// Intensity at this timestamp (0-10)
    required int intensity,
    
    /// Notes about the intensity change
    String? notes,
  }) = _MigraineIntensityHistory;

  factory MigraineIntensityHistory.fromJson(Map<String, dynamic> json) =>
      _$MigraineIntensityHistoryFromJson(json);
}

/// Migraine statistics for a user
@freezed
class MigraineStatistics with _$MigraineStatistics {
  const factory MigraineStatistics({
    /// User ID
    required String userId,
    
    /// Time period for these statistics
    required DateTime periodStart,
    required DateTime periodEnd,
    
    /// Total number of migraines
    @Default(0) int totalCount,
    
    /// Number of migraine days
    @Default(0) int migraineDays,
    
    /// Number of days without migraines
    @Default(0) int daysWithoutMigraines,
    
    /// Average intensity (0-10)
    double? averageIntensity,
    
    /// Maximum intensity (0-10)
    int? maxIntensity,
    
    /// Minimum intensity (0-10)
    int? minIntensity,
    
    /// Average duration in minutes
    double? averageDurationMinutes,
    
    /// Maximum duration in minutes
    int? maxDurationMinutes,
    
    /// Minimum duration in minutes
    int? minDurationMinutes,
    
    /// Total duration in minutes
    int? totalDurationMinutes,
    
    /// Most common symptoms
    @Default({}) Map<String, int> symptomFrequency,
    
    /// Most common triggers
    @Default({}) Map<String, int> triggerFrequency,
    
    /// Most common sides
    @Default({}) Map<String, int> sideFrequency,
    
    /// Most common types
    @Default({}) Map<String, int> typeFrequency,
    
    /// Migraines by day of week
    @Default({}) Map<String, int> migrainesByDayOfWeek,
    
    /// Migraines by hour of day
    @Default({}) Map<String, int> migrainesByHourOfDay,
    
    /// Migraines by month
    @Default({}) Map<String, int> migrainesByMonth,
    
    /// Medication effectiveness
    @Default({}) Map<String, Map<String, dynamic>> medicationStats,
    
    /// Whether migraines are increasing
    bool? isIncreasing,
    
    /// Trend percentage
    double? trendPercentage,
    
    /// Most common phase
    String? mostCommonPhase,
    
    /// Percentage with aura
    double? percentageWithAura,
    
    /// Percentage requiring bed rest
    double? percentageRequiringBedRest,
    
    /// Percentage causing missed work
    double? percentageCausingMissedWork,
  }) = _MigraineStatistics;

  factory MigraineStatistics.fromJson(Map<String, dynamic> json) =>
      _$MigraineStatisticsFromJson(json);
}

// Hive type adapters for local storage
class MigraineModelAdapter extends TypeAdapter<MigraineModel> {
  @override
  final int typeId = 1;

  @override
  MigraineModel read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return MigraineModel.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, MigraineModel obj) {
    writer.writeMap(obj.toJson());
  }
}

class MigraineMedicationAdapter extends TypeAdapter<MigraineMedication> {
  @override
  final int typeId = 2;

  @override
  MigraineMedication read(BinaryReader reader) {
    final json = reader.readMap() as Map<String, dynamic>;
    return MigraineMedication.fromJson(json);
  }

  @override
  void write(BinaryWriter writer, MigraineMedication obj) {
    writer.writeMap(obj.toJson());
  }
}

// Register Hive adapters
void registerMigraineAdapters() {
  Hive.registerAdapter(MigraineModelAdapter());
  Hive.registerAdapter(MigraineMedicationAdapter());
}

// Extension methods for MigraineModel
extension MigraineModelExtensions on MigraineModel {
  /// Check if migraine is ongoing
  bool get isOngoing => endTime == null;

  /// Get migraine duration in hours
  double get durationHours {
    if (durationMinutes == null) {
      if (endTime == null) return 0;
      return endTime!.difference(startTime).inMinutes / 60.0;
    }
    return durationMinutes! / 60.0;
  }

  /// Get migraine duration display string
  String get durationDisplay {
    final hours = durationHours.floor();
    final minutes = ((durationHours - hours) * 60).round();
    
    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    } else if (hours > 0) {
      return '$hours h';
    } else if (minutes > 0) {
      return '$minutes min';
    }
    return '< 1 min';
  }

  /// Get intensity display string
  String get intensityDisplay {
    switch (intensity) {
      case 0:
        return 'Aucune';
      case 1:
      case 2:
        return 'Légère';
      case 3:
      case 4:
        return 'Modérée';
      case 5:
      case 6:
        return 'Sévère';
      case 7:
      case 8:
        return 'Très sévère';
      case 9:
      case 10:
        return 'Extrême';
      default:
        return '$intensity/10';
    }
  }

  /// Get type display string
  String get typeDisplay {
    switch (type) {
      case MigraineType.withoutAura:
        return 'Sans aura';
      case MigraineType.withAura:
        return 'Avec aura';
      case MigraineType.chronic:
        return 'Chronique';
      case MigraineType.menstrual:
        return 'Menstruelle';
      case MigraineType.vestibular:
        return 'Vestibulaire';
      case MigraineType.hemiplegic:
        return 'Hémiplégique';
      case MigraineType.retinal:
        return 'Rétinienne';
      case MigraineType.other:
        return 'Autre';
      default:
        return 'Inconnue';
    }
  }

  /// Get side display string
  String get sideDisplay {
    switch (side) {
      case MigraineSide.left:
        return 'Côté gauche';
      case MigraineSide.right:
        return 'Côté droit';
      case MigraineSide.both:
        return 'Les deux côtés';
      case MigraineSide.shifting:
        return 'Change de côté';
      case MigraineSide.whole:
        return 'Toute la tête';
      default:
        return 'Non spécifié';
    }
  }

  /// Get phase display string
  String get phaseDisplay {
    switch (phase) {
      case MigrainePhase.prodrome:
        return 'Prodrome';
      case MigrainePhase.aura:
        return 'Aura';
      case MigrainePhase.attack:
        return 'Attaque';
      case MigrainePhase.postdrome:
        return 'Postdrome';
    }
  }

  /// Check if migraine has aura
  bool get hasAura => hadAura == true || type == MigraineType.withAura;

  /// Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in Firestore
    json.remove('localId'); // Don't store local ID in Firestore
    return json;
  }

  /// Create a copy with updated sync status
  MigraineModel copyWithSync(bool synced) {
    return copyWith(isSynced: synced);
  }

  /// Create a copy with local ID
  MigraineModel copyWithLocalId(String id) {
    return copyWith(localId: id);
  }
}

// Helper methods for creating MigraineModel
extension MigraineModelCreator on MigraineModel {
  /// Create a new migraine with current timestamp
  static MigraineModel createNew({
    required String userId,
    required int intensity,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? symptoms,
    List<String>? perceivedTriggers,
    MigraineSide? side,
    String? locationDescription,
    MigraineType? type,
    int? durationMinutes,
    String? notes,
  }) {
    return MigraineModel(
      userId: userId,
      startTime: startTime ?? DateTime.now(),
      endTime: endTime,
      intensity: intensity,
      durationMinutes: durationMinutes,
      side: side,
      locationDescription: locationDescription,
      type: type ?? MigraineType.unknown,
      symptoms: symptoms ?? [],
      perceivedTriggers: perceivedTriggers ?? [],
      notes: notes,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }
}
