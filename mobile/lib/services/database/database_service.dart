import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../../models/user_model.dart';
import '../../models/migraine_model.dart';
import '../../models/daily_log_model.dart';
import '../../models/analysis_model.dart';
import '../../models/report_model.dart';
import '../../models/notification_model.dart';
import '../../models/chat_model.dart';
import '../../models/weather_model.dart';
import 'database_exceptions.dart';

/// Database service for Firestore operations
class DatabaseService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Connectivity _connectivity;

  /// Create a new DatabaseService instance
  DatabaseService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    Connectivity? connectivity,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _connectivity = connectivity ?? Connectivity();

  /// Collection names
  static const String usersCollection = 'users';
  static const String migrainesCollection = 'migraines';
  static const String dailyLogsCollection = 'daily_logs';
  static const String insightsCollection = 'insights';
  static const String reportsCollection = 'reports';
  static const String notificationsCollection = 'notifications';
  static const String chatSessionsCollection = 'chat_sessions';
  static const String weatherCollection = 'weather';
  static const String experimentsCollection = 'experiments';
  static const String riskScoresCollection = 'risk_scores';

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => currentUserId != null;

  /// Check if online
  Future<bool> get isOnline async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  /// Stream of connectivity changes
  Stream<bool> get connectivityChanges {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  // ==================== USER OPERATIONS ====================

  /// Get user document reference
  DocumentReference<UserModel> _getUserDocRef(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromFirestore(snapshot),
          toFirestore: (user, _) => user.toFirestore(),
        );
  }

  /// Create a new user
  Future<UserModel> createUser(UserModel user) async {
    try {
      final docRef = _getUserDocRef(user.id);
      await docRef.set(user);
      return user;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de création de l\'utilisateur: ${e.toString()}',
        code: 'create-user-failed',
      );
    }
  }

  /// Get user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final docRef = _getUserDocRef(userId);
      final doc = await docRef.get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération de l\'utilisateur: ${e.toString()}',
        code: 'get-user-failed',
      );
    }
  }

  /// Update user
  Future<void> updateUser(UserModel user) async {
    try {
      final docRef = _getUserDocRef(user.id);
      await docRef.update(user.toFirestore());
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de mise à jour de l\'utilisateur: ${e.toString()}',
        code: 'update-user-failed',
      );
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      final docRef = _getUserDocRef(userId);
      await docRef.delete();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de suppression de l\'utilisateur: ${e.toString()}',
        code: 'delete-user-failed',
      );
    }
  }

  /// Stream user data
  Stream<UserModel?> streamUser(String userId) {
    final docRef = _getUserDocRef(userId);
    return docRef.snapshots().map((doc) => doc.exists ? doc.data() : null);
  }

  // ==================== MIGRAINE OPERATIONS ====================

  /// Get migraines collection reference for user
  CollectionReference<MigraineModel> _getMigrainesCollectionRef(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(migrainesCollection)
        .withConverter<MigraineModel>(
          fromFirestore: (snapshot, _) => MigraineModel.fromFirestore(snapshot),
          toFirestore: (migraine, _) => migraine.toFirestore(),
        );
  }

  /// Create a new migraine
  Future<MigraineModel> createMigraine(MigraineModel migraine) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getMigrainesCollectionRef(userId);
      final docRef = collectionRef.doc();
      
      // Set ID and update timestamps
      final migraineWithId = migraine.copyWith(
        id: docRef.id,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await docRef.set(migraineWithId);
      return migraineWithId;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de création de la migraine: ${e.toString()}',
        code: 'create-migraine-failed',
      );
    }
  }

  /// Get migraine by ID
  Future<MigraineModel?> getMigraine(String userId, String migraineId) async {
    try {
      final collectionRef = _getMigrainesCollectionRef(userId);
      final doc = await collectionRef.doc(migraineId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération de la migraine: ${e.toString()}',
        code: 'get-migraine-failed',
      );
    }
  }

  /// Get all migraines for user
  Future<List<MigraineModel>> getAllMigraines(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) async {
    try {
      final collectionRef = _getMigrainesCollectionRef(userId);
      
      Query<MigraineModel> query = collectionRef;
      
      // Apply filters
      if (startDate != null) {
        query = query.where('startTime', isGreaterThanOrEqualTo: startDate);
      }
      
      if (endDate != null) {
        query = query.where('startTime', isLessThanOrEqualTo: endDate);
      }
      
      // Apply ordering
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      } else {
        query = query.orderBy('startTime', descending: descending);
      }
      
      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération des migraines: ${e.toString()}',
        code: 'get-migraines-failed',
      );
    }
  }

  /// Update migraine
  Future<void> updateMigraine(MigraineModel migraine) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getMigrainesCollectionRef(userId);
      await collectionRef.doc(migraine.id).update(migraine.toFirestore());
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de mise à jour de la migraine: ${e.toString()}',
        code: 'update-migraine-failed',
      );
    }
  }

  /// Delete migraine
  Future<void> deleteMigraine(String userId, String migraineId) async {
    try {
      final collectionRef = _getMigrainesCollectionRef(userId);
      await collectionRef.doc(migraineId).delete();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de suppression de la migraine: ${e.toString()}',
        code: 'delete-migraine-failed',
      );
    }
  }

  /// Stream migraines for user
  Stream<List<MigraineModel>> streamMigraines(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) {
    final collectionRef = _getMigrainesCollectionRef(userId);
    
    Query<MigraineModel> query = collectionRef;
    
    if (startDate != null) {
      query = query.where('startTime', isGreaterThanOrEqualTo: startDate);
    }
    
    if (endDate != null) {
      query = query.where('startTime', isLessThanOrEqualTo: endDate);
    }
    
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    } else {
      query = query.orderBy('startTime', descending: descending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Get migraine count for user
  Future<int> getMigraineCount(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final collectionRef = _getMigrainesCollectionRef(userId);
      
      Query query = collectionRef;
      
      if (startDate != null) {
        query = query.where('startTime', isGreaterThanOrEqualTo: startDate);
      }
      
      if (endDate != null) {
        query = query.where('startTime', isLessThanOrEqualTo: endDate);
      }
      
      final snapshot = await query.count().get();
      return snapshot.count;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de comptage des migraines: ${e.toString()}',
        code: 'count-migraines-failed',
      );
    }
  }

  // ==================== DAILY LOG OPERATIONS ====================

  /// Get daily logs collection reference for user
  CollectionReference<DailyLogModel> _getDailyLogsCollectionRef(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(dailyLogsCollection)
        .withConverter<DailyLogModel>(
          fromFirestore: (snapshot, _) => DailyLogModel.fromFirestore(snapshot),
          toFirestore: (log, _) => log.toFirestore(),
        );
  }

  /// Create a new daily log
  Future<DailyLogModel> createDailyLog(DailyLogModel log) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getDailyLogsCollectionRef(userId);
      final docRef = collectionRef.doc();
      
      // Set ID and update timestamps
      final logWithId = log.copyWith(
        id: docRef.id,
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await docRef.set(logWithId);
      return logWithId;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de création du journal: ${e.toString()}',
        code: 'create-daily-log-failed',
      );
    }
  }

  /// Get daily log by ID
  Future<DailyLogModel?> getDailyLog(String userId, String logId) async {
    try {
      final collectionRef = _getDailyLogsCollectionRef(userId);
      final doc = await collectionRef.doc(logId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération du journal: ${e.toString()}',
        code: 'get-daily-log-failed',
      );
    }
  }

  /// Get daily log by date
  Future<DailyLogModel?> getDailyLogByDate(String userId, DateTime date) async {
    try {
      final collectionRef = _getDailyLogsCollectionRef(userId);
      
      // Normalize date to start of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day + 1);
      
      final query = collectionRef
          .where('date', isGreaterThanOrEqualTo: startOfDay)
          .where('date', isLessThan: endOfDay)
          .limit(1);
      
      final snapshot = await query.get();
      return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération du journal par date: ${e.toString()}',
        code: 'get-daily-log-by-date-failed',
      );
    }
  }

  /// Get all daily logs for user
  Future<List<DailyLogModel>> getAllDailyLogs(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) async {
    try {
      final collectionRef = _getDailyLogsCollectionRef(userId);
      
      Query<DailyLogModel> query = collectionRef;
      
      if (startDate != null) {
        query = query.where('date', isGreaterThanOrEqualTo: startDate);
      }
      
      if (endDate != null) {
        query = query.where('date', isLessThanOrEqualTo: endDate);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      } else {
        query = query.orderBy('date', descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération des journaux: ${e.toString()}',
        code: 'get-daily-logs-failed',
      );
    }
  }

  /// Update daily log
  Future<void> updateDailyLog(DailyLogModel log) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getDailyLogsCollectionRef(userId);
      await collectionRef.doc(log.id).update(log.toFirestore());
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de mise à jour du journal: ${e.toString()}',
        code: 'update-daily-log-failed',
      );
    }
  }

  /// Delete daily log
  Future<void> deleteDailyLog(String userId, String logId) async {
    try {
      final collectionRef = _getDailyLogsCollectionRef(userId);
      await collectionRef.doc(logId).delete();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de suppression du journal: ${e.toString()}',
        code: 'delete-daily-log-failed',
      );
    }
  }

  /// Stream daily logs for user
  Stream<List<DailyLogModel>> streamDailyLogs(String userId, {
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) {
    final collectionRef = _getDailyLogsCollectionRef(userId);
    
    Query<DailyLogModel> query = collectionRef;
    
    if (startDate != null) {
      query = query.where('date', isGreaterThanOrEqualTo: startDate);
    }
    
    if (endDate != null) {
      query = query.where('date', isLessThanOrEqualTo: endDate);
    }
    
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    } else {
      query = query.orderBy('date', descending: descending);
    }
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // ==================== INSIGHT OPERATIONS ====================

  /// Get insights collection reference for user
  CollectionReference<InsightModel> _getInsightsCollectionRef(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(insightsCollection)
        .withConverter<InsightModel>(
          fromFirestore: (snapshot, _) => InsightModel.fromJson(
            {...snapshot.data()!, 'id': snapshot.id},
          ),
          toFirestore: (insight, _) => insight.toJson(),
        );
  }

  /// Create a new insight
  Future<InsightModel> createInsight(InsightModel insight) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getInsightsCollectionRef(userId);
      final docRef = collectionRef.doc();
      
      final insightWithId = insight.copyWith(
        id: docRef.id,
        userId: userId,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      
      await docRef.set(insightWithId);
      return insightWithId;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de création de l\'insight: ${e.toString()}',
        code: 'create-insight-failed',
      );
    }
  }

  /// Get all insights for user
  Future<List<InsightModel>> getAllInsights(String userId, {
    bool? isViewed,
    bool? isDismissed,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) async {
    try {
      final collectionRef = _getInsightsCollectionRef(userId);
      
      Query<InsightModel> query = collectionRef;
      
      if (isViewed != null) {
        query = query.where('isViewed', isEqualTo: isViewed);
      }
      
      if (isDismissed != null) {
        query = query.where('isDismissed', isEqualTo: isDismissed);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      } else {
        query = query.orderBy('createdAt', descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération des insights: ${e.toString()}',
        code: 'get-insights-failed',
      );
    }
  }

  /// Update insight (mark as viewed/dismissed)
  Future<void> updateInsight(InsightModel insight) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getInsightsCollectionRef(userId);
      await collectionRef.doc(insight.id).update(insight.toJson());
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de mise à jour de l\'insight: ${e.toString()}',
        code: 'update-insight-failed',
      );
    }
  }

  // ==================== REPORT OPERATIONS ====================

  /// Get reports collection reference for user
  CollectionReference<ReportModel> _getReportsCollectionRef(String userId) {
    return _firestore
        .collection(usersCollection)
        .doc(userId)
        .collection(reportsCollection)
        .withConverter<ReportModel>(
          fromFirestore: (snapshot, _) => ReportModel.fromJson(
            {...snapshot.data()!, 'id': snapshot.id},
          ),
          toFirestore: (report, _) => report.toJson(),
        );
  }

  /// Create a new report
  Future<ReportModel> createReport(ReportModel report) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        throw DatabaseException(
          message: 'Utilisateur non authentifié',
          code: 'unauthenticated',
        );
      }
      
      final collectionRef = _getReportsCollectionRef(userId);
      final docRef = collectionRef.doc();
      
      final reportWithId = report.copyWith(
        id: docRef.id,
        userId: userId,
        createdAt: DateTime.now(),
        isSynced: false,
      );
      
      await docRef.set(reportWithId);
      return reportWithId;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de création du rapport: ${e.toString()}',
        code: 'create-report-failed',
      );
    }
  }

  /// Get all reports for user
  Future<List<ReportModel>> getAllReports(String userId, {
    ReportType? type,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    String? orderBy,
    bool descending = true,
  }) async {
    try {
      final collectionRef = _getReportsCollectionRef(userId);
      
      Query<ReportModel> query = collectionRef;
      
      if (type != null) {
        query = query.where('type', isEqualTo: type.toString().split('.').last);
      }
      
      if (startDate != null) {
        query = query.where('periodStart', isGreaterThanOrEqualTo: startDate);
      }
      
      if (endDate != null) {
        query = query.where('periodEnd', isLessThanOrEqualTo: endDate);
      }
      
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      } else {
        query = query.orderBy('createdAt', descending: descending);
      }
      
      if (limit != null) {
        query = query.limit(limit);
      }
      
      final snapshot = await query.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération des rapports: ${e.toString()}',
        code: 'get-reports-failed',
      );
    }
  }

  // ==================== WEATHER OPERATIONS ====================

  /// Get weather collection reference
  CollectionReference<WeatherModel> _getWeatherCollectionRef() {
    return _firestore
        .collection(weatherCollection)
        .withConverter<WeatherModel>(
          fromFirestore: (snapshot, _) => WeatherModel.fromFirestore(snapshot),
          toFirestore: (weather, _) => weather.toFirestore(),
        );
  }

  /// Get weather by location and date
  Future<WeatherModel?> getWeatherByLocationAndDate(
    String locationId,
    DateTime date,
  ) async {
    try {
      final collectionRef = _getWeatherCollectionRef();
      
      // Normalize date to start of day
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day + 1);
      
      final query = collectionRef
          .where('locationId', isEqualTo: locationId)
          .where('dateTime', isGreaterThanOrEqualTo: startOfDay)
          .where('dateTime', isLessThan: endOfDay)
          .orderBy('dateTime', descending: true)
          .limit(1);
      
      final snapshot = await query.get();
      return snapshot.docs.isNotEmpty ? snapshot.docs.first.data() : null;
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de récupération de la météo: ${e.toString()}',
        code: 'get-weather-failed',
      );
    }
  }

  /// Create or update weather data
  Future<void> saveWeather(WeatherModel weather) async {
    try {
      final collectionRef = _getWeatherCollectionRef();
      
      // Create a composite ID: location + date
      final dateStr = '${weather.dateTime.year}-${weather.dateTime.month.toString().padLeft(2, '0')}-${weather.dateTime.day.toString().padLeft(2, '0')}';
      final compositeId = '${weather.locationId}_$dateStr';
      
      await collectionRef.doc(compositeId).set(weather);
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de sauvegarde de la météo: ${e.toString()}',
        code: 'save-weather-failed',
      );
    }
  }

  // ==================== BATCH OPERATIONS ====================

  /// Execute a batch operation
  Future<void> executeBatch(List<DatabaseOperation> operations) async {
    try {
      final batch = _firestore.batch();
      
      for (final operation in operations) {
        switch (operation.type) {
          case DatabaseOperationType.set:
            batch.set(operation.reference, operation.data);
            break;
          case DatabaseOperationType.update:
            batch.update(operation.reference, operation.data);
            break;
          case DatabaseOperationType.delete:
            batch.delete(operation.reference);
            break;
        }
      }
      
      await batch.commit();
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur d\'exécution du batch: ${e.toString()}',
        code: 'batch-failed',
      );
    }
  }

  // ==================== TRANSACTION OPERATIONS ====================

  /// Execute a transaction
  Future<T> executeTransaction<T>(
    DocumentReference reference,
    Future<T> Function(Transaction) handler,
  ) async {
    try {
      return await _firestore.runTransaction((transaction) async {
        return await handler(transaction);
      });
    } catch (e) {
      throw DatabaseException(
        message: 'Erreur de transaction: ${e.toString()}',
        code: 'transaction-failed',
      );
    }
  }
}

/// Database operation types
enum DatabaseOperationType {
  set,
  update,
  delete,
}

/// Database operation model
class DatabaseOperation {
  final DatabaseOperationType type;
  final DocumentReference reference;
  final Map<String, dynamic> data;

  DatabaseOperation({
    required this.type,
    required this.reference,
    this.data = const {},
  });
}
