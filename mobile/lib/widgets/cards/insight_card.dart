import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/analysis_model.dart';

/// Insight card widget for displaying analysis insights
class InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final ConfidenceLevel confidenceLevel;
  final String? category;
  final String? dataPoints;
  final VoidCallback? onTap;
  final bool showChevron;

  const InsightCard({
    super.key,
    required this.title,
    required this.description,
    required this.confidenceLevel,
    this.category,
    this.dataPoints,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                  // Confidence indicator
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(confidenceLevel).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      confidenceLevel.displayName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getConfidenceColor(confidenceLevel),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Title
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Chevron
                  if (showChevron)
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              // Metadata
              if (category != null || dataPoints != null)
                Row(
                  children: [
                    if (category != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (dataPoints != null) ...[
                      Text(
                        '$dataPoints données',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
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

  /// Get confidence color
  Color _getConfidenceColor(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.insufficientData:
        return AppColors.error;
      case ConfidenceLevel.low:
        return AppColors.warning;
      case ConfidenceLevel.medium:
        return AppColors.primary;
      case ConfidenceLevel.high:
        return AppColors.success;
      case ConfidenceLevel.veryHigh:
        return AppColors.success;
    }
  }
}

/// Insight list widget
class InsightList extends StatelessWidget {
  final List<InsightCard> insights;
  final double spacing;

  const InsightList({
    super.key,
    required this.insights,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        insights.length,
        (index) {
          if (index > 0) {
            return Padding(
              padding: EdgeInsets.only(top: spacing),
              child: insights[index],
            );
          }
          return insights[index];
        },
      ),
    );
  }
}

/// Discovery card for "Mes découvertes" section
class DiscoveryCard extends StatelessWidget {
  final String title;
  final String description;
  final String? explanation;
  final ConfidenceLevel confidenceLevel;
  final int dataPoints;
  final List<String>? factors;
  final VoidCallback? onViewDetails;

  const DiscoveryCard({
    super.key,
    required this.title,
    required this.description,
    this.explanation,
    required this.confidenceLevel,
    required this.dataPoints,
    this.factors,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onViewDetails != null)
                  TextButton(
                    onPressed: onViewDetails,
                    child: const Text('Voir les détails'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Confidence and data points
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(confidenceLevel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Confiance: ${confidenceLevel.displayName}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getConfidenceColor(confidenceLevel),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '$dataPoints observations',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (factors != null && factors!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: factors!.map((factor) => Chip(
                  label: Text(factor),
                  backgroundColor: theme.colorScheme.primaryContainer,
                  labelStyle: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Get confidence color
  Color _getConfidenceColor(ConfidenceLevel level) {
    switch (level) {
      case ConfidenceLevel.insufficientData:
        return AppColors.error;
      case ConfidenceLevel.low:
        return AppColors.warning;
      case ConfidenceLevel.medium:
        return AppColors.primary;
      case ConfidenceLevel.high:
        return AppColors.success;
      case ConfidenceLevel.veryHigh:
        return AppColors.success;
    }
  }
}

/// Empty state card
class EmptyStateCard extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionText;

  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionText != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
