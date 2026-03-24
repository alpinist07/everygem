import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/heatmap_calendar.dart';
import '../widgets/weekly_bar_chart.dart';
import '../widgets/monthly_trend_chart.dart';
import 'habit_stats_screen.dart';

class StatsDetailScreen extends StatelessWidget {
  const StatsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habits = context.watch<HabitProvider>().habits;
    final heatmapData = _buildHeatmap(habits);
    final weeklyRates = _weeklyRates(habits);
    final monthlyData = _monthlyTrendData(habits);
    final now = DateTime.now();
    final todayIndex = now.weekday - 1; // 0=Mon

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Detailed Stats',
            style: AppTextStyles.heading3.copyWith(color: context.textP)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall heatmap
            Text('Overview',
                style: AppTextStyles.subtitle.copyWith(color: context.textP)),
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

            // Weekly bar chart
            Text('This Week',
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
              child: WeeklyBarChart(
                rates: weeklyRates,
                todayIndex: todayIndex,
              ),
            ),
            const SizedBox(height: 24),

            // Monthly trend
            Text('Monthly Trend',
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
              child: MonthlyTrendChart(
                weeklyRates: monthlyData['rates'] as List<double>,
                weekLabels: monthlyData['labels'] as List<String>,
              ),
            ),
            const SizedBox(height: 24),

            // Per-habit list
            Text('Habits',
                style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            ...habits.map((h) => _HabitRow(habit: h)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Map<String, double> _buildHeatmap(List<Habit> habits) {
    final map = <String, double>{};
    final now = DateTime.now();
    for (int i = 0; i < 105; i++) {
      final date = now.subtract(Duration(days: i));
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      int total = 0, done = 0;
      for (final h in habits) {
        if (h.activeDays.contains(date.weekday)) {
          total++;
          if (h.isCompletedOn(date)) done++;
        }
      }
      map[key] = total > 0 ? done / total : 0;
    }
    return map;
  }

  List<double> _weeklyRates(List<Habit> habits) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      int total = 0, done = 0;
      for (final h in habits) {
        if (h.activeDays.contains(date.weekday)) {
          total++;
          if (h.isCompletedOn(date)) done++;
        }
      }
      return total > 0 ? done / total : 0;
    });
  }

  Map<String, dynamic> _monthlyTrendData(List<Habit> habits) {
    final now = DateTime.now();
    final rates = <double>[];
    final labels = <String>[];

    // Last 4 weeks
    for (int w = 3; w >= 0; w--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + w * 7));
      int total = 0, done = 0;
      for (int d = 0; d < 7; d++) {
        final date = weekStart.add(Duration(days: d));
        if (date.isAfter(now)) break;
        for (final h in habits) {
          if (h.activeDays.contains(date.weekday)) {
            total++;
            if (h.isCompletedOn(date)) done++;
          }
        }
      }
      rates.add(total > 0 ? done / total : 0);
      labels.add('W${4 - w}');
    }

    return {'rates': rates, 'labels': labels};
  }
}

class _HabitRow extends StatelessWidget {
  final Habit habit;
  const _HabitRow({required this.habit});

  @override
  Widget build(BuildContext context) {
    final total = habit.completionLog.values.where((v) => v).length;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HabitStatsScreen(habit: habit)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border),
        ),
        child: Row(
          children: [
            Text(habit.emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textP)),
                  Text('$total days  •  ${habit.currentStreak} streak',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: context.textS)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: context.textH, size: 20),
          ],
        ),
      ),
    );
  }
}
