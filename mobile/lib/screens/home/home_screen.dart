import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/common/primary_button.dart';
import '../dashboard/dashboard_screen.dart';
import '../migraine/add_migraine_screen.dart';
import '../journal/daily_journal_screen.dart';
import '../analysis/analysis_screen.dart';
import '../calendar/calendar_screen.dart';
import '../reports/reports_screen.dart';
import '../discoveries/discoveries_screen.dart';
import '../experiments/experiments_screen.dart';
import '../chat/chat_screen.dart';
import '../settings/settings_screen.dart';

/// Home screen with navigation
class HomeScreen extends ConsumerStatefulWidget {
  final Widget child;

  const HomeScreen({super.key, required this.child});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final isMigraineMode = ref.watch(migraineModeProvider);

    return Scaffold(
      backgroundColor: isMigraineMode 
          ? AppColors.migraineBg
          : theme.colorScheme.surface,
      body: widget.child,
      
      // Floating action button for adding migraine
      floatingActionButton: !isMigraineMode ? Padding(
        padding: const EdgeInsets.only(bottom: 70), // Space for bottom nav
        child: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.addMigraine);
          },
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
      ) : null,
      
      // Bottom navigation bar
      bottomNavigationBar: !isMigraineMode ? NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        surfaceTintColor: theme.colorScheme.primaryContainer,
        elevation: 8,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Navigate to the selected screen
          switch (index) {
            case 0:
              context.go(AppRoutes.dashboard);
              break;
            case 1:
              context.go(AppRoutes.migraines);
              break;
            case 2:
              context.go(AppRoutes.addMigraine);
              break;
            case 3:
              context.go(AppRoutes.analysis);
              break;
            case 4:
              context.go(AppRoutes.settings);
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Tableau de bord',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Migraines',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: 'Ajouter',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Analyses',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Paramètres',
          ),
        ],
      ) : null,
    );
  }
}
