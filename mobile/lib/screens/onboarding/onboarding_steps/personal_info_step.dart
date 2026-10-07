import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../../core/constants/app_constants.dart';
import '../../../providers/onboarding_provider.dart';
import '../../../widgets/forms/form_text_field.dart';
import '../../../widgets/forms/form_number_field.dart';
import '../../../widgets/forms/form_dropdown_field.dart';
import '../../../models/user_model.dart';

/// Personal information step for onboarding
class PersonalInfoStep extends ConsumerStatefulWidget {
  const PersonalInfoStep({super.key});

  @override
  ConsumerState<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends ConsumerState<PersonalInfoStep> {
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
            'Informations personnelles',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Ces informations nous aident à personnaliser votre expérience',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // First name
          FormTextField(
            name: 'firstName',
            label: 'Prénom',
            hint: 'Votre prénom',
            initialValue: onboardingState.formData['firstName'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('firstName', value);
            },
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          
          // Last name
          FormTextField(
            name: 'lastName',
            label: 'Nom de famille',
            hint: 'Votre nom de famille',
            initialValue: onboardingState.formData['lastName'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('lastName', value);
            },
            textCapitalization: TextCapitalization.words,
          ),
          
          const SizedBox(height: 16),
          
          // Age
          FormNumberField(
            name: 'age',
            label: 'Âge',
            hint: 'Votre âge en années',
            initialValue: onboardingState.formData['age']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('age', value?.toInt());
            },
            minValue: 0,
            maxValue: 150,
          ),
          
          const SizedBox(height: 16),
          
          // Gender
          FormDropdownField<String>(
            name: 'gender',
            label: 'Genre',
            hint: 'Sélectionnez votre genre',
            initialValue: onboardingState.formData['gender'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('gender', value);
            },
            items: const [
              DropdownMenuItem(
                value: 'male',
                child: Text('Homme'),
              ),
              DropdownMenuItem(
                value: 'female',
                child: Text('Femme'),
              ),
              DropdownMenuItem(
                value: 'other',
                child: Text('Autre'),
              ),
              DropdownMenuItem(
                value: 'preferNotToSay',
                child: Text('Préfère ne pas dire'),
              ),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Height
          FormNumberField(
            name: 'height',
            label: 'Taille (cm)',
            hint: 'Votre taille en centimètres',
            initialValue: onboardingState.formData['height']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('height', value?.toInt());
            },
            minValue: 50,
            maxValue: 250,
            isOptional: true,
          ),
          
          const SizedBox(height: 16),
          
          // Weight
          FormNumberField(
            name: 'weight',
            label: 'Poids (kg)',
            hint: 'Votre poids en kilogrammes',
            initialValue: onboardingState.formData['weight']?.toDouble(),
            onChanged: (value) {
              onboardingNotifier.updateFormData('weight', value);
            },
            minValue: 10,
            maxValue: 300,
            isOptional: true,
            decimalPlaces: 1,
          ),
          
          const SizedBox(height: 16),
          
          // Timezone
          FormDropdownField<String>(
            name: 'timezone',
            label: 'Fuseau horaire',
            hint: 'Sélectionnez votre fuseau horaire',
            initialValue: onboardingState.formData['timezone'],
            onChanged: (value) {
              onboardingNotifier.updateFormData('timezone', value);
            },
            items: const [
              DropdownMenuItem(
                value: 'Europe/Paris',
                child: Text('Europe/Paris (UTC+1/UTC+2)'),
              ),
              DropdownMenuItem(
                value: 'Europe/Brussels',
                child: Text('Europe/Brussels (UTC+1/UTC+2)'),
              ),
              DropdownMenuItem(
                value: 'Europe/Zurich',
                child: Text('Europe/Zurich (UTC+1/UTC+2)'),
              ),
              DropdownMenuItem(
                value: 'America/New_York',
                child: Text('America/New_York (UTC-5/UTC-4)'),
              ),
              DropdownMenuItem(
                value: 'America/Los_Angeles',
                child: Text('America/Los_Angeles (UTC-8/UTC-7)'),
              ),
            ],
            isOptional: true,
          ),
          
          const SizedBox(height: 8),
          
          // Optional note
          Text(
            'Tous les champs sont facultatifs. Plus vous renseignez d\'informations, plus l\'application pourra vous aider.',
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
