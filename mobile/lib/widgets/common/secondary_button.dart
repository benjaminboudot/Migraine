import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Secondary button widget
class SecondaryButton extends StatelessWidget {
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

  const SecondaryButton({
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
    
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
    final effectiveForegroundColor = foregroundColor ?? theme.colorScheme.primary;
    
    final effectiveBorder = border ?? 
        (borderWidth != null && borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth!,
              )
            : Border.all(
                color: theme.colorScheme.outline,
                width: 1.5,
              ));
    
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(8);
    
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: isLoading || isDisabled || onPressed == null ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: effectiveBackgroundColor,
          foregroundColor: effectiveForegroundColor,
          elevation: elevation,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
          ),
          side: effectiveBorder,
          disabledForegroundColor: theme.colorScheme.onSurfaceVariant,
          disabledBorderColor: theme.colorScheme.outlineVariant,
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

/// Secondary icon button
class SecondaryIconButton extends StatelessWidget {
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

  const SecondaryIconButton({
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
    
    return SecondaryButton(
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
                  foregroundColor ?? theme.colorScheme.primary,
                ),
                strokeWidth: 2,
              ),
            )
          : Icon(
              icon,
              size: effectiveIconSize,
              color: iconColor ?? foregroundColor ?? theme.colorScheme.primary,
            ),
    );
  }
}

/// Secondary text button
class SecondaryTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const SecondaryTextButton({
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
    
    return SecondaryButton(
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

/// Text button (minimal style)
class TextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final bool isDisabled;
  final TextStyle? textStyle;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const TextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isDisabled = false,
    this.textStyle,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveColor = color ?? theme.colorScheme.primary;
    final effectiveFontSize = fontSize ?? theme.textTheme.labelLarge?.fontSize ?? 16;
    final effectiveFontWeight = fontWeight ?? FontWeight.bold;
    
    return TextButton(
      onPressed: isLoading || isDisabled || onPressed == null ? null : onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: isLoading
          ? SizedBox(
              width: effectiveFontSize,
              height: effectiveFontSize,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
                strokeWidth: 2,
              ),
            )
          : Text(
              text,
              style: textStyle ?? TextStyle(
                color: effectiveColor,
                fontSize: effectiveFontSize,
                fontWeight: effectiveFontWeight,
              ),
            ),
    );
  }
}
