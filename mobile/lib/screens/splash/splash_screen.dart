import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/app_logo.dart';

/// Splash screen displayed when the app starts
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize the app by checking authentication state
  Future<void> _initializeApp() async {
    // Wait a moment to show the splash screen
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Check authentication state
    final authState = ref.read(authStateProvider);
    
    if (authState.status == AuthStatus.authenticated) {
      // Check if onboarding is completed
      // In a real implementation, we would check this from the user data
      // For now, we'll assume it's completed if user exists
      if (context.mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      // Check if we need to show onboarding
      // In a real implementation, we would check this from shared preferences
      // For now, we'll always show onboarding for new users
      if (context.mounted) {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    return Scaffold(
      backgroundColor: isDarkMode 
          ? theme.colorScheme.surface
          : theme.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            const AppLogo(size: 120),
            
            const SizedBox(height: 32),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDarkMode 
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App name
            Text(
              'Migraine Tracker',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDarkMode 
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onPrimaryContainer,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Suivez et analysez vos migraines',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDarkMode 
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
