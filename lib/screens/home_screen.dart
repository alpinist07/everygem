import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/gem_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/habit_card.dart';
import '../widgets/gem_popup.dart';
import 'add_habit_screen.dart';
import 'rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate;
  late List<DateTime> _weekDates;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _generateWeekDates();
  }

  void _generateWeekDates() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    _weekDates = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final userProvider = context.watch<UserProvider>();
    final habitProvider = context.watch<HabitProvider>();
    final gemProvider = context.watch<GemProvider>();
    final todayHabits = habitProvider.habitsForDate(_selectedDate);
    final completed = habitProvider.completedForDate(_selectedDate);

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
              // Greeting
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang.trWith(AppLocalizations.kHiUser, {'name': userProvider.user?.name ?? ''}),
                          style: AppTextStyles.heading2.copyWith(color: context.textP),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.tr(AppLocalizations.kLetsMakeHabits),
                          style: AppTextStyles.bodySmall.copyWith(color: context.textS),
                        ),
                      ],
                    ),
                  ),
                  // Gem balance
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RewardsScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('💎', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text('${gemProvider.totalGems}',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.amber)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      userProvider.user?.name.isNotEmpty == true
                          ? userProvider.user!.name[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Week day selector
              SizedBox(
                height: 72,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _weekDates.asMap().entries.map((entry) {
                    final i = entry.key;
                    final date = entry.value;
                    final isSelected = date.day == _selectedDate.day &&
                        date.month == _selectedDate.month;
                    final isToday = date.day == DateTime.now().day &&
                        date.month == DateTime.now().month;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: Container(
                        width: 42,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              dayLabels[i],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white70
                                    : context.textS,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${date.day}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight:
                                    isToday ? FontWeight.w700 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : context.textP,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Progress banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Text('🎯', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todayHabits.isEmpty
                                ? lang.tr(AppLocalizations.kAddFirstHabit)
                                : lang.trWith(AppLocalizations.kHabitsCompleted, {
                                    'completed': '$completed',
                                    'total': '${todayHabits.length}',
                                  }),
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lang.tr(AppLocalizations.kDailyGoalsAlmostDone),
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Habits section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.tr(AppLocalizations.kHabits), style: AppTextStyles.heading3.copyWith(color: context.textP)),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      lang.tr(AppLocalizations.kViewAll),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              if (todayHabits.isEmpty)
                _buildEmptyState(lang)
              else
                ...todayHabits.map((habit) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: HabitCard(
                        habit: habit,
                        date: _selectedDate,
                        onToggle: () async {
                          final wasCompleted = habit.isCompletedOn(_selectedDate);
                          await habitProvider.toggleHabitCompletion(
                              habit.id, _selectedDate);
                          if (!wasCompleted && context.mounted) {
                            final amount = await gemProvider.awardGems(
                              habitId: habit.id,
                              currentStreak: habit.currentStreak,
                            );
                            if (context.mounted) {
                              showGemPopup(context, amount);
                            }
                          }
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddHabitScreen(habit: habit),
                            ),
                          );
                        },
                        onDelete: () => _confirmDelete(context, habitProvider, habit, lang),
                      ),
                    )),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, HabitProvider provider, habit, LanguageProvider lang) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(lang.tr(AppLocalizations.kDeleteHabit)),
        content: Text(lang.trWith(AppLocalizations.kDeleteHabitConfirm, {'name': habit.name})),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.tr(AppLocalizations.kCancel)),
          ),
          TextButton(
            onPressed: () {
              provider.deleteHabit(habit.id);
              Navigator.pop(context);
            },
            child: Text(lang.tr(AppLocalizations.kDelete), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(LanguageProvider lang) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(
        children: [
          const Text('💎', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(lang.tr(AppLocalizations.kNoHabitsYet), style: AppTextStyles.subtitle.copyWith(color: context.textP)),
          const SizedBox(height: 8),
          Text(
            lang.tr(AppLocalizations.kTapToAddHabit),
            style: AppTextStyles.bodySmall.copyWith(color: context.textS),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.addHabit),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(lang.tr(AppLocalizations.kAddHabit)),
          ),
        ],
      ),
    );
  }
}