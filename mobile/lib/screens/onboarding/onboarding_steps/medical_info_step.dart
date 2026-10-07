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

/// Medical information step for onboarding
class MedicalInfoStep extends ConsumerStatefulWidget {
  const MedicalInfoStep({super.key});

  @override
  ConsumerState<MedicalInfoStep> createState() => _MedicalInfoStepState();
}

class _MedicalInfoStepState extends ConsumerState<MedicalInfoStep> {
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
            'Informations médicales',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Aidez-nous à comprendre votre historique de migraines',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Years with migraines
          FormNumberField(
            name: 'yearsWithMigraines',
            label: 'Depuis combien de temps souffrez-vous de migraines ?',
            hint: 'Nombre d\'années',
            initialValue: onboardingState.formData['yearsWithMigraines']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('yearsWithMigraines', value?.toInt());
            },
            minValue: 0,
            maxValue: 100,
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Typical migraine frequency
          FormNumberField(
            name: 'typicalMigraineFrequency',
            label: 'Fréquence habituelle des migraines',
            hint: 'Nombre de migraines par mois',
            initialValue: onboardingState.formData['typicalMigraineFrequency']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('typicalMigraineFrequency', value?.toInt());
            },
            minValue: 0,
            maxValue: 30,
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Typical migraine duration
          FormNumberField(
            name: 'typicalMigraineDuration',
            label: 'Durée habituelle des migraines',
            hint: 'Durée en heures',
            initialValue: onboardingState.formData['typicalMigraineDuration']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('typicalMigraineDuration', value);
            },
            minValue: 0,
            maxValue: 72,
            decimalPlaces: 1,
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Typical migraine intensity
          FormDropdownField<int>(
            name: 'typicalMigraineIntensity',
            label: 'Intensité habituelle des migraines',
            hint: 'Sur une échelle de 0 à 10',
            initialValue: onboardingState.formData['typicalMigraineIntensity'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('typicalMigraineIntensity', value);
            },
            items: List<DropdownMenuItem<int>>.generate(
              11,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(AppConstants.migraineIntensityLabels[index] ?? '$index'),
              ),
            ),
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Identified triggers
          FormMultiSelectField<String>(
            name: 'identifiedTriggers',
            label: 'Facteurs déclencheurs déjà identifiés',
            hint: 'Sélectionnez les facteurs que vous avez déjà identifiés',
            initialValue: onboardingState.formData['identifiedTriggers'] != null
                ? List<String>.from(onboardingState.formData['identifiedTriggers'])
                : null,
            onChanged: (value) {
              onboardingNotifier.updateFormData('identifiedTriggers', value);
            },
            items: AppConstants.migraineTriggers
                .map((trigger) => MultiSelectItem<String>(
                      value: trigger,
                      label: trigger,
                    ))
                .toList(),
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Family history
          FormDropdownField<bool>(
            name: 'familyHistory',
            label: 'Antécédents familiaux de migraines',
            hint: 'Avez-vous des antécédents familiaux ?',
            initialValue: onboardingState.formData['familyHistory'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('familyHistory', value);
            },
            items: const [
              DropdownMenuItem(
                value: true,
                child: Text('Oui'),
              ),
              DropdownMenuItem(
                value: false,
                child: Text('Non'),
              ),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Other conditions
          FormMultiSelectField<String>(
            name: 'otherConditions',
            label: 'Autres conditions médicales',
            hint: 'Sélectionnez les autres conditions que vous avez',
            initialValue: onboardingState.formData['otherConditions'] != null
                ? List<String>.from(onboardingState.formData['otherConditions'])
                : null,
            onChanged: (value) {
              onboardingNotifier.updateFormData('otherConditions', value);
            },
            items: [
              MultiSelectItem(value: 'Hypertension', label: 'Hypertension'),
              MultiSelectItem(value: 'Diabète', label: 'Diabète'),
              MultiSelectItem(value: 'Asthme', label: 'Asthme'),
              MultiSelectItem(value: 'Dépression', label: 'Dépression'),
              MultiSelectItem(value: 'Anxiété', label: 'Anxiété'),
              MultiSelectItem(value: 'Troubles du sommeil', label: 'Troubles du sommeil'),
              MultiSelectItem(value: 'Autre', label: 'Autre'),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Allergies
          FormTextField(
            name: 'allergies',
            label: 'Allergies',
            hint: 'Listez vos allergies, séparées par des virgules',
            initialValue: onboardingState.formData['allergies'],
            onChanged: (value) {
              onboardingNotifier.updateFormData(
                'allergies',
                value?.split(',')?.map((s) => s.trim())?.toList(),
              );
            },
            isOptional: true,
          ),
          
          const SizedBox(height: 8),
          
          // Note about medical information
          Text(
            'Ces informations sont optionnelles et ne seront pas partagées sans votre consentement.',
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

/// Multi select item for dropdown
class MultiSelectItem<T> {
  final T value;
  final String label;

  MultiSelectItem({
    required this.value,
    required this.label,
  });
}
