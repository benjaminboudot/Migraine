import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Primary button widget
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;
  final double? borderWidth;
  final Color? borderColor;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.borderWidth,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    final effectiveBackgroundColor = backgroundColor ?? 
        (isDisabled ? theme.colorScheme.surfaceVariant : theme.colorScheme.primary);
    
    final effectiveForegroundColor = foregroundColor ?? 
        (isDisabled ? theme.colorScheme.onSurfaceVariant : theme.colorScheme.onPrimary);
    
    final effectiveBorder = border ?? 
        (borderWidth != null && borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth!,
              )
            : null);
    
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(8);
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading || isDisabled || onPressed == null ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: elevation,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
            side: effectiveBorder ?? BorderSide.none,
          ),
          disabledBackgroundColor: theme.colorScheme.surfaceVariant,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    effectiveForegroundColor,
                  ),
                  strokeWidth: 2,
                ),
              )
            : child,
      ),
    );
  }
}

/// Primary icon button
class PrimaryIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double? iconSize;
  final Color? iconColor;
  final double? size;
  final bool isLoading;
  final bool isDisabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  const PrimaryIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconSize,
    this.iconColor,
    this.size,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveSize = size ?? 48;
    final effectiveIconSize = iconSize ?? effectiveSize * 0.5;
    
    return PrimaryButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: effectiveSize,
      height: effectiveSize,
      padding: EdgeInsets.zero,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      borderRadius: borderRadius,
      border: border,
      child: isLoading
          ? SizedBox(
              width: effectiveIconSize,
              height: effectiveIconSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  foregroundColor ?? theme.colorScheme.onPrimary,
                ),
                strokeWidth: 2,
              ),
            )
          : Icon(
              icon,
              size: effectiveIconSize,
              color: iconColor ?? foregroundColor ?? theme.colorScheme.onPrimary,
            ),
    );
  }
}

/// Primary text button (for text-only buttons)
class PrimaryTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const PrimaryTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return PrimaryButton(
      onPressed: onPressed,
      isLoading: isLoading,
      isDisabled: isDisabled,
      width: width,
      height: height,
      padding: padding,
      child: Text(
        text,
        style: textStyle ?? theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
