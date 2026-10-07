import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_model.freezed.dart';
part 'analysis_model.g.dart';

/// Analysis type enum
enum AnalysisType {
  correlation,      // Correlation between two factors
  temporal,        // Temporal pattern analysis
  comparative,     // Comparison between groups
  predictive,      // Predictive analysis
  clustering,      // Clustering similar episodes
}

/// Confidence level for insights
enum ConfidenceLevel {
  insufficientData,  // Less than 5 data points
  low,              // 5-10 data points
  medium,           // 10-20 data points
  high,             // 20-50 data points
  veryHigh,         // 50+ data points
}

/// Insight model representing a discovered pattern or correlation
@freezed
class InsightModel with _$InsightModel {
  const factory InsightModel({
    /// Unique insight ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Insight title
    required String title,
    
    /// Insight description
    required String description,
    
    /// Insight type
    @Default(AnalysisType.correlation) AnalysisType type,
    
    /// Confidence level
    @Default(ConfidenceLevel.insufficientData) ConfidenceLevel confidenceLevel,
    
    /// Confidence score (0-1)
    double? confidenceScore,
    
    /// Statistical significance (p-value)
    double? pValue,
    
    /// Correlation coefficient (for correlation insights)
    double? correlationCoefficient,
    
    /// Factors involved in this insight
    @Default([]) List<String> factors,
    
    /// Primary factor
    String? primaryFactor,
    
    /// Secondary factor (if applicable)
    String? secondaryFactor,
    
    /// Direction of correlation (positive, negative, none)
    String? correlationDirection,
    
    /// Strength of correlation (weak, moderate, strong)
    String? correlationStrength,
    
    /// Data points used for this insight
    @Default(0) int dataPoints,
    
    /// Time period analyzed
    DateTime? periodStart,
    DateTime? periodEnd,
    
    /// Whether this insight is still valid
    @Default(true) bool isValid,
    
    /// Whether this insight has been viewed by user
    @Default(false) bool isViewed,
    
    /// Whether this insight has been dismissed by user
    @Default(false) bool isDismissed,
    
    /// User's feedback on this insight
    InsightFeedback? feedback,
    
    /// Related migraine IDs
    @Default([]) List<String> relatedMigraineIds,
    
    /// Related daily log IDs
    @Default([]) List<String> relatedDailyLogIds,
    
    /// Insight category
    String? category,
    
    /// Insight priority (0-10)
    int? priority,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether the insight is synced
    @Default(false) bool isSynced,
  }) = _InsightModel;

  factory InsightModel.fromJson(Map<String, dynamic> json) =>
      _$InsightModelFromJson(json);
}

/// Insight feedback from user
@freezed
class InsightFeedback with _$InsightFeedback {
  const factory InsightFeedback({
    /// Whether user found the insight helpful
    bool? helpful,
    
    /// Whether user agrees with the insight
    bool? agree,
    
    /// User's confidence in this insight (0-5)
    int? userConfidence,
    
    /// User's notes
    String? notes,
    
    /// Whether user wants to track this factor more
    @Default(false) bool trackMore,
    
    /// Feedback timestamp
    DateTime? timestamp,
  }) = _InsightFeedback;

  factory InsightFeedback.fromJson(Map<String, dynamic> json) =>
      _$InsightFeedbackFromJson(json);
}

/// Correlation analysis result
@freezed
class CorrelationAnalysis with _$CorrelationAnalysis {
  const factory CorrelationAnalysis({
    /// Factor 1
    required String factor1,
    
    /// Factor 2
    required String factor2,
    
    /// Correlation coefficient (-1 to 1)
    required double correlation,
    
    /// P-value
    double? pValue,
    
    /// Number of data points
    required int dataPoints,
    
    /// Time period
    DateTime? periodStart,
    DateTime? periodEnd,
    
    /// Whether correlation is statistically significant
    bool? isSignificant,
    
    /// Significance level (e.g., 0.05, 0.01)
    double? significanceLevel,
    
    /// Direction (positive, negative, none)
    String? direction,
    
    /// Strength (weak, moderate, strong)
    String? strength,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Description
    String? description,
    
    /// Recommendation
    String? recommendation,
  }) = _CorrelationAnalysis;

  factory CorrelationAnalysis.fromJson(Map<String, dynamic> json) =>
      _$CorrelationAnalysisFromJson(json);
}

/// Temporal pattern analysis result
@freezed
class TemporalPattern with _$TemporalPattern {
  const factory TemporalPattern({
    /// Pattern type (daily, weekly, monthly, seasonal)
    required String type,
    
    /// Factor being analyzed
    required String factor,
    
    /// Pattern description
    required String description,
    
    /// Days of week pattern (for weekly patterns)
    Map<String, dynamic>? weeklyPattern,
    
    /// Hours of day pattern (for daily patterns)
    Map<String, dynamic>? dailyPattern,
    
    /// Monthly pattern
    Map<String, dynamic>? monthlyPattern,
    
    /// Seasonal pattern
    Map<String, dynamic>? seasonalPattern,
    
    /// Number of data points
    required int dataPoints,
    
    /// Time period
    DateTime? periodStart,
    DateTime? periodEnd,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Statistical measures
    Map<String, dynamic>? statistics,
  }) = _TemporalPattern;

  factory TemporalPattern.fromJson(Map<String, dynamic> json) =>
      _$TemporalPatternFromJson(json);
}

/// Comparative analysis result
@freezed
class ComparativeAnalysis with _$ComparativeAnalysis {
  const factory ComparativeAnalysis({
    /// Group 1 name
    required String group1,
    
    /// Group 2 name
    required String group2,
    
    /// Factor being compared
    required String factor,
    
    /// Group 1 average
    double? group1Average,
    
    /// Group 2 average
    double? group2Average,
    
    /// Difference (group1 - group2)
    double? difference,
    
    /// Percentage difference
    double? percentageDifference,
    
    /// P-value
    double? pValue,
    
    /// Number of data points in group 1
    required int group1Count,
    
    /// Number of data points in group 2
    required int group2Count,
    
    /// Time period
    DateTime? periodStart,
    DateTime? periodEnd,
    
    /// Whether difference is statistically significant
    bool? isSignificant,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Description
    String? description,
  }) = _ComparativeAnalysis;

  factory ComparativeAnalysis.fromJson(Map<String, dynamic> json) =>
      _$ComparativeAnalysisFromJson(json);
}

/// Predictive analysis result
@freezed
class PredictiveAnalysis with _$PredictiveAnalysis {
  const factory PredictiveAnalysis({
    /// Prediction type
    required String type,
    
    /// Predicted value
    dynamic predictedValue,
    
    /// Confidence interval lower bound
    dynamic? confidenceIntervalLower,
    
    /// Confidence interval upper bound
    dynamic? confidenceIntervalUpper,
    
    /// Prediction probability
    double? probability,
    
    /// Model used
    String? model,
    
    /// Features used
    @Default([]) List<String> features,
    
    /// Feature importance
    Map<String, double>? featureImportance,
    
    /// Number of data points used for training
    required int trainingDataPoints,
    
    /// Time period for training data
    DateTime? trainingPeriodStart,
    DateTime? trainingPeriodEnd,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Prediction timestamp
    required DateTime predictedAt,
    
    /// Valid until timestamp
    DateTime? validUntil,
  }) = _PredictiveAnalysis;

  factory PredictiveAnalysis.fromJson(Map<String, dynamic> json) =>
      _$PredictiveAnalysisFromJson(json);
}

/// Risk score model
@freezed
class RiskScoreModel with _$RiskScoreModel {
  const factory RiskScoreModel({
    /// Unique risk score ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Date for the risk score
    required DateTime date,
    
    /// Overall risk score (0-100)
    required double score,
    
    /// Risk level (low, medium, high, veryHigh)
    required String level,
    
    /// Individual factor scores
    @Default({}) Map<String, double> factorScores,
    
    /// Individual factor contributions
    @Default({}) Map<String, String> factorContributions,
    
    /// Main contributing factors
    @Default([]) List<String> mainFactors,
    
    /// Risk prediction for next 24 hours
    double? next24HoursRisk,
    
    /// Risk prediction for next 48 hours
    double? next48HoursRisk,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Whether the risk score is synced
    @Default(false) bool isSynced,
  }) = _RiskScoreModel;

  factory RiskScoreModel.fromJson(Map<String, dynamic> json) =>
      _$RiskScoreModelFromJson(json);
}

/// Factor analysis model
@freezed
class FactorAnalysis with _$FactorAnalysis {
  const factory FactorAnalysis({
    /// Factor name
    required String name,
    
    /// Factor display name
    String? displayName,
    
    /// Factor category
    String? category,
    
    /// Factor values across all data points
    @Default([]) List<double> values,
    
    /// Average value
    double? average,
    
    /// Median value
    double? median,
    
    /// Minimum value
    double? min,
    
    /// Maximum value
    double? max,
    
    /// Standard deviation
    double? stdDev,
    
    /// Number of data points
    required int count,
    
    /// Correlation with migraines
    double? correlationWithMigraines,
    
    /// Whether this factor is a potential trigger
    bool? isPotentialTrigger,
    
    /// Trigger confidence level
    ConfidenceLevel? triggerConfidence,
    
    /// Typical value for this user
    double? typicalValue,
    
    /// Current value (if available)
    double? currentValue,
    
    /// Trend (increasing, decreasing, stable)
    String? trend,
    
    /// Time period
    DateTime? periodStart,
    DateTime? periodEnd,
  }) = _FactorAnalysis;

  factory FactorAnalysis.fromJson(Map<String, dynamic> json) =>
      _FactorAnalysisFromJson(json);
}

/// Analysis summary model
@freezed
class AnalysisSummary with _$AnalysisSummary {
  const factory AnalysisSummary({
    /// User ID
    required String userId,
    
    /// Time period
    required DateTime periodStart,
    required DateTime periodEnd,
    
    /// Total number of insights
    @Default(0) int totalInsights,
    
    /// New insights since last summary
    @Default(0) int newInsights,
    
    /// High confidence insights
    @Default(0) int highConfidenceInsights,
    
    /// Top factors
    @Default([]) List<FactorAnalysis> topFactors,
    
    /// Top correlations
    @Default([]) List<CorrelationAnalysis> topCorrelations,
    
    /// Top temporal patterns
    @Default([]) List<TemporalPattern> topTemporalPatterns,
    
    /// Top comparative insights
    @Default([]) List<ComparativeAnalysis> topComparativeInsights,
    
    /// Current risk score
    RiskScoreModel? currentRiskScore,
    
    /// Data quality score (0-100)
    double? dataQualityScore,
    
    /// Missing data information
    Map<String, int>? missingData,
    
    /// Recommendations
    @Default([]) List<String> recommendations,
    
    /// Creation timestamp
    required DateTime createdAt,
  }) = _AnalysisSummary;

  factory AnalysisSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalysisSummaryFromJson(json);
}

/// Experiment model for personal experimentation
@freezed
class ExperimentModel with _$ExperimentModel {
  const factory ExperimentModel({
    /// Unique experiment ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Experiment title
    required String title,
    
    /// Experiment description
    String? description,
    
    /// Hypothesis being tested
    required String hypothesis,
    
    /// Independent variable (what's being changed)
    required String independentVariable,
    
    /// Dependent variable (what's being measured)
    required String dependentVariable,
    
    /// Experiment type
    String? type,
    
    /// Experiment status
    @Default(ExperimentStatus.planning) ExperimentStatus status,
    
    /// Start date
    DateTime? startDate,
    
    /// End date
    DateTime? endDate,
    
    /// Planned duration in days
    int? plannedDuration,
    
    /// Protocol description
    String? protocol,
    
    /// Baseline data (before experiment)
    Map<String, dynamic>? baselineData,
    
    /// Experiment data (during experiment)
    Map<String, dynamic>? experimentData,
    
    /// Results
    ExperimentResults? results,
    
    /// Notes
    String? notes,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether the experiment is synced
    @Default(false) bool isSynced,
  }) = _ExperimentModel;

  factory ExperimentModel.fromJson(Map<String, dynamic> json) =>
      _$ExperimentModelFromJson(json);
}

/// Experiment status enum
enum ExperimentStatus {
  planning,      // Experiment is being planned
  notStarted,    // Experiment hasn't started yet
  inProgress,    // Experiment is currently running
  paused,        // Experiment is paused
  completed,    // Experiment is completed
  abandoned,     // Experiment was abandoned
}

/// Experiment results
@freezed
class ExperimentResults with _$ExperimentResults {
  const factory ExperimentResults({
    /// Whether hypothesis was supported
    bool? hypothesisSupported,
    
    /// Statistical significance
    double? pValue,
    
    /// Effect size
    double? effectSize,
    
    /// Confidence interval lower
    double? confidenceIntervalLower,
    
    /// Confidence interval upper
    double? confidenceIntervalUpper,
    
    /// Baseline average
    double? baselineAverage,
    
    /// Experiment average
    double? experimentAverage,
    
    /// Change percentage
    double? changePercentage,
    
    /// Number of data points
    @Default(0) int dataPoints,
    
    /// Results summary
    String? summary,
    
    /// Confidence level
    ConfidenceLevel? confidenceLevel,
    
    /// Results timestamp
    DateTime? timestamp,
  }) = _ExperimentResults;

  factory ExperimentResults.fromJson(Map<String, dynamic> json) =>
      _$ExperimentResultsFromJson(json);
}

/// Statistical test result
@freezed
class StatisticalTestResult with _$StatisticalTestResult {
  const factory StatisticalTestResult({
    /// Test name
    required String testName,
    
    /// Test statistic
    double? statistic,
    
    /// P-value
    double? pValue,
    
    /// Degrees of freedom
    int? degreesOfFreedom,
    
    /// Sample size
    int? sampleSize,
    
    /// Whether result is significant
    bool? isSignificant,
    
    /// Significance level
    @Default(0.05) double significanceLevel,
    
    /// Test assumptions
    @Default([]) List<String> assumptions,
    
    /// Test limitations
    @Default([]) List<String> limitations,
    
    /// Interpretation
    String? interpretation,
  }) = _StatisticalTestResult;

  factory StatisticalTestResult.fromJson(Map<String, dynamic> json) =>
      _$StatisticalTestResultFromJson(json);
}

// Helper methods for analysis models
extension ConfidenceLevelExtensions on ConfidenceLevel {
  /// Get confidence level display name
  String get displayName {
    switch (this) {
      case ConfidenceLevel.insufficientData:
        return 'Données insuffisantes';
      case ConfidenceLevel.low:
        return 'Faible';
      case ConfidenceLevel.medium:
        return 'Moyenne';
      case ConfidenceLevel.high:
        return 'Élevée';
      case ConfidenceLevel.veryHigh:
        return 'Très élevée';
    }
  }

  /// Get confidence level color
  String get color {
    switch (this) {
      case ConfidenceLevel.insufficientData:
        return '#FF6B6B';
      case ConfidenceLevel.low:
        return '#FFC107';
      case ConfidenceLevel.medium:
        return '#FF9800';
      case ConfidenceLevel.high:
        return '#4CAF50';
      case ConfidenceLevel.veryHigh:
        return '#2E7D32';
    }
  }

  /// Get confidence score (0-1)
  double get score {
    switch (this) {
      case ConfidenceLevel.insufficientData:
        return 0.0;
      case ConfidenceLevel.low:
        return 0.25;
      case ConfidenceLevel.medium:
        return 0.5;
      case ConfidenceLevel.high:
        return 0.75;
      case ConfidenceLevel.veryHigh:
        return 1.0;
    }
  }
}

extension AnalysisTypeExtensions on AnalysisType {
  /// Get analysis type display name
  String get displayName {
    switch (this) {
      case AnalysisType.correlation:
        return 'Corrélation';
      case AnalysisType.temporal:
        return 'Temporel';
      case AnalysisType.comparative:
        return 'Comparatif';
      case AnalysisType.predictive:
        return 'Prédictif';
      case AnalysisType.clustering:
        return 'Regroupement';
    }
  }
}

extension ExperimentStatusExtensions on ExperimentStatus {
  /// Get experiment status display name
  String get displayName {
    switch (this) {
      case ExperimentStatus.planning:
        return 'En planification';
      case ExperimentStatus.notStarted:
        return 'Non commencé';
      case ExperimentStatus.inProgress:
        return 'En cours';
      case ExperimentStatus.paused:
        return 'En pause';
      case ExperimentStatus.completed:
        return 'Terminé';
      case ExperimentStatus.abandoned:
        return 'Abandonné';
    }
  }
}

// Helper methods for creating insights
extension InsightModelCreator on InsightModel {
  /// Create a new correlation insight
  static InsightModel createCorrelation({
    required String userId,
    required String factor1,
    required String factor2,
    required double correlation,
    required int dataPoints,
    double? pValue,
    String? description,
    ConfidenceLevel? confidenceLevel,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    final direction = correlation > 0.3 ? 'positive' : 
                      correlation < -0.3 ? 'negative' : 'none';
    final strength = correlation.abs() > 0.7 ? 'strong' :
                     correlation.abs() > 0.4 ? 'moderate' : 'weak';
    
    final title = 'Corrélation entre $factor1 et $factor2';
    final desc = description ?? 
      'Une corrélation ${direction == 'positive' ? 'positive' : 'négative'} '
      '${strength == 'strong' ? 'forte' : strength == 'moderate' ? 'modérée' : 'faible'} '
      'a été observée entre $factor1 et $factor2.';
    
    return InsightModel(
      userId: userId,
      title: title,
      description: desc,
      type: AnalysisType.correlation,
      confidenceLevel: confidenceLevel ?? 
        _getConfidenceLevel(dataPoints),
      correlationCoefficient: correlation,
      pValue: pValue,
      dataPoints: dataPoints,
      factors: [factor1, factor2],
      primaryFactor: factor1,
      secondaryFactor: factor2,
      correlationDirection: direction,
      correlationStrength: strength,
      periodStart: periodStart,
      periodEnd: periodEnd,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Create a new temporal pattern insight
  static InsightModel createTemporalPattern({
    required String userId,
    required String factor,
    required String patternType,
    required String description,
    required int dataPoints,
    Map<String, dynamic>? patternData,
    ConfidenceLevel? confidenceLevel,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    return InsightModel(
      userId: userId,
      title: 'Motif temporel: $factor',
      description: description,
      type: AnalysisType.temporal,
      confidenceLevel: confidenceLevel ?? _getConfidenceLevel(dataPoints),
      dataPoints: dataPoints,
      factors: [factor],
      primaryFactor: factor,
      periodStart: periodStart,
      periodEnd: periodEnd,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Create a new comparative insight
  static InsightModel createComparative({
    required String userId,
    required String group1,
    required String group2,
    required String factor,
    required double difference,
    required int dataPoints,
    double? pValue,
    String? description,
    ConfidenceLevel? confidenceLevel,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    final direction = difference > 0 ? 'plus élevé' : 'plus bas';
    final absDifference = difference.abs();
    
    final title = 'Différence entre $group1 et $group2';
    final desc = description ?? 
      'Le facteur $factor est $direction dans le groupe $group1 '
      'par rapport au groupe $group2 (différence: $absDifference).';
    
    return InsightModel(
      userId: userId,
      title: title,
      description: desc,
      type: AnalysisType.comparative,
      confidenceLevel: confidenceLevel ?? _getConfidenceLevel(dataPoints),
      dataPoints: dataPoints,
      factors: [factor, group1, group2],
      primaryFactor: factor,
      periodStart: periodStart,
      periodEnd: periodEnd,
      createdAt: DateTime.now(),
      isSynced: false,
    );
  }

  /// Get confidence level based on data points
  static ConfidenceLevel _getConfidenceLevel(int dataPoints) {
    if (dataPoints < 5) {
      return ConfidenceLevel.insufficientData;
    } else if (dataPoints < 10) {
      return ConfidenceLevel.low;
    } else if (dataPoints < 20) {
      return ConfidenceLevel.medium;
    } else if (dataPoints < 50) {
      return ConfidenceLevel.high;
    } else {
      return ConfidenceLevel.veryHigh;
    }
  }
}
