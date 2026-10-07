import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/migraine_model.dart';
import '../../models/daily_log_model.dart';
import '../../services/database/migraine_repository.dart';
import '../../services/database/daily_log_repository.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/secondary_button.dart';
import '../../widgets/cards/stat_card.dart';
import '../../widgets/cards/insight_card.dart';
import '../../widgets/charts/migraine_trend_chart.dart';
import '../migraine/add_migraine_screen.dart';

/// Dashboard screen
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _isLoading = true;
  List<MigraineModel> _migraines = [];
  List<DailyLogModel> _dailyLogs = [];
  
  // Dashboard statistics
  int _daysWithoutMigraine = 0;
  int _migrainesThisMonth = 0;
  int _migrainesLastMonth = 0;
  double _averageIntensity = 0;
  double _averageDuration = 0;
  String _trend = 'stable';
  List<String> _topTriggers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Load data for dashboard
  Future<void> _loadData() async {
    try {
      final migraineRepo = ref.read(migraineRepositoryProvider);
      final dailyLogRepo = ref.read(dailyLogRepositoryProvider);
      
      // Get migraines for current month and last month
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month, 1);
      final lastMonthStart = DateTime(now.year, now.month - 1, 1);
      final lastMonthEnd = DateTime(now.year, now.month, 0);
      
      final currentMonthMigraines = await migraineRepo.getMigrainesByDateRange(
        currentMonthStart,
        now,
      );
      
      final lastMonthMigraines = await migraineRepo.getMigrainesByDateRange(
        lastMonthStart,
        lastMonthEnd,
      );
      
      // Get recent daily logs
      final recentLogs = await dailyLogRepo.getDailyLogsByDateRange(
        now.subtract(const Duration(days: 30)),
        now,
      );
      
      // Calculate statistics
      final stats = await migraineRepo.getMigraineStatistics(
        startDate: currentMonthStart,
        endDate: now,
      );
      
      setState(() {
        _migraines = [...currentMonthMigraines, ...lastMonthMigraines];
        _dailyLogs = recentLogs;
        _migrainesThisMonth = currentMonthMigraines.length;
        _migrainesLastMonth = lastMonthMigraines.length;
        _averageIntensity = stats.averageIntensity ?? 0;
        _averageDuration = stats.averageDurationMinutes != null 
            ? stats.averageDurationMinutes! / 60 
            : 0;
        
        // Calculate trend
        if (_migrainesLastMonth > 0) {
          final change = _migrainesThisMonth - _migrainesLastMonth;
          final percentage = (change / _migrainesLastMonth) * 100;
          if (percentage > 10) {
            _trend = 'increasing';
          } else if (percentage < -10) {
            _trend = 'decreasing';
          } else {
            _trend = 'stable';
          }
        }
        
        // Calculate days without migraine
        _calculateDaysWithoutMigraine();
        
        // Get top triggers
        _topTriggers = stats.triggerFrequency.entries
            .sortedBy<num>((e) => -e.value)
            .take(3)
            .map((e) => e.key)
            .toList();
        
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Calculate days without migraine
  void _calculateDaysWithoutMigraine() {
    if (_dailyLogs.isEmpty) {
      _daysWithoutMigraine = 0;
      return;
    }
    
    final now = DateTime.now();
    int consecutiveDays = 0;
    
    for (int i = 0; i < _dailyLogs.length; i++) {
      final log = _dailyLogs[i];
      final logDate = DateTime(log.date.year, log.date.month, log.date.day);
      final daysDiff = now.difference(logDate).inDays;
      
      if (daysDiff == 0 && !log.hadMigraine) {
        consecutiveDays++;
      } else if (daysDiff == 0 && log.hadMigraine) {
        break;
      }
    }
    
    _daysWithoutMigraine = consecutiveDays;
  }

  /// Get trend display
  String _getTrendDisplay() {
    switch (_trend) {
      case 'increasing':
        return '↑ en hausse';
      case 'decreasing':
        return '↓ en baisse';
      default:
        return '→ stable';
    }
  }

  /// Get trend color
  Color _getTrendColor(BuildContext context) {
    final theme = Theme.of(context);
    
    switch (_trend) {
      case 'increasing':
        return AppColors.error;
      case 'decreasing':
        return AppColors.success;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  /// Format number
  String _formatNumber(int number) {
    return NumberFormat('#,##0', 'fr_FR').format(number);
  }

  /// Format duration
  String _formatDuration(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    
    if (h > 0 && m > 0) {
      return '$h h $m min';
    } else if (h > 0) {
      return '$h h';
    } else if (m > 0) {
      return '$m min';
    }
    return '< 1 min';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final isMigraineMode = ref.watch(migraineModeProvider);
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: isMigraineMode 
          ? AppColors.migraineBg
          : theme.colorScheme.surface,
      
      appBar: !isMigraineMode ? AppBar(
        title: const AppName(showSubtitle: false),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Open notifications
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open search
            },
            tooltip: 'Rechercher',
          ),
        ],
      ) : null,
      
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome section
                  if (user != null) ...[
                    Text(
                      'Bonjour, ${user.firstName ?? user.displayName ?? "Utilisateur"}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Comment allez-vous aujourd\'hui ?',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Quick actions
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () {
                            context.push(AppRoutes.addMigraine);
                          },
                          child: const Text('J\'ai une migraine'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () {
                            // Quick action for "Je vais bien"
                          },
                          child: const Text('Je vais bien'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Stats section
                  Text(
                    'Votre activité récente',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Statistics cards
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Jours sans migraine',
                          value: _formatNumber(_daysWithoutMigraine),
                          icon: Icons.check_circle,
                          iconColor: AppColors.success,
                          trend: _daysWithoutMigraine > 0 ? '↑' : null,
                          trendColor: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Migraines ce mois',
                          value: _formatNumber(_migrainesThisMonth),
                          icon: Icons.calendar_today,
                          iconColor: theme.colorScheme.primary,
                          trend: _getTrendDisplay(),
                          trendColor: _getTrendColor(context),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'Intensité moyenne',
                          value: _averageIntensity.toStringAsFixed(1),
                          unit: '/10',
                          icon: Icons.analytics,
                          iconColor: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatCard(
                          title: 'Durée moyenne',
                          value: _formatDuration(_averageDuration),
                          icon: Icons.timer,
                          iconColor: theme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Comparison with last month
                  if (_migrainesLastMonth > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.compare_arrows,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Évolution par rapport au mois dernier',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${_formatNumber(_migrainesThisMonth)} migraines ce mois contre ${_formatNumber(_migrainesLastMonth)} le mois dernier',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  
                  // Current observations
                  if (_topTriggers.isNotEmpty) ...[
                    Text(
                      'Vos principaux facteurs associés',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    ..._topTriggers.map((trigger) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InsightCard(
                        title: trigger,
                        description: 'Facteur associé à vos migraines',
                        confidenceLevel: ConfidenceLevel.medium,
                        onTap: () {
                          // Show more details
                        },
                      ),
                    )).toList(),
                    
                    const SizedBox(height: 24),
                  ],
                  
                  // Chart section
                  Text(
                    'Tendance des migraines',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Trend chart
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MigraineTrendChart(
                      migraines: _migraines,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Quick access buttons
                  Text(
                    'Accès rapide',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () {
                            context.push(AppRoutes.dailyJournal);
                          },
                          child: const Text('Journal quotidien'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () {
                            context.push(AppRoutes.calendar);
                          },
                          child: const Text('Calendrier'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () {
                            context.push(AppRoutes.reports);
                          },
                          child: const Text('Rapports'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SecondaryButton(
                          onPressed: () {
                            context.push(AppRoutes.discoveries);
                          },
                          child: const Text('Mes découvertes'),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
      
      // Floating action button for quick migraine entry
      floatingActionButton: !isMigraineMode ? FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.addMigraine);
        },
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ) : null,
    );
  }
}

/// App name widget
class AppName extends StatelessWidget {
  final bool showSubtitle;

  const AppName({super.key, this.showSubtitle = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Migraine Tracker',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showSubtitle)
          Text(
            'Suivez et analysez vos migraines',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}

/// Provider for migraine repository
final migraineRepositoryProvider = Provider<MigraineRepository>((ref) {
  return MigraineRepository();
});

/// Provider for daily log repository
final dailyLogRepositoryProvider = Provider<DailyLogRepository>((ref) {
  return DailyLogRepository();
});
