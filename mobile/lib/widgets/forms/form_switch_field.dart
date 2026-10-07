import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/theme/app_theme.dart';

/// Form switch field widget
class FormSwitchField extends StatelessWidget {
  final String name;
  final String label;
  final String? description;
  final bool? initialValue;
  final ValueChanged<bool?>? onChanged;
  final FormFieldValidator<bool>? validator;
  final bool readOnly;
  final bool enabled;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Widget? secondary;

  const FormSwitchField({
    super.key,
    required this.name,
    required this.label,
    this.description,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderSwitch(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      activeColor: activeColor ?? theme.colorScheme.primary,
      inactiveColor: inactiveColor ?? theme.colorScheme.outline,
      activeTrackColor: activeTrackColor ?? 
          theme.colorScheme.primary.withOpacity(0.5),
      inactiveTrackColor: inactiveTrackColor ?? 
          theme.colorScheme.outline.withOpacity(0.5),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: description != null
          ? Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      secondary: secondary,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

/// Form checkbox field
class FormCheckboxField extends StatelessWidget {
  final String name;
  final String label;
  final String? description;
  final bool? initialValue;
  final ValueChanged<bool?>? onChanged;
  final FormFieldValidator<bool>? validator;
  final bool readOnly;
  final bool enabled;
  final Color? activeColor;
  final Color? checkColor;
  final Color? fillColor;
  final Widget? secondary;

  const FormCheckboxField({
    super.key,
    required this.name,
    required this.label,
    this.description,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.enabled = true,
    this.activeColor,
    this.checkColor,
    this.fillColor,
    this.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderCheckbox(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      readOnly: readOnly,
      enabled: enabled,
      activeColor: activeColor ?? theme.colorScheme.primary,
      checkColor: checkColor ?? theme.colorScheme.onPrimary,
      fillColor: fillColor ?? 
          theme.colorScheme.primary.withOpacity(0.2),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: description != null
          ? Text(
              description!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : null,
      secondary: secondary,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

/// Form checkbox group (multiple checkboxes)
class FormCheckboxGroup<T> extends StatelessWidget {
  final String name;
  final String label;
  final String? description;
  final List<T>? initialValue;
  final ValueChanged<List<T>?>? onChanged;
  final FormFieldValidator<List<T>>? validator;
  final List<FormCheckboxGroupItem<T>> items;
  final bool readOnly;
  final bool enabled;
  final Color? activeColor;
  final Color? checkColor;
  final Color? fillColor;

  const FormCheckboxGroup({
    super.key,
    required this.name,
    required this.label,
    this.description,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.items,
    this.readOnly = false,
    this.enabled = true,
    this.activeColor,
    this.checkColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderField<List<T>>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        final selectedValues = field.value ?? [];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Column(
              children: items.map((item) {
                final isSelected = selectedValues.contains(item.value);
                
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: readOnly || !enabled
                      ? null
                      : (selected) {
                          final newValue = selected
                              ? [...selectedValues, item.value]
                              : selectedValues.where((v) => v != item.value).toList();
                          field.didChange(newValue);
                          onChanged?.call(newValue);
                        },
                  title: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: item.description != null
                      ? Text(
                          item.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  secondary: item.icon != null
                      ? Icon(
                          item.icon,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  activeColor: activeColor ?? theme.colorScheme.primary,
                  checkColor: checkColor ?? theme.colorScheme.onPrimary,
                  fillColor: fillColor ?? 
                      theme.colorScheme.primary.withOpacity(0.2),
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }).toList(),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Form radio group
class FormRadioGroup<T> extends StatelessWidget {
  final String name;
  final String label;
  final String? description;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final List<FormRadioGroupItem<T>> items;
  final bool readOnly;
  final bool enabled;
  final Color? activeColor;
  final Color? fillColor;

  const FormRadioGroup({
    super.key,
    required this.name,
    required this.label,
    this.description,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.items,
    this.readOnly = false,
    this.enabled = true,
    this.activeColor,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        final selectedValue = field.value;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  description!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            Column(
              children: items.map((item) {
                final isSelected = item.value == selectedValue;
                
                return RadioListTile<T>(
                  value: item.value,
                  groupValue: selectedValue,
                  onChanged: readOnly || !enabled
                      ? null
                      : (value) {
                          field.didChange(value);
                          onChanged?.call(value);
                        },
                  title: Text(
                    item.label,
                    style: theme.textTheme.bodyMedium,
                  ),
                  subtitle: item.description != null
                      ? Text(
                          item.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  secondary: item.icon != null
                      ? Icon(
                          item.icon,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  activeColor: activeColor ?? theme.colorScheme.primary,
                  fillColor: fillColor ?? 
                      theme.colorScheme.primary.withOpacity(0.2),
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                );
              }).toList(),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  field.errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Form multi-select field
class FormMultiSelectField<T> extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final List<T>? initialValue;
  final ValueChanged<List<T>?>? onChanged;
  final FormFieldValidator<List<T>>? validator;
  final List<MultiSelectItem<T>> items;
  final bool isOptional;
  final bool isRequired;
  final bool readOnly;
  final bool enabled;
  final String? helperText;
  final String? errorText;

  const FormMultiSelectField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.items,
    this.isOptional = false,
    this.isRequired = false,
    this.readOnly = false,
    this.enabled = true,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedValues = initialValue ?? [];
    
    return FormBuilderField<List<T>>(
      name: name,
      initialValue: selectedValues,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        final effectiveSelectedValues = field.value ?? [];
        
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            helperText: helperText,
            errorText: field.errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.outline,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            helperStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            isDense: true,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          child: Wrap(
            spacing: 8,
            children: items.map((item) {
              final isSelected = effectiveSelectedValues.contains(item.value);
              
              return FilterChip(
                label: Text(item.label),
                selected: isSelected,
                onSelected: readOnly || !enabled
                    ? null
                    : (selected) {
                        final newValue = selected
                            ? [...effectiveSelectedValues, item.value]
                            : effectiveSelectedValues.where((v) => v != item.value).toList();
                        field.didChange(newValue);
                        onChanged?.call(newValue);
                      },
                backgroundColor: theme.colorScheme.surface,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
                checkmarkColor: theme.colorScheme.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                side: BorderSide(
                  color: theme.colorScheme.outline,
                  width: 1,
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

/// Checkbox group item
class FormCheckboxGroupItem<T> {
  final T value;
  final String label;
  final String? description;
  final IconData? icon;

  FormCheckboxGroupItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });
}

/// Radio group item
class FormRadioGroupItem<T> {
  final T value;
  final String label;
  final String? description;
  final IconData? icon;

  FormRadioGroupItem({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });
}

/// Multi select item
class MultiSelectItem<T> {
  final T value;
  final String label;

  MultiSelectItem({
    required this.value,
    required this.label,
  });
}
