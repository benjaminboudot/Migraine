import '../../models/daily_log_model.dart';
import 'database_service.dart';
import 'database_exceptions.dart';

/// Daily log repository for managing daily log data
class DailyLogRepository {
  final DatabaseService _databaseService;

  /// Create a new DailyLogRepository instance
  DailyLogRepository({
    DatabaseService? databaseService,
  }) : _databaseService = databaseService ?? DatabaseService();

  /// Get current user ID
  String? get currentUserId => _databaseService.currentUserId;

  /// Create a new daily log
  Future<DailyLogModel> createDailyLog(DailyLogModel log) async {
    try {
      // Validate log
      if (log.date == null) {
        throw RepositoryException(
          message: 'La date du journal est requise',
          code: 'invalid-date',
        );
      }
      
      // Set timestamps if not set
      final logToCreate = log.copyWith(
        createdAt: log.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      return await _databaseService.createDailyLog(logToCreate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de création du journal: ${e.toString()}',
        code: 'create-daily-log-failed',
        innerException: e,
      );
    }
  }

  /// Get daily log by ID
  Future<DailyLogModel?> getDailyLog(String logId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return await _databaseService.getDailyLog(userId, logId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération du journal: ${e.toString()}',
        code: 'get-daily-log-failed',
        innerException: e,
      );
    }
  }

  /// Get daily log by date
  Future<DailyLogModel?> getDailyLogByDate(DateTime date) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      return await _databaseService.getDailyLogByDate(userId, date);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération du journal par date: ${e.toString()}',
        code: 'get-daily-log-by-date-failed',
        innerException: e,
      );
    }
  }

  /// Get today's daily log
  Future<DailyLogModel?> getTodaysDailyLog() async {
    return await getDailyLogByDate(DateTime.now());
  }

  /// Get all daily logs for current user
  Future<List<DailyLogModel>> getAllDailyLogs({
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
      
      return await _databaseService.getAllDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération des journaux: ${e.toString()}',
        code: 'get-daily-logs-failed',
        innerException: e,
      );
    }
  }

  /// Get daily logs by date range
  Future<List<DailyLogModel>> getDailyLogsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return await getAllDailyLogs(
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Get daily logs for a specific month
  Future<List<DailyLogModel>> getDailyLogsForMonth(DateTime month) async {
    final startDate = DateTime(month.year, month.month, 1);
    final endDate = DateTime(month.year, month.month + 1, 0);
    
    return await getDailyLogsByDateRange(startDate, endDate);
  }

  /// Get daily logs for a specific week
  Future<List<DailyLogModel>> getDailyLogsForWeek(DateTime weekStart) async {
    final endDate = weekStart.add(const Duration(days: 6));
    
    return await getDailyLogsByDateRange(weekStart, endDate);
  }

  /// Update daily log
  Future<void> updateDailyLog(DailyLogModel log) async {
    try {
      // Update timestamp
      final logToUpdate = log.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _databaseService.updateDailyLog(logToUpdate);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de mise à jour du journal: ${e.toString()}',
        code: 'update-daily-log-failed',
        innerException: e,
      );
    }
  }

  /// Delete daily log
  Future<void> deleteDailyLog(String logId) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw RepositoryException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      await _databaseService.deleteDailyLog(userId, logId);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de suppression du journal: ${e.toString()}',
        code: 'delete-daily-log-failed',
        innerException: e,
      );
    }
  }

  /// Stream daily logs for current user
  Stream<List<DailyLogModel>> streamDailyLogs({
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
      
      return _databaseService.streamDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        orderBy: orderBy,
        descending: descending,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de stream des journaux: ${e.toString()}',
        code: 'stream-daily-logs-failed',
        innerException: e,
      );
    }
  }

  /// Check if daily log exists for a date
  Future<bool> dailyLogExists(DateTime date) async {
    final log = await getDailyLogByDate(date);
    return log != null;
  }

  /// Get completion statistics for daily logs
  Future<Map<String, dynamic>> getCompletionStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final logs = await getAllDailyLogs(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (logs.isEmpty) {
        return {
          'total_days': 0,
          'complete_days': 0,
          'partial_days': 0,
          'no_data_days': 0,
          'completion_percentage': 0.0,
          'field_completion': <String, double>{},
        };
      }
      
      int completeDays = 0;
      int partialDays = 0;
      int noDataDays = 0;
      
      final fieldCounts = <String, int>{};
      final fieldTotal = <String, int>{};
      
      // Define fields to track
      final fields = [
        'sleep',
        'hydration',
        'caffeine',
        'alcohol',
        'food',
        'stress',
        'fatigue',
        'physicalActivity',
        'screenTime',
        'environment',
        'mood',
        'medications',
      ];
      
      for (final log in logs) {
        bool hasAnyData = false;
        int fieldCount = 0;
        
        for (final field in fields) {
          final value = _getFieldValue(log, field);
          
          if (value != null) {
            hasAnyData = true;
            fieldCount++;
            fieldCounts[field] = (fieldCounts[field] ?? 0) + 1;
          }
          
          fieldTotal[field] = (fieldTotal[field] ?? 0) + 1;
        }
        
        if (!hasAnyData) {
          noDataDays++;
        } else if (fieldCount == fields.length) {
          completeDays++;
        } else {
          partialDays++;
        }
      }
      
      final totalDays = logs.length;
      final completionPercentage = (completeDays / totalDays) * 100;
      
      // Calculate field completion percentages
      final fieldCompletion = <String, double>{};
      for (final field in fields) {
        fieldCompletion[field] = 
            fieldTotal[field] != null && fieldTotal[field]! > 0
                ? (fieldCounts[field] ?? 0) / fieldTotal[field]! * 100
                : 0;
      }
      
      return {
        'total_days': totalDays,
        'complete_days': completeDays,
        'partial_days': partialDays,
        'no_data_days': noDataDays,
        'completion_percentage': completionPercentage,
        'field_completion': fieldCompletion,
      };
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de calcul des statistiques de complétion: ${e.toString()}',
        code: 'calculate-completion-stats-failed',
        innerException: e,
      );
    }
  }

  /// Get field value from daily log
  dynamic _getFieldValue(DailyLogModel log, String field) {
    switch (field) {
      case 'sleep':
        return log.sleep;
      case 'hydration':
        return log.hydration;
      case 'caffeine':
        return log.caffeine;
      case 'alcohol':
        return log.alcohol;
      case 'food':
        return log.food;
      case 'stress':
        return log.stress;
      case 'fatigue':
        return log.fatigue;
      case 'physicalActivity':
        return log.physicalActivity;
      case 'screenTime':
        return log.screenTime;
      case 'environment':
        return log.environment;
      case 'mood':
        return log.mood;
      case 'medications':
        return log.medications.isNotEmpty ? log.medications : null;
      default:
        return null;
    }
  }

  /// Get most recent daily logs
  Future<List<DailyLogModel>> getRecentDailyLogs({int count = 5}) async {
    return await getAllDailyLogs(
      limit: count,
      orderBy: 'date',
      descending: true,
    );
  }

  /// Get daily logs with migraines
  Future<List<DailyLogModel>> getDailyLogsWithMigraines() async {
    final logs = await getAllDailyLogs();
    return logs.where((log) => log.hadMigraine).toList();
  }

  /// Get daily logs without migraines
  Future<List<DailyLogModel>> getDailyLogsWithoutMigraines() async {
    final logs = await getAllDailyLogs();
    return logs.where((log) => !log.hadMigraine).toList();
  }

  /// Check if user has daily logs
  Future<bool> hasDailyLogs() async {
    final count = await getDailyLogCount();
    return count > 0;
  }

  /// Get daily log count
  Future<int> getDailyLogCount() async {
    final logs = await getAllDailyLogs();
    return logs.length;
  }

  /// Get statistics for daily logs
  Future<Map<String, dynamic>> getDailyLogStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final logs = await getAllDailyLogs(
        startDate: startDate,
        endDate: endDate,
      );
      
      if (logs.isEmpty) {
        return {};
      }
      
      // Calculate sleep statistics
      final sleepDurations = logs
          .map((log) => log.sleep?.durationMinutes?.toDouble() ?? 0)
          .where((d) => d > 0)
          .toList();
      
      final sleepQualities = logs
          .map((log) => log.sleep?.quality?.toDouble() ?? 0)
          .where((q) => q > 0)
          .toList();
      
      // Calculate stress statistics
      final stressLevels = logs
          .map((log) => log.stress?.level?.toDouble() ?? 0)
          .where((s) => s > 0)
          .toList();
      
      // Calculate fatigue statistics
      final fatigueLevels = logs
          .map((log) => log.fatigue?.level?.toDouble() ?? 0)
          .where((f) => f > 0)
          .toList();
      
      // Calculate caffeine statistics
      final caffeineValues = logs
          .map((log) => log.caffeine?.totalCaffeineMg?.toDouble() ?? 0)
          .where((c) => c > 0)
          .toList();
      
      // Calculate water statistics
      final waterValues = logs
          .map((log) => log.hydration?.totalWaterMl?.toDouble() ?? 0)
          .where((w) => w > 0)
          .toList();
      
      return {
        'sleep': {
          'average_duration_minutes': sleepDurations.average,
          'average_quality': sleepQualities.average,
          'min_duration_minutes': sleepDurations.isNotEmpty ? sleepDurations.min : 0,
          'max_duration_minutes': sleepDurations.isNotEmpty ? sleepDurations.max : 0,
        },
        'stress': {
          'average_level': stressLevels.average,
          'min_level': stressLevels.isNotEmpty ? stressLevels.min : 0,
          'max_level': stressLevels.isNotEmpty ? stressLevels.max : 0,
        },
        'fatigue': {
          'average_level': fatigueLevels.average,
          'min_level': fatigueLevels.isNotEmpty ? fatigueLevels.min : 0,
          'max_level': fatigueLevels.isNotEmpty ? fatigueLevels.max : 0,
        },
        'caffeine': {
          'average_mg': caffeineValues.average,
          'min_mg': caffeineValues.isNotEmpty ? caffeineValues.min : 0,
          'max_mg': caffeineValues.isNotEmpty ? caffeineValues.max : 0,
        },
        'water': {
          'average_ml': waterValues.average,
          'min_ml': waterValues.isNotEmpty ? waterValues.min : 0,
          'max_ml': waterValues.isNotEmpty ? waterValues.max : 0,
        },
      };
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de calcul des statistiques: ${e.toString()}',
        code: 'calculate-statistics-failed',
        innerException: e,
      );
    }
  }
}
