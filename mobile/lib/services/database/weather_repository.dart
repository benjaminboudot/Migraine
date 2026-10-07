import '../../models/weather_model.dart';
import 'database_service.dart';
import 'database_exceptions.dart';

/// Weather repository for managing weather data
class WeatherRepository {
  final DatabaseService _databaseService;

  /// Create a new WeatherRepository instance
  WeatherRepository({
    DatabaseService? databaseService,
  }) : _databaseService = databaseService ?? DatabaseService();

  /// Get current user ID
  String? get currentUserId => _databaseService.currentUserId;

  /// Save weather data
  Future<void> saveWeather(WeatherModel weather) async {
    try {
      await _databaseService.saveWeather(weather);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de sauvegarde de la météo: ${e.toString()}',
        code: 'save-weather-failed',
        innerException: e,
      );
    }
  }

  /// Get weather by location and date
  Future<WeatherModel?> getWeatherByLocationAndDate(
    String locationId,
    DateTime date,
  ) async {
    try {
      return await _databaseService.getWeatherByLocationAndDate(
        locationId,
        date,
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération de la météo: ${e.toString()}',
        code: 'get-weather-failed',
        innerException: e,
      );
    }
  }

  /// Get weather for user by date
  Future<WeatherModel?> getWeatherByDate(
    String userId,
    DateTime date,
  ) async {
    // In a real implementation, we would get the user's location
    // For now, use a default location or get from user settings
    try {
      // Get user's location from database or use default
      // This is a simplified version
      final locationId = 'default_$userId';
      
      return await getWeatherByLocationAndDate(locationId, date);
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération de la météo par date: ${e.toString()}',
        code: 'get-weather-by-date-failed',
        innerException: e,
      );
    }
  }

  /// Get weather for a date range
  Future<List<WeatherModel>> getWeatherForDateRange(
    String locationId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final results = <WeatherModel>[];
      
      for (var date = startDate;
           date.isBefore(endDate) || date == endDate;
           date = date.add(const Duration(days: 1))) {
        final weather = await getWeatherByLocationAndDate(locationId, date);
        if (weather != null) {
          results.add(weather);
        }
      }
      
      return results;
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur de récupération de la météo pour la période: ${e.toString()}',
        code: 'get-weather-range-failed',
        innerException: e,
      );
    }
  }

  /// Get pressure analysis for user
  Future<PressureAnalysis> getPressureAnalysis({
    required String userId,
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
      
      // Get weather data for the period
      final locationId = 'default_$userId';
      final weatherData = await getWeatherForDateRange(
        locationId,
        startDate ?? DateTime.now().subtract(const Duration(days: 30)),
        endDate ?? DateTime.now(),
      );
      
      if (weatherData.isEmpty) {
        return PressureAnalysis(
          userId: userId,
          date: DateTime.now(),
          analyzedAt: DateTime.now(),
        );
      }
      
      // Get migraines for the same period
      final migraines = await _getMigraineRepository().getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      // Prepare pressure data points
      final pressureDataPoints = <PressureDataPoint>[];
      
      for (final weather in weatherData) {
        if (weather.pressure == null) continue;
        
        // Find if there was a migraine near this date
        final weatherDate = DateTime(
          weather.dateTime.year,
          weather.dateTime.month,
          weather.dateTime.day,
        );
        
        bool hadMigraine = false;
        double? hoursUntilNextMigraine;
        double? hoursSincePreviousMigraine;
        
        // Find nearest migraines
        for (final migraine in migraines) {
          final migraineDate = DateTime(
            migraine.startTime.year,
            migraine.startTime.month,
            migraine.startTime.day,
          );
          
          final daysDiff = weatherDate.difference(migraineDate).inDays;
          
          if (daysDiff == 0) {
            hadMigraine = true;
            break;
          }
        }
        
        pressureDataPoints.add(
          PressureDataPoint(
            timestamp: weather.dateTime,
            pressure: weather.pressure!,
            temperature: weather.temperatureC,
            humidity: weather.humidity,
            hadMigraine: hadMigraine,
            hoursUntilNextMigraine: hoursUntilNextMigraine,
            hoursSincePreviousMigraine: hoursSincePreviousMigraine,
          ),
        );
      }
      
      // Calculate pressure changes
      final pressureChanges = <String, int>{};
      final pressureChangePercentages = <String, double>{};
      
      for (int i = 1; i < pressureDataPoints.length; i++) {
        final prev = pressureDataPoints[i - 1];
        final curr = pressureDataPoints[i];
        
        final hoursDiff = curr.timestamp.difference(prev.timestamp).inHours;
        final pressureDiff = curr.pressure - prev.pressure;
        
        if (hoursDiff > 0 && hoursDiff <= 24) {
          final key = '${hoursDiff}h';
          pressureChanges[key] = (pressureChanges[key] ?? 0) + pressureDiff;
          pressureChangePercentages[key] = 
              (pressureChangePercentages[key] ?? 0) + 
              (pressureDiff / prev.pressure * 100);
        }
      }
      
      // Calculate current pressure
      final currentPressure = pressureDataPoints.isNotEmpty
          ? pressureDataPoints.last.pressure
          : null;
      
      // Calculate stability index
      double stabilityIndex = 100.0;
      if (pressureDataPoints.length > 1) {
        final pressureDiffs = <int>[];
        for (int i = 1; i < pressureDataPoints.length; i++) {
          pressureDiffs.add(
            (pressureDataPoints[i].pressure - pressureDataPoints[i - 1].pressure).abs(),
          );
        }
        
        final avgPressureDiff = pressureDiffs.average;
        final maxPressureDiff = pressureDiffs.max;
        
        // Stability index: 100 - (max diff / avg diff * 10)
        // Higher values mean more stable
        if (avgPressureDiff > 0) {
          stabilityIndex = max(0, 100 - (maxPressureDiff / avgPressureDiff * 10));
        }
      }
      
      // Check if pressure change is significant for migraine
      bool isSignificantForMigraine = false;
      if (pressureChanges.containsKey('24h')) {
        isSignificantForMigraine = pressureChanges['24h']!.abs() > 10;
      }
      
      // Calculate correlation with migraines (simplified)
      double correlationWithMigraines = 0;
      if (pressureDataPoints.any((p) => p.hadMigraine)) {
        // Simple correlation: if migraines occur more often with pressure changes
        final migrainePoints = pressureDataPoints.where((p) => p.hadMigraine).toList();
        final nonMigrainePoints = pressureDataPoints.where((p) => !p.hadMigraine).toList();
        
        if (migrainePoints.isNotEmpty && nonMigrainePoints.isNotEmpty) {
          final avgPressureMigraine = migrainePoints
              .map((p) => p.pressure.toDouble())
              .average;
          final avgPressureNoMigraine = nonMigrainePoints
              .map((p) => p.pressure.toDouble())
              .average;
          
          // Simple correlation based on pressure difference
          correlationWithMigraines = 
              (avgPressureMigraine - avgPressureNoMigraine).abs() / 100;
        }
      }
      
      return PressureAnalysis(
        userId: userId,
        date: DateTime.now(),
        currentPressure: currentPressure,
        pressureChanges: pressureChanges,
        pressureChangePercentages: pressureChangePercentages,
        trend: _getPressureTrend(pressureChanges),
        stabilityIndex: stabilityIndex,
        isSignificantForMigraine: isSignificantForMigraine,
        correlationWithMigraines: correlationWithMigraines,
        historicalData: pressureDataPoints,
        analyzedAt: DateTime.now(),
      );
    } catch (e) {
      throw RepositoryException(
        message: 'Erreur d\'analyse de la pression: ${e.toString()}',
        code: 'pressure-analysis-failed',
        innerException: e,
      );
    }
  }

  /// Get pressure trend
  String _getPressureTrend(Map<String, int> pressureChanges) {
    if (pressureChanges.isEmpty) return 'stable';
    
    // Look at 24h change
    final change24h = pressureChanges['24h'] ?? 0;
    
    if (change24h > 5) return 'rising';
    if (change24h < -5) return 'falling';
    return 'stable';
  }

  /// Get migraine repository (lazy initialization to avoid circular dependency)
  MigraineRepository? _migraineRepository;
  
  MigraineRepository _getMigraineRepository() {
    _migraineRepository ??= MigraineRepository();
    return _migraineRepository!;
  }
}
