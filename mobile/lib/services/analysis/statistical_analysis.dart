import 'dart:math';

/// Statistical analysis utility class
class StatisticalAnalysis {
  /// Calculate mean (average)
  static double calculateMean(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  /// Calculate median
  static double calculateMedian(List<double> values) {
    if (values.isEmpty) return 0;
    
    final sorted = [...values]..sort();
    final length = sorted.length;
    
    if (length % 2 == 0) {
      // Even number of elements
      return (sorted[length ~/ 2 - 1] + sorted[length ~/ 2]) / 2;
    } else {
      // Odd number of elements
      return sorted[length ~/ 2];
    }
  }

  /// Calculate mode
  static double calculateMode(List<double> values) {
    if (values.isEmpty) return 0;
    
    final frequencyMap = <double, int>{};
    for (final value in values) {
      frequencyMap[value] = (frequencyMap[value] ?? 0) + 1;
    }
    
    double mode = values.first;
    int maxFrequency = 1;
    
    for (final entry in frequencyMap.entries) {
      if (entry.value > maxFrequency) {
        maxFrequency = entry.value;
        mode = entry.key;
      }
    }
    
    return mode;
  }

  /// Calculate range
  static double calculateRange(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce(max) - values.reduce(min);
  }

  /// Calculate variance
  static double calculateVariance(List<double> values, {bool sample = false}) {
    if (values.isEmpty) return 0;
    
    final mean = calculateMean(values);
    final squaredDifferences = values.map((v) => pow(v - mean, 2)).toList();
    final sumOfSquaredDifferences = squaredDifferences.reduce((a, b) => a + b);
    
    if (sample) {
      return sumOfSquaredDifferences / (values.length - 1);
    } else {
      return sumOfSquaredDifferences / values.length;
    }
  }

  /// Calculate standard deviation
  static double calculateStdDev(List<double> values, {bool sample = false}) {
    return sqrt(calculateVariance(values, sample: sample));
  }

  /// Calculate coefficient of variation
  static double calculateCoefficientOfVariation(List<double> values) {
    final mean = calculateMean(values);
    final stdDev = calculateStdDev(values);
    
    if (mean == 0) return 0;
    return stdDev / mean;
  }

  /// Calculate Pearson correlation coefficient
  static double calculateCorrelation(List<double> x, List<double> y) {
    if (x.isEmpty || y.isEmpty || x.length != y.length) return 0;
    
    final n = x.length;
    final meanX = calculateMean(x);
    final meanY = calculateMean(y);
    
    double numerator = 0;
    double sumXSquared = 0;
    double sumYSquared = 0;
    
    for (int i = 0; i < n; i++) {
      final xDiff = x[i] - meanX;
      final yDiff = y[i] - meanY;
      numerator += xDiff * yDiff;
      sumXSquared += pow(xDiff, 2);
      sumYSquared += pow(yDiff, 2);
    }
    
    final denominator = sqrt(sumXSquared * sumYSquared);
    
    if (denominator == 0) return 0;
    
    return numerator / denominator;
  }

  /// Calculate Spearman rank correlation coefficient
  static double calculateSpearmanCorrelation(List<double> x, List<double> y) {
    if (x.isEmpty || y.isEmpty || x.length != y.length) return 0;
    
    // Rank the values
    final rankedX = _rankValues(x);
    final rankedY = _rankValues(y);
    
    // Calculate Pearson correlation on ranks
    return calculateCorrelation(rankedX, rankedY);
  }

  /// Rank values (handling ties)
  static List<double> _rankValues(List<double> values) {
    // Create a list of (value, original index)
    final indexedValues = values.asMap().entries.map((e) => (e.value, e.key)).toList();
    
    // Sort by value
    indexedValues.sort((a, b) => a.$1.compareTo(b.$1));
    
    // Assign ranks
    final ranks = List<double>.filled(values.length, 0);
    
    int i = 0;
    while (i < indexedValues.length) {
      // Find all values with the same value
      int j = i;
      while (j < indexedValues.length && indexedValues[j].$1 == indexedValues[i].$1) {
        j++;
      }
      
      // Calculate average rank for this group
      final rank = (i + j + 1) / 2.0;
      
      // Assign rank to all in this group
      for (int k = i; k < j; k++) {
        ranks[indexedValues[k].$2] = rank;
      }
      
      i = j;
    }
    
    return ranks;
  }

  /// Calculate simple linear regression
  static LinearRegressionResult calculateLinearRegression(
    List<double> x,
    List<double> y,
  ) {
    if (x.isEmpty || y.isEmpty || x.length != y.length) {
      return LinearRegressionResult(
        slope: 0,
        intercept: 0,
        rSquared: 0,
      );
    }
    
    final n = x.length;
    final meanX = calculateMean(x);
    final meanY = calculateMean(y);
    
    double numerator = 0;
    double denominator = 0;
    
    for (int i = 0; i < n; i++) {
      numerator += (x[i] - meanX) * (y[i] - meanY);
      denominator += pow(x[i] - meanX, 2);
    }
    
    final slope = denominator != 0 ? numerator / denominator : 0;
    final intercept = meanY - slope * meanX;
    
    // Calculate R-squared
    final ssTotal = y.map((yi) => pow(yi - meanY, 2)).reduce((a, b) => a + b);
    final ssResidual = y.asMap().entries.map((e) => 
      pow(e.value - (slope * x[e.key] + intercept), 2)
    ).reduce((a, b) => a + b);
    
    final rSquared = ssTotal != 0 ? 1 - (ssResidual / ssTotal) : 0;
    
    return LinearRegressionResult(
      slope: slope,
      intercept: intercept,
      rSquared: rSquared,
    );
  }

  /// Calculate chi-square test for independence
  static ChiSquareResult calculateChiSquare(
    List<List<int>> observed,
  ) {
    if (observed.isEmpty || observed.first.isEmpty) {
      return ChiSquareResult(
        chiSquare: 0,
        pValue: 1,
        degreesOfFreedom: 0,
        expected: [],
      );
    }
    
    final rows = observed.length;
    final cols = observed.first.length;
    
    // Calculate row and column totals
    final rowTotals = List<int>.filled(rows, 0);
    final colTotals = List<int>.filled(cols, 0);
    int grandTotal = 0;
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        rowTotals[i] += observed[i][j];
        colTotals[j] += observed[i][j];
        grandTotal += observed[i][j];
      }
    }
    
    // Calculate expected values
    final expected = List<List<double>>.generate(
      rows,
      (i) => List<double>.generate(
        cols,
        (j) => (rowTotals[i] * colTotals[j]) / grandTotal.toDouble(),
      ),
    );
    
    // Calculate chi-square statistic
    double chiSquare = 0;
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        chiSquare += pow(observed[i][j] - expected[i][j], 2) / expected[i][j];
      }
    }
    
    // Degrees of freedom
    final degreesOfFreedom = (rows - 1) * (cols - 1);
    
    // Calculate p-value (approximation)
    final pValue = _chiSquarePValue(chiSquare, degreesOfFreedom);
    
    return ChiSquareResult(
      chiSquare: chiSquare,
      pValue: pValue,
      degreesOfFreedom: degreesOfFreedom,
      expected: expected,
    );
  }

  /// Calculate chi-square p-value (approximation)
  static double _chiSquarePValue(double chiSquare, int df) {
    // This is a simplified approximation
    // In a real app, use a proper chi-square distribution library
    
    if (df <= 0) return 1.0;
    
    // Use gamma distribution approximation
    // chi-square with df degrees of freedom is gamma(df/2, 2)
    return _gammaDistributionCDF(chiSquare, df / 2, 2);
  }

  /// Gamma distribution CDF approximation
  static double _gammaDistributionCDF(double x, double shape, double scale) {
    // Simplified approximation - in real app use proper statistical library
    if (x <= 0) return 0;
    
    // For large shape values, use normal approximation
    if (shape > 100) {
      final mean = shape * scale;
      final stdDev = sqrt(shape) * scale;
      return _normalCDF((x - mean) / stdDev);
    }
    
    // Simple approximation for small shape values
    // This is not accurate but works for demonstration
    return 1 - exp(-x / scale);
  }

  /// Normal distribution CDF approximation
  static double _normalCDF(double x) {
    return 0.5 * (1 + erf(x / sqrt(2)));
  }

  /// Error function approximation
  static double erf(double x) {
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

  /// Calculate t-test for independent samples
  static TTestResult calculateTTest(
    List<double> sample1,
    List<double> sample2,
  ) {
    if (sample1.isEmpty || sample2.isEmpty) {
      return TTestResult(
        tStatistic: 0,
        pValue: 1,
        degreesOfFreedom: 0,
        mean1: 0,
        mean2: 0,
        confidenceInterval: [0, 0],
      );
    }
    
    final n1 = sample1.length;
    final n2 = sample2.length;
    
    final mean1 = calculateMean(sample1);
    final mean2 = calculateMean(sample2);
    
    final variance1 = calculateVariance(sample1, sample: true);
    final variance2 = calculateVariance(sample2, sample: true);
    
    // Calculate pooled standard deviation
    final pooledVariance = ((n1 - 1) * variance1 + (n2 - 1) * variance2) / (n1 + n2 - 2);
    final pooledStdDev = sqrt(pooledVariance);
    
    // Calculate standard error
    final standardError = pooledStdDev * sqrt(1/n1 + 1/n2);
    
    // Calculate t-statistic
    final tStatistic = (mean1 - mean2) / standardError;
    
    // Degrees of freedom
    final degreesOfFreedom = n1 + n2 - 2;
    
    // Calculate p-value (two-tailed)
    final pValue = _tDistributionPValue(tStatistic.abs(), degreesOfFreedom);
    
    // Calculate confidence interval (95%)
    final marginOfError = _tDistributionQuantile(0.975, degreesOfFreedom) * standardError;
    final confidenceInterval = [
      mean1 - mean2 - marginOfError,
      mean1 - mean2 + marginOfError,
    ];
    
    return TTestResult(
      tStatistic: tStatistic,
      pValue: pValue,
      degreesOfFreedom: degreesOfFreedom,
      mean1: mean1,
      mean2: mean2,
      confidenceInterval: confidenceInterval,
    );
  }

  /// Calculate t-distribution p-value (two-tailed)
  static double _tDistributionPValue(double t, int df) {
    // This is a simplified approximation
    // In a real app, use a proper t-distribution library
    
    if (df <= 0) return 1.0;
    
    // For large df, t-distribution approaches normal distribution
    if (df > 100) {
      return 2 * (1 - _normalCDF(t));
    }
    
    // Simple approximation for t-distribution
    return 2 * (1 - _tDistributionCDF(t, df));
  }

  /// t-distribution CDF approximation
  static double _tDistributionCDF(double t, int df) {
    // Simplified approximation - in real app use proper statistical library
    if (df <= 0) return 0.5;
    
    // For large df, use normal distribution
    if (df > 100) {
      return _normalCDF(t);
    }
    
    // Simple approximation
    return 1 / (1 + exp(-t * sqrt(1 + df / 2)));
  }

  /// t-distribution quantile function (inverse CDF)
  static double _tDistributionQuantile(double p, int df) {
    // Simplified approximation - in real app use proper statistical library
    if (p <= 0 || p >= 1) return 0;
    
    // For 95% confidence interval, p = 0.975
    if (p == 0.975) {
      // Use known values for common degrees of freedom
      if (df >= 120) return 1.98;
      if (df == 60) return 2.00;
      if (df == 30) return 2.042;
      if (df == 20) return 2.086;
      if (df == 10) return 2.228;
      if (df == 5) return 2.571;
      if (df == 1) return 12.706;
    }
    
    // Simple approximation
    return _normalQuantile(p) * (1 + (1 / (4 * df)));
  }

  /// Normal distribution quantile function (inverse CDF)
  static double _normalQuantile(double p) {
    // Simplified approximation - in real app use proper statistical library
    if (p <= 0 || p >= 1) return 0;
    
    // For 95% confidence interval, p = 0.975
    if (p == 0.975) return 1.96;
    if (p == 0.95) return 1.645;
    if (p == 0.99) return 2.326;
    
    // Simple approximation
    return sqrt(-2 * ln(1 - p));
  }

  /// Calculate ANOVA (Analysis of Variance)
  static ANOVAResult calculateANOVA(List<List<double>> groups) {
    if (groups.isEmpty || groups.any((g) => g.isEmpty)) {
      return ANOVAResult(
        fStatistic: 0,
        pValue: 1,
        degreesOfFreedomBetween: 0,
        degreesOfFreedomWithin: 0,
        groupMeans: [],
        grandMean: 0,
      );
    }
    
    final k = groups.length; // Number of groups
    final n = groups.map((g) => g.length).reduce((a, b) => a + b); // Total observations
    
    // Calculate group means
    final groupMeans = groups.map((g) => calculateMean(g)).toList();
    
    // Calculate grand mean
    final allValues = groups.expand((g) => g).toList();
    final grandMean = calculateMean(allValues);
    
    // Calculate Sum of Squares Between (SSB)
    double ssb = 0;
    for (int i = 0; i < k; i++) {
      ssb += groups[i].length * pow(groupMeans[i] - grandMean, 2);
    }
    
    // Calculate Sum of Squares Within (SSW)
    double ssw = 0;
    for (int i = 0; i < k; i++) {
      for (final value in groups[i]) {
        ssw += pow(value - groupMeans[i], 2);
      }
    }
    
    // Degrees of freedom
    final dfBetween = k - 1;
    final dfWithin = n - k;
    
    // Mean squares
    final msb = ssb / dfBetween;
    final msw = ssw / dfWithin;
    
    // F-statistic
    final fStatistic = msw != 0 ? msb / msw : 0;
    
    // Calculate p-value
    final pValue = _fDistributionPValue(fStatistic, dfBetween, dfWithin);
    
    return ANOVAResult(
      fStatistic: fStatistic,
      pValue: pValue,
      degreesOfFreedomBetween: dfBetween,
      degreesOfFreedomWithin: dfWithin,
      groupMeans: groupMeans,
      grandMean: grandMean,
    );
  }

  /// Calculate F-distribution p-value (approximation)
  static double _fDistributionPValue(double f, int df1, int df2) {
    // Simplified approximation - in real app use proper statistical library
    if (df1 <= 0 || df2 <= 0) return 1.0;
    
    // For large df2, F-distribution approaches chi-square / df1
    if (df2 > 1000) {
      return _chiSquarePValue(f * df1, df1);
    }
    
    // Simple approximation
    return exp(-f * df1 / (df1 + df2));
  }

  /// Calculate moving average
  static List<double> calculateMovingAverage(
    List<double> values,
    int windowSize,
  ) {
    if (values.isEmpty || windowSize <= 0 || windowSize > values.length) {
      return [];
    }
    
    final result = <double>[];
    
    for (int i = 0; i <= values.length - windowSize; i++) {
      final window = values.sublist(i, i + windowSize);
      result.add(calculateMean(window));
    }
    
    return result;
  }

  /// Calculate exponential moving average
  static List<double> calculateExponentialMovingAverage(
    List<double> values,
    double alpha,
  ) {
    if (values.isEmpty || alpha <= 0 || alpha >= 1) {
      return [];
    }
    
    final result = <double>[];
    double? ema;
    
    for (int i = 0; i < values.length; i++) {
      if (i == 0) {
        ema = values[i];
      } else {
        ema = alpha * values[i] + (1 - alpha) * ema!;
      }
      result.add(ema);
    }
    
    return result;
  }

  /// Calculate percentile
  static double calculatePercentile(List<double> values, double percentile) {
    if (values.isEmpty) return 0;
    
    final sorted = [...values]..sort();
    final index = percentile / 100 * (sorted.length - 1);
    
    final lower = index.floor();
    final upper = index.ceil();
    final fraction = index - lower;
    
    if (lower == upper) {
      return sorted[lower];
    }
    
    return sorted[lower] + fraction * (sorted[upper] - sorted[lower]);
  }

  /// Calculate quartiles
  static List<double> calculateQuartiles(List<double> values) {
    if (values.isEmpty) return [0, 0, 0];
    
    final sorted = [...values]..sort();
    
    return [
      calculatePercentile(sorted, 25),
      calculatePercentile(sorted, 50),
      calculatePercentile(sorted, 75),
    ];
  }

  /// Calculate interquartile range (IQR)
  static double calculateIQR(List<double> values) {
    if (values.isEmpty) return 0;
    
    final quartiles = calculateQuartiles(values);
    return quartiles[2] - quartiles[0];
  }

  /// Calculate outliers using IQR method
  static List<double> findOutliers(List<double> values) {
    if (values.isEmpty) return [];
    
    final sorted = [...values]..sort();
    final quartiles = calculateQuartiles(sorted);
    final q1 = quartiles[0];
    final q3 = quartiles[2];
    final iqr = q3 - q1;
    
    final lowerBound = q1 - 1.5 * iqr;
    final upperBound = q3 + 1.5 * iqr;
    
    return values.where((v) => v < lowerBound || v > upperBound).toList();
  }

  /// Calculate z-scores
  static List<double> calculateZScores(List<double> values) {
    if (values.isEmpty) return [];
    
    final mean = calculateMean(values);
    final stdDev = calculateStdDev(values);
    
    if (stdDev == 0) return List<double>.filled(values.length, 0);
    
    return values.map((v) => (v - mean) / stdDev).toList();
  }

  /// Calculate skewness
  static double calculateSkewness(List<double> values) {
    if (values.isEmpty) return 0;
    
    final mean = calculateMean(values);
    final stdDev = calculateStdDev(values);
    
    if (stdDev == 0) return 0;
    
    final n = values.length;
    double sum = 0;
    
    for (final value in values) {
      sum += pow((value - mean) / stdDev, 3);
    }
    
    return (n / ((n - 1) * (n - 2))) * sum;
  }

  /// Calculate kurtosis
  static double calculateKurtosis(List<double> values) {
    if (values.isEmpty) return 0;
    
    final mean = calculateMean(values);
    final stdDev = calculateStdDev(values);
    
    if (stdDev == 0) return 0;
    
    final n = values.length;
    double sum = 0;
    
    for (final value in values) {
      sum += pow((value - mean) / stdDev, 4);
    }
    
    return (n * (n + 1) / ((n - 1) * (n - 2) * (n - 3))) * sum - 
           3 * pow(n - 1, 2) / ((n - 2) * (n - 3));
  }
}

/// Linear regression result
class LinearRegressionResult {
  final double slope;
  final double intercept;
  final double rSquared;

  LinearRegressionResult({
    required this.slope,
    required this.intercept,
    required this.rSquared,
  });
}

/// Chi-square test result
class ChiSquareResult {
  final double chiSquare;
  final double pValue;
  final int degreesOfFreedom;
  final List<List<double>> expected;

  ChiSquareResult({
    required this.chiSquare,
    required this.pValue,
    required this.degreesOfFreedom,
    required this.expected,
  });
}

/// T-test result
class TTestResult {
  final double tStatistic;
  final double pValue;
  final int degreesOfFreedom;
  final double mean1;
  final double mean2;
  final List<double> confidenceInterval;

  TTestResult({
    required this.tStatistic,
    required this.pValue,
    required this.degreesOfFreedom,
    required this.mean1,
    required this.mean2,
    required this.confidenceInterval,
  });
}

/// ANOVA result
class ANOVAResult {
  final double fStatistic;
  final double pValue;
  final int degreesOfFreedomBetween;
  final int degreesOfFreedomWithin;
  final List<double> groupMeans;
  final double grandMean;

  ANOVAResult({
    required this.fStatistic,
    required this.pValue,
    required this.degreesOfFreedomBetween,
    required this.degreesOfFreedomWithin,
    required this.groupMeans,
    required this.grandMean,
  });
}

/// Extension methods for List<double>
extension ListDoubleExtensions on List<double> {
  /// Get average
  double get average => StatisticalAnalysis.calculateMean(this);
  
  /// Get median
  double get median => StatisticalAnalysis.calculateMedian(this);
  
  /// Get mode
  double get mode => StatisticalAnalysis.calculateMode(this);
  
  /// Get range
  double get range => StatisticalAnalysis.calculateRange(this);
  
  /// Get variance
  double get variance => StatisticalAnalysis.calculateVariance(this);
  
  /// Get standard deviation
  double get stdDev => StatisticalAnalysis.calculateStdDev(this);
  
  /// Get coefficient of variation
  double get coefficientOfVariation => 
      StatisticalAnalysis.calculateCoefficientOfVariation(this);
  
  /// Get minimum value
  double get min => reduce(min);
  
  /// Get maximum value
  double get max => reduce(max);
  
  /// Get sum
  double get sum => reduce((a, b) => a + b);
  
  /// Get quartiles
  List<double> get quartiles => StatisticalAnalysis.calculateQuartiles(this);
  
  /// Get IQR
  double get iqr => StatisticalAnalysis.calculateIQR(this);
  
  /// Get outliers
  List<double> get outliers => StatisticalAnalysis.findOutliers(this);
  
  /// Get z-scores
  List<double> get zScores => StatisticalAnalysis.calculateZScores(this);
  
  /// Get skewness
  double get skewness => StatisticalAnalysis.calculateSkewness(this);
  
  /// Get kurtosis
  double get kurtosis => StatisticalAnalysis.calculateKurtosis(this);
}
