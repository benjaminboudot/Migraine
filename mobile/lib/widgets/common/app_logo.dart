import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_theme.dart';

/// App logo widget
class AppLogo extends StatelessWidget {
  final double size;
  final bool showName;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 64,
    this.showName = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: effectiveColor,
            borderRadius: BorderRadius.circular(size / 4),
          ),
          child: Center(
            child: Icon(
              Icons.healing,
              size: size * 0.6,
              color: Colors.white,
            ),
          ),
        ),
        
        if (showName) ...[
          const SizedBox(height: 8),
          Text(
            'Migraine Tracker',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: effectiveColor,
            ),
          ),
        ],
      ],
    );
  }
}

/// App icon widget (for app bar, etc.)
class AppIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const AppIcon({
    super.key,
    this.size = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(size / 4),
      ),
      child: Center(
        child: Icon(
          Icons.healing,
          size: size * 0.6,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// App name widget
class AppName extends StatelessWidget {
  final TextStyle? style;
  final bool showSubtitle;

  const AppName({
    super.key,
    this.style,
    this.showSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = style ?? theme.textTheme.titleLarge;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Migraine Tracker',
          style: effectiveStyle?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (showSubtitle)
          Text(
            'Suivez et analysez vos migraines',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
