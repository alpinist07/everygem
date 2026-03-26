import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
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
      final firstOfMonth = DateTime(now.year, now.month, 1);
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      for (int i = 0; i < daysInMonth; i++) {
        final date = firstOfMonth.add(Duration(days: i));
        if (date.isAfter(now)) break;
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
    return List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      int total = 0;
      int done = 0;
      for (final h in habits) {
        if (h.activeDays.contains(date.weekday)) {
          total++;
          if (h.isCompletedOn(date)) done++;
        }
      }
      return total > 0 ? done / total : 0.0;
    });
  }

  int _getBestStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final habitProvider = context.watch<HabitProvider>();
    final habits = habitProvider.habits;
    final stats = _getStats(habits);

    final tabLabels = [
      lang.tr(AppLocalizations.kDaily),
      lang.tr(AppLocalizations.kWeekly),
      lang.tr(AppLocalizations.kMonthly),
    ];
    final dayLabels = [
      lang.tr(AppLocalizations.kMon), lang.tr(AppLocalizations.kTue),
      lang.tr(AppLocalizations.kWed), lang.tr(AppLocalizations.kThu),
      lang.tr(AppLocalizations.kFri), lang.tr(AppLocalizations.kSat),
      lang.tr(AppLocalizations.kSun),
    ];

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
                  Text(lang.tr(AppLocalizations.kActivity),
                      style: AppTextStyles.heading2.copyWith(color: context.textP)),
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
                      child: Text(lang.tr(AppLocalizations.kDetails),
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
                  children: List.generate(tabLabels.length, (i) {
                    final isActive = i == _selectedTab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedTab = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              tabLabels[i],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : context.textS,
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
                                  ? lang.tr(AppLocalizations.kToday)
                                  : _selectedTab == 1
                                      ? lang.tr(AppLocalizations.kThisWeek)
                                      : lang.tr(AppLocalizations.kThisMonth),
                              style: AppTextStyles.subtitle.copyWith(color: context.textP),
                            ),
                            Text(lang.tr(AppLocalizations.kSummary),
                                style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _StatItem(
                            label: lang.tr(AppLocalizations.kCompleted),
                            value: '${stats['completed']}',
                            color: context.textP),
                        _StatItem(
                            label: lang.tr(AppLocalizations.kTotal),
                            value: '${stats['total']}',
                            color: AppColors.primary),
                        _StatItem(
                            label: lang.tr(AppLocalizations.kRate),
                            value: '${stats['rate']}%',
                            color: AppColors.green),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Overall stats gradient
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
                              style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(lang.tr(AppLocalizations.kActiveHabits),
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white24),
                    Expanded(
                      child: Column(
                        children: [
                          Text('${_getBestStreak(habits)}',
                              style: GoogleFonts.inter(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 4),
                          Text(lang.tr(AppLocalizations.kBestStreak),
                              style: GoogleFonts.inter(fontSize: 12, color: Colors.white70)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tab-specific content
              if (_selectedTab == 0)
                _DailyTabView(habits: habits, lang: lang)
              else if (_selectedTab == 1)
                _WeeklyTabView(
                  habits: habits,
                  weeklyRates: _getWeeklyRates(habits),
                  dayLabels: dayLabels,
                  lang: lang,
                )
              else
                _MonthlyTabView(habits: habits, dayLabels: dayLabels, lang: lang),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Daily Tab ────────────────────────────────────────────────────────────────

class _DailyTabView extends StatelessWidget {
  final List<Habit> habits;
  final LanguageProvider lang;

  const _DailyTabView({required this.habits, required this.lang});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final todayHabits = habits.where((h) => h.activeDays.contains(now.weekday)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.tr(AppLocalizations.kToday),
            style: AppTextStyles.subtitle.copyWith(color: context.textP)),
        const SizedBox(height: 12),
        if (todayHabits.isEmpty)
          _EmptyHabitsCard(lang: lang)
        else
          ...todayHabits.map((h) => _DailyHabitRow(habit: h, lang: lang)),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _DailyHabitRow extends StatelessWidget {
  final Habit habit;
  final LanguageProvider lang;

  const _DailyHabitRow({required this.habit, required this.lang});

  @override
  Widget build(BuildContext context) {
    final isCompleted = habit.isCompletedOn(DateTime.now());

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HabitStatsScreen(habit: habit)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCompleted
                ? AppColors.green.withValues(alpha: 0.35)
                : context.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: habit.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                  child: Text(habit.emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(habit.name,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: context.textP)),
                  const SizedBox(height: 2),
                  Text(
                    '${habit.currentStreak} ${lang.tr(AppLocalizations.kDayStreak)}',
                    style: AppTextStyles.bodySmall.copyWith(color: context.textS),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.green.withValues(alpha: 0.12)
                    : AppColors.amber.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    size: 14,
                    color: isCompleted ? AppColors.green : AppColors.amber,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCompleted
                        ? lang.tr(AppLocalizations.kCompleted)
                        : lang.tr(AppLocalizations.kPending),
                    style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isCompleted ? AppColors.green : AppColors.amber),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Weekly Tab ───────────────────────────────────────────────────────────────

class _WeeklyTabView extends StatelessWidget {
  final List<Habit> habits;
  final List<double> weeklyRates;
  final List<String> dayLabels;
  final LanguageProvider lang;

  const _WeeklyTabView({
    required this.habits,
    required this.weeklyRates,
    required this.dayLabels,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.tr(AppLocalizations.kThisWeek),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final date = monday.add(Duration(days: i));
              final isToday = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;
              final isFuture = date.isAfter(now);
              return _DayDot(
                label: dayLabels[i],
                dayNum: '${date.day}',
                rate: weeklyRates[i],
                isToday: isToday,
                isFuture: isFuture,
              );
            }),
          ),
        ),
        const SizedBox(height: 24),
        Text(lang.tr(AppLocalizations.kHabitDetails),
            style: AppTextStyles.subtitle.copyWith(color: context.textP)),
        const SizedBox(height: 12),
        if (habits.isEmpty)
          _EmptyHabitsCard(lang: lang)
        else
          ...habits.map((h) =>
              _WeeklyHabitRow(habit: h, dayLabels: dayLabels, lang: lang)),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _WeeklyHabitRow extends StatelessWidget {
  final Habit habit;
  final List<String> dayLabels;
  final LanguageProvider lang;

  const _WeeklyHabitRow(
      {required this.habit, required this.dayLabels, required this.lang});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    int weekCompleted = 0;
    int weekTotal = 0;
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      if (!date.isAfter(now) && habit.activeDays.contains(date.weekday)) {
        weekTotal++;
        if (habit.isCompletedOn(date)) weekCompleted++;
      }
    }
    final dots = List.generate(7, (i) {
      final date = monday.add(Duration(days: i));
      final isFuture = date.isAfter(now);
      final isScheduled = habit.activeDays.contains(date.weekday);
      final isCompleted = isScheduled && !isFuture && habit.isCompletedOn(date);

      return _MiniDot(
        isScheduled: isScheduled,
        isCompleted: isCompleted,
        isFuture: isFuture,
        label: dayLabels[i],
        color: habit.color,
      );
    });

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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child:
                          Text(habit.emoji, style: const TextStyle(fontSize: 18))),
                ),
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
                      Text(
                        '$weekCompleted/$weekTotal ${lang.tr(AppLocalizations.kThisWeekShort)}  •  ${habit.currentStreak} ${lang.tr(AppLocalizations.kDayStreak)}',
                        style:
                            AppTextStyles.bodySmall.copyWith(color: context.textS),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dots,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniDot extends StatelessWidget {
  final bool isScheduled;
  final bool isCompleted;
  final bool isFuture;
  final String label;
  final Color color;

  const _MiniDot({
    required this.isScheduled,
    required this.isCompleted,
    required this.isFuture,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget dotChild;
    late final Color dotColor;
    Border? border;

    if (!isScheduled) {
      dotColor = Colors.transparent;
      border = null;
      dotChild = Text('–',
          style: GoogleFonts.inter(
              fontSize: 10,
              color: context.textS.withValues(alpha: 0.35)));
    } else if (isFuture) {
      dotColor = Colors.transparent;
      border = Border.all(color: context.border);
      dotChild = const SizedBox.shrink();
    } else if (isCompleted) {
      dotColor = color.withValues(alpha: 0.15);
      dotChild = Icon(Icons.check, size: 12, color: color);
    } else {
      dotColor = context.bg;
      border = Border.all(color: context.border);
      dotChild = const SizedBox.shrink();
    }

    return Column(
      children: [
        Text(label,
            style: AppTextStyles.caption
                .copyWith(color: context.textS, fontSize: 10)),
        const SizedBox(height: 4),
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Center(child: dotChild),
        ),
      ],
    );
  }
}

// ─── Monthly Tab ──────────────────────────────────────────────────────────────

class _MonthlyTabView extends StatelessWidget {
  final List<Habit> habits;
  final List<String> dayLabels;
  final LanguageProvider lang;

  const _MonthlyTabView(
      {required this.habits, required this.dayLabels, required this.lang});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.tr(AppLocalizations.kThisMonth),
            style: AppTextStyles.subtitle.copyWith(color: context.textP)),
        const SizedBox(height: 12),
        _MonthlyCalendarView(habits: habits, dayLabels: dayLabels),
        const SizedBox(height: 24),
        Text(lang.tr(AppLocalizations.kHabitDetails),
            style: AppTextStyles.subtitle.copyWith(color: context.textP)),
        const SizedBox(height: 12),
        if (habits.isEmpty)
          _EmptyHabitsCard(lang: lang)
        else
          ...habits.map((h) => _MonthlyHabitBar(habit: h, lang: lang)),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _MonthlyCalendarView extends StatelessWidget {
  final List<Habit> habits;
  final List<String> dayLabels;

  const _MonthlyCalendarView(
      {required this.habits, required this.dayLabels});

  double _rateForDay(DateTime date) {
    int total = 0;
    int done = 0;
    for (final h in habits) {
      if (h.activeDays.contains(date.weekday)) {
        total++;
        if (h.isCompletedOn(date)) done++;
      }
    }
    return total > 0 ? done / total : -1.0; // -1 = no habits scheduled
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final startOffset = firstOfMonth.weekday - 1; // Mon=0
    final totalCells = startOffset + daysInMonth;
    final rowCount = (totalCells / 7).ceil();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        children: [
          // Day of week headers
          Row(
            children: dayLabels
                .map((d) => Expanded(
                      child: Center(
                        child: Text(d,
                            style: AppTextStyles.caption
                                .copyWith(color: context.textS)),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Week rows
          ...List.generate(rowCount, (row) {
            return Row(
              children: List.generate(7, (col) {
                final cellIndex = row * 7 + col;
                final dayNum = cellIndex - startOffset + 1;

                if (cellIndex < startOffset || dayNum > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }

                final date = DateTime(now.year, now.month, dayNum);
                final isFuture = date.isAfter(now);
                final isToday =
                    date.day == now.day && date.month == now.month;
                final rate = isFuture ? -2.0 : _rateForDay(date);

                Color dotColor;
                if (isFuture) {
                  dotColor = Colors.transparent;
                } else if (rate < 0) {
                  dotColor = Colors.transparent; // no habits that day
                } else if (rate >= 1.0) {
                  dotColor = AppColors.green.withValues(alpha: 0.2);
                } else if (rate > 0) {
                  dotColor = AppColors.amber.withValues(alpha: 0.2);
                } else {
                  dotColor = context.bg;
                }

                return Expanded(
                  child: Center(
                    child: Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                        border: isToday
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          '$dayNum',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: isToday
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isToday
                                ? AppColors.primary
                                : isFuture
                                    ? context.textS.withValues(alpha: 0.3)
                                    : context.textP,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }
}

class _MonthlyHabitBar extends StatelessWidget {
  final Habit habit;
  final LanguageProvider lang;

  const _MonthlyHabitBar({required this.habit, required this.lang});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstOfMonth = DateTime(now.year, now.month, 1);
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    int totalScheduled = 0;
    int completed = 0;
    for (int i = 0; i < daysInMonth; i++) {
      final date = firstOfMonth.add(Duration(days: i));
      if (date.isAfter(now)) break;
      if (habit.activeDays.contains(date.weekday)) {
        totalScheduled++;
        if (habit.isCompletedOn(date)) completed++;
      }
    }
    final rate = totalScheduled > 0 ? completed / totalScheduled : 0.0;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HabitStatsScreen(habit: habit)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: habit.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: Text(habit.emoji,
                          style: const TextStyle(fontSize: 18))),
                ),
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
                      Text(
                          '${habit.currentStreak} ${lang.tr(AppLocalizations.kDayStreak)}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: context.textS)),
                    ],
                  ),
                ),
                Text(
                  '$completed/$totalScheduled',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: habit.color),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: rate,
                backgroundColor: context.border,
                valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _EmptyHabitsCard extends StatelessWidget {
  final LanguageProvider lang;
  const _EmptyHabitsCard({required this.lang});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Center(
        child: Text(lang.tr(AppLocalizations.kNoHabitsYet),
            style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyles.caption.copyWith(color: context.textS)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22, fontWeight: FontWeight.w700, color: color)),
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
          style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.amber));
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
            border:
                isToday ? Border.all(color: AppColors.primary, width: 2) : null,
          ),
          child: child != null ? Center(child: child) : null,
        ),
      ],
    );
  }
}
