// App constants
class AppConstants {
  static const String appName = 'Migraine Tracker';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Suivez et analysez vos migraines';
  
  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int migrainesPerPage = 10;
  static const int journalEntriesPerPage = 30;
  
  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String shortDateFormat = 'dd MMM';
  static const String monthYearFormat = 'MMM yyyy';
  static const String dayOfWeekFormat = 'EEE';
  
  // Storage keys
  static const String storageUserKey = 'user';
  static const String storageAuthKey = 'auth';
  static const String storageOnboardingKey = 'onboarding';
  static const String storageThemeKey = 'theme';
  static const String storageMigraineModeKey = 'migraine_mode';
  static const String storageLanguageKey = 'language';
  
  // API endpoints
  static const String apiBaseUrl = 'https://api.migraine-tracker.com';
  static const String apiAuthEndpoint = '/auth';
  static const String apiUsersEndpoint = '/users';
  static const String apiMigrainesEndpoint = '/migraines';
  static const String apiDailyLogsEndpoint = '/daily-logs';
  static const String apiWeatherEndpoint = '/weather';
  static const String apiAnalysisEndpoint = '/analysis';
  static const String apiReportsEndpoint = '/reports';
  static const String apiExperimentsEndpoint = '/experiments';
  static const String apiInsightsEndpoint = '/insights';
  static const String apiChatEndpoint = '/chat';
  
  // Weather API
  static const String weatherApiKey = 'YOUR_WEATHER_API_KEY';
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String weatherCurrentEndpoint = '/weather';
  static const String weatherForecastEndpoint = '/forecast';
  static const String weatherOneCallEndpoint = '/onecall';
  
  // Firebase
  static const String firebaseProjectId = 'migraine-tracker';
  
  // Health integration
  static const String healthKitAvailable = 'health_kit_available';
  static const String healthConnectAvailable = 'health_connect_available';
  
  // Notification channels
  static const String notificationChannelGeneral = 'general';
  static const String notificationChannelReminders = 'reminders';
  static const String notificationChannelInsights = 'insights';
  static const String notificationChannelAlerts = 'alerts';
  
  // Confidence levels for insights
  static const Map<int, String> confidenceLevels = {
    0: 'Insuffisant',
    1: 'Faible',
    2: 'Moyen',
    3: 'Élevé',
    4: 'Très élevé',
  };
  
  // Data quality thresholds
  static const int minDataPointsForInsight = 5;
  static const int goodDataPointsForInsight = 10;
  static const int strongDataPointsForInsight = 20;
  
  // Migraine intensity labels
  static const Map<int, String> migraineIntensityLabels = {
    0: 'Aucune',
    1: 'Très légère',
    2: 'Légère',
    3: 'Modérée',
    4: 'Modérée à sévère',
    5: 'Sévère',
    6: 'Très sévère',
    7: 'Extrêmement sévère',
    8: 'Intolérable',
    9: 'Pire possible',
    10: 'Pire imaginable',
  };
  
  // Sleep quality labels
  static const Map<int, String> sleepQualityLabels = {
    1: 'Très mauvaise',
    2: 'Mauvaise',
    3: 'Moyenne',
    4: 'Bonne',
    5: 'Excellent',
  };
  
  // Stress level labels
  static const Map<int, String> stressLevelLabels = {
    0: 'Aucun',
    1: 'Très faible',
    2: 'Faible',
    3: 'Modéré',
    4: 'Élevé',
    5: 'Très élevé',
    6: 'Extrême',
    7: 'Extrêmement élevé',
    8: 'Presque intolérable',
    9: 'Intolérable',
    10: 'Pire possible',
  };
  
  // Fatigue level labels
  static const Map<int, String> fatigueLevelLabels = {
    0: 'Aucune',
    1: 'Très faible',
    2: 'Faible',
    3: 'Modérée',
    4: 'Élevée',
    5: 'Très élevée',
    6: 'Extrême',
    7: 'Extrêmement élevée',
    8: 'Presque intolérable',
    9: 'Intolérable',
    10: 'Pire possible',
  };
  
  // Hydration level labels
  static const Map<int, String> hydrationLevelLabels = {
    1: 'Très déshydraté',
    2: 'Déshydraté',
    3: 'Légèrement déshydraté',
    4: 'Bien hydraté',
    5: 'Très bien hydraté',
  };
  
  // Mood labels
  static const Map<int, String> moodLabels = {
    1: 'Très triste',
    2: 'Triste',
    3: 'Neutre',
    4: 'Heureux',
    5: 'Très heureux',
  };
  
  // Physical activity intensity labels
  static const Map<int, String> activityIntensityLabels = {
    1: 'Très légère',
    2: 'Légère',
    3: 'Modérée',
    4: 'Intense',
    5: 'Très intense',
  };
  
  // Medication effectiveness labels
  static const Map<int, String> medicationEffectivenessLabels = {
    0: 'Aucun effet',
    1: 'Effet très faible',
    2: 'Effet faible',
    3: 'Effet modéré',
    4: 'Effet bon',
    5: 'Effet excellent',
  };
  
  // Symptom categories
  static const List<String> migraineSymptoms = [
    'Douleur pulsatile',
    'Douleur d\'un côté',
    'Douleur des deux côtés',
    'Nausées',
    'Vomissements',
    'Sensibilité à la lumière',
    'Sensibilité au bruit',
    'Sensibilité aux odeurs',
    'Troubles visuels',
    'Aura',
    'Vertiges',
    'Fatigue',
    'Difficultés de concentration',
    'Autres',
  ];
  
  // Trigger categories
  static const List<String> migraineTriggers = [
    'Manque de sommeil',
    'Trop de sommeil',
    'Stress',
    'Alcool',
    'Caféine',
    'Manque de caféine',
    'Déshydratation',
    'Repas sauté',
    'Certains aliments',
    'Activité physique',
    'Écrans',
    'Météo',
    'Bruit',
    'Lumière',
    'Fatigue',
    'Travail',
    'Autre',
  ];
  
  // Food categories
  static const List<String> foodCategories = [
    'Chocolat',
    'Fromage',
    'Charcuterie',
    'Glutamate',
    'Aliments fermentés',
    'Aliments gras',
    'Aliments épicés',
    'Fruits secs',
    'Agrumes',
    'Alcool',
    'Autre',
  ];
  
  // Caffeine sources
  static const List<String> caffeineSources = [
    'Café',
    'Thé',
    'Boisson énergisante',
    'Soda caféiné',
    'Chocolat',
    'Médicament',
    'Autre',
  ];
  
  // Alcohol types
  static const List<String> alcoholTypes = [
    'Vin rouge',
    'Vin blanc',
    'Bière',
    'Spiritueux',
    'Champagne',
    'Cocktail',
    'Autre',
  ];
  
  // Medication types
  static const List<String> medicationTypes = [
    'Antalgique (paracétamol)',
    'Anti-inflammatoire (ibuprofène)',
    'Triptan',
    'Ergotamine',
    'Traitement de fond',
    'Autre',
  ];
  
  // Week days
  static const List<String> weekDays = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche',
  ];
  
  // Month names
  static const List<String> monthNames = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];
  
  // Medical alert symptoms (require immediate attention)
  static const List<String> medicalAlertSymptoms = [
    'Céphalée brutale et extrêmement intense',
    'Nouveau déficit neurologique',
    'Confusion importante',
    'Perte de connaissance',
    'Convulsions',
    'Fièvre importante avec raideur de nuque',
    'Traumatisme crânien',
    'Changement majeur et inhabituel du profil des céphalées',
  ];
  
  // Default values
  static const int defaultMigraineDurationHours = 4;
  static const int defaultSleepDurationHours = 8;
  static const int defaultCaffeinePerCupMg = 80;
  static const double defaultWaterPerGlassL = 0.25;
  
  // Free tier limits
  static const int freeTierMaxMigraines = 50;
  static const int freeTierMaxJournalEntries = 100;
  static const int freeTierMaxReports = 5;
  static const bool freeTierHasAdvancedAnalysis = false;
  static const bool freeTierHasAIChat = false;
  static const bool freeTierHasWeather = false;
  static const bool freeTierHasHealthSync = false;
  
  // Premium tier features
  static const int premiumTierMaxMigraines = -1; // Unlimited
  static const int premiumTierMaxJournalEntries = -1; // Unlimited
  static const int premiumTierMaxReports = -1; // Unlimited
  static const bool premiumTierHasAdvancedAnalysis = true;
  static const bool premiumTierHasAIChat = true;
  static const bool premiumTierHasWeather = true;
  static const bool premiumTierHasHealthSync = true;
  
  // Subscription prices (in EUR)
  static const double monthlyPrice = 4.99;
  static const double yearlyPrice = 39.99;
  static const double lifetimePrice = 99.99;
  
  // Trial period (in days)
  static const int trialPeriodDays = 7;
}
