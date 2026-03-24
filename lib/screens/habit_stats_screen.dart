import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/habit.dart';
import '../widgets/heatmap_calendar.dart';

class HabitStatsScreen extends StatelessWidget {
  final Habit habit;

  const HabitStatsScreen({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    final heatmapData = _buildHeatmapData();
    final weekdayStats = _weekdayStats();
    final totalDays = habit.completionLog.values.where((v) => v).length;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${habit.emoji} ${habit.name}',
            style: AppTextStyles.heading3.copyWith(color: context.textP)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary row
            Row(
              children: [
                _StatBox(
                    label: 'Total Days', value: '$totalDays', color: AppColors.primary),
                const SizedBox(width: 12),
                _StatBox(
                    label: 'Current Streak',
                    value: '${habit.currentStreak}',
                    color: AppColors.green),
                const SizedBox(width: 12),
                _StatBox(
                    label: 'Best Streak',
                    value: '${_bestStreak()}',
                    color: AppColors.amber),
              ],
            ),
            const SizedBox(height: 24),

            // Heatmap
            Text('Activity', style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.border),
              ),
              child: HeatmapCalendar(data: heatmapData),
            ),
            const SizedBox(height: 24),

            // Weekday breakdown
            Text('By Day of Week',
                style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.border),
              ),
              child: Column(
                children: weekdayStats.entries.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 32,
                          child: Text(e.key,
                              style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: context.textP)),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: e.value,
                              minHeight: 12,
                              backgroundColor: context.bg,
                              valueColor: AlwaysStoppedAnimation(
                                e.value >= 0.8
                                    ? AppColors.green
                                    : e.value >= 0.5
                                        ? AppColors.primary
                                        : AppColors.amber,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 36,
                          child: Text('${(e.value * 100).round()}%',
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: context.textS)),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Monthly completion rate
            Text('Monthly Rate',
                style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.border),
              ),
              child: Column(
                children: _monthlyRates()
                    .map((mr) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 60,
                                child: Text(mr['label'] as String,
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: context.textP)),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: mr['rate'] as double,
                                    minHeight: 10,
                                    backgroundColor: context.bg,
                                    valueColor: AlwaysStoppedAnimation(
                                        AppColors.primary),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 36,
                                child: Text(
                                    '${((mr['rate'] as double) * 100).round()}%',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: context.textS)),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Map<String, double> _buildHeatmapData() {
    final map = <String, double>{};
    for (final entry in habit.completionLog.entries) {
      map[entry.key] = entry.value ? 1.0 : 0.0;
    }
    return map;
  }

  int _bestStreak() {
    if (habit.completionLog.isEmpty) return 0;
    final keys = habit.completionLog.keys.toList()..sort();
    int best = 0, current = 0;
    DateTime? prev;
    for (final k in keys) {
      if (!(habit.completionLog[k] ?? false)) continue;
      final parts = k.split('-');
      final date = DateTime(
          int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      if (prev != null && date.difference(prev).inDays == 1) {
        current++;
      } else {
        current = 1;
      }
      if (current > best) best = current;
      prev = date;
    }
    return best;
  }

  Map<String, double> _weekdayStats() {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final counts = <int, int>{};
    final totals = <int, int>{};

    // Count last 12 weeks
    final now = DateTime.now();
    for (int i = 0; i < 84; i++) {
      final date = now.subtract(Duration(days: i));
      final wd = date.weekday;
      if (!habit.activeDays.contains(wd)) continue;
      totals[wd] = (totals[wd] ?? 0) + 1;
      if (habit.isCompletedOn(date)) {
        counts[wd] = (counts[wd] ?? 0) + 1;
      }
    }

    final result = <String, double>{};
    for (int d = 1; d <= 7; d++) {
      if (!habit.activeDays.contains(d)) continue;
      final total = totals[d] ?? 0;
      result[dayNames[d - 1]] = total > 0 ? (counts[d] ?? 0) / total : 0;
    }
    return result;
  }

  List<Map<String, dynamic>> _monthlyRates() {
    const monthNames = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final now = DateTime.now();
    final results = <Map<String, dynamic>>[];

    for (int i = 0; i < 6; i++) {
      final month = now.month - i;
      final year = now.year + (month <= 0 ? -1 : 0);
      final m = month <= 0 ? month + 12 : month;
      final daysInMonth = DateTime(year, m + 1, 0).day;

      int total = 0, completed = 0;
      for (int d = 1; d <= daysInMonth; d++) {
        final date = DateTime(year, m, d);
        if (date.isAfter(now)) break;
        if (date.isBefore(habit.createdAt.subtract(const Duration(days: 1)))) continue;
        if (!habit.activeDays.contains(date.weekday)) continue;
        total++;
        if (habit.isCompletedOn(date)) completed++;
      }

      results.add({
        'label': '${monthNames[m]} $year',
        'rate': total > 0 ? completed / total : 0.0,
      });
    }

    return results.reversed.toList();
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border),
        ),
        child: Column(
          children: [
            Text(value,
                style: GoogleFonts.inter(
                    fontSize: 24, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 10, color: context.textS),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
