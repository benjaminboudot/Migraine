import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/theme/app_theme.dart';

/// Form text field widget
class FormTextField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool isRequired;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? helperText;
  final String? errorText;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;
  final TextStyle? style;
  final TextAlign? textAlign;

  const FormTextField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.isOptional = false,
    this.isRequired = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.prefixIcon,
    this.suffixIcon,
    this.helperText,
    this.errorText,
    this.contentPadding,
    this.decoration,
    this.style,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      textInputAction: textInputAction,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      style: style ?? theme.textTheme.bodyMedium,
      textAlign: textAlign ?? TextAlign.start,
      decoration: decoration ?? InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(
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
}

/// Form password field
class FormPasswordField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool isRequired;
  final int? maxLength;
  final String? helperText;
  final String? errorText;

  const FormPasswordField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.isOptional = false,
    this.isRequired = false,
    this.maxLength,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: TextCapitalization.none,
      textInputAction: textInputAction,
      obscureText: true,
      readOnly: readOnly,
      enabled: enabled,
      maxLength: maxLength,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: const Icon(Icons.lock_outline),
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
}

/// Form email field
class FormEmailField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool isRequired;

  const FormEmailField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.isOptional = false,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      textCapitalization: TextCapitalization.none,
      textInputAction: textInputAction,
      readOnly: readOnly,
      enabled: enabled,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.email_outline),
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
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        isDense: true,
      ),
    );
  }
}

/// Form search field
class FormSearchField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onSubmitted;

  const FormSearchField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: textInputAction ?? TextInputAction.search,
      readOnly: readOnly,
      enabled: enabled,
      onSubmitted: onSubmitted,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
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
        errorStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.error,
        ),
        isDense: true,
      ),
    );
  }
}

/// Form multi-line text field
class FormMultilineTextField extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final bool enabled;
  final bool isOptional;
  final bool isRequired;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final String? helperText;
  final String? errorText;

  const FormMultilineTextField({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.readOnly = false,
    this.enabled = true,
    this.isOptional = false,
    this.isRequired = false,
    this.maxLength,
    this.maxLines = 3,
    this.minLines = 1,
    this.helperText,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization ?? TextCapitalization.sentences,
      textInputAction: textInputAction,
      readOnly: readOnly,
      enabled: enabled,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
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
        alignLabelWithHint: true,
      ),
    );
  }
}
