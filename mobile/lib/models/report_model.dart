import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

/// Report type enum
enum ReportType {
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
  custom,
}

/// Report format enum
enum ReportFormat {
  summary,
  detailed,
  medical,
}

/// Report model
@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    /// Unique report ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Report type
    @Default(ReportType.weekly) ReportType type,
    
    /// Report format
    @Default(ReportFormat.summary) ReportFormat format,
    
    /// Report title
    String? title,
    
    /// Report period start
    required DateTime periodStart,
    
    /// Report period end
    required DateTime periodEnd,
    
    /// Report data
    required ReportData data,
    
    /// Report summary (natural language)
    String? summary,
    
    /// Report insights
    @Default([]) List<ReportInsight> insights,
    
    /// Report recommendations
    @Default([]) List<String> recommendations,
    
    /// Report warnings
    @Default([]) List<String> warnings,
    
    /// Whether report has been viewed
    @Default(false) bool isViewed,
    
    /// Whether report has been exported
    @Default(false) bool isExported,
    
    /// Export formats
    @Default([]) List<String> exportFormats,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether the report is synced
    @Default(false) bool isSynced,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}

/// Report data model
@freezed
class ReportData with _$ReportData {
  const factory ReportData({
    /// Total migraines
    @Default(0) int totalMigraines,
    
    /// Migraine days
    @Default(0) int migraineDays,
    
    /// Days without migraines
    @Default(0) int daysWithoutMigraines,
    
    /// Average migraine intensity
    double? averageIntensity,
    
    /// Maximum migraine intensity
    int? maxIntensity,
    
    /// Minimum migraine intensity
    int? minIntensity,
    
    /// Average migraine duration in minutes
    double? averageDurationMinutes,
    
    /// Total migraine duration in minutes
    int? totalDurationMinutes,
    
    /// Most frequent symptoms
    @Default({}) Map<String, int> symptomFrequency,
    
    /// Most frequent triggers
    @Default({}) Map<String, int> triggerFrequency,
    
    /// Migraines by day of week
    @Default({}) Map<String, int> migrainesByDayOfWeek,
    
    /// Migraines by hour
    @Default({}) Map<String, int> migrainesByHour,
    
    /// Average sleep duration in minutes
    double? averageSleepDuration,
    
    /// Average sleep quality
    double? averageSleepQuality,
    
    /// Average stress level
    double? averageStressLevel,
    
    /// Average fatigue level
    double? averageFatigueLevel,
    
    /// Total caffeine consumption in mg
    int? totalCaffeineMg,
    
    /// Average caffeine consumption in mg
    double? averageCaffeineMg,
    
    /// Total alcohol consumption in grams
    double? totalAlcoholG,
    
    /// Average alcohol consumption in grams
    double? averageAlcoholG,
    
    /// Total water consumption in ml
    int? totalWaterMl,
    
    /// Average water consumption in ml
    double? averageWaterMl,
    
    /// Physical activity data
    PhysicalActivityReportData? physicalActivity,
    
    /// Medication data
    MedicationReportData? medication,
    
    /// Weather data
    WeatherReportData? weather,
    
    /// Menstrual data
    MenstrualReportData? menstrual,
    
    /// Work data
    WorkReportData? work,
    
    /// Trend analysis
    TrendAnalysisData? trends,
    
    /// Correlation analysis
    CorrelationReportData? correlations,
    
    /// Comparative analysis
    ComparativeReportData? comparisons,
    
    /// Data quality
    DataQualityData? dataQuality,
  }) = _ReportData;

  factory ReportData.fromJson(Map<String, dynamic> json) =>
      _$ReportDataFromJson(json);
}

/// Physical activity report data
@freezed
class PhysicalActivityReportData with _$PhysicalActivityReportData {
  const factory PhysicalActivityReportData({
    /// Total activity duration in minutes
    @Default(0) int totalDurationMinutes,
    
    /// Average activity duration in minutes
    double? averageDurationMinutes,
    
    /// Number of active days
    @Default(0) int activeDays,
    
    /// Activity by type
    @Default({}) Map<String, int> activityByType,
    
    /// Activity by intensity
    @Default({}) Map<String, int> activityByIntensity,
    
    /// Most frequent activity types
    @Default([]) List<String> mostFrequentTypes,
  }) = _PhysicalActivityReportData;

  factory PhysicalActivityReportData.fromJson(Map<String, dynamic> json) =>
      _$PhysicalActivityReportDataFromJson(json);
}

/// Medication report data
@freezed
class MedicationReportData with _$MedicationReportData {
  const factory MedicationReportData({
    /// Total medications taken
    @Default(0) int totalMedications,
    
    /// Medications by type
    @Default({}) Map<String, int> medicationsByType,
    
    /// Average effectiveness
    double? averageEffectiveness,
    
    /// Most effective medications
    @Default({}) Map<String, double> mostEffective,
    
    /// Most commonly used medications
    @Default({}) Map<String, int> mostCommon,
    
    /// Medications by time
    @Default({}) Map<String, int> medicationsByTime,
  }) = _MedicationReportData;

  factory MedicationReportData.fromJson(Map<String, dynamic> json) =>
      _$MedicationReportDataFromJson(json);
}

/// Weather report data
@freezed
class WeatherReportData with _$WeatherReportData {
  const factory WeatherReportData({
    /// Average temperature
    double? averageTemperature,
    
    /// Temperature range
    Map<String, double>? temperatureRange,
    
    /// Average humidity
    double? averageHumidity,
    
    /// Average pressure
    double? averagePressure,
    
    /// Pressure changes
    @Default({}) Map<String, int> pressureChanges,
    
    /// Weather conditions
    @Default({}) Map<String, int> conditions,
    
    /// Weather by day
    @Default({}) Map<String, Map<String, dynamic>> weatherByDay,
  }) = _WeatherReportData;

  factory WeatherReportData.fromJson(Map<String, dynamic> json) =>
      _$WeatherReportDataFromJson(json);
}

/// Menstrual report data
@freezed
class MenstrualReportData with _$MenstrualReportData {
  const factory MenstrualReportData({
    /// Whether user tracks menstrual cycle
    @Default(false) bool isTracking,
    
    /// Number of menstrual days
    @Default(0) int menstrualDays,
    
    /// Number of fertile window days
    @Default(0) int fertileWindowDays,
    
    /// Number of pre-menstrual days
    @Default(0) int preMenstrualDays,
    
    /// Migraines during menstrual phase
    @Default(0) int migrainesDuringMenstrual,
    
    /// Migraines during fertile window
    @Default(0) int migrainesDuringFertile,
    
    /// Migraines during pre-menstrual phase
    @Default(0) int migrainesDuringPreMenstrual,
    
    /// Correlation with menstrual cycle
    double? correlationWithCycle,
  }) = _MenstrualReportData;

  factory MenstrualReportData.fromJson(Map<String, dynamic> json) =>
      _$MenstrualReportDataFromJson(json);
}

/// Work report data
@freezed
class WorkReportData with _$WorkReportData {
  const factory WorkReportData({
    /// Number of work days
    @Default(0) int workDays,
    
    /// Number of non-work days
    @Default(0) int nonWorkDays,
    
    /// Average work duration in minutes
    double? averageWorkDuration,
    
    /// Average stress level on work days
    double? averageWorkStress,
    
    /// Average stress level on non-work days
    double? averageNonWorkStress,
    
    /// Migraines on work days
    @Default(0) int migrainesOnWorkDays,
    
    /// Migraines on non-work days
    @Default(0) int migrainesOnNonWorkDays,
    
    /// Work from home days
    @Default(0) int workFromHomeDays,
    
    /// Migraines on work from home days
    @Default(0) int migrainesOnWorkFromHomeDays,
  }) = _WorkReportData;

  factory WorkReportData.fromJson(Map<String, dynamic> json) =>
      _$WorkReportDataFromJson(json);
}

/// Trend analysis data
@freezed
class TrendAnalysisData with _$TrendAnalysisData {
  const factory TrendAnalysisData({
    /// Overall trend
    String? overallTrend,
    
    /// Trend percentage
    double? trendPercentage,
    
    /// Trend by factor
    @Default({}) Map<String, String> trendByFactor,
    
    /// Factors showing improvement
    @Default([]) List<String> improvingFactors,
    
    /// Factors showing deterioration
    @Default([]) List<String> deterioratingFactors,
    
    /// Factors with no change
    @Default([]) List<String> stableFactors,
    
    /// Trend over time
    @Default({}) Map<String, dynamic> trendOverTime,
  }) = _TrendAnalysisData;

  factory TrendAnalysisData.fromJson(Map<String, dynamic> json) =>
      _$TrendAnalysisDataFromJson(json);
}

/// Correlation report data
@freezed
class CorrelationReportData with _$CorrelationReportData {
  const factory CorrelationReportData({
    /// Top positive correlations
    @Default([]) List<ReportCorrelation> topPositiveCorrelations,
    
    /// Top negative correlations
    @Default([]) List<ReportCorrelation> topNegativeCorrelations,
    
    /// All correlations
    @Default([]) List<ReportCorrelation> allCorrelations,
    
    /// Most significant correlations
    @Default([]) List<ReportCorrelation> mostSignificantCorrelations,
  }) = _CorrelationReportData;

  factory CorrelationReportData.fromJson(Map<String, dynamic> json) =>
      _$CorrelationReportDataFromJson(json);
}

/// Report correlation
@freezed
class ReportCorrelation with _$ReportCorrelation {
  const factory ReportCorrelation({
    /// Factor 1
    required String factor1,
    
    /// Factor 2
    required String factor2,
    
    /// Correlation coefficient
    required double correlation,
    
    /// P-value
    double? pValue,
    
    /// Data points
    required int dataPoints,
    
    /// Direction
    String? direction,
    
    /// Strength
    String? strength,
    
    /// Confidence level
    String? confidenceLevel,
    
    /// Description
    String? description,
  }) = _ReportCorrelation;

  factory ReportCorrelation.fromJson(Map<String, dynamic> json) =>
      _$ReportCorrelationFromJson(json);
}

/// Comparative report data
@freezed
class ComparativeReportData with _$ComparativeReportData {
  const factory ComparativeReportData({
    /// Weekday vs weekend comparison
    WeekdayWeekendComparison? weekdayWeekend,
    
    /// Work vs non-work comparison
    WorkNonWorkComparison? workNonWork,
    
    /// Menstrual vs non-menstrual comparison
    MenstrualComparison? menstrualComparison,
    
    /// Caffeine consumption comparison
    CaffeineComparison? caffeineComparison,
    
    /// Sleep comparison
    SleepComparison? sleepComparison,
    
    /// Stress comparison
    StressComparison? stressComparison,
  }) = _ComparativeReportData;

  factory ComparativeReportData.fromJson(Map<String, dynamic> json) =>
      _$ComparativeReportDataFromJson(json);
}

/// Weekday vs weekend comparison
@freezed
class WeekdayWeekendComparison with _$WeekdayWeekendComparison {
  const factory WeekdayWeekendComparison({
    /// Migraine frequency on weekdays
    double? weekdayFrequency,
    
    /// Migraine frequency on weekends
    double? weekendFrequency,
    
    /// Frequency ratio (weekend/weekday)
    double? frequencyRatio,
    
    /// Average intensity on weekdays
    double? weekdayIntensity,
    
    /// Average intensity on weekends
    double? weekendIntensity,
    
    /// Sleep comparison
    SleepComparison? sleep,
    
    /// Caffeine comparison
    CaffeineComparison? caffeine,
    
    /// Stress comparison
    StressComparison? stress,
    
    /// Alcohol comparison
    AlcoholComparison? alcohol,
  }) = _WeekdayWeekendComparison;

  factory WeekdayWeekendComparison.fromJson(Map<String, dynamic> json) =>
      _$WeekdayWeekendComparisonFromJson(json);
}

/// Work vs non-work comparison
@freezed
class WorkNonWorkComparison with _$WorkNonWorkComparison {
  const factory WorkNonWorkComparison({
    /// Migraine frequency on work days
    double? workDayFrequency,
    
    /// Migraine frequency on non-work days
    double? nonWorkDayFrequency,
    
    /// Frequency ratio (work/non-work)
    double? frequencyRatio,
    
    /// Average intensity on work days
    double? workDayIntensity,
    
    /// Average intensity on non-work days
    double? nonWorkDayIntensity,
    
    /// Sleep comparison
    SleepComparison? sleep,
    
    /// Stress comparison
    StressComparison? stress,
  }) = _WorkNonWorkComparison;

  factory WorkNonWorkComparison.fromJson(Map<String, dynamic> json) =>
      _$WorkNonWorkComparisonFromJson(json);
}

/// Menstrual vs non-menstrual comparison
@freezed
class MenstrualComparison with _$MenstrualComparison {
  const factory MenstrualComparison({
    /// Migraine frequency during menstrual phase
    double? menstrualFrequency,
    
    /// Migraine frequency during non-menstrual phase
    double? nonMenstrualFrequency,
    
    /// Frequency ratio
    double? frequencyRatio,
    
    /// Average intensity during menstrual phase
    double? menstrualIntensity,
    
    /// Average intensity during non-menstrual phase
    double? nonMenstrualIntensity,
  }) = _MenstrualComparison;

  factory MenstrualComparison.fromJson(Map<String, dynamic> json) =>
      _$MenstrualComparisonFromJson(json);
}

/// Caffeine comparison
@freezed
class CaffeineComparison with _$CaffeineComparison {
  const factory CaffeineComparison({
    /// Average caffeine on group 1
    double? group1Average,
    
    /// Average caffeine on group 2
    double? group2Average,
    
    /// Difference
    double? difference,
    
    /// Percentage difference
    double? percentageDifference,
  }) = _CaffeineComparison;

  factory CaffeineComparison.fromJson(Map<String, dynamic> json) =>
      _$CaffeineComparisonFromJson(json);
}

/// Sleep comparison
@freezed
class SleepComparison with _$SleepComparison {
  const factory SleepComparison({
    /// Average sleep duration on group 1
    double? group1Duration,
    
    /// Average sleep duration on group 2
    double? group2Duration,
    
    /// Difference in minutes
    int? durationDifference,
    
    /// Average sleep quality on group 1
    double? group1Quality,
    
    /// Average sleep quality on group 2
    double? group2Quality,
    
    /// Quality difference
    double? qualityDifference,
  }) = _SleepComparison;

  factory SleepComparison.fromJson(Map<String, dynamic> json) =>
      _$SleepComparisonFromJson(json);
}

/// Stress comparison
@freezed
class StressComparison with _$StressComparison {
  const factory StressComparison({
    /// Average stress on group 1
    double? group1Average,
    
    /// Average stress on group 2
    double? group2Average,
    
    /// Difference
    double? difference,
    
    /// Percentage difference
    double? percentageDifference,
  }) = _StressComparison;

  factory StressComparison.fromJson(Map<String, dynamic> json) =>
      _$StressComparisonFromJson(json);
}

/// Alcohol comparison
@freezed
class AlcoholComparison with _$AlcoholComparison {
  const factory AlcoholComparison({
    /// Average alcohol on group 1
    double? group1Average,
    
    /// Average alcohol on group 2
    double? group2Average,
    
    /// Difference
    double? difference,
    
    /// Percentage difference
    double? percentageDifference,
  }) = _AlcoholComparison;

  factory AlcoholComparison.fromJson(Map<String, dynamic> json) =>
      _$AlcoholComparisonFromJson(json);
}

/// Data quality data
@freezed
class DataQualityData with _$DataQualityData {
  const factory DataQualityData({
    /// Overall data quality score (0-100)
    double? score,
    
    /// Missing data by type
    @Default({}) Map<String, int> missingData,
    
    /// Complete data days
    @Default(0) int completeDataDays,
    
    /// Partial data days
    @Default(0) int partialDataDays,
    
    /// Days with no data
    @Default(0) int noDataDays,
    
    /// Data completeness percentage
    double? completenessPercentage,
    
    /// Most missing data types
    @Default([]) List<String> mostMissingTypes,
    
    /// Recommendations for improving data quality
    @Default([]) List<String> recommendations,
  }) = _DataQualityData;

  factory DataQualityData.fromJson(Map<String, dynamic> json) =>
      _$DataQualityDataFromJson(json);
}

/// Report insight
@freezed
class ReportInsight with _$ReportInsight {
  const factory ReportInsight({
    /// Insight type
    required String type,
    
    /// Insight title
    required String title,
    
    /// Insight description
    required String description,
    
    /// Insight priority (0-10)
    @Default(5) int priority,
    
    /// Related data
    Map<String, dynamic>? data,
    
    /// Confidence level
    String? confidenceLevel,
  }) = _ReportInsight;

  factory ReportInsight.fromJson(Map<String, dynamic> json) =>
      _$ReportInsightFromJson(json);
}

// Helper methods for report models
extension ReportTypeExtensions on ReportType {
  /// Get report type display name
  String get displayName {
    switch (this) {
      case ReportType.daily:
        return 'Quotidien';
      case ReportType.weekly:
        return 'Hebdomadaire';
      case ReportType.monthly:
        return 'Mensuel';
      case ReportType.quarterly:
        return 'Trimestriel';
      case ReportType.yearly:
        return 'Annuel';
      case ReportType.custom:
        return 'Personnalisé';
    }
  }

  /// Get report type period in days
  int get periodInDays {
    switch (this) {
      case ReportType.daily:
        return 1;
      case ReportType.weekly:
        return 7;
      case ReportType.monthly:
        return 30;
      case ReportType.quarterly:
        return 90;
      case ReportType.yearly:
        return 365;
      case ReportType.custom:
        return 0; // Custom period
    }
  }
}

extension ReportFormatExtensions on ReportFormat {
  /// Get report format display name
  String get displayName {
    switch (this) {
      case ReportFormat.summary:
        return 'Résumé';
      case ReportFormat.detailed:
        return 'Détaillé';
      case ReportFormat.medical:
        return 'Médical';
    }
  }
}

// Helper methods for creating reports
extension ReportModelCreator on ReportModel {
  /// Create a new weekly report
  static ReportModel createWeekly({
    required String userId,
    required DateTime weekStart,
    required ReportData data,
    String? title,
    ReportFormat? format,
  }) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    
    return ReportModel(
      userId: userId,
      type: ReportType.weekly,
      format: format ?? ReportFormat.summary,
      title: title ?? 'Rapport hebdomadaire - ${_formatDate(weekStart)} au ${_formatDate(weekEnd)}',
      periodStart: weekStart,
      periodEnd: weekEnd,
      data: data,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Create a new monthly report
  static ReportModel createMonthly({
    required String userId,
    required DateTime monthStart,
    required ReportData data,
    String? title,
    ReportFormat? format,
  }) {
    final monthEnd = DateTime(monthStart.year, monthStart.month + 1, 0);
    
    return ReportModel(
      userId: userId,
      type: ReportType.monthly,
      format: format ?? ReportFormat.summary,
      title: title ?? 'Rapport mensuel - ${_formatMonth(monthStart)}',
      periodStart: monthStart,
      periodEnd: monthEnd,
      data: data,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Format date as dd/MM
  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }

  /// Format month as MMMM yyyy
  static String _formatMonth(DateTime date) {
    const months = [
      'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  /// Create a medical report for doctor
  static ReportModel createMedicalReport({
    required String userId,
    required DateTime periodStart,
    required DateTime periodEnd,
    required ReportData data,
    String? title,
  }) {
    return ReportModel(
      userId: userId,
      type: ReportType.custom,
      format: ReportFormat.medical,
      title: title ?? 'Rapport médical - ${_formatDate(periodStart)} au ${_formatDate(periodEnd)}',
      periodStart: periodStart,
      periodEnd: periodEnd,
      data: data,
      summary: _generateMedicalSummary(data),
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Generate medical summary
  static String _generateMedicalSummary(ReportData data) {
    final buffer = StringBuffer();
    
    buffer.writeln('Ce rapport est généré automatiquement à partir des données saisies par l\'utilisateur.');
    buffer.writeln('Il ne constitue pas un diagnostic médical.');
    buffer.writeln('');
    buffer.writeln('Période analysée: ${data.periodStart} au ${data.periodEnd}');
    buffer.writeln('');
    buffer.writeln('Fréquence des migraines: ${data.totalMigraines} épisodes');
    buffer.writeln('Intensité moyenne: ${data.averageIntensity?.toStringAsFixed(1) ?? 'N/A'}/10');
    buffer.writeln('Durée moyenne: ${(data.averageDurationMinutes ?? 0) / 60} heures');
    
    if (data.symptomFrequency.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('Symptômes les plus fréquents:');
      final sortedSymptoms = data.symptomFrequency.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final entry in sortedSymptoms.take(3)) {
        buffer.writeln('  - ${entry.key}: ${entry.value} fois');
      }
    }
    
    if (data.triggerFrequency.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('Facteurs déclencheurs les plus fréquents:');
      final sortedTriggers = data.triggerFrequency.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      for (final entry in sortedTriggers.take(3)) {
        buffer.writeln('  - ${entry.key}: ${entry.value} fois');
      }
    }
    
    return buffer.toString();
  }
}
