import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/theme/app_theme.dart';

/// Form dropdown field widget
class FormDropdownField<T> extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final List<DropdownMenuItem<T>> items;
  final bool isOptional;
  final bool isRequired;
  final bool readOnly;
  final bool enabled;
  final bool isExpanded;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const FormDropdownField({
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
    this.isExpanded = true,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderDropdown<T>(
      name: name,
      initialValue: initialValue,
      onChanged: onChanged,
      validator: validator,
      items: items,
      readOnly: readOnly,
      enabled: enabled,
      isExpanded: isExpanded,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
      style: theme.textTheme.bodyMedium,
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 24,
      isDense: true,
      dropdownColor: theme.colorScheme.surface,
    );
  }
}

/// Form dropdown button (custom dropdown with better UI)
class FormDropdownButton<T> extends StatelessWidget {
  final String name;
  final String? label;
  final String? hint;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final List<DropdownMenuItem<T>> items;
  final bool isOptional;
  final bool isRequired;
  final bool readOnly;
  final bool enabled;
  final String? helperText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const FormDropdownButton({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.value,
    this.onChanged,
    this.validator,
    required this.items,
    this.isOptional = false,
    this.isRequired = false,
    this.readOnly = false,
    this.enabled = true,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderField<T>(
      name: name,
      initialValue: value,
      validator: validator,
      enabled: enabled,
      builder: (field) {
        final effectiveValue = field.value;
        final selectedItem = items.firstWhere(
          (item) => item.value == effectiveValue,
          orElse: () => items.first,
        );
        
        return InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            helperText: helperText,
            errorText: field.errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon ?? const Icon(Icons.arrow_drop_down),
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
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: effectiveValue,
              items: items,
              onChanged: readOnly || !enabled ? null : (value) {
                field.didChange(value);
                onChanged?.call(value);
              },
              isExpanded: true,
              isDense: true,
              icon: const SizedBox(), // Hide default icon, use suffixIcon instead
              style: theme.textTheme.bodyMedium,
            ),
          ),
        );
      },
    );
  }
}

/// Form searchable dropdown
class FormSearchableDropdown<T> extends StatefulWidget {
  final String name;
  final String? label;
  final String? hint;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final List<T> items;
  final String Function(T)? itemToString;
  final bool isOptional;
  final bool isRequired;
  final bool readOnly;
  final bool enabled;
  final String? helperText;
  final String? errorText;

  const FormSearchableDropdown({
    super.key,
    required this.name,
    this.label,
    this.hint,
    this.initialValue,
    this.onChanged,
    this.validator,
    required this.items,
    this.itemToString,
    this.isOptional = false,
    this.isRequired = false,
    this.readOnly = false,
    this.enabled = true,
    this.helperText,
    this.errorText,
  });

  @override
  State<FormSearchableDropdown<T>> createState() => _FormSearchableDropdownState<T>();
}

class _FormSearchableDropdownState<T> extends State<FormSearchableDropdown<T>> {
  List<T> _filteredItems = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return FormBuilderField<T>(
      name: widget.name,
      initialValue: widget.initialValue,
      validator: widget.validator,
      enabled: widget.enabled,
      builder: (field) {
        final effectiveValue = field.value;
        final selectedItem = widget.items.firstWhere(
          (item) => item == effectiveValue,
          orElse: () => null,
        );
        
        return InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            helperText: widget.helperText,
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
          child: PopupMenuButton<T>(
            itemBuilder: (context) {
              return _filteredItems.map((item) {
                return PopupMenuItem<T>(
                  value: item,
                  child: Text(
                    widget.itemToString != null
                        ? widget.itemToString!(item)
                        : item.toString(),
                  ),
                );
              }).toList();
            },
            onSelected: widget.readOnly || !widget.enabled ? null : (value) {
              field.didChange(value);
              widget.onChanged?.call(value);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItem != null
                        ? (widget.itemToString != null
                            ? widget.itemToString!(selectedItem)
                            : selectedItem.toString())
                        : widget.hint ?? '',
                    style: selectedItem != null
                        ? theme.textTheme.bodyMedium
                        : theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.search),
              ],
            ),
          ),
        );
      },
    );
  }
}
