import '../../models/migraine_model.dart';
import 'database_service.dart';
import 'database_exceptions.dart';

/// Migraine repository for managing migraine data
class MigraineRepository {
  final DatabaseService _databaseService;

  /// Create a new MigraineRepository instance
  MigraineRepository({
    DatabaseService? databaseService,
  }) : _databaseService = databaseService ?? DatabaseService();

  /// Get current user ID
  String? get currentUserId => _databaseService.currentUserId;

  /// Create a new migraine
  Future<MigraineModel> createMigraine(MigraineModel migraine) async {
    try {
      // Validate migraine
      if (migraine.intensity < 0 || migraine.intensity > 10) {
        throw RepositoryException(
          message: 'L\'intensité de la migraine doit être comprise entre 0 et 10',
          code: 'invalid-intensity',
        );
      }
      
      // Set timestamps if not set
      final migraineToCreate = migraine.copyWith(
        createdAt: migraine.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      return await _databaseService.createMigraine(migraineToCreate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de création de la migraine: ${e.toString()}',
        code: 'create-migraine-failed',
        innerException: e,
      );
    }
  }

  /// Get migraine by ID
  Future<MigraineModel?> getMigraine(String migraineId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return await _databaseService.getMigraine(userId, migraineId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération de la migraine: ${e.toString()}',
        code: 'get-migraine-failed',
        innerException: e,
      );
    }
  }

  /// Get all migraines for current user
  Future<List<MigraineModel>> getAllMigraines({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return await _databaseService.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération des migraines: ${e.toString()}',
        code: 'get-migraines-failed',
        innerException: e,
      );
    }
  }

  /// Get migraines by date range
  Future<List<MigraineModel>> getMigrainesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await getAllMigraines(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get migraines for a specific month
  Future<List<MigraineModel>> getMigrainesForMonth(
    DateTime month,
  ) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);
    
    return await getMigrainesByDateRange(startDate, endDate);
  }

  /// Get migraines for a specific week
  Future<List<MigraineModel>> getMigrainesForWeek(
    DateTime weekStart,
  ) async {
    final endDate = weekStart.add(const Duration(days: 6));
    
    return await getMigrainesByDateRange(weekStart, endDate);
  }

  /// Get today's migraines
  Future<List<MigraineModel>> getTodaysMigraines() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, now.day);
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    return await getMigrainesByDateRange(startDate, endDate);
  }

  /// Get ongoing migraines (no end time)
  Future<List<MigraineModel>> getOngoingMigraines() async {
    final migraines = await getAllMigraines();
    return migraines.where((m) => m.isOngoing).toList();
  }

  /// Update migraine
  Future<void> updateMigraine(MigraineModel migraine) async {
    try {
      // Validate migraine
      if (migraine.intensity < 0 || migraine.intensity > 10) {
        throw RepositoryException(
          message: 'L\'intensité de la migraine doit être comprise entre 0 et 10',
          code: 'invalid-intensity',
        );
      }
      
      // Update timestamp
      final migraineToUpdate = migraine.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateMigraine(migraineToUpdate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour de la migraine: ${e.toString()}',
        code: 'update-migraine-failed',
        innerException: e,
      );
    }
  }

  /// End an ongoing migraine
  Future<void> endMigraine(String migraineId, DateTime endTime) async {
    try {
      final migraine = await getMigraine(migraineId);
      if (migraine == null) {
        throw RepositoryException(
          message: 'Migraine non trouvée',
          code: 'migraine-not-found',
        );
      }
      
      if (!migraine.isOngoing) {
        throw RepositoryException(
          message: 'Cette migraine est déjà terminée',
          code: 'migraine-already-ended',
        );
      }
      
      // Calculate duration
      final durationMinutes = endTime.difference(migraine.startTime).inMinutes;
      
      final updatedMigraine = migraine.copyWith(
        endTime: endTime,
        durationMinutes: durationMinutes,
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateMigraine(updatedMigraine);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de fin de la migraine: ${e.toString()}',
        code: 'end-migraine-failed',
        innerException: e,
      );
    }
  }

  /// Delete migraine
  Future<void> deleteMigraine(String migraineId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      await _databaseService.deleteMigraine(userId, migraineId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de suppression de la migraine: ${e.toString()}',
        code: 'delete-migraine-failed',
        innerException: e,
      );
    }
  }

  /// Stream migraines for current user
  Stream<List<MigraineModel>> streamMigraines({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return _databaseService.streamMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de stream des migraines: ${e.toString()}',
        code: 'stream-migraines-failed',
        innerException: e,
      );
    }
  }

  /// Get migraine count
  Future<int> getMigraineCount({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return await _databaseService.getMigraineCount(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de comptage des migraines: ${e.toString()}',
        code: 'count-migraines-failed',
        innerException: e,
      );
    }
  }

  /// Get statistics for migraines
  Future<MigraineStatistics> getMigraineStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final migraines = await getAllMigraines(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (migraines.isEmpty) {
        return MigraineStatistics(
          userId: currentUserId ?? '',
          periodStart: startDate ?? DateTime.now().subtract(const Duration(days: 30)),
          periodEnd: endDate ?? DateTime.now(),
        );
      }
      
      // Calculate basic statistics
      final intensities = migraines.map((m) => m.intensity.toDouble()).toList();
      final durations = migraines
          .map((m) => m.durationHours)
          .where((d) => d > 0)
          .toList();
      
      // Count migraines by day of week
      final migrainesByDayOfWeek = <String, int>{};
      for (final migraine in migraines) {
        final dayName = _getDayName(migraine.startTime.weekday);
        migrainesByDayOfWeek[dayName] = (migrainesByDayOfWeek[dayName] ?? 0) + 1;
      }
      
      // Count migraines by hour
      final migrainesByHour = <String, int>{};
      for (final migraine in migraines) {
        final hour = migraine.startTime.hour.toString();
        migrainesByHour[hour] = (migrainesByHour[hour] ?? 0) + 1;
      }
      
      // Count symptoms
      final symptomFrequency = <String, int>{};
      for (final migraine in migraines) {
        for (final symptom in migraine.symptoms) {
          symptomFrequency[symptom] = (symptomFrequency[symptom] ?? 0) + 1;
        }
      }
      
      // Count triggers
      final triggerFrequency = <String, int>{};
      for (final migraine in migraines) {
        for (final trigger in migraine.perceivedTriggers) {
          triggerFrequency[trigger] = (triggerFrequency[trigger] ?? 0) + 1;
        }
      }
      
      // Calculate medication statistics
      final medicationStats = <String, Map<String, dynamic>>{};
      for (final migraine in migraines) {
        for (final medication in migraine.medications) {
          final medName = medication.name;
          if (!medicationStats.containsKey(medName)) {
            medicationStats[medName] = {
              'count': 0,
              'total_effectiveness': 0,
              'effectiveness_list': <int>[],
            };
          }
          medicationStats[medName]!['count']++;
          if (medication.effectiveness != null) {
            medicationStats[medName]!['total_effectiveness'] += medication.effectiveness!;
            medicationStats[medName]!['effectiveness_list'].add(medication.effectiveness!);
          }
        }
      }
      
      // Calculate average effectiveness for each medication
      for (final entry in medicationStats.entries) {
        final count = entry.value['count'] as int;
        final totalEffectiveness = entry.value['total_effectiveness'] as int;
        entry.value['average_effectiveness'] = count > 0 ? totalEffectiveness / count : 0;
      }
      
      return MigraineStatistics(
        userId: currentUserId ?? '',
        periodStart: startDate ?? migraines.last.startTime,
        periodEnd: endDate ?? migraines.first.startTime,
        totalCount: migraines.length,
        migraineDays: migraines
            .map((m) => DateTime(m.startTime.year, m.startTime.month, m.startTime.day))
            .toSet()
            .length,
        daysWithoutMigraines: 0, // Will be calculated separately
        averageIntensity: intensities.average,
        maxIntensity: intensities.max.toInt(),
        minIntensity: intensities.min.toInt(),
        averageDurationMinutes: durations.isNotEmpty ? durations.average * 60 : null,
        maxDurationMinutes: durations.isNotEmpty ? (durations.max * 60).round() : null,
        minDurationMinutes: durations.isNotEmpty ? (durations.min * 60).round() : null,
        symptomFrequency: symptomFrequency,
        triggerFrequency: triggerFrequency,
        migrainesByDayOfWeek: migrainesByDayOfWeek,
        migrainesByHourOfDay: migrainesByHour,
        medicationStats: medicationStats,
        percentageWithAura: migraines.where((m) => m.hasAura).length / migraines.length,
        percentageRequiringBedRest: migraines.where((m) => m.requiredBedRest).length / migraines.length,
        percentageCausingMissedWork: migraines.where((m) => m.causedMissedWork).length / migraines.length,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de calcul des statistiques: ${e.toString()}',
        code: 'calculate-statistics-failed',
        innerException: e,
      );
    }
  }

  /// Get day name
  String _getDayName(int weekday) {
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];
    return days[weekday - 1];
  }

  /// Check if user has migraines
  Future<bool> hasMigraines() async {
    final count = await getMigraineCount();
    return count > 0;
  }

  /// Get last migraine
  Future<MigraineModel?> getLastMigraine() async {
    final migraines = await getAllMigraines(
      limit: 1,
      orderBy: 'startTime',
      descending: true,
    );
    return migraines.isNotEmpty ? migraines.first : null;
  }

  /// Get first migraine
  Future<MigraineModel?> getFirstMigraine() async {
    final migraines = await getAllMigraines(
      limit: 1,
      orderBy: 'startTime',
      descending: false,
    );
    return migraines.isNotEmpty ? migraines.first : null;
  }

  /// Get most recent migraines
  Future<List<MigraineModel>> getRecentMigraines({int count = 5}) async {
    return await getAllMigraines(
      limit: count,
      orderBy: 'startTime',
      descending: true,
    );
  }

  /// Get migraines with aura
  Future<List<MigraineModel>> getMigrainesWithAura() async {
    final migraines = await getAllMigraines();
    return migraines.where((m) => m.hasAura).toList();
  }

  /// Get migraines requiring bed rest
  Future<List<MigraineModel>> getMigrainesRequiringBedRest() async {
    final migraines = await getAllMigraines();
    return migraines.where((m) => m.requiredBedRest).toList();
  }

  /// Get migraines causing missed work
  Future<List<MigraineModel>> getMigrainesCausingMissedWork() async {
    final migraines = await getAllMigraines();
    return migraines.where((m) => m.causedMissedWork).toList();
  }
}
