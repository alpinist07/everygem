import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';
import 'stats_detail_screen.dart';
import 'habit_stats_screen.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedTab = 1; // 0=Daily, 1=Weekly, 2=Monthly
  final _tabs = ['Daily', 'Weekly', 'Monthly'];

  Map<String, int> _getStats(List<Habit> habits) {
    final now = DateTime.now();
    int completed = 0;
    int total = 0;

    if (_selectedTab == 0) {
      for (final h in habits) {
        if (h.activeDays.contains(now.weekday)) {
          total++;
          if (h.isCompletedOn(now)) completed++;
        }
      }
    } else if (_selectedTab == 1) {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      for (int i = 0; i < 7; i++) {
        final date = startOfWeek.add(Duration(days: i));
        for (final h in habits) {
          if (h.activeDays.contains(date.weekday)) {
            total++;
            if (h.isCompletedOn(date)) completed++;
          }
        }
      }
    } else {
      final startOfMonth = DateTime(now.year, now.month, 1);
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 0; i < daysInMonth; i++) {
        final date = startOfMonth.add(Duration(days: i));
        for (final h in habits) {
          if (h.activeDays.contains(date.weekday)) {
            total++;
            if (h.isCompletedOn(date)) completed++;
          }
        }
      }
    }

    final rate = total > 0 ? ((completed / total) * 100).round() : 0;
    return {'completed': completed, 'total': total, 'rate': rate};
  }

  List<double> _getWeeklyRates(List<Habit> habits) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final rates = <double>[];

    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      int total = 0;
      int completed = 0;
      for (final h in habits) {
        if (h.activeDays.contains(date.weekday)) {
          total++;
          if (h.isCompletedOn(date)) completed++;
        }
      }
      rates.add(total > 0 ? completed / total : 0);
    }
    return rates;
  }

  int _getBestStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();
    final habits = habitProvider.habits;
    final stats = _getStats(habits);
    final weeklyRates = _getWeeklyRates(habits);

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Activity', style: AppTextStyles.heading2.copyWith(color: context.textP)),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StatsDetailScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Details',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.border),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: List.generate(_tabs.length, (i) {
                    final isActive = i == _selectedTab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[i],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isActive
                                    ? Colors.white
                                    : context.textS,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('😎', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedTab == 0
                                  ? 'Today'
                                  : _selectedTab == 1
                                      ? 'This Week'
                                      : 'This Month',
                              style: AppTextStyles.subtitle.copyWith(color: context.textP),
                            ),
                            Text('Summary', style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatItem(label: 'COMPLETED', value: '${stats['completed']}', color: context.textP),
                        _StatItem(label: 'TOTAL', value: '${stats['total']}', color: AppColors.primary),
                        _StatItem(label: 'RATE', value: '${stats['rate']}%', color: AppColors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Overall stats
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text('${habits.length}',
                              style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Active Habits', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white24),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_getBestStreak(habits)}',
                              style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Best Streak', style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Weekly streak calendar
              Text('This Week', style: AppTextStyles.subtitle.copyWith(color: context.textP)),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (i) {
                    final now = DateTime.now();
                    final monday = now.subtract(Duration(days: now.weekday - 1));
                    final date = monday.add(Duration(days: i));
                    final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
                    final isFuture = date.isAfter(now);

                    return _DayDot(
                      label: DateFormat('E').format(date)[0],
                      dayNum: '${date.day}',
                      rate: weeklyRates[i],
                      isToday: isToday,
                      isFuture: isFuture,
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Per-habit breakdown
              Text('Habit Details', style: AppTextStyles.subtitle.copyWith(color: context.textP)),
              const SizedBox(height: 12),
              if (habits.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: context.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.border),
                  ),
                  child: Center(
                    child: Text('No habits yet', style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
                  ),
                )
              else
                ...habits.map((habit) => _HabitDetailCard(habit: habit)),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: context.textS)),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

class _DayDot extends StatelessWidget {
  final String label;
  final String dayNum;
  final double rate;
  final bool isToday;
  final bool isFuture;

  const _DayDot({
    required this.label,
    required this.dayNum,
    required this.rate,
    this.isToday = false,
    this.isFuture = false,
  });

  @override
  Widget build(BuildContext context) {
    Color dotColor;
    Widget? child;

    if (isFuture) {
      dotColor = context.bg;
      child = null;
    } else if (rate >= 1.0) {
      dotColor = AppColors.green.withValues(alpha: 0.15);
      child = const Icon(Icons.check, color: AppColors.green, size: 16);
    } else if (rate > 0) {
      dotColor = AppColors.amber.withValues(alpha: 0.15);
      child = Text('${(rate * 100).round()}',
          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.amber));
    } else {
      dotColor = context.bg;
      child = null;
    }

    return Column(
      children: [
        Text(label, style: AppTextStyles.caption.copyWith(color: context.textS)),
        const SizedBox(height: 4),
        Text(dayNum,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: isToday ? AppColors.primary : context.textS,
            )),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: isToday ? Border.all(color: AppColors.primary, width: 2) : null,
          ),
          child: child != null ? Center(child: child) : null,
        ),
      ],
    );
  }
}

class _HabitDetailCard extends StatelessWidget {
  final Habit habit;

  const _HabitDetailCard({required this.habit});

  int get _last7Completed {
    int count = 0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (habit.isCompletedOn(now.subtract(Duration(days: i)))) count++;
    }
    return count;
  }

  int get _last7Active {
    int count = 0;
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (habit.activeDays.contains(now.subtract(Duration(days: i)).weekday)) count++;
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final active = _last7Active;
    final completed = _last7Completed;
    final rate = active > 0 ? completed / active : 0.0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HabitStatsScreen(habit: habit)),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: habit.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(habit.emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: context.textP)),
                const SizedBox(height: 2),
                Text('$completed/$active this week  •  ${habit.currentStreak} day streak',
                    style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: rate,
                  strokeWidth: 3,
                  backgroundColor: context.border,
                  valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                ),
                Text('${(rate * 100).round()}%',
                    style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: context.textP)),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}
