import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

/// Weather condition enum
/// Based on OpenWeatherMap condition codes

/// Moon phase enum
enum MoonPhase {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

/// Weather condition type
enum WeatherConditionType {
  clear,
  clouds,
  rain,
  drizzle,
  thunderstorm,
  snow,
  mist,
  smoke,
  haze,
  dust,
  fog,
  sand,
  ash,
  squall,
  tornado,
  unknown,
}

/// Weather data model
@freezed
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    /// Unique weather ID (composite key: location + date + time)
    String? id,
    
    /// Location ID (city or coordinates)
    String? locationId,
    
    /// Location name
    String? locationName,
    
    /// Latitude
    double? latitude,
    
    /// Longitude
    double? longitude,
    
    /// Date and time of the weather data
    required DateTime dateTime,
    
    /// Date only (for daily summaries)
    DateTime? date,
    
    /// Temperature in Celsius
    double? temperatureC,
    
    /// Feels like temperature in Celsius
    double? feelsLikeC,
    
    /// Minimum temperature in Celsius (for daily summaries)
    double? minTemperatureC,
    
    /// Maximum temperature in Celsius (for daily summaries)
    double? maxTemperatureC,
    
    /// Temperature in Kelvin (from API)
    double? temperatureK,
    
    /// Feels like temperature in Kelvin
    double? feelsLikeK,
    
    /// Pressure in hPa
    int? pressure,
    
    /// Pressure at sea level in hPa
    int? pressureSeaLevel,
    
    /// Pressure at ground level in hPa
    int? pressureGroundLevel,
    
    /// Pressure change from previous reading (3h, 6h, 12h, 24h)
    @Default({}) Map<String, int> pressureChanges,
    
    /// Humidity percentage
    int? humidity,
    
    /// Wind speed in m/s
    double? windSpeedMs,
    
    /// Wind speed in km/h
    double? windSpeedKph,
    
    /// Wind direction in degrees (0-360)
    int? windDirectionDegrees,
    
    /// Wind direction as compass direction
    String? windDirectionCompass,
    
    /// Wind gust speed in m/s
    double? windGustMs,
    
    /// Wind gust speed in km/h
    double? windGustKph,
    
    /// Precipitation volume in mm (last 1h)
    double? precipitation1hMm,
    
    /// Precipitation volume in mm (last 3h)
    double? precipitation3hMm,
    
    /// Total precipitation in mm (for daily summaries)
    double? totalPrecipitationMm,
    
    /// Snow volume in mm (last 1h)
    double? snow1hMm,
    
    /// Snow volume in mm (last 3h)
    double? snow3hMm,
    
    /// Total snow in mm (for daily summaries)
    double? totalSnowMm,
    
    /// Cloud cover percentage
    int? cloudCover,
    
    /// Visibility in meters
    int? visibility,
    
    /// UV index
    double? uvIndex,
    
    /// Weather condition ID (from OpenWeatherMap)
    int? conditionId,
    
    /// Weather condition main group
    String? conditionMain,
    
    /// Weather condition description
    String? conditionDescription,
    
    /// Weather condition type (normalized)
    WeatherConditionType? conditionType,
    
    /// Weather icon code
    String? iconCode,
    
    /// Sunrise time
    DateTime? sunrise,
    
    /// Sunset time
    DateTime? sunset,
    
    /// Moonrise time
    DateTime? moonrise,
    
    /// Moonset time
    DateTime? moonset,
    
    /// Moon phase
    MoonPhase? moonPhase,
    
    /// Moon illumination percentage
    int? moonIllumination,
    
    /// Dew point temperature in Celsius
    double? dewPointC,
    
    /// Air quality index (if available)
    int? airQualityIndex,
    
    /// Air quality components (CO, NO2, O3, SO2, PM2.5, PM10)
    @Default({}) Map<String, double> airQuality,
    
    /// Solar radiation in W/m²
    double? solarRadiation,
    
    /// Data source (e.g., "openweathermap", "weatherapi")
    String? source,
    
    /// Data retrieval timestamp
    DateTime? retrievedAt,
    
    /// Whether data is from cache
    @Default(false) bool isCached,
    
    /// Cache timestamp
    DateTime? cachedAt,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  factory WeatherModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WeatherModel.fromJson({...data, 'id': doc.id});
  }
}

/// Daily weather summary
@freezed
class DailyWeatherSummary with _$DailyWeatherSummary {
  const factory DailyWeatherSummary({
    /// Date
    required DateTime date,
    
    /// Location
    String? location,
    
    /// Average temperature in Celsius
    double? averageTemperature,
    
    /// Minimum temperature in Celsius
    double? minTemperature,
    
    /// Maximum temperature in Celsius
    double? maxTemperature,
    
    /// Temperature range
    double? temperatureRange,
    
    /// Average feels like temperature in Celsius
    double? averageFeelsLike,
    
    /// Average humidity
    double? averageHumidity,
    
    /// Minimum humidity
    int? minHumidity,
    
    /// Maximum humidity
    int? maxHumidity,
    
    /// Average pressure
    double? averagePressure,
    
    /// Minimum pressure
    int? minPressure,
    
    /// Maximum pressure
    int? maxPressure,
    
    /// Pressure change from previous day
    int? pressureChange,
    
    /// Pressure change percentage
    double? pressureChangePercentage,
    
    /// Total precipitation in mm
    double? totalPrecipitation,
    
    /// Total snow in mm
    double? totalSnow,
    
    /// Average cloud cover
    double? averageCloudCover,
    
    /// Average wind speed in km/h
    double? averageWindSpeed,
    
    /// Maximum wind speed in km/h
    double? maxWindSpeed,
    
    /// Dominant wind direction
    String? dominantWindDirection,
    
    /// Average UV index
    double? averageUvIndex,
    
    /// Maximum UV index
    int? maxUvIndex,
    
    /// Dominant weather condition
    String? dominantCondition,
    
    /// Weather conditions throughout the day
    @Default({}) Map<String, int> conditions,
    
    /// Sunrise time
    DateTime? sunrise,
    
    /// Sunset time
    DateTime? sunset,
    
    /// Day length in minutes
    int? dayLengthMinutes,
    
    /// Moon phase
    MoonPhase? moonPhase,
    
    /// Average moon illumination
    double? averageMoonIllumination,
    
    /// Whether there was a significant weather change
    @Default(false) bool hadSignificantChange,
    
    /// Significant weather events
    @Default([]) List<String> significantEvents,
  }) = _DailyWeatherSummary;

  factory DailyWeatherSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyWeatherSummaryFromJson(json);
}

/// Weather forecast model
@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    /// Location
    required String location,
    
    /// Forecast timestamp
    required DateTime timestamp,
    
    /// Forecast interval in hours
    @Default(3) int intervalHours,
    
    /// Forecast data points
    @Default([]) List<WeatherModel> dataPoints,
    
    /// Daily summaries
    @Default([]) List<DailyWeatherSummary> dailySummaries,
    
    /// Data source
    String? source,
    
    /// Retrieved timestamp
    DateTime? retrievedAt,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}

/// Weather alert model
@freezed
class WeatherAlert with _$WeatherAlert {
  const factory WeatherAlert({
    /// Alert ID
    String? id,
    
    /// Alert type
    required String type,
    
    /// Alert title
    required String title,
    
    /// Alert description
    required String description,
    
    /// Alert severity (low, medium, high, extreme)
    String? severity,
    
    /// Alert start time
    DateTime? startTime,
    
    /// Alert end time
    DateTime? endTime,
    
    /// Affected locations
    @Default([]) List<String> affectedLocations,
    
    /// Alert source
    String? source,
    
    /// Alert timestamp
    DateTime? timestamp,
  }) = _WeatherAlert;

  factory WeatherAlert.fromJson(Map<String, dynamic> json) =>
      _$WeatherAlertFromJson(json);
}

/// Pressure analysis for migraine correlation
@freezed
class PressureAnalysis with _$PressureAnalysis {
  const factory PressureAnalysis({
    /// User ID
    required String userId,
    
    /// Date of analysis
    required DateTime date,
    
    /// Current pressure
    int? currentPressure,
    
    /// Pressure changes over different periods
    @Default({}) Map<String, int> pressureChanges,
    
    /// Pressure change percentages
    @Default({}) Map<String, double> pressureChangePercentages,
    
    /// Pressure trend (rising, falling, stable)
    String? trend,
    
    /// Pressure stability index (0-100, where 100 is very stable)
    double? stabilityIndex,
    
    /// Whether pressure change is significant for migraine
    bool? isSignificantForMigraine,
    
    /// Correlation with migraines
    double? correlationWithMigraines,
    
    /// Historical pressure data
    @Default([]) List<PressureDataPoint> historicalData,
    
    /// Analysis timestamp
    required DateTime analyzedAt,
  }) = _PressureAnalysis;

  factory PressureAnalysis.fromJson(Map<String, dynamic> json) =>
      _$PressureAnalysisFromJson(json);
}

/// Pressure data point
@freezed
class PressureDataPoint with _$PressureDataPoint {
  const factory PressureDataPoint({
    /// Timestamp
    required DateTime timestamp,
    
    /// Pressure in hPa
    required int pressure,
    
    /// Temperature in Celsius
    double? temperature,
    
    /// Humidity percentage
    int? humidity,
    
    /// Whether a migraine occurred near this time
    @Default(false) bool hadMigraine,
    
    /// Time until next migraine (in hours)
    double? hoursUntilNextMigraine,
    
    /// Time since previous migraine (in hours)
    double? hoursSincePreviousMigraine,
  }) = _PressureDataPoint;

  factory PressureDataPoint.fromJson(Map<String, dynamic> json) =>
      _$PressureDataPointFromJson(json);
}

/// Weather and migraine correlation
@freezed
class WeatherMigraineCorrelation with _$WeatherMigraineCorrelation {
  const factory WeatherMigraineCorrelation({
    /// User ID
    required String userId,
    
    /// Weather factor
    required String weatherFactor,
    
    /// Correlation coefficient
    double? correlation,
    
    /// P-value
    double? pValue,
    
    /// Number of data points
    required int dataPoints,
    
    /// Direction (positive, negative, none)
    String? direction,
    
    /// Strength (weak, moderate, strong)
    String? strength,
    
    /// Confidence level
    String? confidenceLevel,
    
    /// Description
    String? description,
    
    /// Time period
    DateTime? periodStart,
    DateTime? periodEnd,
    
    /// Optimal range for this user (if any)
    Map<String, dynamic>? optimalRange,
    
    /// Risk thresholds
    Map<String, dynamic>? riskThresholds,
  }) = _WeatherMigraineCorrelation;

  factory WeatherMigraineCorrelation.fromJson(Map<String, dynamic> json) =>
      _$WeatherMigraineCorrelationFromJson(json);
}

// Extension methods for WeatherModel
extension WeatherModelExtensions on WeatherModel {
  /// Get temperature display string
  String get temperatureDisplay {
    if (temperatureC == null) return 'N/A';
    return '${temperatureC!.toStringAsFixed(1)}°C';
  }

  /// Get feels like temperature display string
  String get feelsLikeDisplay {
    if (feelsLikeC == null) return 'N/A';
    return 'Ressenti: ${feelsLikeC!.toStringAsFixed(1)}°C';
  }

  /// Get pressure display string
  String get pressureDisplay {
    if (pressure == null) return 'N/A';
    return '$pressure hPa';
  }

  /// Get humidity display string
  String get humidityDisplay {
    if (humidity == null) return 'N/A';
    return '$humidity%';
  }

  /// Get wind speed display string
  String get windSpeedDisplay {
    if (windSpeedKph == null) return 'N/A';
    return '${windSpeedKph!.toStringAsFixed(1)} km/h';
  }

  /// Get wind direction display string
  String get windDirectionDisplay {
    if (windDirectionCompass != null) {
      return windDirectionCompass!;
    }
    if (windDirectionDegrees != null) {
      return _degreesToCompass(windDirectionDegrees!);
    }
    return 'N/A';
  }

  /// Get condition display string
  String get conditionDisplay {
    if (conditionDescription != null) {
      return conditionDescription!;
    }
    if (conditionMain != null) {
      return conditionMain!;
    }
    return 'Inconnu';
  }

  /// Get UV index display string
  String get uvIndexDisplay {
    if (uvIndex == null) return 'N/A';
    
    final uv = uvIndex!;
    if (uv < 3) return 'Faible';
    if (uv < 6) return 'Modéré';
    if (uv < 8) return 'Élevé';
    if (uv < 11) return 'Très élevé';
    return 'Extrême';
  }

  /// Get moon phase display string
  String get moonPhaseDisplay {
    switch (moonPhase) {
      case MoonPhase.newMoon:
        return 'Nouvelle lune';
      case MoonPhase.waxingCrescent:
        return 'Premier croissant';
      case MoonPhase.firstQuarter:
        return 'Premier quartier';
      case MoonPhase.waxingGibbous:
        return 'Lune gibbeuse croissante';
      case MoonPhase.fullMoon:
        return 'Pleine lune';
      case MoonPhase.waningGibbous:
        return 'Lune gibbeuse décroissante';
      case MoonPhase.lastQuarter:
        return 'Dernier quartier';
      case MoonPhase.waningCrescent:
        return 'Dernier croissant';
      default:
        return 'Inconnu';
    }
  }

  /// Convert degrees to compass direction
  static String _degreesToCompass(int degrees) {
    final directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];
    final index = ((degrees + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  /// Get weather condition type from condition ID
  /// Based on OpenWeatherMap condition codes
  static WeatherConditionType getConditionTypeFromId(int? conditionId) {
    if (conditionId == null) return WeatherConditionType.unknown;
    
    // Group 2xx: Thunderstorm
    if (conditionId >= 200 && conditionId < 300) {
      return WeatherConditionType.thunderstorm;
    }
    // Group 3xx: Drizzle
    if (conditionId >= 300 && conditionId < 400) {
      return WeatherConditionType.drizzle;
    }
    // Group 5xx: Rain
    if (conditionId >= 500 && conditionId < 600) {
      return WeatherConditionType.rain;
    }
    // Group 6xx: Snow
    if (conditionId >= 600 && conditionId < 700) {
      return WeatherConditionType.snow;
    }
    // Group 7xx: Atmosphere
    if (conditionId >= 700 && conditionId < 800) {
      if (conditionId == 701 || conditionId == 711 || conditionId == 721) {
        return WeatherConditionType.mist;
      }
      if (conditionId == 731 || conditionId == 751 || conditionId == 761 || conditionId == 762) {
        return WeatherConditionType.dust;
      }
      if (conditionId == 741) {
        return WeatherConditionType.fog;
      }
      return WeatherConditionType.mist;
    }
    // Group 800: Clear
    if (conditionId == 800) {
      return WeatherConditionType.clear;
    }
    // Group 80x: Clouds
    if (conditionId >= 801 && conditionId < 900) {
      return WeatherConditionType.clouds;
    }
    // Group 9xx: Extreme
    if (conditionId >= 900) {
      return WeatherConditionType.unknown;
    }
    
    return WeatherConditionType.unknown;
  }

  /// Check if weather might be related to migraines
  /// This is based on common associations, not causation
  bool get mightBeMigraineRelated {
    // Significant pressure changes
    if (pressureChanges.containsKey('24h') && 
        pressureChanges['24h']!.abs() > 10) {
      return true;
    }
    
    // Very high or very low pressure
    if (pressure != null && (pressure! < 990 || pressure! > 1030)) {
      return true;
    }
    
    // Extreme temperatures
    if (temperatureC != null && (temperatureC! < -10 || temperatureC! > 35)) {
      return true;
    }
    
    // High humidity
    if (humidity != null && humidity! > 85) {
      return true;
    }
    
    // Strong winds
    if (windSpeedKph != null && windSpeedKph! > 40) {
      return true;
    }
    
    // Thunderstorms
    if (conditionType == WeatherConditionType.thunderstorm) {
      return true;
    }
    
    // Rapid weather changes
    // This would need historical data to determine
    
    return false;
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in Firestore
    return json;
  }
}

extension MoonPhaseExtensions on MoonPhase {
  /// Get moon phase display name
  String get displayName {
    switch (this) {
      case MoonPhase.newMoon:
        return 'Nouvelle lune';
      case MoonPhase.waxingCrescent:
        return 'Premier croissant';
      case MoonPhase.firstQuarter:
        return 'Premier quartier';
      case MoonPhase.waxingGibbous:
        return 'Lune gibbeuse croissante';
      case MoonPhase.fullMoon:
        return 'Pleine lune';
      case MoonPhase.waningGibbous:
        return 'Lune gibbeuse décroissante';
      case MoonPhase.lastQuarter:
        return 'Dernier quartier';
      case MoonPhase.waningCrescent:
        return 'Dernier croissant';
    }
  }

  /// Get moon phase icon name
  String get iconName {
    switch (this) {
      case MoonPhase.newMoon:
        return 'new_moon';
      case MoonPhase.waxingCrescent:
        return 'waxing_crescent';
      case MoonPhase.firstQuarter:
        return 'first_quarter';
      case MoonPhase.waxingGibbous:
        return 'waxing_gibbous';
      case MoonPhase.fullMoon:
        return 'full_moon';
      case MoonPhase.waningGibbous:
        return 'waning_gibbous';
      case MoonPhase.lastQuarter:
        return 'last_quarter';
      case MoonPhase.waningCrescent:
        return 'waning_crescent';
    }
  }
}

extension WeatherConditionTypeExtensions on WeatherConditionType {
  /// Get condition display name
  String get displayName {
    switch (this) {
      case WeatherConditionType.clear:
        return 'Dégagé';
      case WeatherConditionType.clouds:
        return 'Nuageux';
      case WeatherConditionType.rain:
        return 'Pluie';
      case WeatherConditionType.drizzle:
        return 'Bruine';
      case WeatherConditionType.thunderstorm:
        return 'Orage';
      case WeatherConditionType.snow:
        return 'Neige';
      case WeatherConditionType.mist:
        return 'Brume';
      case WeatherConditionType.smoke:
        return 'Fumée';
      case WeatherConditionType.haze:
        return 'Brouillard léger';
      case WeatherConditionType.dust:
        return 'Poussière';
      case WeatherConditionType.fog:
        return 'Brouillard';
      case WeatherConditionType.sand:
        return 'Sable';
      case WeatherConditionType.ash:
        return 'Cendres';
      case WeatherConditionType.squall:
        return 'Grain';
      case WeatherConditionType.tornado:
        return 'Tornade';
      case WeatherConditionType.unknown:
        return 'Inconnu';
    }
  }

  /// Get condition icon name
  String get iconName {
    switch (this) {
      case WeatherConditionType.clear:
        return 'clear';
      case WeatherConditionType.clouds:
        return 'clouds';
      case WeatherConditionType.rain:
        return 'rain';
      case WeatherConditionType.drizzle:
        return 'drizzle';
      case WeatherConditionType.thunderstorm:
        return 'thunderstorm';
      case WeatherConditionType.snow:
        return 'snow';
      case WeatherConditionType.mist:
      case WeatherConditionType.fog:
      case WeatherConditionType.haze:
        return 'fog';
      case WeatherConditionType.smoke:
        return 'smoke';
      case WeatherConditionType.dust:
      case WeatherConditionType.sand:
        return 'dust';
      case WeatherConditionType.ash:
        return 'ash';
      case WeatherConditionType.squall:
        return 'squall';
      case WeatherConditionType.tornado:
        return 'tornado';
      case WeatherConditionType.unknown:
        return 'unknown';
    }
  }
}

// Helper methods for creating weather models
extension WeatherModelCreator on WeatherModel {
  /// Create a weather model from OpenWeatherMap API response
  static WeatherModel fromOpenWeatherMapCurrent(Map<String, dynamic> json, String locationName) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      json['dt'] * 1000,
      isUtc: true,
    );
    
    return WeatherModel(
      locationName: locationName,
      dateTime: dateTime,
      date: DateTime(dateTime.year, dateTime.month, dateTime.day),
      temperatureK: (json['main']?['temp'] as num?)?.toDouble(),
      temperatureC: (json['main']?['temp'] as num?)?.toDouble()?.roundToDouble(),
      feelsLikeK: (json['main']?['feels_like'] as num?)?.toDouble(),
      feelsLikeC: (json['main']?['feels_like'] as num?)?.toDouble()?.roundToDouble(),
      pressure: (json['main']?['pressure'] as num?)?.toInt(),
      pressureSeaLevel: (json['main']?['sea_level'] as num?)?.toInt(),
      pressureGroundLevel: (json['main']?['grnd_level'] as num?)?.toInt(),
      humidity: (json['main']?['humidity'] as num?)?.toInt(),
      windSpeedMs: (json['wind']?['speed'] as num?)?.toDouble(),
      windSpeedKph: (json['wind']?['speed'] as num?)?.toDouble()?.times(3.6),
      windDirectionDegrees: (json['wind']?['deg'] as num?)?.toInt(),
      windGustMs: (json['wind']?['gust'] as num?)?.toDouble(),
      windGustKph: (json['wind']?['gust'] as num?)?.toDouble()?.times(3.6),
      cloudCover: (json['clouds']?['all'] as num?)?.toInt(),
      visibility: (json['visibility'] as num?)?.toInt(),
      conditionId: json['weather']?[0]?['id'] as int?,
      conditionMain: json['weather']?[0]?['main'] as String?,
      conditionDescription: json['weather']?[0]?['description'] as String?,
      conditionType: WeatherModelExtensions.getConditionTypeFromId(
        json['weather']?[0]?['id'] as int?,
      ),
      iconCode: json['weather']?[0]?['icon'] as String?,
      sunrise: json['sys']?['sunrise'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['sys']?['sunrise'] as num).toInt() * 1000,
              isUtc: true,
            )
          : null,
      sunset: json['sys']?['sunset'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['sys']?['sunset'] as num).toInt() * 1000,
              isUtc: true,
            )
          : null,
      source: 'openweathermap',
      retrievedAt: DateTime.now(),
      isCached: false,
    );
  }

  /// Create a weather model from WeatherAPI response
  static WeatherModel fromWeatherAPICurrent(Map<String, dynamic> json, String locationName) {
    final dateTime = DateTime.parse(json['location']?['localtime'] ?? DateTime.now().toIso8601String());
    
    return WeatherModel(
      locationName: locationName,
      latitude: (json['location']?['lat'] as num?)?.toDouble(),
      longitude: (json['location']?['lon'] as num?)?.toDouble(),
      dateTime: dateTime,
      date: DateTime(dateTime.year, dateTime.month, dateTime.day),
      temperatureC: (json['current']?['temp_c'] as num?)?.toDouble(),
      feelsLikeC: (json['current']?['feelslike_c'] as num?)?.toDouble(),
      pressure: (json['current']?['pressure_mb'] as num?)?.toInt(),
      humidity: (json['current']?['humidity'] as num?)?.toInt(),
      windSpeedKph: (json['current']?['wind_kph'] as num?)?.toDouble(),
      windDirectionDegrees: (json['current']?['wind_degree'] as num?)?.toInt(),
      windDirectionCompass: json['current']?['wind_dir'] as String?,
      windGustKph: (json['current']?['gust_kph'] as num?)?.toDouble(),
      precipitation1hMm: (json['current']?['precip_mm'] as num?)?.toDouble(),
      cloudCover: (json['current']?['cloud'] as num?)?.toInt(),
      visibility: (json['current']?['vis_km'] as num?)?.toInt(),
      uvIndex: (json['current']?['uv'] as num?)?.toDouble(),
      conditionMain: json['current']?['condition']?['text'] as String?,
      conditionDescription: json['current']?['condition']?['text'] as String?,
      iconCode: json['current']?['condition']?['icon'] as String?,
      conditionType: _getConditionTypeFromText(
        json['current']?['condition']?['text'] as String?,
      ),
      source: 'weatherapi',
      retrievedAt: DateTime.now(),
      isCached: false,
    );
  }

  /// Get condition type from text description
  static WeatherConditionType _getConditionTypeFromText(String? text) {
    if (text == null) return WeatherConditionType.unknown;
    
    final lower = text.toLowerCase();
    
    if (lower.contains('clear') || lower.contains('dégagé')) {
      return WeatherConditionType.clear;
    }
    if (lower.contains('cloud') || lower.contains('nuage')) {
      return WeatherConditionType.clouds;
    }
    if (lower.contains('rain') || lower.contains('pluie') || lower.contains('drizzle') || lower.contains('bruine')) {
      return WeatherConditionType.rain;
    }
    if (lower.contains('thunder') || lower.contains('orage')) {
      return WeatherConditionType.thunderstorm;
    }
    if (lower.contains('snow') || lower.contains('neige')) {
      return WeatherConditionType.snow;
    }
    if (lower.contains('mist') || lower.contains('brume')) {
      return WeatherConditionType.mist;
    }
    if (lower.contains('fog') || lower.contains('brouillard')) {
      return WeatherConditionType.fog;
    }
    if (lower.contains('smoke') || lower.contains('fumée')) {
      return WeatherConditionType.smoke;
    }
    if (lower.contains('haze')) {
      return WeatherConditionType.haze;
    }
    if (lower.contains('dust') || lower.contains('poussière')) {
      return WeatherConditionType.dust;
    }
    if (lower.contains('sand') || lower.contains('sable')) {
      return WeatherConditionType.sand;
    }
    if (lower.contains('ash') || lower.contains('cendre')) {
      return WeatherConditionType.ash;
    }
    if (lower.contains('squall') || lower.contains('grain')) {
      return WeatherConditionType.squall;
    }
    if (lower.contains('tornado') || lower.contains('tornade')) {
      return WeatherConditionType.tornado;
    }
    
    return WeatherConditionType.unknown;
  }
}

extension DoubleExtensions on double {
  /// Round to double
  double roundToDouble() {
    return (this * 10).round() / 10;
  }

  /// Multiply by factor
  double times(double factor) {
    return this * factor;
  }
}
