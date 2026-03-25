import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../providers/habit_provider.dart';
import '../providers/gem_provider.dart';
import '../models/habit.dart';
import 'rewards_screen.dart';
import 'friends_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  int _totalCompleted(List<Habit> habits) {
    return habits.fold<int>(
        0, (sum, h) => sum + h.completionLog.values.where((v) => v).length);
  }

  int _bestStreak(List<Habit> habits) {
    if (habits.isEmpty) return 0;
    return habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
  }

  int _daysActive(List<Habit> habits) {
    final allDates = <String>{};
    for (final h in habits) {
      for (final entry in h.completionLog.entries) {
        if (entry.value) allDates.add(entry.key);
      }
    }
    return allDates.length;
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final user = context.watch<UserProvider>().user;
    final habits = context.watch<HabitProvider>().habits;
    final gem = context.watch<GemProvider>();
    final totalCompleted = _totalCompleted(habits);

    final tabs = [lang.tr(AppLocalizations.kActivityTab), lang.tr(AppLocalizations.kAchievements)];

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(lang.tr(AppLocalizations.kYourProfile), style: AppTextStyles.heading2.copyWith(color: context.textP)),
                  IconButton(
                    icon: Icon(Icons.settings_outlined, color: context.textP),
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.settings),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile info
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : '?',
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'User', style: AppTextStyles.heading3),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RewardsScreen()),
                        ),
                        child: Row(
                          children: [
                            Text(lang.tr(gem.levelName),
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.textS)),
                            const SizedBox(width: 8),
                            const Text('💎', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 4),
                            Text(
                              '${gem.totalGems}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.amber,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Friends button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FriendsScreen()),
                  ),
                  icon: const Icon(Icons.group_outlined),
                  label: Text(lang.tr(AppLocalizations.kFriends)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.border),
                ),
                child: Row(
                  children: [
                    _MiniStat(label: lang.tr(AppLocalizations.kHabits), value: '${habits.length}'),
                    _MiniStat(label: lang.tr(AppLocalizations.kCompleted), value: '$totalCompleted'),
                    _MiniStat(label: lang.tr(AppLocalizations.kBestStreak), value: '${_bestStreak(habits)}'),
                    _MiniStat(label: lang.tr(AppLocalizations.kDaysActive), value: '${_daysActive(habits)}'),
                  ],
                ),
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
                  children: List.generate(tabs.length, (i) {
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
                              tabs[i],
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
              const SizedBox(height: 20),

              if (_selectedTab == 0)
                _buildActivityTab(habits, totalCompleted, lang),
              if (_selectedTab == 1)
                _buildAchievementsTab(habits, totalCompleted, lang),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityTab(List<Habit> habits, int totalCompleted, LanguageProvider lang) {
    final activities = <_ActivityData>[];
    final now = DateTime.now();
    for (final h in habits) {
      if (h.isCompletedOn(now)) {
        activities.add(_ActivityData(
          text: '${h.emoji} ${h.name} ${lang.tr(AppLocalizations.kCompletedAction)}',
          time: lang.tr(AppLocalizations.kToday),
          icon: '✅',
        ));
      }
    }
    for (final h in habits) {
      if (h.currentStreak >= 3) {
        activities.add(_ActivityData(
          text: '${h.emoji} ${h.name} - ${h.currentStreak} ${lang.tr(AppLocalizations.kDayStreak)}!',
          time: lang.tr(AppLocalizations.kOngoing),
          icon: '🔥',
        ));
      }
    }
    if (activities.isEmpty) {
      activities.add(_ActivityData(
        text: lang.tr(AppLocalizations.kCompleteHabitToSee),
        time: '',
        icon: '💡',
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.tr(AppLocalizations.kRecentActivity), style: AppTextStyles.bodySmall),
        const SizedBox(height: 12),
        ...activities.map((a) => _ActivityItem(text: a.text, time: a.time, icon: a.icon)),
      ],
    );
  }

  Widget _buildAchievementsTab(List<Habit> habits, int totalCompleted, LanguageProvider lang) {
    final bestStreak = _bestStreak(habits);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AchievementCard(title: lang.tr(AppLocalizations.kAchFirstStep), subtitle: lang.tr(AppLocalizations.kAchFirstStepSub), emoji: '🏆', unlocked: totalCompleted >= 1),
        _AchievementCard(title: lang.tr(AppLocalizations.kAchGettingStarted), subtitle: lang.tr(AppLocalizations.kAchGettingStartedSub), emoji: '⭐', unlocked: totalCompleted >= 10),
        _AchievementCard(title: lang.tr(AppLocalizations.kAchConsistent), subtitle: lang.tr(AppLocalizations.kAchConsistentSub), emoji: '🔥', unlocked: bestStreak >= 3),
        _AchievementCard(title: lang.tr(AppLocalizations.kAchOnFire), subtitle: lang.tr(AppLocalizations.kAchOnFireSub), emoji: '💪', unlocked: bestStreak >= 7),
        _AchievementCard(title: lang.tr(AppLocalizations.kAchGemCollector), subtitle: lang.tr(AppLocalizations.kAchGemCollectorSub), emoji: '💎', unlocked: totalCompleted >= 50),
        _AchievementCard(title: lang.tr(AppLocalizations.kAchUnstoppable), subtitle: lang.tr(AppLocalizations.kAchUnstoppableSub), emoji: '👑', unlocked: bestStreak >= 30),
      ],
    );
  }
}

class _ActivityData {
  final String text;
  final String time;
  final String icon;
  _ActivityData({required this.text, required this.time, required this.icon});
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  const _MiniStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: context.textP)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.inter(fontSize: 11, color: context.textS)),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final String text;
  final String time;
  final String icon;
  const _ActivityItem({required this.text, required this.time, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.border),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: AppTextStyles.body.copyWith(color: context.textP)),
                if (time.isNotEmpty)
                  Text(time, style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final bool unlocked;
  const _AchievementCard({required this.title, required this.subtitle, required this.emoji, this.unlocked = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unlocked ? context.card : context.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: unlocked ? AppColors.green.withValues(alpha: 0.3) : context.border),
      ),
      child: Row(
        children: [
          Opacity(opacity: unlocked ? 1.0 : 0.3, child: Text(emoji, style: const TextStyle(fontSize: 28))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitle.copyWith(color: context.textP)),
                Text(subtitle, style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
              ],
            ),
          ),
          if (unlocked)
            const Icon(Icons.check_circle, color: AppColors.green, size: 22)
          else
            Icon(Icons.lock_outline, color: context.textH, size: 20),
        ],
      ),
    );
  }
}