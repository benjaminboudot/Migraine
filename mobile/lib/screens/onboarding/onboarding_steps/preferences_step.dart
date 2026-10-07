import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/constants/app_constants.dart';
import '../../../providers/onboarding_provider.dart';
import '../../../widgets/forms/form_switch_field.dart';
import '../../../widgets/forms/form_dropdown_field.dart';
import '../../../models/user_model.dart';

/// Preferences step for onboarding
class PreferencesStep extends ConsumerStatefulWidget {
  const PreferencesStep({super.key});

  @override
  ConsumerState<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends ConsumerState<PreferencesStep> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.read(onboardingProvider.notifier);
    
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Préférences',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Personnalisez votre expérience',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Notification preferences
          Text(
            'Notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'dailyReminders',
            label: 'Rappels quotidiens',
            description: 'Recevoir des rappels pour remplir votre journal quotidien',
            initialValue: onboardingState.formData['dailyReminders'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('dailyReminders', value);
            },
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'insightNotifications',
            label: 'Notifications de découvertes',
            description: 'Recevoir des notifications lorsque de nouvelles découvertes sont disponibles',
            initialValue: onboardingState.formData['insightNotifications'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('insightNotifications', value);
            },
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'weeklySummary',
            label: 'Résumé hebdomadaire',
            description: 'Recevoir un résumé hebdomadaire de vos migraines',
            initialValue: onboardingState.formData['weeklySummary'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('weeklySummary', value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Display preferences
          Text(
            'Affichage',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormDropdownField<String>(
            name: 'dateFormat',
            label: 'Format de date',
            hint: 'Format d\'affichage des dates',
            initialValue: onboardingState.formData['dateFormat'] ?? 'dd/MM/yyyy',
            onChanged: (value) {
              onboardingNotifier.updateFormData('dateFormat', value);
            },
            items: const [
              DropdownMenuItem(value: 'dd/MM/yyyy', child: Text('01/01/2024')),
              DropdownMenuItem(value: 'MM/dd/yyyy', child: Text('01/01/2024')),
              DropdownMenuItem(value: 'yyyy-MM-dd', child: Text('2024-01-01')),
            ],
          ),
          
          const SizedBox(height: 8),
          
          FormDropdownField<String>(
            name: 'timeFormat',
            label: 'Format de l\'heure',
            hint: 'Format d\'affichage des heures',
            initialValue: onboardingState.formData['timeFormat'] ?? 'HH:mm',
            onChanged: (value) {
              onboardingNotifier.updateFormData('timeFormat', value);
            },
            items: const [
              DropdownMenuItem(value: 'HH:mm', child: Text('14:30')),
              DropdownMenuItem(value: 'h:mm a', child: Text('02:30 PM')),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Other preferences
          Text(
            'Autres préférences',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'showMigraineModeConfirmation',
            label: 'Confirmer le mode migraine',
            description: 'Demander confirmation avant d\'activer le mode migraine',
            initialValue: onboardingState.formData['showMigraineModeConfirmation'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('showMigraineModeConfirmation', value);
            },
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'enableHapticFeedback',
            label: 'Retour haptique',
            description: 'Activer les vibrations pour les interactions',
            initialValue: onboardingState.formData['enableHapticFeedback'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('enableHapticFeedback', value);
            },
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'enableSoundEffects',
            label: 'Effets sonores',
            description: 'Activer les sons pour les interactions',
            initialValue: onboardingState.formData['enableSoundEffects'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('enableSoundEffects', value);
            },
          ),
          
          const SizedBox(height: 8),
          
          FormSwitchField(
            name: 'showMedicalDisclaimer',
            label: 'Afficher l\'avertissement médical',
            description: 'Afficher régulièrement l\'avertissement que cette application ne fournit pas de diagnostic',
            initialValue: onboardingState.formData['showMedicalDisclaimer'] ?? true,
            onChanged: (value) {
              onboardingNotifier.updateFormData('showMedicalDisclaimer', value);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Final note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vous pouvez modifier ces préférences à tout moment dans les paramètres.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
