import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/migraine/add_migraine_screen.dart';
import '../../screens/migraine/migraine_detail_screen.dart';
import '../../screens/migraine/migraine_list_screen.dart';
import '../../screens/journal/daily_journal_screen.dart';
import '../../screens/journal/journal_history_screen.dart';
import '../../screens/analysis/analysis_screen.dart';
import '../../screens/analysis/caffeine_analysis_screen.dart';
import '../../screens/analysis/weekend_analysis_screen.dart';
import '../../screens/reports/reports_screen.dart';
import '../../screens/reports/report_detail_screen.dart';
import '../../screens/calendar/calendar_screen.dart';
import '../../screens/discoveries/discoveries_screen.dart';
import '../../screens/experiments/experiments_screen.dart';
import '../../screens/experiments/experiment_detail_screen.dart';
import '../../screens/chat/chat_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/settings/profile_screen.dart';
import '../../screens/settings/privacy_screen.dart';
import '../../screens/settings/subscription_screen.dart';
import '../../widgets/migraine_mode_wrapper.dart';

// Route names
class AppRoutes {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const addMigraine = '/add-migraine';
  static const migraineDetail = '/migraine/:id';
  static const migraines = '/migraines';
  static const dailyJournal = '/daily-journal';
  static const journalHistory = '/journal-history';
  static const analysis = '/analysis';
  static const caffeineAnalysis = '/analysis/caffeine';
  static const weekendAnalysis = '/analysis/weekend';
  static const reports = '/reports';
  static const reportDetail = '/reports/:id';
  static const calendar = '/calendar';
  static const discoveries = '/discoveries';
  static const experiments = '/experiments';
  static const experimentDetail = '/experiments/:id';
  static const chat = '/chat';
  static const settings = '/settings';
  static const profile = '/settings/profile';
  static const privacy = '/settings/privacy';
  static const subscription = '/settings/subscription';
}

// Router provider
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isMigraineMode = ref.watch(migraineModeProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Public routes
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      // Auth shell route
      ShellRoute(
        builder: (context, state, child) {
          return isMigraineMode
              ? MigraineModeWrapper(child: child)
              : child;
        },
        routes: [
          // Main app shell
          ShellRoute(
            builder: (context, state, child) {
              return HomeScreen(child: child);
            },
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.dashboard,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashboardScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.addMigraine,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AddMigraineScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.migraineDetail,
                pageBuilder: (context, state) {
                  final id = state.pathParams['id']!;
                  return NoTransitionPage(
                    child: MigraineDetailScreen(migraineId: id),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.migraines,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: MigraineListScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.dailyJournal,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DailyJournalScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.journalHistory,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: JournalHistoryScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.analysis,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: AnalysisScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.caffeineAnalysis,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CaffeineAnalysisScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.weekendAnalysis,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: WeekendAnalysisScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.reports,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ReportsScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.reportDetail,
                pageBuilder: (context, state) {
                  final id = state.pathParams['id']!;
                  return NoTransitionPage(
                    child: ReportDetailScreen(reportId: id),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.calendar,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CalendarScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.discoveries,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DiscoveriesScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.experiments,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ExperimentsScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.experimentDetail,
                pageBuilder: (context, state) {
                  final id = state.pathParams['id']!;
                  return NoTransitionPage(
                    child: ExperimentDetailScreen(experimentId: id),
                  );
                },
              ),
              GoRoute(
                path: AppRoutes.chat,
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ChatScreen(),
                ),
              ),
            ],
          ),

          // Settings routes (outside main shell)
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.privacy,
            builder: (context, state) => const PrivacyScreen(),
          ),
          GoRoute(
            path: AppRoutes.subscription,
            builder: (context, state) => const SubscriptionScreen(),
          ),
        ],
      ),
    ],

    // Redirect logic
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isOnAuthPage = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup ||
          state.matchedLocation == AppRoutes.onboarding;
      final isOnSplash = state.matchedLocation == AppRoutes.splash;

      // Allow splash screen to load
      if (isOnSplash) {
        return null;
      }

      // If not logged in and not on auth page, redirect to login
      if (!isLoggedIn && !isOnAuthPage) {
        return AppRoutes.login;
      }

      // If logged in and on auth page, redirect to home
      if (isLoggedIn && isOnAuthPage) {
        return AppRoutes.home;
      }

      return null;
    },

    // Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page non trouvée',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              state.error?.message ?? 'Une erreur est survenue',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});

// Provider for migraine mode
final migraineModeProvider = StateProvider<bool>((ref) => false);

// Navigation service for programmatic navigation
class AppNavigation {
  static final _navigatorKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static BuildContext? get context => _navigatorKey.currentContext;

  static void pop({dynamic result}) {
    if (context != null) {
      Navigator.of(context!).pop(result);
    }
  }

  static Future<T?> push<T>(Widget page, {bool fullscreenDialog = false}) {
    if (context != null) {
      return Navigator.of(context!).push<T>(
        MaterialPageRoute(
          builder: (_) => page,
          fullscreenDialog: fullscreenDialog,
        ),
      );
    }
    return Future.value(null);
  }

  static Future<T?> pushReplacement<T>(Widget page) {
    if (context != null) {
      return Navigator.of(context!).pushReplacement<T>(
        MaterialPageRoute(builder: (_) => page),
      );
    }
    return Future.value(null);
  }

  static Future<T?> pushAndRemoveUntil<T>(Widget page, bool Function(Route<dynamic>) predicate) {
    if (context != null) {
      return Navigator.of(context!).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        predicate,
      );
    }
    return Future.value(null);
  }

  static void showDialog(Widget child, {bool barrierDismissible = true}) {
    if (context != null) {
      showDialog(
        context: context!,
        barrierDismissible: barrierDismissible,
        builder: (_) => child,
      );
    }
  }

  static void showBottomSheet(Widget child, {bool isScrollControlled = false}) {
    if (context != null) {
      showModalBottomSheet(
        context: context!,
        isScrollControlled: isScrollControlled,
        builder: (_) => child,
      );
    }
  }
}
