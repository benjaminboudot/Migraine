import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../core/theme/app_theme.dart';
import '../../models/migraine_model.dart';

/// Migraine trend chart widget
class MigraineTrendChart extends StatelessWidget {
  final List<MigraineModel> migraines;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool showLine;
  final bool showPoints;
  final bool showGrid;
  final Color? lineColor;
  final Color? pointColor;
  final Color? gridColor;

  const MigraineTrendChart({
    super.key,
    required this.migraines,
    this.startDate,
    this.endDate,
    this.showLine = true,
    this.showPoints = true,
    this.showGrid = true,
    this.lineColor,
    this.pointColor,
    this.gridColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Prepare chart data
    final chartData = _prepareChartData();
    
    if (chartData.isEmpty) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: showGrid,
          drawVerticalLine: true,
          drawHorizontalLine: true,
          verticalInterval: _calculateVerticalInterval(chartData),
          horizontalInterval: _calculateHorizontalInterval(chartData),
          getDrawingVerticalLine: (value) => FlLine(
            color: gridColor ?? theme.colorScheme.outlineVariant,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
          getDrawingHorizontalLine: (value) => FlLine(
            color: gridColor ?? theme.colorScheme.outlineVariant,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: gridColor ?? theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
        minX: 0,
        maxX: chartData.length.toDouble() - 1,
        minY: 0,
        maxY: _calculateMaxY(chartData),
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: true,
            color: lineColor ?? theme.colorScheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showPoints,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: pointColor ?? theme.colorScheme.primary,
                strokeWidth: 2,
                strokeColor: theme.colorScheme.surface,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: (lineColor ?? theme.colorScheme.primary).withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: theme.colorScheme.surface,
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date = _getDateFromIndex(spot.x.toInt());
                return LineTooltipItem(
                  '${_formatDate(date)}\n${spot.y.toInt()} migraines',
                  TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
          touchCallback: (touchEvent, touchResponse) {
            // Handle touch events if needed
          },
        ),
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Prepare chart data from migraines
  List<FlSpot> _prepareChartData() {
    if (migraines.isEmpty) return [];
    
    // Group migraines by date
    final dateCounts = <DateTime, int>{};
    for (final migraine in migraines) {
      final date = DateTime(
        migraine.startTime.year,
        migraine.startTime.month,
        migraine.startTime.day,
      );
      dateCounts[date] = (dateCounts[date] ?? 0) + 1;
    }
    
    // Sort dates
    final sortedDates = dateCounts.keys.toList()..sort();
    
    // Create chart spots
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dateCounts[sortedDates[i]]!.toDouble()));
    }
    
    return spots;
  }

  /// Get date from chart index
  DateTime _getDateFromIndex(int index) {
    if (migraines.isEmpty) return DateTime.now();
    
    final dateCounts = <DateTime, int>{};
    for (final migraine in migraines) {
      final date = DateTime(
        migraine.startTime.year,
        migraine.startTime.month,
        migraine.startTime.day,
      );
      dateCounts[date] = (dateCounts[date] ?? 0) + 1;
    }
    
    final sortedDates = dateCounts.keys.toList()..sort();
    return sortedDates[index.clamp(0, sortedDates.length - 1)];
  }

  /// Calculate max Y value
  double _calculateMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxY + 1; // Add some padding
  }

  /// Calculate vertical interval for grid
  double _calculateVerticalInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return maxY / 5; // Divide into 5 intervals
  }

  /// Calculate horizontal interval for grid
  double _calculateHorizontalInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;
    
    final count = spots.length;
    return count / 5; // Divide into 5 intervals
  }

  /// Format date for tooltip
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Migraine intensity chart
class MigraineIntensityChart extends StatelessWidget {
  final List<MigraineModel> migraines;
  final bool showLine;
  final bool showPoints;

  const MigraineIntensityChart({
    super.key,
    required this.migraines,
    this.showLine = true,
    this.showPoints = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Prepare chart data
    final chartData = _prepareChartData();
    
    if (chartData.isEmpty) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: chartData.length.toDouble() - 1,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: false,
            color: AppColors.secondary,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: showPoints,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 3,
                color: AppColors.secondary,
                strokeWidth: 1,
                strokeColor: theme.colorScheme.surface,
              ),
            ),
          ),
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Prepare chart data from migraines
  List<FlSpot> _prepareChartData() {
    if (migraines.isEmpty) return [];
    
    // Sort migraines by start time
    final sortedMigraines = [...migraines]..sort(
      (a, b) => a.startTime.compareTo(b.startTime),
    );
    
    // Create chart spots
    final spots = <FlSpot>[];
    for (int i = 0; i < sortedMigraines.length; i++) {
      spots.add(FlSpot(
        i.toDouble(),
        sortedMigraines[i].intensity.toDouble(),
      ));
    }
    
    return spots;
  }
}

/// Migraine duration chart
class MigraineDurationChart extends StatelessWidget {
  final List<MigraineModel> migraines;
  final bool showBars;
  final Color? barColor;

  const MigraineDurationChart({
    super.key,
    required this.migraines,
    this.showBars = true,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Prepare chart data
    final chartData = _prepareChartData();
    
    if (chartData.isEmpty) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        minY: 0,
        maxY: _calculateMaxY(chartData),
        barGroups: chartData,
      ),
      swapAnimationDuration: const Duration(milliseconds: 300),
    );
  }

  /// Prepare chart data from migraines
  List<BarChartGroupData> _prepareChartData() {
    if (migraines.isEmpty) return [];
    
    // Sort migraines by start time
    final sortedMigraines = [...migraines]..sort(
      (a, b) => a.startTime.compareTo(b.startTime),
    );
    
    // Create chart groups
    final groups = <BarChartGroupData>[];
    for (int i = 0; i < sortedMigraines.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: sortedMigraines[i].durationHours,
              color: barColor ?? AppColors.primary,
              width: 16,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
          ],
        ),
      );
    }
    
    return groups;
  }

  /// Calculate max Y value
  double _calculateMaxY(List<BarChartGroupData> groups) {
    if (groups.isEmpty) return 1;
    
    double maxY = 0;
    for (final group in groups) {
      for (final rod in group.barRods) {
        if (rod.toY > maxY) {
          maxY = rod.toY;
        }
      }
    }
    
    return maxY + 1; // Add some padding
  }
}

/// Heatmap chart for migraine frequency by day and hour
class MigraineHeatmapChart extends StatelessWidget {
  final List<MigraineModel> migraines;

  const MigraineHeatmapChart({super.key, required this.migraines});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Prepare heatmap data
    final heatmapData = _prepareHeatmapData();
    
    if (heatmapData.isEmpty) {
      return Center(
        child: Text(
          'Aucune donnée disponible',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    // For now, return a simple placeholder
    // In a real implementation, use a proper heatmap library
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.grid_view,
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Heatmap des migraines',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Jour × Heure',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Prepare heatmap data
  List<List<int>> _prepareHeatmapData() {
    if (migraines.isEmpty) return [];
    
    // Create a 7x24 matrix (days x hours)
    final matrix = List.generate(7, (_) => List<int>.filled(24, 0));
    
    for (final migraine in migraines) {
      final dayOfWeek = migraine.startTime.weekday - 1; // 0-6
      final hour = migraine.startTime.hour;
      
      if (dayOfWeek >= 0 && dayOfWeek < 7 && hour >= 0 && hour < 24) {
        matrix[dayOfWeek][hour]++;
      }
    }
    
    return matrix;
  }
}
