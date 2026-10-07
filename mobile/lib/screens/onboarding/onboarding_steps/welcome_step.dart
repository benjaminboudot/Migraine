import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/theme_provider.dart';

/// Welcome step for onboarding
class WelcomeStep extends ConsumerWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Bienvenue dans Migraine Tracker',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Text(
          'Prenez le contrôle de vos migraines avec une application conçue pour vous aider à comprendre et gérer vos épisodes.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 32),
        
        // Features list
        _buildFeatureItem(
          context,
          icon: Icons.analytics,
          title: 'Analyse intelligente',
          description: 'Découvrez les facteurs déclencheurs potentiels',
        ),
        
        const SizedBox(height: 16),
        
        _buildFeatureItem(
          context,
          icon: Icons.calendar_today,
          title: 'Suivi quotidien',
          description: 'Enregistrez vos migraines et symptômes',
        ),
        
        const SizedBox(height: 16),
        
        _buildFeatureItem(
          context,
          icon: Icons.insights,
          title: 'Rapports détaillés',
          description: 'Visualisez vos progrès et tendances',
        ),
        
        const SizedBox(height: 16),
        
        _buildFeatureItem(
          context,
          icon: Icons.privacy_tip,
          title: 'Confidentialité',
          description: 'Vos données restent privées et sécurisées',
        ),
        
        const SizedBox(height: 24),
        
        // Medical disclaimer
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode 
                ? AppColors.grey800
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.info_outline,
                size: 24,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 8),
              Text(
                'Important',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cette application est un outil de suivi personnel et ne fournit pas de diagnostic médical. '
                'Consultez toujours un professionnel de santé pour toute question médicale.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a feature item
  Widget _buildFeatureItem(
    BuildContext context,
    {
      required IconData icon,
      required String title,
      required String description,
    }
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 28,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
