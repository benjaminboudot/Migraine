import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_theme.dart';

/// Form number field widget
class FormNumberField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final double? initialValue;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<double>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool isRequired;
  final double? minValue;
  final double? maxValue;
  final int? decimalPlaces;
  final String? prefixText;
  final String? suffixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;

  const FormNumberField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.isOptional = false,
    this.isRequired = false,
    this.minValue,
    this.maxValue,
    this.decimalPlaces,
    this.prefixText,
    this.suffixText,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Create input formatter for decimal places
    List<TextInputFormatter> inputFormatters = [];
    
    if (decimalPlaces != null && decimalPlaces! > 0) {
      inputFormatters.add(
        _DecimalInputFormatter(decimalPlaces!),
      );
    } else {
      inputFormatters.add(
        FilteringTextInputFormatter.digitsOnly,
      );
    }

    return FormBuilderTextField(
      name: name,
      initialValue: initialValue != null ? _formatNumber(initialValue!) : null,
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value.replaceAll(',', '.'));
          onChanged?.call(number);
        } else {
          onChanged?.call(null);
        }
      },
      validator: (value) {
        if (validator != null) {
          if (value != null && value.isNotEmpty) {
            final number = double.tryParse(value.replaceAll(',', '.'));
            return validator!(number);
          }
          return validator!(null);
        }
        return null;
      },
      keyboardType: keyboardType ?? TextInputType.number,
      textInputAction: textInputAction,
      readOnly: readOnly,
      enabled: enabled,
      inputFormatters: inputFormatters,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        suffixText: suffixText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        helperText: helperText,
        errorText: errorText,
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
      ),
    );
  }

  /// Format number for display
  String _formatNumber(double value) {
    if (decimalPlaces != null && decimalPlaces! > 0) {
      return value.toStringAsFixed(decimalPlaces!);
    }
    return value.toStringAsFixed(0);
  }
}

/// Decimal input formatter
class _DecimalInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  _DecimalInputFormatter(this.decimalPlaces);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits and decimal point
    final newText = newValue.text.replaceAll(',', '.');
    
    // Check if the new text is valid
    if (newText.isEmpty) {
      return newValue.copyWith(text: newText);
    }

    // Check if the text contains only digits and at most one decimal point
    final decimalPointCount = newText.split('.').length - 1;
    final hasOnlyDigitsAndDecimal = RegExp(r'^[\d.]+$').hasMatch(newText);
    
    if (!hasOnlyDigitsAndDecimal || decimalPointCount > 1) {
      return oldValue;
    }

    // Check decimal places
    if (decimalPointCount == 1) {
      final parts = newText.split('.');
      if (parts[1].length > decimalPlaces) {
        return oldValue;
      }
    }

    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}

/// Form slider field
class FormSliderField extends StatelessWidget {
  final String name;
  final String label;
  final String? hint;
  final double? initialValue;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<double>? validator;
  final double min;
  final double max;
  final int? divisions;
  final String? displayValue;
  final bool readOnly;
  final bool enabled;

  const FormSliderField({
    super.key,
    required this.name,
    required this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.min = 0,
    this.max = 10,
    this.divisions,
    this.displayValue,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderSlider(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      min: min,
      max: max,
      divisions: divisions,
      readOnly: readOnly,
      enabled: enabled,
      activeColor: theme.colorScheme.primary,
      inactiveColor: theme.colorScheme.outlineVariant,
      thumbColor: theme.colorScheme.primary,
      overlayColor: theme.colorScheme.primary.withOpacity(0.2),
      numberFormat: displayValue != null 
          ? NumberFormat(displayValue!)
          : null,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 16,
        ),
        border: InputBorder.none,
        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        isDense: true,
      ),
    );
  }
}

/// Number format for slider display
class NumberFormat {
  final String format;

  NumberFormat(this.format);

  String formatValue(double value) {
    return format.replaceAll('{value}', value.toStringAsFixed(0));
  }
}

/// Form rating field (star rating)
class FormRatingField extends StatelessWidget {
  final String name;
  final String label;
  final String? hint;
  final double? initialValue;
  final ValueChanged<double?>? onChanged;
  final FormFieldValidator<double>? validator;
  final int starCount;
  final double starSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool readOnly;
  final bool enabled;

  const FormRatingField({
    super.key,
    required this.name,
    required this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.starCount = 5,
    this.starSize = 24,
    this.activeColor,
    this.inactiveColor,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveActiveColor = activeColor ?? theme.colorScheme.primary;
    final effectiveInactiveColor = inactiveColor ?? theme.colorScheme.outline;
    
    return FormBuilderField<double>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
            border: InputBorder.none,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
            errorText: field.errorText,
            isDense: true,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              starCount,
              (index) => GestureDetector(
                onTap: readOnly || !enabled
                    ? null
                    : () {
                        field.didChange((index + 1).toDouble());
                        onChanged?.call((index + 1).toDouble());
                      },
                child: Icon(
                  index < (field.value?.floor() ?? 0)
                      ? Icons.star
                      : Icons.star_outline,
                  size: starSize,
                  color: index < (field.value?.floor() ?? 0)
                      ? effectiveActiveColor
                      : effectiveInactiveColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
