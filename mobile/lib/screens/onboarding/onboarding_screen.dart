import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../providers/onboarding_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/app_logo.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/secondary_button.dart';
import 'onboarding_steps/personal_info_step.dart';
import 'onboarding_steps/medical_info_step.dart';
import 'onboarding_steps/lifestyle_info_step.dart';
import 'onboarding_steps/welcome_step.dart';
import 'onboarding_steps/preferences_step.dart';

/// Onboarding screen for new users
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeOnboarding();
  }

  /// Initialize onboarding
  Future<void> _initializeOnboarding() async {
    // Check if onboarding is already completed
    final isCompleted = await ref.read(onboardingProvider.notifier).isOnboardingCompleted();
    if (isCompleted && mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Get the current step widget
  Widget _getCurrentStep() {
    final currentStep = ref.watch(currentOnboardingStepProvider);
    
    switch (currentStep) {
      case OnboardingStep.welcome:
        return const WelcomeStep();
      case OnboardingStep.personalInfo:
        return const PersonalInfoStep();
      case OnboardingStep.medicalInfo:
        return const MedicalInfoStep();
      case OnboardingStep.lifestyleInfo:
        return const LifestyleInfoStep();
      case OnboardingStep.preferences:
        return const PreferencesStep();
      case OnboardingStep.completed:
        // This should not happen in the onboarding screen
        return const SizedBox();
    }
  }

  /// Handle next button press
  Future<void> _handleNext() async {
    final currentStep = ref.read(currentOnboardingStepProvider);
    
    // Validate current step if it's a form
    if (currentStep != OnboardingStep.welcome && 
        currentStep != OnboardingStep.completed) {
      // In a real implementation, we would validate the form
      // For now, we'll just proceed
    }
    
    // Move to next step
    await ref.read(onboardingProvider.notifier).nextStep();
    
    // If we've completed onboarding, go to home
    final newStep = ref.read(currentOnboardingStepProvider);
    if (newStep == OnboardingStep.completed && mounted) {
      context.go(AppRoutes.home);
    }
  }

  /// Handle skip button press
  Future<void> _handleSkip() async {
    // Mark onboarding as completed
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  /// Handle back button press
  Future<void> _handleBack() async {
    final currentStep = ref.read(currentOnboardingStepProvider);
    
    if (currentStep.index > 0) {
      await ref.read(onboardingProvider.notifier).previousStep();
    } else {
      // If on first step, go back to splash or home
      if (mounted) {
        context.go(AppRoutes.splash);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentStep = ref.watch(currentOnboardingStepProvider);
    final progress = ref.watch(onboardingProgressProvider);
    final isLoading = ref.watch(isOnboardingLoadingProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep.index > 0 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleBack,
                tooltip: 'Retour',
              )
            : null,
        actions: [
          if (currentStep != OnboardingStep.completed)
            TextButton(
              onPressed: _handleSkip,
              child: Text(
                'Passer',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: progress / 100,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Step indicator
            Text(
              'Étape ${currentStep.index + 1} sur ${OnboardingStep.values.length - 1}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App logo (only on welcome step)
            if (currentStep == OnboardingStep.welcome)
              const AppLogo(size: 80),
            
            if (currentStep == OnboardingStep.welcome)
              const SizedBox(height: 24),
            
            // Current step content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _getCurrentStep(),
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  if (currentStep.index > 0)
                    Expanded(
                      child: SecondaryButton(
                        onPressed: _handleBack,
                        child: const Text('Précédent'),
                      ),
                    ),
                  if (currentStep.index > 0)
                    const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: isLoading ? null : _handleNext,
                      isLoading: isLoading,
                      child: Text(
                        currentStep == OnboardingStep.preferences 
                            ? 'Terminer' 
                            : 'Continuer',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
