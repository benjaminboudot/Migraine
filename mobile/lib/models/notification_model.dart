import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

/// Notification type enum
enum NotificationType {
  // Reminder notifications
  dailyJournalReminder,
  migraineEntryReminder,
  medicationReminder,
  
  // Insight notifications
  newInsight,
  importantInsight,
  trendDetected,
  
  // Alert notifications
  medicalAlert,
  highRiskAlert,
  abnormalDataAlert,
  
  // Information notifications
  weeklySummary,
  monthlySummary,
  reportReady,
  
  // System notifications
  syncError,
  backupReminder,
  updateAvailable,
  
  // Custom notifications
  custom,
}

/// Notification priority enum
enum NotificationPriority {
  low,
  normal,
  high,
  urgent,
}

/// Notification channel enum
enum NotificationChannel {
  general,
  reminders,
  insights,
  alerts,
  system,
}

/// Notification model
@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    /// Unique notification ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Notification type
    required NotificationType type,
    
    /// Notification channel
    NotificationChannel? channel,
    
    /// Notification title
    required String title,
    
    /// Notification body/message
    required String body,
    
    /// Notification payload (additional data)
    Map<String, dynamic>? payload,
    
    /// Notification priority
    @Default(NotificationPriority.normal) NotificationPriority priority,
    
    /// Scheduled time for notification
    DateTime? scheduledTime,
    
    /// Actual delivery time
    DateTime? deliveredTime,
    
    /// Read status
    @Default(false) bool isRead,
    
    /// Dismissed status
    @Default(false) bool isDismissed,
    
    /// Action taken (e.g., "opened", "snoozed", "ignored")
    String? actionTaken,
    
    /// Action timestamp
    DateTime? actionTimestamp,
    
    /// Whether notification is recurring
    @Default(false) bool isRecurring,
    
    /// Recurrence pattern (for recurring notifications)
    String? recurrencePattern,
    
    /// Next occurrence time (for recurring notifications)
    DateTime? nextOccurrence,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Expiration timestamp
    DateTime? expiresAt,
    
    /// Whether notification is synced
    @Default(false) bool isSynced,
    
    /// Device token (for push notifications)
    String? deviceToken,
    
    /// Notification ID from Firebase (for push notifications)
    String? firebaseId,
    
    /// Whether notification was sent via push
    @Default(false) bool wasPushed,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

/// Notification settings model
@freezed
class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    /// User ID
    required String userId,
    
    /// Whether notifications are enabled globally
    @Default(true) bool notificationsEnabled,
    
    /// Settings by channel
    @Default({}) Map<String, ChannelSettings> channelSettings,
    
    /// Settings by type
    @Default({}) Map<String, TypeSettings> typeSettings,
    
    /// Quiet hours start time
    String? quietHoursStart,
    
    /// Quiet hours end time
    String? quietHoursEnd,
    
    /// Whether quiet hours are enabled
    @Default(false) bool quietHoursEnabled,
    
    /// Notification sound
    String? sound,
    
    /// Whether vibration is enabled
    @Default(true) bool vibrationEnabled,
    
    /// Whether notification preview is shown
    @Default(true) bool showPreview,
    
    /// Notification preview lines
    @Default(2) int previewLines,
    
    /// Last updated timestamp
    DateTime? updatedAt,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

/// Channel settings
@freezed
class ChannelSettings with _$ChannelSettings {
  const factory ChannelSettings({
    /// Whether channel is enabled
    @Default(true) bool enabled,
    
    /// Channel priority
    @Default(NotificationPriority.normal) NotificationPriority priority,
    
    /// Whether sound is enabled for this channel
    @Default(true) bool soundEnabled,
    
    /// Whether vibration is enabled for this channel
    @Default(true) bool vibrationEnabled,
    
    /// Channel-specific sound
    String? sound,
    
    /// Whether notifications should be shown as badges
    @Default(true) bool showBadge,
    
    /// Badge count
    @Default(0) int badgeCount,
  }) = _ChannelSettings;

  factory ChannelSettings.fromJson(Map<String, dynamic> json) =>
      _$ChannelSettingsFromJson(json);
}

/// Type settings
@freezed
class TypeSettings with _$TypeSettings {
  const factory TypeSettings({
    /// Whether this notification type is enabled
    @Default(true) bool enabled,
    
    /// Notification type priority
    @Default(NotificationPriority.normal) NotificationPriority priority,
    
    /// Whether sound is enabled
    @Default(true) bool soundEnabled,
    
    /// Whether vibration is enabled
    @Default(true) bool vibrationEnabled,
    
    /// Specific sound for this type
    String? sound,
    
    /// Notification frequency (for recurring notifications)
    String? frequency,
    
    /// Specific times for notification
    @Default([]) List<String> times,
    
    /// Whether to snooze this notification
    @Default(false) bool canSnooze,
    
    /// Snooze duration in minutes
    @Default(10) int snoozeDuration,
  }) = _TypeSettings;

  factory TypeSettings.fromJson(Map<String, dynamic> json) =>
      _$TypeSettingsFromJson(json);
}

/// Notification schedule model
@freezed
class NotificationSchedule with _$NotificationSchedule {
  const factory NotificationSchedule({
    /// Schedule ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Notification type
    required NotificationType type,
    
    /// Schedule title
    String? title,
    
    /// Schedule description
    String? description,
    
    /// Scheduled time
    required String time,
    
    /// Days of week (0-6, where 0 is Monday)
    @Default([]) List<int> daysOfWeek,
    
    /// Whether schedule is active
    @Default(true) bool isActive,
    
    /// Start date
    DateTime? startDate,
    
    /// End date
    DateTime? endDate,
    
    /// Recurrence pattern
    String? recurrencePattern,
    
    /// Last triggered time
    DateTime? lastTriggered,
    
    /// Next scheduled time
    DateTime? nextScheduled,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether schedule is synced
    @Default(false) bool isSynced,
  }) = _NotificationSchedule;

  factory NotificationSchedule.fromJson(Map<String, dynamic> json) =>
      _$NotificationScheduleFromJson(json);
}

/// Reminder model
@freezed
class ReminderModel with _$ReminderModel {
  const factory ReminderModel({
    /// Reminder ID
    String? id,
    
    /// User ID
    required String userId,
    
    /// Reminder title
    required String title,
    
    /// Reminder message
    String? message,
    
    /// Reminder type
    String? type,
    
    /// Scheduled time
    required DateTime scheduledTime,
    
    /// Whether reminder is recurring
    @Default(false) bool isRecurring,
    
    /// Recurrence pattern
    String? recurrencePattern,
    
    /// Days of week for recurrence
    @Default([]) List<int> daysOfWeek,
    
    /// Whether reminder is active
    @Default(true) bool isActive,
    
    /// Whether reminder has been completed
    @Default(false) bool isCompleted,
    
    /// Completion time
    DateTime? completedTime,
    
    /// Reminder data
    Map<String, dynamic>? data,
    
    /// Creation timestamp
    required DateTime createdAt,
    
    /// Last update timestamp
    DateTime? updatedAt,
    
    /// Whether reminder is synced
    @Default(false) bool isSynced,
  }) = _ReminderModel;

  factory ReminderModel.fromJson(Map<String, dynamic> json) =>
      _$ReminderModelFromJson(json);
}

/// Notification action model
@freezed
class NotificationAction with _$NotificationAction {
  const factory NotificationAction({
    /// Action ID
    String? id,
    
    /// Notification ID
    String? notificationId,
    
    /// Action type (e.g., "open", "snooze", "dismiss", "custom")
    required String type,
    
    /// Action data
    Map<String, dynamic>? data,
    
    /// Action timestamp
    required DateTime timestamp,
    
    /// User ID
    required String userId,
  }) = _NotificationAction;

  factory NotificationAction.fromJson(Map<String, dynamic> json) =>
      _$NotificationActionFromJson(json);
}

// Extension methods for NotificationModel
extension NotificationModelExtensions on NotificationModel {
  /// Get notification type display name
  String get typeDisplayName {
    switch (type) {
      case NotificationType.dailyJournalReminder:
        return 'Rappel journal quotidien';
      case NotificationType.migraineEntryReminder:
        return 'Rappel saisie migraine';
      case NotificationType.medicationReminder:
        return 'Rappel médication';
      case NotificationType.newInsight:
        return 'Nouvelle découverte';
      case NotificationType.importantInsight:
        return 'Découverte importante';
      case NotificationType.trendDetected:
        return 'Tendance détectée';
      case NotificationType.medicalAlert:
        return 'Alerte médicale';
      case NotificationType.highRiskAlert:
        return 'Risque élevé';
      case NotificationType.abnormalDataAlert:
        return 'Données anormales';
      case NotificationType.weeklySummary:
        return 'Résumé hebdomadaire';
      case NotificationType.monthlySummary:
        return 'Résumé mensuel';
      case NotificationType.reportReady:
        return 'Rapport prêt';
      case NotificationType.syncError:
        return 'Erreur de synchronisation';
      case NotificationType.backupReminder:
        return 'Rappel sauvegarde';
      case NotificationType.updateAvailable:
        return 'Mise à jour disponible';
      case NotificationType.custom:
        return 'Notification personnalisée';
    }
  }

  /// Get notification channel
  NotificationChannel get channel {
    switch (type) {
      case NotificationType.dailyJournalReminder:
      case NotificationType.migraineEntryReminder:
      case NotificationType.medicationReminder:
        return NotificationChannel.reminders;
      case NotificationType.newInsight:
      case NotificationType.importantInsight:
      case NotificationType.trendDetected:
        return NotificationChannel.insights;
      case NotificationType.medicalAlert:
      case NotificationType.highRiskAlert:
      case NotificationType.abnormalDataAlert:
        return NotificationChannel.alerts;
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
      case NotificationType.reportReady:
      case NotificationType.syncError:
      case NotificationType.backupReminder:
      case NotificationType.updateAvailable:
        return NotificationChannel.system;
      case NotificationType.custom:
        return NotificationChannel.general;
    }
  }

  /// Get notification priority display name
  String get priorityDisplayName {
    switch (priority) {
      case NotificationPriority.low:
        return 'Faible';
      case NotificationPriority.normal:
        return 'Normale';
      case NotificationPriority.high:
        return 'Élevée';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  /// Check if notification is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if notification should be shown
  bool get shouldShow {
    if (isDismissed) return false;
    if (isExpired) return false;
    if (isRead) return false;
    return true;
  }

  /// Convert to map for Firestore
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in Firestore
    return json;
  }
}

extension NotificationTypeExtensions on NotificationType {
  /// Get notification type display name
  String get displayName {
    switch (this) {
      case NotificationType.dailyJournalReminder:
        return 'Rappel journal quotidien';
      case NotificationType.migraineEntryReminder:
        return 'Rappel saisie migraine';
      case NotificationType.medicationReminder:
        return 'Rappel médication';
      case NotificationType.newInsight:
        return 'Nouvelle découverte';
      case NotificationType.importantInsight:
        return 'Découverte importante';
      case NotificationType.trendDetected:
        return 'Tendance détectée';
      case NotificationType.medicalAlert:
        return 'Alerte médicale';
      case NotificationType.highRiskAlert:
        return 'Risque élevé';
      case NotificationType.abnormalDataAlert:
        return 'Données anormales';
      case NotificationType.weeklySummary:
        return 'Résumé hebdomadaire';
      case NotificationType.monthlySummary:
        return 'Résumé mensuel';
      case NotificationType.reportReady:
        return 'Rapport prêt';
      case NotificationType.syncError:
        return 'Erreur de synchronisation';
      case NotificationType.backupReminder:
        return 'Rappel sauvegarde';
      case NotificationType.updateAvailable:
        return 'Mise à jour disponible';
      case NotificationType.custom:
        return 'Notification personnalisée';
    }
  }

  /// Get notification type channel
  NotificationChannel get channel {
    switch (this) {
      case NotificationType.dailyJournalReminder:
      case NotificationType.migraineEntryReminder:
      case NotificationType.medicationReminder:
        return NotificationChannel.reminders;
      case NotificationType.newInsight:
      case NotificationType.importantInsight:
      case NotificationType.trendDetected:
        return NotificationChannel.insights;
      case NotificationType.medicalAlert:
      case NotificationType.highRiskAlert:
      case NotificationType.abnormalDataAlert:
        return NotificationChannel.alerts;
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
      case NotificationType.reportReady:
      case NotificationType.syncError:
      case NotificationType.backupReminder:
      case NotificationType.updateAvailable:
        return NotificationChannel.system;
      case NotificationType.custom:
        return NotificationChannel.general;
    }
  }

  /// Get default priority for notification type
  NotificationPriority get defaultPriority {
    switch (this) {
      case NotificationType.medicalAlert:
      case NotificationType.highRiskAlert:
        return NotificationPriority.urgent;
      case NotificationType.abnormalDataAlert:
      case NotificationType.importantInsight:
        return NotificationPriority.high;
      case NotificationType.migraineEntryReminder:
      case NotificationType.dailyJournalReminder:
      case NotificationType.medicationReminder:
      case NotificationType.newInsight:
      case NotificationType.trendDetected:
        return NotificationPriority.normal;
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
      case NotificationType.reportReady:
      case NotificationType.syncError:
      case NotificationType.backupReminder:
      case NotificationType.updateAvailable:
      case NotificationType.custom:
        return NotificationPriority.low;
    }
  }

  /// Get default enabled status for notification type
  bool get defaultEnabled {
    switch (this) {
      case NotificationType.medicalAlert:
      case NotificationType.highRiskAlert:
        return true; // Always enabled for safety
      case NotificationType.migraineEntryReminder:
      case NotificationType.dailyJournalReminder:
      case NotificationType.importantInsight:
        return true; // Enabled by default
      case NotificationType.newInsight:
      case NotificationType.trendDetected:
      case NotificationType.weeklySummary:
      case NotificationType.monthlySummary:
      case NotificationType.reportReady:
        return true;
      case NotificationType.medicationReminder:
      case NotificationType.abnormalDataAlert:
      case NotificationType.syncError:
      case NotificationType.backupReminder:
      case NotificationType.updateAvailable:
      case NotificationType.custom:
        return false; // Disabled by default
    }
  }
}

extension NotificationPriorityExtensions on NotificationPriority {
  /// Get notification priority display name
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Faible';
      case NotificationPriority.normal:
        return 'Normale';
      case NotificationPriority.high:
        return 'Élevée';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }

  /// Get notification priority value (0-3)
  int get value {
    switch (this) {
      case NotificationPriority.low:
        return 0;
      case NotificationPriority.normal:
        return 1;
      case NotificationPriority.high:
        return 2;
      case NotificationPriority.urgent:
        return 3;
    }
  }
}

extension NotificationChannelExtensions on NotificationChannel {
  /// Get notification channel display name
  String get displayName {
    switch (this) {
      case NotificationChannel.general:
        return 'Général';
      case NotificationChannel.reminders:
        return 'Rappels';
      case NotificationChannel.insights:
        return 'Découvertes';
      case NotificationChannel.alerts:
        return 'Alertes';
      case NotificationChannel.system:
        return 'Système';
    }
  }

  /// Get notification channel description
  String get description {
    switch (this) {
      case NotificationChannel.general:
        return 'Notifications générales';
      case NotificationChannel.reminders:
        return 'Rappels pour le journal et les migraines';
      case NotificationChannel.insights:
        return 'Nouvelles découvertes et tendances';
      case NotificationChannel.alerts:
        return 'Alertes importantes';
      case NotificationChannel.system:
        return 'Notifications système';
    }
  }
}

// Helper methods for creating notifications
extension NotificationModelCreator on NotificationModel {
  /// Create a daily journal reminder notification
  static NotificationModel createDailyJournalReminder({
    required String userId,
    required DateTime scheduledTime,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.dailyJournalReminder,
      channel: NotificationChannel.reminders,
      title: title ?? 'Rappel: Journal quotidien',
      body: body ?? 'N\'oubliez pas de remplir votre journal quotidien pour aujourd\'hui.',
      priority: NotificationPriority.normal,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
      expiresAt: scheduledTime.add(const Duration(hours: 24)),
      isSynced: false,
    );
  }

  /// Create a migraine entry reminder notification
  static NotificationModel createMigraineEntryReminder({
    required String userId,
    required DateTime scheduledTime,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.migraineEntryReminder,
      channel: NotificationChannel.reminders,
      title: title ?? 'Rappel: Saisie migraine',
      body: body ?? 'Vous avez indiqué une migraine hier. Voulez-vous ajouter des détails ?',
      priority: NotificationPriority.normal,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
      expiresAt: scheduledTime.add(const Duration(hours: 24)),
      isSynced: false,
    );
  }

  /// Create a medication reminder notification
  static NotificationModel createMedicationReminder({
    required String userId,
    required DateTime scheduledTime,
    required String medicationName,
    String? dosage,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.medicationReminder,
      channel: NotificationChannel.reminders,
      title: title ?? 'Rappel: Médicament',
      body: body ?? 'Il est temps de prendre votre médicament: $medicationName${dosage != null ? ' ($dosage)' : ''}.',
      priority: NotificationPriority.normal,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
      expiresAt: scheduledTime.add(const Duration(hours: 1)),
      payload: {
        'medicationName': medicationName,
        'dosage': dosage,
      },
      isSynced: false,
    );
  }

  /// Create a new insight notification
  static NotificationModel createNewInsightNotification({
    required String userId,
    required String insightTitle,
    required String insightDescription,
    required NotificationPriority priority,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.newInsight,
      channel: NotificationChannel.insights,
      title: title ?? 'Nouvelle découverte',
      body: body ?? insightDescription,
      priority: priority,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      payload: {
        'insightTitle': insightTitle,
        'insightDescription': insightDescription,
      },
      isSynced: false,
    );
  }

  /// Create a medical alert notification
  static NotificationModel createMedicalAlertNotification({
    required String userId,
    required String alertType,
    required String alertDescription,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.medicalAlert,
      channel: NotificationChannel.alerts,
      title: title ?? '⚠️ Alerte médicale importante',
      body: body ?? 'Symptôme nécessitant une attention médicale: $alertDescription',
      priority: NotificationPriority.urgent,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      payload: {
        'alertType': alertType,
        'alertDescription': alertDescription,
        'requiresAction': true,
      },
      isSynced: false,
    );
  }

  /// Create a high risk alert notification
  static NotificationModel createHighRiskAlertNotification({
    required String userId,
    required double riskScore,
    required List<String> contributingFactors,
    String? title,
    String? body,
  }) {
    final factorsText = contributingFactors.take(3).join(', ');
    
    return NotificationModel(
      userId: userId,
      type: NotificationType.highRiskAlert,
      channel: NotificationChannel.alerts,
      title: title ?? '⚠️ Risque élevé de migraine',
      body: body ?? 'Votre score de risque est élevé aujourd\'hui ($riskScore%). Facteurs: $factorsText.',
      priority: NotificationPriority.high,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 1)),
      payload: {
        'riskScore': riskScore,
        'contributingFactors': contributingFactors,
      },
      isSynced: false,
    );
  }

  /// Create a weekly summary notification
  static NotificationModel createWeeklySummaryNotification({
    required String userId,
    required int migraineCount,
    required double averageIntensity,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.weeklySummary,
      channel: NotificationChannel.system,
      title: title ?? 'Résumé hebdomadaire',
      body: body ?? 'Cette semaine: $migraineCount migraines, intensité moyenne: ${averageIntensity.toStringAsFixed(1)}/10.',
      priority: NotificationPriority.low,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 7)),
      payload: {
        'migraineCount': migraineCount,
        'averageIntensity': averageIntensity,
      },
      isSynced: false,
    );
  }

  /// Create a monthly summary notification
  static NotificationModel createMonthlySummaryNotification({
    required String userId,
    required int migraineCount,
    required double averageIntensity,
    required int daysWithoutMigraines,
    String? title,
    String? body,
  }) {
    return NotificationModel(
      userId: userId,
      type: NotificationType.monthlySummary,
      channel: NotificationChannel.system,
      title: title ?? 'Résumé mensuel',
      body: body ?? 'Ce mois: $migraineCount migraines, $daysWithoutMigraines jours sans migraine.',
      priority: NotificationPriority.low,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      payload: {
        'migraineCount': migraineCount,
        'averageIntensity': averageIntensity,
        'daysWithoutMigraines': daysWithoutMigraines,
      },
      isSynced: false,
    );
  }
}
