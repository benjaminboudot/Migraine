import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/constants/app_constants.dart';
import '../../../providers/onboarding_provider.dart';
import '../../../widgets/forms/form_text_field.dart';
import '../../../widgets/forms/form_number_field.dart';
import '../../../widgets/forms/form_dropdown_field.dart';
import '../../../widgets/forms/form_multi_select_field.dart';
import '../../../models/user_model.dart';

/// Lifestyle information step for onboarding
class LifestyleInfoStep extends ConsumerStatefulWidget {
  const LifestyleInfoStep({super.key});

  @override
  ConsumerState<LifestyleInfoStep> createState() => _LifestyleInfoStepState();
}

class _LifestyleInfoStepState extends ConsumerState<LifestyleInfoStep> {
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
            'Informations sur votre style de vie',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Ces informations nous aident à mieux comprendre vos habitudes',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Sleep schedule
          Text(
            'Sommeil',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormTextField(
            name: 'bedtime',
            label: 'Heure de coucher habituelle',
            hint: 'Ex: 22:30',
            initialValue: (onboardingState.formData['typicalSleepSchedule'] as Map<String, dynamic>?)?['bedtime'],
            onChanged: (value) {
              final sleepSchedule = onboardingState.formData['typicalSleepSchedule'] as Map<String, dynamic>? ?? {};
              sleepSchedule['bedtime'] = value;
              onboardingNotifier.updateFormData('typicalSleepSchedule', sleepSchedule);
            },
            keyboardType: TextInputType.text,
            isOptional: true,
          ),
          
          const SizedBox(height: 8),
          
          FormTextField(
            name: 'wakeupTime',
            label: 'Heure de réveil habituelle',
            hint: 'Ex: 07:00',
            initialValue: (onboardingState.formData['typicalSleepSchedule'] as Map<String, dynamic>?)?['wakeupTime'],
            onChanged: (value) {
              final sleepSchedule = onboardingState.formData['typicalSleepSchedule'] as Map<String, dynamic>? ?? {};
              sleepSchedule['wakeupTime'] = value;
              onboardingNotifier.updateFormData('typicalSleepSchedule', sleepSchedule);
            },
            keyboardType: TextInputType.text,
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Caffeine consumption
          Text(
            'Consommation de caféine',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormNumberField(
            name: 'cupsPerDay',
            label: 'Nombre de tasses par jour',
            hint: 'Ex: 2',
            initialValue: (onboardingState.formData['typicalCaffeineConsumption'] as Map<String, dynamic>?)?['cupsPerDay']?.toDouble(),
            onChanged: (value) {
              final caffeineConsumption = onboardingState.formData['typicalCaffeineConsumption'] as Map<String, dynamic>? ?? {};
              caffeineConsumption['cupsPerDay'] = value?.toInt();
              onboardingNotifier.updateFormData('typicalCaffeineConsumption', caffeineConsumption);
            },
            minValue: 0,
            maxValue: 20,
            isOptional: true,
          ),
          
          const SizedBox(height: 8),
          
          FormDropdownField<String>(
            name: 'caffeineSources',
            label: 'Sources de caféine',
            hint: 'Types de caféine consommés',
            initialValue: (onboardingState.formData['typicalCaffeineConsumption'] as Map<String, dynamic>?)?['sources']?.first,
            onChanged: (value) {
              if (value != null) {
                final caffeineConsumption = onboardingState.formData['typicalCaffeineConsumption'] as Map<String, dynamic>? ?? {};
                caffeineConsumption['sources'] = [value];
                onboardingNotifier.updateFormData('typicalCaffeineConsumption', caffeineConsumption);
              }
            },
            items: AppConstants.caffeineSources
                .map((source) => DropdownMenuItem(
                      value: source,
                      child: Text(source),
                    ))
                .toList(),
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Alcohol consumption
          Text(
            'Consommation d\'alcool',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormDropdownField<String>(
            name: 'alcoholFrequency',
            label: 'Fréquence',
            hint: 'Combien souvent ?',
            initialValue: (onboardingState.formData['typicalAlcoholConsumption'] as Map<String, dynamic>?)?['frequency'],
            onChanged: (value) {
              final alcoholConsumption = onboardingState.formData['typicalAlcoholConsumption'] as Map<String, dynamic>? ?? {};
              alcoholConsumption['frequency'] = value;
              onboardingNotifier.updateFormData('typicalAlcoholConsumption', alcoholConsumption);
            },
            items: const [
              DropdownMenuItem(value: 'never', child: Text('Jamais')),
              DropdownMenuItem(value: 'rarely', child: Text('Rarement')),
              DropdownMenuItem(value: 'occasionally', child: Text('Occasionnellement')),
              DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
              DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Work schedule
          Text(
            'Travail',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          FormDropdownField<String>(
            name: 'workFrequency',
            label: 'Fréquence de travail',
            hint: 'Combien de jours par semaine ?',
            initialValue: (onboardingState.formData['workSchedule'] as Map<String, dynamic>?)?['workDays']?.first?.toString(),
            onChanged: (value) {
              if (value != null) {
                final workSchedule = onboardingState.formData['workSchedule'] as Map<String, dynamic>? ?? {};
                workSchedule['workDays'] = [int.parse(value)];
                onboardingNotifier.updateFormData('workSchedule', workSchedule);
              }
            },
            items: const [
              DropdownMenuItem(value: '5', child: Text('5 jours (lundi-vendredi)')),
              DropdownMenuItem(value: '6', child: Text('6 jours')),
              DropdownMenuItem(value: '7', child: Text('7 jours')),
              DropdownMenuItem(value: 'variable', child: Text('Variable')),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Diet preferences
          FormMultiSelectField<String>(
            name: 'dietPreferences',
            label: 'Préférences alimentaires',
            hint: 'Sélectionnez vos préférences',
            initialValue: onboardingState.formData['dietPreferences'] != null
                ? List<String>.from(onboardingState.formData['dietPreferences'])
                : null,
            onChanged: (value) {
              onboardingNotifier.updateFormData('dietPreferences', value);
            },
            items: [
              MultiSelectItem(value: 'Végétarien', label: 'Végétarien'),
              MultiSelectItem(value: 'Végétalien', label: 'Végétalien'),
              MultiSelectItem(value: 'Sans gluten', label: 'Sans gluten'),
              MultiSelectItem(value: 'Sans lactose', label: 'Sans lactose'),
              MultiSelectItem(value: 'Autre', label: 'Autre'),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 8),
          
          // Note
          Text(
            'Ces informations sont optionnelles et peuvent être modifiées plus tard.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
