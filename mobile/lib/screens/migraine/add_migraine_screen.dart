import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/migraine_model.dart';
import '../../services/database/migraine_repository.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/secondary_button.dart';
import '../../widgets/forms/form_text_field.dart';
import '../../widgets/forms/form_number_field.dart';
import '../../widgets/forms/form_dropdown_field.dart';
import '../../widgets/forms/form_multi_select_field.dart';
import '../../widgets/forms/form_switch_field.dart';

/// Add/Edit Migraine Screen
/// This screen allows users to quickly record a migraine episode
class AddMigraineScreen extends ConsumerStatefulWidget {
  final MigraineModel? migraine;

  const AddMigraineScreen({super.key, this.migraine});

  @override
  ConsumerState<AddMigraineScreen> createState() => _AddMigraineScreenState();
}

class _AddMigraineScreenState extends ConsumerState<AddMigraineScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form state
  DateTime _startTime = DateTime.now();
  DateTime? _endTime;
  int _intensity = 5;
  List<String> _symptoms = [];
  MigraineSide? _side;
  String? _locationDescription;
  List<String> _perceivedTriggers = [];
  List<MigraineMedication> _medications = [];
  String? _notes;
  bool _hadAura = false;
  bool _requiredBedRest = false;
  bool _causedMissedWork = false;
  bool _causedMissedActivities = false;
  bool _menstrualRelated = false;

  // State
  bool _isLoading = false;
  bool _isOngoing = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing migraine data if editing
    if (widget.migraine != null) {
      _startTime = widget.migraine!.startTime;
      _endTime = widget.migraine!.endTime;
      _intensity = widget.migraine!.intensity;
      _symptoms = widget.migraine!.symptoms;
      _side = widget.migraine!.side;
      _locationDescription = widget.migraine!.locationDescription;
      _perceivedTriggers = widget.migraine!.perceivedTriggers;
      _medications = widget.migraine!.medications;
      _notes = widget.migraine!.notes;
      _hadAura = widget.migraine!.hadAura;
      _requiredBedRest = widget.migraine!.requiredBedRest;
      _causedMissedWork = widget.migraine!.causedMissedWork;
      _causedMissedActivities = widget.migraine!.causedMissedActivities;
      _menstrualRelated = widget.migraine!.menstrualRelated ?? false;
      _isOngoing = widget.migraine!.isOngoing;
    }
  }

  /// Save migraine
  Future<void> _saveMigraine() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final migraineRepo = ref.read(migraineRepositoryProvider);
      final userId = ref.read(userIdProvider);
      
      if (userId == null) {
        throw Exception('User not authenticated');
      }
      
      final migraine = MigraineModel(
        id: widget.migraine?.id,
        userId: userId,
        startTime: _startTime,
        endTime: _endTime,
        intensity: _intensity,
        side: _side,
        locationDescription: _locationDescription,
        symptoms: _symptoms,
        perceivedTriggers: _perceivedTriggers,
        medications: _medications,
        notes: _notes,
        hadAura: _hadAura,
        requiredBedRest: _requiredBedRest,
        causedMissedWork: _causedMissedWork,
        causedMissedActivities: _causedMissedActivities,
        menstrualRelated: _menstrualRelated,
        createdAt: widget.migraine?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      if (widget.migraine == null) {
        // Create new migraine
        await migraineRepo.createMigraine(migraine);
      } else {
        // Update existing migraine
        await migraineRepo.updateMigraine(migraine);
      }
      
      // Navigate back
      if (mounted) {
        context.pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de sauvegarde: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// End ongoing migraine
  Future<void> _endMigraine() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final migraineRepo = ref.read(migraineRepositoryProvider);
      
      if (widget.migraine != null) {
        await migraineRepo.endMigraine(
          widget.migraine!.id!,
          DateTime.now(),
        );
      }
      
      setState(() {
        _endTime = DateTime.now();
        _isOngoing = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Format time for display
  String _formatTime(DateTime time) {
    return DateFormat('HH:mm', 'fr_FR').format(time);
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final isMigraineMode = ref.watch(migraineModeProvider);
    
    return Scaffold(
      backgroundColor: isMigraineMode 
          ? AppColors.migraineBg
          : theme.colorScheme.surface,
      
      appBar: !isMigraineMode ? AppBar(
        title: Text(
          widget.migraine == null ? 'Nouvelle migraine' : 'Modifier la migraine',
        ),
        actions: [
          if (widget.migraine != null && _isOngoing)
            TextButton(
              onPressed: _endMigraine,
              child: const Text('Terminer'),
            ),
        ],
      ) : null,
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Quick entry section (for rapid entry)
              if (widget.migraine == null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Entrée rapide',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Intensity slider
                      Row(
                        children: [
                          Text(
                            'Intensité:',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Slider(
                              value: _intensity.toDouble(),
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: _intensity.toString(),
                              onChanged: (value) {
                                setState(() {
                                  _intensity = value.toInt();
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            _intensity.toString(),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Quick symptoms
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Douleur pulsatile',
                          'Nausées',
                          'Sensibilité à la lumière',
                          'Aura',
                        ].map((symptom) {
                          final isSelected = _symptoms.contains(symptom);
                          return FilterChip(
                            label: Text(symptom),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _symptoms.add(symptom);
                                } else {
                                  _symptoms.remove(symptom);
                                }
                              });
                            },
                            backgroundColor: theme.colorScheme.surface,
                            selectedColor: theme.colorScheme.primaryContainer,
                            labelStyle: theme.textTheme.bodySmall?.copyWith(
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                            ),
                            checkmarkColor: theme.colorScheme.onPrimaryContainer,
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Quick save button
                      PrimaryButton(
                        onPressed: _saveMigraine,
                        isLoading: _isLoading,
                        child: const Text('Enregistrer rapidement'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // Detailed entry section
              Text(
                'Détails de la migraine',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Start time
              Text(
                'Début',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Expanded(
                    child: FormTextField(
                      name: 'startDate',
                      label: 'Date',
                      initialValue: _formatDate(_startTime),
                      readOnly: true,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _startTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              _startTime.hour,
                              _startTime.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FormTextField(
                      name: 'startTime',
                      label: 'Heure',
                      initialValue: _formatTime(_startTime),
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                            hour: _startTime.hour,
                            minute: _startTime.minute,
                          ),
                        );
                        if (time != null) {
                          setState(() {
                            _startTime = DateTime(
                              _startTime.year,
                              _startTime.month,
                              _startTime.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // End time (if not ongoing)
              if (!_isOngoing || _endTime != null) ...[
                Text(
                  'Fin',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Expanded(
                      child: FormTextField(
                        name: 'endDate',
                        label: 'Date',
                        initialValue: _endTime != null ? _formatDate(_endTime!) : '',
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endTime ?? _startTime,
                            firstDate: _startTime,
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _endTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                _endTime?.hour ?? _startTime.hour,
                                _endTime?.minute ?? _startTime.minute,
                              );
                              _isOngoing = false;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FormTextField(
                        name: 'endTime',
                        label: 'Heure',
                        initialValue: _endTime != null ? _formatTime(_endTime!) : '',
                        readOnly: true,
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: _endTime?.hour ?? _startTime.hour,
                              minute: _endTime?.minute ?? _startTime.minute,
                            ),
                          );
                          if (time != null) {
                            setState(() {
                              _endTime = DateTime(
                                _endTime?.year ?? _startTime.year,
                                _endTime?.month ?? _startTime.month,
                                _endTime?.day ?? _startTime.day,
                                time.hour,
                                time.minute,
                              );
                              _isOngoing = false;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
              ],
              
              // Duration (auto-calculated)
              if (_endTime != null) ...[
                Text(
                  'Durée: ${_calculateDuration()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
              ],
              
              // Intensity
              FormNumberField(
                name: 'intensity',
                label: 'Intensité (0-10)',
                initialValue: _intensity.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _intensity = value?.toInt() ?? 0;
                  });
                },
                minValue: 0,
                maxValue: 10,
                validator: (value) {
                  if (value == null || value < 0 || value > 10) {
                    return 'Veuillez entrer une valeur entre 0 et 10';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Symptoms
              Text(
                'Symptômes',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              FormMultiSelectField<String>(
                name: 'symptoms',
                initialValue: _symptoms,
                onChanged: (value) {
                  setState(() {
                    _symptoms = value ?? [];
                  });
                },
                items: AppConstants.migraineSymptoms
                    .map((symptom) => MultiSelectItem(
                          value: symptom,
                          label: symptom,
                        ))
                    .toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Side
              FormDropdownField<MigraineSide?>(
                name: 'side',
                label: 'Côté de la douleur',
                initialValue: _side,
                onChanged: (value) {
                  setState(() {
                    _side = value;
                  });
                },
                items: const [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Non spécifié'),
                  ),
                  DropdownMenuItem(
                    value: MigraineSide.left,
                    child: Text('Côté gauche'),
                  ),
                  DropdownMenuItem(
                    value: MigraineSide.right,
                    child: Text('Côté droit'),
                  ),
                  DropdownMenuItem(
                    value: MigraineSide.both,
                    child: Text('Les deux côtés'),
                  ),
                  DropdownMenuItem(
                    value: MigraineSide.shifting,
                    child: Text('Change de côté'),
                  ),
                  DropdownMenuItem(
                    value: MigraineSide.whole,
                    child: Text('Toute la tête'),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Location description
              FormTextField(
                name: 'locationDescription',
                label: 'Localisation précise (optionnel)',
                hint: 'Ex: tempes, derrière l\'œil',
                initialValue: _locationDescription,
                onChanged: (value) {
                  setState(() {
                    _locationDescription = value;
                  });
                },
                isOptional: true,
              ),
              
              const SizedBox(height: 16),
              
              // Perceived triggers
              Text(
                'Facteurs déclencheurs (perception)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Ces facteurs sont enregistrés comme votre perception et sont séparés des corrélations calculées automatiquement.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              
              const SizedBox(height: 8),
              
              FormMultiSelectField<String>(
                name: 'perceivedTriggers',
                initialValue: _perceivedTriggers,
                onChanged: (value) {
                  setState(() {
                    _perceivedTriggers = value ?? [];
                  });
                },
                items: AppConstants.migraineTriggers
                    .map((trigger) => MultiSelectItem(
                          value: trigger,
                          label: trigger,
                        ))
                    .toList(),
              ),
              
              const SizedBox(height: 16),
              
              // Additional options
              Text(
                'Options supplémentaires',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 8),
              
              FormSwitchField(
                name: 'hadAura',
                label: 'Présence d\'aura',
                initialValue: _hadAura,
                onChanged: (value) {
                  setState(() {
                    _hadAura = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              FormSwitchField(
                name: 'requiredBedRest',
                label: 'Nécessité de repos au lit',
                initialValue: _requiredBedRest,
                onChanged: (value) {
                  setState(() {
                    _requiredBedRest = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              FormSwitchField(
                name: 'causedMissedWork',
                label: 'A causé un arrêt de travail',
                initialValue: _causedMissedWork,
                onChanged: (value) {
                  setState(() {
                    _causedMissedWork = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              FormSwitchField(
                name: 'causedMissedActivities',
                label: 'A causé un arrêt d\'activités',
                initialValue: _causedMissedActivities,
                onChanged: (value) {
                  setState(() {
                    _causedMissedActivities = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 8),
              
              FormSwitchField(
                name: 'menstrualRelated',
                label: 'Liée au cycle menstruel',
                initialValue: _menstrualRelated,
                onChanged: (value) {
                  setState(() {
                    _menstrualRelated = value ?? false;
                  });
                },
              ),
              
              const SizedBox(height: 16),
              
              // Notes
              FormTextField(
                name: 'notes',
                label: 'Notes',
                hint: 'Ajoutez des notes supplémentaires sur cette migraine',
                initialValue: _notes,
                onChanged: (value) {
                  setState(() {
                    _notes = value;
                  });
                },
                maxLines: 3,
                isOptional: true,
              ),
              
              const SizedBox(height: 24),
              
              // Save button
              PrimaryButton(
                onPressed: _saveMigraine,
                isLoading: _isLoading,
                child: Text(
                  widget.migraine == null 
                      ? 'Enregistrer la migraine' 
                      : 'Mettre à jour la migraine',
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Cancel button
              if (widget.migraine != null)
                SecondaryButton(
                  onPressed: () {
                    if (mounted) {
                      context.pop();
                    }
                  },
                  child: const Text('Annuler'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculate duration
  String _calculateDuration() {
    if (_endTime == null) return 'En cours';
    
    final duration = _endTime!.difference(_startTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return '$hours h $minutes min';
    } else if (hours > 0) {
      return '$hours h';
    } else if (minutes > 0) {
      return '$minutes min';
    }
    return '< 1 min';
  }
}
