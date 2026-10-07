import 'dart:math';
import 'package:collection/collection.dart';

import '../../models/migraine_model.dart';
import '../../models/daily_log_model.dart';
import '../../models/analysis_model.dart';
import '../../models/weather_model.dart';
import '../database/migraine_repository.dart';
import '../database/daily_log_repository.dart';
import '../database/weather_repository.dart';
import 'statistical_analysis.dart';

/// Analysis service for performing various analyses on migraine data
class AnalysisService {
  final MigraineRepository _migraineRepository;
  final DailyLogRepository _dailyLogRepository;
  final WeatherRepository _weatherRepository;

  /// Create a new AnalysisService instance
  AnalysisService({
    MigraineRepository? migraineRepository,
    DailyLogRepository? dailyLogRepository,
    WeatherRepository? weatherRepository,
  })  : _migraineRepository = migraineRepository ?? MigraineRepository(),
        _dailyLogRepository = dailyLogRepository ?? DailyLogRepository(),
        _weatherRepository = weatherRepository ?? WeatherRepository();

  // ==================== CORRELATION ANALYSIS ====================

  /// Analyze correlations between migraines and various factors
  Future<List<CorrelationAnalysis>> analyzeCorrelations({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? factors,
    double minCorrelation = 0.3,
    double maxPValue = 0.05,
    int minDataPoints = 5,
  }) async {
    try {
      // Get migraines and daily logs
      final migraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      final dailyLogs = await _dailyLogRepository.getAllDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (migraines.isEmpty || dailyLogs.isEmpty) {
        return [];
      }
      
      // Define factors to analyze
      final allFactors = factors ?? _getDefaultFactors();
      
      // Prepare data for analysis
      final analysisData = _prepareCorrelationData(migraines, dailyLogs);
      
      final results = <CorrelationAnalysis>[];
      
      // Analyze correlations between each factor and migraine occurrence
      for (final factor in allFactors) {
        if (!analysisData.factorValues.containsKey(factor)) continue;
        
        final correlation = StatisticalAnalysis.calculateCorrelation(
          analysisData.migraineOccurrence,
          analysisData.factorValues[factor]!,
        );
        
        final dataPoints = min(
          analysisData.migraineOccurrence.length,
          analysisData.factorValues[factor]!.length,
        );
        
        if (dataPoints < minDataPoints) continue;
        
        // Calculate p-value (simplified - in real app use proper statistical test)
        final pValue = _calculatePValue(correlation, dataPoints);
        
        if (correlation.abs() >= minCorrelation && pValue <= maxPValue) {
          results.add(
            CorrelationAnalysis(
              factor1: 'Migraine',
              factor2: factor,
              correlation: correlation,
              pValue: pValue,
              dataPoints: dataPoints,
              periodStart: startDate,
              periodEnd: endDate,
              isSignificant: pValue <= maxPValue,
              significanceLevel: maxPValue,
              direction: correlation > 0 ? 'positive' : 'negative',
              strength: _getCorrelationStrength(correlation.abs()),
              confidenceLevel: _getConfidenceLevel(dataPoints),
              description: _generateCorrelationDescription(
                factor,
                correlation,
                pValue,
                dataPoints,
              ),
            ),
          );
        }
      }
      
      // Sort by absolute correlation value
      results.sort((a, b) => b.correlation.abs().compareTo(a.correlation.abs()));
      
      return results;
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur d\'analyse de corrélation: ${e.toString()}',
        code: 'correlation-analysis-failed',
      );
    }
  }

  /// Get default factors to analyze
  List<String> _getDefaultFactors() {
    return [
      'sleep_duration',
      'sleep_quality',
      'stress_level',
      'fatigue_level',
      'caffeine_total',
      'caffeine_change',
      'alcohol_total',
      'water_total',
      'physical_activity',
      'screen_time',
      'pressure',
      'pressure_change',
      'temperature',
      'humidity',
      'work_day',
      'weekend',
      'menstrual_phase',
    ];
  }

  /// Prepare data for correlation analysis
  CorrelationData _prepareCorrelationData(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
  ) {
    final factorValues = <String, List<double>>{};
    final migraineOccurrence = <double>[];
    final dates = <DateTime>[];
    
    // Create a map of date to migraine occurrence
    final migraineDates = migraines.map((m) => 
      DateTime(m.startTime.year, m.startTime.month, m.startTime.day)
    ).toSet();
    
    // Process daily logs
    for (final log in dailyLogs) {
      final date = DateTime(log.date.year, log.date.month, log.date.day);
      dates.add(date);
      
      // Migraine occurrence (1 if migraine, 0 otherwise)
      migraineOccurrence.add(migraineDates.contains(date) ? 1.0 : 0.0);
      
      // Sleep factors
      if (log.sleep != null) {
        factorValues.putIfAbsent('sleep_duration', () => [])
            .add(log.sleep!.durationMinutes?.toDouble() ?? 0);
        factorValues.putIfAbsent('sleep_quality', () => [])
            .add(log.sleep!.quality?.toDouble() ?? 0);
      } else {
        factorValues.putIfAbsent('sleep_duration', () => []).add(0);
        factorValues.putIfAbsent('sleep_quality', () => []).add(0);
      }
      
      // Stress and fatigue
      factorValues.putIfAbsent('stress_level', () => [])
          .add(log.stress?.level?.toDouble() ?? 0);
      factorValues.putIfAbsent('fatigue_level', () => [])
          .add(log.fatigue?.level?.toDouble() ?? 0);
      
      // Caffeine
      factorValues.putIfAbsent('caffeine_total', () => [])
          .add(log.caffeine?.totalCaffeineMg?.toDouble() ?? 0);
      
      // Alcohol
      factorValues.putIfAbsent('alcohol_total', () => [])
          .add(log.alcohol?.totalAlcoholG ?? 0);
      
      // Water
      factorValues.putIfAbsent('water_total', () => [])
          .add(log.hydration?.totalWaterMl?.toDouble() ?? 0);
      
      // Physical activity
      factorValues.putIfAbsent('physical_activity', () => [])
          .add(log.physicalActivity?.totalDurationMinutes?.toDouble() ?? 0);
      
      // Screen time
      factorValues.putIfAbsent('screen_time', () => [])
          .add(log.screenTime?.totalMinutes?.toDouble() ?? 0);
      
      // Work day
      factorValues.putIfAbsent('work_day', () => [])
          .add(log.work?.wasWorkDay == true ? 1.0 : 0.0);
      
      // Weekend
      final isWeekend = date.weekday == 6 || date.weekday == 7;
      factorValues.putIfAbsent('weekend', () => []).add(isWeekend ? 1.0 : 0.0);
      
      // Menstrual phase (simplified)
      factorValues.putIfAbsent('menstrual_phase', () => [])
          .add(log.menstrual?.isMenstruating == true ? 1.0 : 0.0);
    }
    
    return CorrelationData(
      factorValues: factorValues,
      migraineOccurrence: migraineOccurrence,
      dates: dates,
    );
  }

  /// Calculate p-value (simplified approximation)
  double _calculatePValue(double correlation, int dataPoints) {
    // This is a simplified approximation
    // In a real app, use proper statistical tests (Pearson, Spearman, etc.)
    if (dataPoints <= 1) return 1.0;
    
    // Use t-distribution approximation
    final t = correlation * sqrt(dataPoints - 2) / sqrt(1 - correlation * correlation);
    
    // Two-tailed p-value from t-distribution
    // This is a very rough approximation
    return 2 * (1 - _tDistributionCDF(t.abs(), dataPoints - 2));
  }

  /// t-distribution CDF approximation (simplified)
  double _tDistributionCDF(double t, int df) {
    // Very simplified approximation - in real app use proper statistical library
    if (df <= 0) return 0.5;
    
    // For large df, t-distribution approaches normal distribution
    if (df > 100) {
      return _normalCDF(t);
    }
    
    // Simple approximation for t-distribution
    return 1 / (1 + exp(-t * sqrt(1 + df / 2)));
  }

  /// Normal distribution CDF approximation
  double _normalCDF(double x) {
    return 0.5 * (1 + erf(x / sqrt(2)));
  }

  /// Error function approximation
  double erf(double x) {
    // Save the sign of x
    final sign = x >= 0 ? 1.0 : -1.0;
    x = x.abs();
    
    // Constants
    final a1 = 0.254829592;
    final a2 = -0.284496736;
    final a3 = 1.421413741;
    final a4 = -1.453152027;
    final a5 = 1.061405429;
    final p = 0.3275911;
    
    // A&S formula 7.1.26
    final t = 1.0 / (1.0 + p * x);
    final y = 1.0 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * exp(-x * x);
    
    return sign * y;
  }

  /// Get correlation strength
  String _getCorrelationStrength(double absCorrelation) {
    if (absCorrelation >= 0.7) return 'strong';
    if (absCorrelation >= 0.4) return 'moderate';
    if (absCorrelation >= 0.2) return 'weak';
    return 'none';
  }

  /// Get confidence level
  ConfidenceLevel _getConfidenceLevel(int dataPoints) {
    if (dataPoints < 5) return ConfidenceLevel.insufficientData;
    if (dataPoints < 10) return ConfidenceLevel.low;
    if (dataPoints < 20) return ConfidenceLevel.medium;
    if (dataPoints < 50) return ConfidenceLevel.high;
    return ConfidenceLevel.veryHigh;
  }

  /// Generate correlation description
  String _generateCorrelationDescription(
    String factor,
    double correlation,
    double pValue,
    int dataPoints,
  ) {
    final factorDisplay = _getFactorDisplayName(factor);
    final direction = correlation > 0 ? 'positive' : 'négative';
    final strength = _getCorrelationStrength(correlation.abs());
    final confidence = _getConfidenceLevel(dataPoints);
    
    return 'Corrélation $direction ${_getStrengthDisplay(strength)} entre les migraines et $factorDisplay '
           '(coefficient: ${correlation.toStringAsFixed(2)}, p: ${pValue.toStringAsFixed(4)}, '
           'n: $dataPoints, confiance: ${_getConfidenceDisplay(confidence)})';
  }

  /// Get factor display name
  String _getFactorDisplayName(String factor) {
    switch (factor) {
      case 'sleep_duration':
        return 'durée du sommeil';
      case 'sleep_quality':
        return 'qualité du sommeil';
      case 'stress_level':
        return 'niveau de stress';
      case 'fatigue_level':
        return 'niveau de fatigue';
      case 'caffeine_total':
        return 'consommation de caféine';
      case 'caffeine_change':
        return 'changement de caféine';
      case 'alcohol_total':
        return 'consommation d\'alcool';
      case 'water_total':
        return 'hydratation';
      case 'physical_activity':
        return 'activité physique';
      case 'screen_time':
        return 'temps d\'écran';
      case 'pressure':
        return 'pression atmosphérique';
      case 'pressure_change':
        return 'changement de pression';
      case 'temperature':
        return 'température';
      case 'humidity':
        return 'humidité';
      case 'work_day':
        return 'jour de travail';
      case 'weekend':
        return 'week-end';
      case 'menstrual_phase':
        return 'phase menstruelle';
      default:
        return factor;
    }
  }

  /// Get strength display
  String _getStrengthDisplay(String strength) {
    switch (strength) {
      case 'strong':
        return 'forte';
      case 'moderate':
        return 'modérée';
      case 'weak':
        return 'faible';
      default:
        return strength;
    }
  }

  /// Get confidence display
  String _getConfidenceDisplay(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.insufficientData:
        return 'insuffisante';
      case ConfidenceLevel.low:
        return 'faible';
      case ConfidenceLevel.medium:
        return 'moyenne';
      case ConfidenceLevel.high:
        return 'élevée';
      case ConfidenceLevel.veryHigh:
        return 'très élevée';
    }
  }

  // ==================== TEMPORAL ANALYSIS ====================

  /// Analyze temporal patterns in migraine data
  Future<List<TemporalPattern>> analyzeTemporalPatterns({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? patternTypes,
  }) async {
    try {
      final migraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (migraines.isEmpty) {
        return [];
      }
      
      final results = <TemporalPattern>[];
      final allPatternTypes = patternTypes ?? ['daily', 'weekly', 'monthly'];
      
      for (final patternType in allPatternTypes) {
        switch (patternType) {
          case 'daily':
            results.addAll(await _analyzeDailyPatterns(migraines));
            break;
          case 'weekly':
            results.addAll(await _analyzeWeeklyPatterns(migraines));
            break;
          case 'monthly':
            results.addAll(await _analyzeMonthlyPatterns(migraines));
            break;
        }
      }
      
      return results;
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur d\'analyse temporelle: ${e.toString()}',
        code: 'temporal-analysis-failed',
      );
    }
  }

  /// Analyze daily patterns
  Future<List<TemporalPattern>> _analyzeDailyPatterns(
    List<MigraineModel> migraines,
  ) async {
    final results = <TemporalPattern>[];
    
    // Analyze by hour of day
    final hourlyDistribution = <int, int>{};
    for (final migraine in migraines) {
      final hour = migraine.startTime.hour;
      hourlyDistribution[hour] = (hourlyDistribution[hour] ?? 0) + 1;
    }
    
    if (hourlyDistribution.isNotEmpty) {
      // Find peak hours
      final maxCount = hourlyDistribution.values.max;
      final peakHours = hourlyDistribution.entries
          .where((e) => e.value == maxCount)
          .map((e) => e.key)
          .toList();
      
      results.add(
        TemporalPattern(
          type: 'daily',
          factor: 'hour_of_day',
          description: 'Les migraines surviennent le plus souvent entre '
                      '${peakHours.first}h et ${peakHours.last}h',
          dailyPattern: {'peak_hours': peakHours, 'distribution': hourlyDistribution},
          dataPoints: migraines.length,
          confidenceLevel: _getConfidenceLevel(migraines.length),
        ),
      );
    }
    
    return results;
  }

  /// Analyze weekly patterns
  Future<List<TemporalPattern>> _analyzeWeeklyPatterns(
    List<MigraineModel> migraines,
  ) async {
    final results = <TemporalPattern>[];
    
    // Analyze by day of week
    final weeklyDistribution = <int, int>{};
    for (final migraine in migraines) {
      final dayOfWeek = migraine.startTime.weekday; // 1-7 (Monday-Sunday)
      weeklyDistribution[dayOfWeek] = (weeklyDistribution[dayOfWeek] ?? 0) + 1;
    }
    
    if (weeklyDistribution.isNotEmpty) {
      // Find peak days
      final maxCount = weeklyDistribution.values.max;
      final peakDays = weeklyDistribution.entries
          .where((e) => e.value == maxCount)
          .map((e) => e.key)
          .toList();
      
      final dayNames = peakDays.map((d) => _getDayName(d)).toList();
      
      results.add(
        TemporalPattern(
          type: 'weekly',
          factor: 'day_of_week',
          description: 'Les migraines surviennent le plus souvent le ${dayNames.join(" et ")}',
          weeklyPattern: weeklyDistribution,
          dataPoints: migraines.length,
          confidenceLevel: _getConfidenceLevel(migraines.length),
        ),
      );
      
      // Calculate weekend vs weekday
      final weekendCount = weeklyDistribution.entries
          .where((e) => e.key == 6 || e.key == 7)
          .map((e) => e.value)
          .fold(0, (a, b) => a + b);
      
      final weekdayCount = weeklyDistribution.entries
          .where((e) => e.key >= 1 && e.key <= 5)
          .map((e) => e.value)
          .fold(0, (a, b) => a + b);
      
      if (weekdayCount > 0 && weekendCount > 0) {
        final ratio = weekendCount / weekdayCount;
        results.add(
          TemporalPattern(
            type: 'weekly',
            factor: 'weekend_vs_weekday',
            description: 'Le risque de migraine est ${ratio > 1 ? '${ratio.toStringAsFixed(1)}x plus élevé' : '${(1/ratio).toStringAsFixed(1)}x moins élevé'} '
                        'le week-end par rapport aux jours de semaine',
            weeklyPattern: {
              'weekend': weekendCount,
              'weekday': weekdayCount,
              'ratio': ratio,
            },
            dataPoints: migraines.length,
            confidenceLevel: _getConfidenceLevel(migraines.length),
          ),
        );
      }
    }
    
    return results;
  }

  /// Analyze monthly patterns
  Future<List<TemporalPattern>> _analyzeMonthlyPatterns(
    List<MigraineModel> migraines,
  ) async {
    final results = <TemporalPattern>[];
    
    // Analyze by month
    final monthlyDistribution = <int, int>{};
    for (final migraine in migraines) {
      final month = migraine.startTime.month;
      monthlyDistribution[month] = (monthlyDistribution[month] ?? 0) + 1;
    }
    
    if (monthlyDistribution.isNotEmpty) {
      // Find peak months
      final maxCount = monthlyDistribution.values.max;
      final peakMonths = monthlyDistribution.entries
          .where((e) => e.value == maxCount)
          .map((e) => e.key)
          .toList();
      
      final monthNames = peakMonths.map((m) => _getMonthName(m)).toList();
      
      results.add(
        TemporalPattern(
          type: 'monthly',
          factor: 'month',
          description: 'Les migraines surviennent le plus souvent en ${monthNames.join(" et ")}',
          monthlyPattern: monthlyDistribution,
          dataPoints: migraines.length,
          confidenceLevel: _getConfidenceLevel(migraines.length),
        ),
      );
    }
    
    return results;
  }

  /// Get day name
  String _getDayName(int dayOfWeek) {
    const days = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'
    ];
    return days[dayOfWeek - 1];
  }

  /// Get month name
  String _getMonthName(int month) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return months[month - 1];
  }

  // ==================== COMPARATIVE ANALYSIS ====================

  /// Compare data between different groups (e.g., work vs non-work days)
  Future<List<ComparativeAnalysis>> analyzeComparative({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<ComparativeGroup>? groups,
  }) async {
    try {
      final migraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      final dailyLogs = await _dailyLogRepository.getAllDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (migraines.isEmpty || dailyLogs.isEmpty) {
        return [];
      }
      
      final results = <ComparativeAnalysis>[];
      final allGroups = groups ?? [
        ComparativeGroup.workVsNonWork,
        ComparativeGroup.weekendVsWeekday,
        ComparativeGroup.highStressVsLowStress,
        ComparativeGroup.shortSleepVsLongSleep,
      ];
      
      for (final group in allGroups) {
        results.addAll(await _analyzeGroupComparison(
          migraines,
          dailyLogs,
          group,
        ));
      }
      
      return results;
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur d\'analyse comparative: ${e.toString()}',
        code: 'comparative-analysis-failed',
      );
    }
  }

  /// Analyze comparison between groups
  Future<List<ComparativeAnalysis>> _analyzeGroupComparison(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
    ComparativeGroup group,
  ) async {
    final results = <ComparativeAnalysis>[];
    
    switch (group) {
      case ComparativeGroup.workVsNonWork:
        results.addAll(await _analyzeWorkVsNonWork(migraines, dailyLogs));
        break;
      case ComparativeGroup.weekendVsWeekday:
        results.addAll(await _analyzeWeekendVsWeekday(migraines, dailyLogs));
        break;
      case ComparativeGroup.highStressVsLowStress:
        results.addAll(await _analyzeHighStressVsLowStress(migraines, dailyLogs));
        break;
      case ComparativeGroup.shortSleepVsLongSleep:
        results.addAll(await _analyzeShortSleepVsLongSleep(migraines, dailyLogs));
        break;
    }
    
    return results;
  }

  /// Analyze work vs non-work days
  Future<List<ComparativeAnalysis>> _analyzeWorkVsNonWork(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
  ) async {
    final results = <ComparativeAnalysis>[];
    
    // Separate logs by work day
    final workDayLogs = dailyLogs.where((log) => log.work?.wasWorkDay == true).toList();
    final nonWorkDayLogs = dailyLogs.where((log) => log.work?.wasWorkDay == false).toList();
    
    if (workDayLogs.isEmpty || nonWorkDayLogs.isEmpty) {
      return results;
    }
    
    // Count migraines on work vs non-work days
    final workDayMigraineCount = workDayLogs
        .where((log) => log.hadMigraine)
        .length;
    final nonWorkDayMigraineCount = nonWorkDayLogs
        .where((log) => log.hadMigraine)
        .length;
    
    final workDayCount = workDayLogs.length;
    final nonWorkDayCount = nonWorkDayLogs.length;
    
    final workDayFrequency = workDayMigraineCount / workDayCount;
    final nonWorkDayFrequency = nonWorkDayMigraineCount / nonWorkDayCount;
    final frequencyRatio = workDayFrequency / nonWorkDayFrequency;
    
    results.add(
      ComparativeAnalysis(
        group1: 'Jours de travail',
        group2: 'Jours de repos',
        factor: 'Fréquence des migraines',
        group1Average: workDayFrequency,
        group2Average: nonWorkDayFrequency,
        difference: workDayFrequency - nonWorkDayFrequency,
        percentageDifference: ((workDayFrequency - nonWorkDayFrequency) / nonWorkDayFrequency) * 100,
        group1Count: workDayCount,
        group2Count: nonWorkDayCount,
        isSignificant: _isSignificantDifference(
          workDayMigraineCount,
          workDayCount,
          nonWorkDayMigraineCount,
          nonWorkDayCount,
        ),
        confidenceLevel: _getConfidenceLevel(workDayCount + nonWorkDayCount),
        description: 'La fréquence des migraines est ${frequencyRatio > 1 ? '${frequencyRatio.toStringAsFixed(1)}x plus élevée' : '${(1/frequencyRatio).toStringAsFixed(1)}x moins élevée'} '
                    'les jours de travail par rapport aux jours de repos',
      ),
    );
    
    // Compare stress levels
    final workDayStress = workDayLogs
        .map((log) => log.stress?.level?.toDouble() ?? 0)
        .average;
    final nonWorkDayStress = nonWorkDayLogs
        .map((log) => log.stress?.level?.toDouble() ?? 0)
        .average;
    
    results.add(
      ComparativeAnalysis(
        group1: 'Jours de travail',
        group2: 'Jours de repos',
        factor: 'Niveau de stress',
        group1Average: workDayStress,
        group2Average: nonWorkDayStress,
        difference: workDayStress - nonWorkDayStress,
        percentageDifference: workDayStress > 0 && nonWorkDayStress > 0
            ? ((workDayStress - nonWorkDayStress) / nonWorkDayStress) * 100
            : null,
        group1Count: workDayCount,
        group2Count: nonWorkDayCount,
        isSignificant: _isSignificantDifference(
          workDayStress,
          workDayCount,
          nonWorkDayStress,
          nonWorkDayCount,
        ),
        confidenceLevel: _getConfidenceLevel(workDayCount + nonWorkDayCount),
      ),
    );
    
    return results;
  }

  /// Analyze weekend vs weekday
  Future<List<ComparativeAnalysis>> _analyzeWeekendVsWeekday(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
  ) async {
    final results = <ComparativeAnalysis>[];
    
    // Separate logs by weekend
    final weekendLogs = dailyLogs.where((log) => 
      log.date.weekday == 6 || log.date.weekday == 7
    ).toList();
    final weekdayLogs = dailyLogs.where((log) => 
      log.date.weekday >= 1 && log.date.weekday <= 5
    ).toList();
    
    if (weekendLogs.isEmpty || weekdayLogs.isEmpty) {
      return results;
    }
    
    // Count migraines on weekend vs weekday
    final weekendMigraineCount = weekendLogs
        .where((log) => log.hadMigraine)
        .length;
    final weekdayMigraineCount = weekdayLogs
        .where((log) => log.hadMigraine)
        .length;
    
    final weekendCount = weekendLogs.length;
    final weekdayCount = weekdayLogs.length;
    
    final weekendFrequency = weekendMigraineCount / weekendCount;
    final weekdayFrequency = weekdayMigraineCount / weekdayCount;
    final frequencyRatio = weekendFrequency / weekdayFrequency;
    
    results.add(
      ComparativeAnalysis(
        group1: 'Week-end',
        group2: 'Semaine',
        factor: 'Fréquence des migraines',
        group1Average: weekendFrequency,
        group2Average: weekdayFrequency,
        difference: weekendFrequency - weekdayFrequency,
        percentageDifference: ((weekendFrequency - weekdayFrequency) / weekdayFrequency) * 100,
        group1Count: weekendCount,
        group2Count: weekdayCount,
        isSignificant: _isSignificantDifference(
          weekendMigraineCount,
          weekendCount,
          weekdayMigraineCount,
          weekdayCount,
        ),
        confidenceLevel: _getConfidenceLevel(weekendCount + weekdayCount),
        description: 'La fréquence des migraines est ${frequencyRatio > 1 ? '${frequencyRatio.toStringAsFixed(1)}x plus élevée' : '${(1/frequencyRatio).toStringAsFixed(1)}x moins élevée'} '
                    'le week-end par rapport à la semaine',
      ),
    );
    
    return results;
  }

  /// Analyze high stress vs low stress
  Future<List<ComparativeAnalysis>> _analyzeHighStressVsLowStress(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
  ) async {
    final results = <ComparativeAnalysis>[];
    
    // Separate logs by stress level
    final highStressLogs = dailyLogs.where((log) => 
      log.stress?.level != null && log.stress!.level! >= 7
    ).toList();
    final lowStressLogs = dailyLogs.where((log) => 
      log.stress?.level != null && log.stress!.level! <= 3
    ).toList();
    
    if (highStressLogs.isEmpty || lowStressLogs.isEmpty) {
      return results;
    }
    
    // Count migraines on high vs low stress days
    final highStressMigraineCount = highStressLogs
        .where((log) => log.hadMigraine)
        .length;
    final lowStressMigraineCount = lowStressLogs
        .where((log) => log.hadMigraine)
        .length;
    
    final highStressCount = highStressLogs.length;
    final lowStressCount = lowStressLogs.length;
    
    final highStressFrequency = highStressMigraineCount / highStressCount;
    final lowStressFrequency = lowStressMigraineCount / lowStressCount;
    final frequencyRatio = highStressFrequency / lowStressFrequency;
    
    results.add(
      ComparativeAnalysis(
        group1: 'Stress élevé',
        group2: 'Stress faible',
        factor: 'Fréquence des migraines',
        group1Average: highStressFrequency,
        group2Average: lowStressFrequency,
        difference: highStressFrequency - lowStressFrequency,
        percentageDifference: ((highStressFrequency - lowStressFrequency) / lowStressFrequency) * 100,
        group1Count: highStressCount,
        group2Count: lowStressCount,
        isSignificant: _isSignificantDifference(
          highStressMigraineCount,
          highStressCount,
          lowStressMigraineCount,
          lowStressCount,
        ),
        confidenceLevel: _getConfidenceLevel(highStressCount + lowStressCount),
        description: 'La fréquence des migraines est ${frequencyRatio > 1 ? '${frequencyRatio.toStringAsFixed(1)}x plus élevée' : '${(1/frequencyRatio).toStringAsFixed(1)}x moins élevée'} '
                    'les jours de stress élevé par rapport aux jours de stress faible',
      ),
    );
    
    return results;
  }

  /// Analyze short sleep vs long sleep
  Future<List<ComparativeAnalysis>> _analyzeShortSleepVsLongSleep(
    List<MigraineModel> migraines,
    List<DailyLogModel> dailyLogs,
  ) async {
    final results = <ComparativeAnalysis>[];
    
    // Separate logs by sleep duration
    final shortSleepLogs = dailyLogs.where((log) => 
      log.sleep?.durationMinutes != null && log.sleep!.durationMinutes! < 420 // < 7 hours
    ).toList();
    final longSleepLogs = dailyLogs.where((log) => 
      log.sleep?.durationMinutes != null && log.sleep!.durationMinutes! >= 480 // >= 8 hours
    ).toList();
    
    if (shortSleepLogs.isEmpty || longSleepLogs.isEmpty) {
      return results;
    }
    
    // Count migraines on short vs long sleep days
    final shortSleepMigraineCount = shortSleepLogs
        .where((log) => log.hadMigraine)
        .length;
    final longSleepMigraineCount = longSleepLogs
        .where((log) => log.hadMigraine)
        .length;
    
    final shortSleepCount = shortSleepLogs.length;
    final longSleepCount = longSleepLogs.length;
    
    final shortSleepFrequency = shortSleepMigraineCount / shortSleepCount;
    final longSleepFrequency = longSleepMigraineCount / longSleepCount;
    final frequencyRatio = shortSleepFrequency / longSleepFrequency;
    
    results.add(
      ComparativeAnalysis(
        group1: 'Sommeil court (< 7h)',
        group2: 'Sommeil long (≥ 8h)',
        factor: 'Fréquence des migraines',
        group1Average: shortSleepFrequency,
        group2Average: longSleepFrequency,
        difference: shortSleepFrequency - longSleepFrequency,
        percentageDifference: ((shortSleepFrequency - longSleepFrequency) / longSleepFrequency) * 100,
        group1Count: shortSleepCount,
        group2Count: longSleepCount,
        isSignificant: _isSignificantDifference(
          shortSleepMigraineCount,
          shortSleepCount,
          longSleepMigraineCount,
          longSleepCount,
        ),
        confidenceLevel: _getConfidenceLevel(shortSleepCount + longSleepCount),
        description: 'La fréquence des migraines est ${frequencyRatio > 1 ? '${frequencyRatio.toStringAsFixed(1)}x plus élevée' : '${(1/frequencyRatio).toStringAsFixed(1)}x moins élevée'} '
                    'après un sommeil court par rapport à un sommeil long',
      ),
    );
    
    return results;
  }

  /// Check if difference is statistically significant (simplified)
  bool _isSignificantDifference(
    dynamic value1,
    int count1,
    dynamic value2,
    int count2,
  ) {
    // Simplified significance check
    // In a real app, use proper statistical tests (chi-square, t-test, etc.)
    
    if (count1 < 5 || count2 < 5) return false;
    
    // Check if the difference is large enough
    final diff = (value1 - value2).abs();
    final avg = (value1 + value2) / 2;
    
    // If relative difference is > 50%, consider significant
    if (avg > 0 && diff / avg > 0.5) {
      return true;
    }
    
    return false;
  }

  // ==================== RISK SCORE ANALYSIS ====================

  /// Calculate current risk score for migraine
  Future<RiskScoreModel> calculateRiskScore({
    required String userId,
    DateTime? date,
  }) async {
    try {
      final now = date ?? DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      // Get recent data
      final recentMigraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: today.subtract(const Duration(days: 30)),
        endDate: today,
      );
      
      final recentLogs = await _dailyLogRepository.getAllDailyLogs(
        userId,
        startDate: today.subtract(const Duration(days: 7)),
        endDate: today,
      );
      
      // Get today's log if available
      final todayLog = recentLogs.firstWhere(
        (log) => DateTime(log.date.year, log.date.month, log.date.day) == today,
        orElse: () => null,
      );
      
      // Calculate risk factors
      final factorScores = <String, double>{};
      final factorContributions = <String, String>{};
      
      // 1. Recent migraine frequency
      final recentFrequency = recentMigraines.length / 30.0;
      final frequencyScore = min(recentFrequency * 100, 100.0);
      factorScores['recent_frequency'] = frequencyScore;
      factorContributions['recent_frequency'] = 
          '${recentMigraines.length} migraines dans les 30 derniers jours';
      
      // 2. Sleep quality
      if (todayLog?.sleep != null) {
        final sleepQuality = todayLog!.sleep!.quality ?? 3;
        final sleepScore = (5 - sleepQuality) * 20.0; // 0-100
        factorScores['sleep_quality'] = sleepScore;
        factorContributions['sleep_quality'] = 
            'Qualité du sommeil: $sleepQuality/5';
      }
      
      // 3. Stress level
      if (todayLog?.stress != null) {
        final stressLevel = todayLog!.stress!.level ?? 5;
        final stressScore = stressLevel * 10.0; // 0-100
        factorScores['stress'] = stressScore;
        factorContributions['stress'] = 
            'Niveau de stress: $stressLevel/10';
      }
      
      // 4. Fatigue level
      if (todayLog?.fatigue != null) {
        final fatigueLevel = todayLog!.fatigue!.level ?? 5;
        final fatigueScore = fatigueLevel * 10.0; // 0-100
        factorScores['fatigue'] = fatigueScore;
        factorContributions['fatigue'] = 
            'Niveau de fatigue: $fatigueLevel/10';
      }
      
      // 5. Caffeine consumption
      if (todayLog?.caffeine != null) {
        final typicalCaffeine = await _getTypicalCaffeine(userId);
        final todayCaffeine = todayLog!.caffeine!.totalCaffeineMg ?? 0;
        final caffeineDiff = (todayCaffeine - typicalCaffeine).abs();
        final caffeineScore = min(caffeineDiff / typicalCaffeine * 50, 50.0);
        factorScores['caffeine_change'] = caffeineScore;
        factorContributions['caffeine_change'] = 
            'Changement de caféine: ${caffeineDiff.round()}mg';
      }
      
      // 6. Hydration
      if (todayLog?.hydration != null) {
        final hydrationLevel = todayLog!.hydration!.level ?? 3;
        final hydrationScore = (5 - hydrationLevel) * 10.0; // 0-50
        factorScores['hydration'] = hydrationScore;
        factorContributions['hydration'] = 
            'Niveau d\'hydratation: $hydrationLevel/5';
      }
      
      // 7. Weather
      final weather = await _weatherRepository.getWeatherByDate(
        userId,
        today,
      );
      if (weather != null) {
        // Check for pressure changes
        final pressureChange = weather.pressureChanges['24h']?.abs() ?? 0;
        final pressureScore = min(pressureChange / 10 * 20, 20.0); // 0-20
        factorScores['pressure_change'] = pressureScore;
        factorContributions['pressure_change'] = 
            'Changement de pression: ${pressureChange}hPa';
      }
      
      // Calculate overall risk score (0-100)
      final totalScore = factorScores.values.fold(0.0, (a, b) => a + b);
      final riskScore = min(totalScore, 100.0);
      
      // Determine risk level
      String riskLevel;
      if (riskScore >= 80) {
        riskLevel = 'veryHigh';
      } else if (riskScore >= 60) {
        riskLevel = 'high';
      } else if (riskScore >= 40) {
        riskLevel = 'medium';
      } else {
        riskLevel = 'low';
      }
      
      // Get main factors (top 3)
      final mainFactors = factorScores.entries
          .sortedBy<num>((e) => -e.value)
          .take(3)
          .map((e) => e.key)
          .toList();
      
      return RiskScoreModel(
        userId: userId,
        date: today,
        score: riskScore,
        level: riskLevel,
        factorScores: factorScores,
        factorContributions: factorContributions,
        mainFactors: mainFactors,
        confidenceLevel: _getConfidenceLevel(recentMigraines.length + recentLogs.length),
        analyzedAt: DateTime.now(),
        isSynced: false,
      );
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur de calcul du score de risque: ${e.toString()}',
        code: 'risk-score-failed',
      );
    }
  }

  /// Get typical caffeine consumption for user
  Future<double> _getTypicalCaffeine(String userId) async {
    final logs = await _dailyLogRepository.getAllDailyLogs(
      userId,
      startDate: DateTime.now().subtract(const Duration(days: 30)),
      endDate: DateTime.now(),
    );
    
    if (logs.isEmpty) return 100.0; // Default value
    
    final caffeineValues = logs
        .map((log) => log.caffeine?.totalCaffeineMg?.toDouble() ?? 0)
        .where((value) => value > 0)
        .toList();
    
    if (caffeineValues.isEmpty) return 100.0;
    
    return caffeineValues.average;
  }

  // ==================== INSIGHT GENERATION ====================

  /// Generate insights from analysis results
  Future<List<InsightModel>> generateInsights({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    List<CorrelationAnalysis>? correlations,
    List<TemporalPattern>? temporalPatterns,
    List<ComparativeAnalysis>? comparativeAnalysis,
  }) async {
    final insights = <InsightModel>[];
    
    // Generate insights from correlations
    if (correlations != null) {
      for (final correlation in correlations) {
        if (correlation.confidenceLevel == ConfidenceLevel.insufficientData) {
          continue;
        }
        
        insights.add(
          InsightModel.createCorrelation(
            userId: userId,
            factor1: correlation.factor1,
            factor2: correlation.factor2,
            correlation: correlation.correlation,
            dataPoints: correlation.dataPoints,
            pValue: correlation.pValue,
            description: correlation.description,
            confidenceLevel: correlation.confidenceLevel,
            periodStart: correlation.periodStart,
            periodEnd: correlation.periodEnd,
          ),
        );
      }
    }
    
    // Generate insights from temporal patterns
    if (temporalPatterns != null) {
      for (final pattern in temporalPatterns) {
        if (pattern.confidenceLevel == ConfidenceLevel.insufficientData) {
          continue;
        }
        
        insights.add(
          InsightModel.createTemporalPattern(
            userId: userId,
            factor: pattern.factor,
            patternType: pattern.type,
            description: pattern.description,
            dataPoints: pattern.dataPoints,
            confidenceLevel: pattern.confidenceLevel,
            periodStart: pattern.periodStart,
            periodEnd: pattern.periodEnd,
          ),
        );
      }
    }
    
    // Generate insights from comparative analysis
    if (comparativeAnalysis != null) {
      for (final comparison in comparativeAnalysis) {
        if (comparison.confidenceLevel == ConfidenceLevel.insufficientData) {
          continue;
        }
        
        insights.add(
          InsightModel.createComparative(
            userId: userId,
            group1: comparison.group1,
            group2: comparison.group2,
            factor: comparison.factor,
            difference: comparison.difference ?? 0,
            dataPoints: comparison.group1Count + comparison.group2Count,
            pValue: 0.05, // Placeholder - calculate properly in real app
            description: comparison.description,
            confidenceLevel: comparison.confidenceLevel,
            periodStart: startDate,
            periodEnd: endDate,
          ),
        );
      }
    }
    
    // Sort insights by priority
    insights.sort((a, b) => b.confidenceLevel.score.compareTo(a.confidenceLevel.score));
    
    return insights;
  }

  // ==================== CAFFEINE ANALYSIS ====================

  /// Analyze caffeine consumption patterns and their relation to migraines
  Future<CaffeineAnalysisResult> analyzeCaffeine({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final migraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      final dailyLogs = await _dailyLogRepository.getAllDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (dailyLogs.isEmpty) {
        return CaffeineAnalysisResult(
          userId: userId,
          periodStart: startDate,
          periodEnd: endDate,
          dataPoints: 0,
        );
      }
      
      // Calculate statistics
      final caffeineValues = dailyLogs
          .map((log) => log.caffeine?.totalCaffeineMg?.toDouble() ?? 0)
          .toList();
      
      final avgCaffeine = caffeineValues.average;
      final minCaffeine = caffeineValues.min;
      final maxCaffeine = caffeineValues.max;
      final stdDevCaffeine = StatisticalAnalysis.calculateStdDev(caffeineValues);
      
      // Calculate changes
      final caffeineChanges = <double>[];
      for (int i = 1; i < caffeineValues.length; i++) {
        caffeineChanges.add(caffeineValues[i] - caffeineValues[i - 1]);
      }
      
      final avgChange = caffeineChanges.average;
      final maxChange = caffeineChanges.max;
      final minChange = caffeineChanges.min;
      
      // Find days with significant changes
      final significantChangeThreshold = stdDevCaffeine * 2;
      final significantChangeDays = caffeineChanges
          .asMap()
          .entries
          .where((e) => e.value.abs() > significantChangeThreshold)
          .map((e) => e.key)
          .toList();
      
      // Check migraines after caffeine changes
      final migrainesAfterChange = <int>[];
      for (final dayIndex in significantChangeDays) {
        // Check if there was a migraine in the next 3 days
        for (int i = 1; i <= 3; i++) {
          if (dayIndex + i < dailyLogs.length) {
            final log = dailyLogs[dayIndex + i];
            if (log.hadMigraine) {
              migrainesAfterChange.add(dayIndex);
              break;
            }
          }
        }
      }
      
      // Calculate correlation with migraines
      final migraineDays = dailyLogs
          .asMap()
          .entries
          .where((e) => e.value.hadMigraine)
          .map((e) => e.key)
          .toList();
      
      final caffeineOnMigraineDays = migraineDays
          .map((day) => caffeineValues[day])
          .toList();
      
      final avgCaffeineOnMigraineDays = caffeineOnMigraineDays.isNotEmpty
          ? caffeineOnMigraineDays.average
          : 0;
      
      final correlation = StatisticalAnalysis.calculateCorrelation(
        caffeineValues,
        dailyLogs.map((log) => log.hadMigraine ? 1.0 : 0.0).toList(),
      );
      
      return CaffeineAnalysisResult(
        userId: userId,
        periodStart: startDate,
        periodEnd: endDate,
        dataPoints: dailyLogs.length,
        averageCaffeine: avgCaffeine,
        minCaffeine: minCaffeine,
        maxCaffeine: maxCaffeine,
        stdDevCaffeine: stdDevCaffeine,
        averageChange: avgChange,
        maxChange: maxChange,
        minChange: minChange,
        significantChangeDays: significantChangeDays,
        migrainesAfterChangeCount: migrainesAfterChange.length,
        migrainesAfterChangePercentage: significantChangeDays.isNotEmpty
            ? (migrainesAfterChange.length / significantChangeDays.length) * 100
            : 0,
        averageCaffeineOnMigraineDays: avgCaffeineOnMigraineDays,
        correlationWithMigraines: correlation,
        insights: _generateCaffeineInsights(
          avgCaffeine,
          stdDevCaffeine,
          correlation,
          migrainesAfterChange.length,
          significantChangeDays.length,
        ),
      );
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur d\'analyse de la caféine: ${e.toString()}',
        code: 'caffeine-analysis-failed',
      );
    }
  }

  /// Generate caffeine insights
  List<String> _generateCaffeineInsights(
    double avgCaffeine,
    double stdDevCaffeine,
    double correlation,
    int migrainesAfterChange,
    int significantChangeDays,
  ) {
    final insights = <String>[];
    
    // High variability
    if (stdDevCaffeine > avgCaffeine * 0.5) {
      insights.add(
        'Votre consommation de caféine varie beaucoup (écart-type: ${stdDevCaffeine.toStringAsFixed(0)}mg). '
        'Une consommation régulière pourrait aider à réduire les migraines.',
      );
    }
    
    // Positive correlation
    if (correlation > 0.3) {
      insights.add(
        'Une corrélation positive (${correlation.toStringAsFixed(2)}) a été observée entre la caféine et les migraines. '
        'Cela pourrait indiquer que la caféine est un facteur déclencheur pour vous.',
      );
    }
    
    // Negative correlation
    if (correlation < -0.3) {
      insights.add(
        'Une corrélation négative (${correlation.toStringAsFixed(2)}) a été observée entre la caféine et les migraines. '
        'Cela pourrait indiquer que la caféine a un effet protecteur contre les migraines pour vous.',
      );
    }
    
    // Migraines after changes
    if (significantChangeDays > 0 && migrainesAfterChange > 0) {
      final percentage = (migrainesAfterChange / significantChangeDays * 100).round();
      insights.add(
        'Dans $percentage% des cas, une migraine est survenue dans les 3 jours suivant un changement significatif '
        'de consommation de caféine.',
      );
    }
    
    return insights;
  }

  // ==================== WEEKEND ANALYSIS ====================

  /// Analyze differences between weekend and weekday patterns
  Future<WeekendAnalysisResult> analyzeWeekend({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final migraines = await _migraineRepository.getAllMigraines(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      final dailyLogs = await _dailyLogRepository.getAllDailyLogs(
        userId,
        startDate: startDate,
        endDate: endDate,
      );
      
      if (dailyLogs.isEmpty) {
        return WeekendAnalysisResult(
          userId: userId,
          periodStart: startDate,
          periodEnd: endDate,
          dataPoints: 0,
        );
      }
      
      // Separate by weekend
      final weekendLogs = dailyLogs.where((log) => 
        log.date.weekday == 6 || log.date.weekday == 7
      ).toList();
      final weekdayLogs = dailyLogs.where((log) => 
        log.date.weekday >= 1 && log.date.weekday <= 5
      ).toList();
      
      // Count migraines
      final weekendMigraines = weekendLogs.where((log) => log.hadMigraine).length;
      final weekdayMigraines = weekdayLogs.where((log) => log.hadMigraine).length;
      
      final weekendFrequency = weekendLogs.isNotEmpty
          ? weekendMigraines / weekendLogs.length
          : 0;
      final weekdayFrequency = weekdayLogs.isNotEmpty
          ? weekdayMigraines / weekdayLogs.length
          : 0;
      
      final frequencyRatio = weekdayFrequency > 0
          ? weekendFrequency / weekdayFrequency
          : 0;
      
      // Calculate statistics for various factors
      final weekendSleep = weekendLogs
          .map((log) => log.sleep?.durationMinutes?.toDouble() ?? 0)
          .average;
      final weekdaySleep = weekdayLogs
          .map((log) => log.sleep?.durationMinutes?.toDouble() ?? 0)
          .average;
      
      final weekendCaffeine = weekendLogs
          .map((log) => log.caffeine?.totalCaffeineMg?.toDouble() ?? 0)
          .average;
      final weekdayCaffeine = weekdayLogs
          .map((log) => log.caffeine?.totalCaffeineMg?.toDouble() ?? 0)
          .average;
      
      final weekendStress = weekendLogs
          .map((log) => log.stress?.level?.toDouble() ?? 0)
          .average;
      final weekdayStress = weekdayLogs
          .map((log) => log.stress?.level?.toDouble() ?? 0)
          .average;
      
      final weekendAlcohol = weekendLogs
          .map((log) => log.alcohol?.totalAlcoholG ?? 0)
          .average;
      final weekdayAlcohol = weekdayLogs
          .map((log) => log.alcohol?.totalAlcoholG ?? 0)
          .average;
      
      return WeekendAnalysisResult(
        userId: userId,
        periodStart: startDate,
        periodEnd: endDate,
        dataPoints: dailyLogs.length,
        weekendDays: weekendLogs.length,
        weekdayDays: weekdayLogs.length,
        weekendMigraines: weekendMigraines,
        weekdayMigraines: weekdayMigraines,
        weekendFrequency: weekendFrequency,
        weekdayFrequency: weekdayFrequency,
        frequencyRatio: frequencyRatio,
        weekendSleep: weekendSleep,
        weekdaySleep: weekdaySleep,
        weekendCaffeine: weekendCaffeine,
        weekdayCaffeine: weekdayCaffeine,
        weekendStress: weekendStress,
        weekdayStress: weekdayStress,
        weekendAlcohol: weekendAlcohol,
        weekdayAlcohol: weekdayAlcohol,
        insights: _generateWeekendInsights(
          frequencyRatio,
          weekendSleep,
          weekdaySleep,
          weekendCaffeine,
          weekdayCaffeine,
          weekendStress,
          weekdayStress,
          weekendAlcohol,
          weekdayAlcohol,
        ),
      );
    } catch (e) {
      throw AnalysisException(
        message: 'Erreur d\'analyse week-end: ${e.toString()}',
        code: 'weekend-analysis-failed',
      );
    }
  }

  /// Generate weekend insights
  List<String> _generateWeekendInsights(
    double frequencyRatio,
    double weekendSleep,
    double weekdaySleep,
    double weekendCaffeine,
    double weekdayCaffeine,
    double weekendStress,
    double weekdayStress,
    double weekendAlcohol,
    double weekdayAlcohol,
  ) {
    final insights = <String>[];
    
    // Frequency comparison
    if (frequencyRatio > 1.5) {
      insights.add(
        'Vous avez ${frequencyRatio.toStringAsFixed(1)}x plus de migraines le week-end que la semaine.',
      );
    } else if (frequencyRatio < 0.67) {
      insights.add(
        'Vous avez ${(1/frequencyRatio).toStringAsFixed(1)}x moins de migraines le week-end que la semaine.',
      );
    }
    
    // Sleep difference
    final sleepDiff = weekendSleep - weekdaySleep;
    if (sleepDiff.abs() > 60) { // More than 1 hour difference
      insights.add(
        'Vous dormez ${sleepDiff > 0 ? 'en moyenne ${(sleepDiff/60).round()}h de plus' : 'en moyenne ${(sleepDiff.abs()/60).round()}h de moins'} '
        'le week-end par rapport à la semaine.',
      );
    }
    
    // Caffeine difference
    final caffeineDiff = weekendCaffeine - weekdayCaffeine;
    if (caffeineDiff.abs() > 50) { // More than 50mg difference
      insights.add(
        'Votre consommation de caféine est ${caffeineDiff > 0 ? 'en moyenne ${caffeineDiff.round()}mg plus élevée' : 'en moyenne ${caffeineDiff.abs().round()}mg moins élevée'} '
        'le week-end par rapport à la semaine.',
      );
    }
    
    // Stress difference
    final stressDiff = weekendStress - weekdayStress;
    if (stressDiff.abs() > 2) { // More than 2 points difference
      insights.add(
        'Votre niveau de stress est ${stressDiff > 0 ? 'en moyenne ${stressDiff.toStringAsFixed(1)} points plus élevé' : 'en moyenne ${stressDiff.abs().toStringAsFixed(1)} points moins élevé'} '
        'le week-end par rapport à la semaine.',
      );
    }
    
    // Alcohol difference
    if (weekendAlcohol > weekdayAlcohol * 2) {
      insights.add(
        'Votre consommation d\'alcool est significativement plus élevée le week-end.',
      );
    }
    
    return insights;
  }
}

/// Analysis exception
class AnalysisException implements Exception {
  final String message;
  final String? code;
  final dynamic innerException;

  const AnalysisException({
    required this.message,
    this.code,
    this.innerException,
  });

  @override
  String toString() => 'AnalysisException: $message (Code: $code)';
}

/// Comparative group enum
enum ComparativeGroup {
  workVsNonWork,
  weekendVsWeekday,
  highStressVsLowStress,
  shortSleepVsLongSleep,
}

/// Correlation data model
class CorrelationData {
  final Map<String, List<double>> factorValues;
  final List<double> migraineOccurrence;
  final List<DateTime> dates;

  CorrelationData({
    required this.factorValues,
    required this.migraineOccurrence,
    required this.dates,
  });
}

/// Caffeine analysis result
class CaffeineAnalysisResult {
  final String userId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final int dataPoints;
  final double averageCaffeine;
  final double minCaffeine;
  final double maxCaffeine;
  final double stdDevCaffeine;
  final double averageChange;
  final double maxChange;
  final double minChange;
  final List<int> significantChangeDays;
  final int migrainesAfterChangeCount;
  final double migrainesAfterChangePercentage;
  final double averageCaffeineOnMigraineDays;
  final double correlationWithMigraines;
  final List<String> insights;

  CaffeineAnalysisResult({
    required this.userId,
    this.periodStart,
    this.periodEnd,
    required this.dataPoints,
    required this.averageCaffeine,
    required this.minCaffeine,
    required this.maxCaffeine,
    required this.stdDevCaffeine,
    required this.averageChange,
    required this.maxChange,
    required this.minChange,
    required this.significantChangeDays,
    required this.migrainesAfterChangeCount,
    required this.migrainesAfterChangePercentage,
    required this.averageCaffeineOnMigraineDays,
    required this.correlationWithMigraines,
    required this.insights,
  });
}

/// Weekend analysis result
class WeekendAnalysisResult {
  final String userId;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final int dataPoints;
  final int weekendDays;
  final int weekdayDays;
  final int weekendMigraines;
  final int weekdayMigraines;
  final double weekendFrequency;
  final double weekdayFrequency;
  final double frequencyRatio;
  final double weekendSleep;
  final double weekdaySleep;
  final double weekendCaffeine;
  final double weekdayCaffeine;
  final double weekendStress;
  final double weekdayStress;
  final double weekendAlcohol;
  final double weekdayAlcohol;
  final List<String> insights;

  WeekendAnalysisResult({
    required this.userId,
    this.periodStart,
    this.periodEnd,
    required this.dataPoints,
    required this.weekendDays,
    required this.weekdayDays,
    required this.weekendMigraines,
    required this.weekdayMigraines,
    required this.weekendFrequency,
    required this.weekdayFrequency,
    required this.frequencyRatio,
    required this.weekendSleep,
    required this.weekdaySleep,
    required this.weekendCaffeine,
    required this.weekdayCaffeine,
    required this.weekendStress,
    required this.weekdayStress,
    required this.weekendAlcohol,
    required this.weekdayAlcohol,
    required this.insights,
  });
}
