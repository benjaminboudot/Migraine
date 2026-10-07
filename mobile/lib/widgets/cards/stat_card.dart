import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

/// Stat card widget for displaying a single statistic
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? unit;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final Color? trendColor;
  final VoidCallback? onTap;
  final bool showBorder;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.unit,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendColor,
    this.onTap,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveTrendColor = trendColor ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: showBorder 
            ? BorderSide(color: theme.colorScheme.outlineVariant)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: effectiveIconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: effectiveIconColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        if (unit != null)
                          Text(
                            unit,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trend != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      trend,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: effectiveTrendColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large stat card for featured statistics
class LargeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final Color? trendColor;
  final VoidCallback? onTap;

  const LargeStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final effectiveTrendColor = trendColor ?? theme.colorScheme.onSurfaceVariant;

    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: effectiveIconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 24,
                        color: effectiveIconColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          value,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (trend != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      trend!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: effectiveTrendColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Mini stat card for compact display
class MiniStatCard extends StatelessWidget {
  final String value;
  final String? unit;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const MiniStatCard({
    super.key,
    required this.value,
    this.unit,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final effectiveIconColor = iconColor ?? theme.colorScheme.onSurface;
    final effectiveBackgroundColor = backgroundColor ?? 
        theme.colorScheme.surfaceVariant;

    return Card(
      elevation: 0,
      color: effectiveBackgroundColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: effectiveIconColor,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unit != null) ...[
                const SizedBox(width: 4),
                Text(
                  unit!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat row for horizontal layout
class StatRow extends StatelessWidget {
  final List<StatCard> children;
  final double spacing;

  const StatRow({
    super.key,
    required this.children,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        children.length,
        (index) {
          if (index > 0) {
            return Padding(
              padding: EdgeInsets.only(left: spacing),
              child: children[index],
            );
          }
          return children[index];
        },
      ),
    );
  }
}
