import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/habit_provider.dart';

class _SuggestedHabit {
  final String emoji;
  final String nameKey;
  final String detailKey;
  final Color bgColor;
  final Color habitColor;

  const _SuggestedHabit({
    required this.emoji,
    required this.nameKey,
    required this.detailKey,
    required this.bgColor,
    required this.habitColor,
  });
}

const _allSuggestions = <_SuggestedHabit>[
  _SuggestedHabit(emoji: '💧', nameKey: AppLocalizations.kSugDrinkWater, detailKey: AppLocalizations.kSugDetail8Glasses, bgColor: Color(0xFFE8F4FD), habitColor: Color(0xFF3B82F6)),
  _SuggestedHabit(emoji: '🏃', nameKey: AppLocalizations.kSugWalk, detailKey: AppLocalizations.kSugDetail10kSteps, bgColor: Color(0xFFFDE8E8), habitColor: Color(0xFFEF4444)),
  _SuggestedHabit(emoji: '🏊', nameKey: AppLocalizations.kSugSwim, detailKey: AppLocalizations.kSugDetail30min, bgColor: Color(0xFFE8E8FD), habitColor: Color(0xFF4B3FF5)),
  _SuggestedHabit(emoji: '📕', nameKey: AppLocalizations.kSugRead, detailKey: AppLocalizations.kSugDetail20min, bgColor: Color(0xFFFDEFE8), habitColor: Color(0xFFF5A623)),
  _SuggestedHabit(emoji: '🧘', nameKey: AppLocalizations.kSugMeditate, detailKey: AppLocalizations.kSugDetail10min, bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E)),
  _SuggestedHabit(emoji: '💪', nameKey: AppLocalizations.kSugExercise, detailKey: AppLocalizations.kSugDetail30min, bgColor: Color(0xFFFDE8F4), habitColor: Color(0xFFEC4899)),
  _SuggestedHabit(emoji: '😴', nameKey: AppLocalizations.kSugSleepEarly, detailKey: AppLocalizations.kSugDetailBefore11, bgColor: Color(0xFFF0E8FD), habitColor: Color(0xFF8B5CF6)),
  _SuggestedHabit(emoji: '📝', nameKey: AppLocalizations.kSugJournal, detailKey: AppLocalizations.kSugDetail5min, bgColor: Color(0xFFFDFDE8), habitColor: Color(0xFFF5A623)),
  _SuggestedHabit(emoji: '🍎', nameKey: AppLocalizations.kSugEatFruits, detailKey: AppLocalizations.kSugDetail2Servings, bgColor: Color(0xFFE8FDF0), habitColor: Color(0xFF22C55E)),
  _SuggestedHabit(emoji: '🧹', nameKey: AppLocalizations.kSugCleanUp, detailKey: AppLocalizations.kSugDetail15min, bgColor: Color(0xFFE8F0FD), habitColor: Color(0xFF14B8A6)),
  _SuggestedHabit(emoji: '🎵', nameKey: AppLocalizations.kSugPracticeMusic, detailKey: AppLocalizations.kSugDetail20min, bgColor: Color(0xFFFDE8EF), habitColor: Color(0xFFEC4899)),
  _SuggestedHabit(emoji: '🌿', nameKey: AppLocalizations.kSugGoOutside, detailKey: AppLocalizations.kSugDetail30min, bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E)),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  String _selectedCategoryKey = AppLocalizations.kAll;

  List<_SuggestedHabit> _filteredSuggestions(LanguageProvider lang) {
    final habitProvider = context.read<HabitProvider>();
    final existingNames =
        habitProvider.habits.map((h) => h.name.toLowerCase()).toSet();

    var list = _allSuggestions
        .where((s) => !existingNames.contains(lang.tr(s.nameKey).toLowerCase()))
        .toList();

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((s) =>
              lang.tr(s.nameKey).toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  Future<void> _addSuggested(_SuggestedHabit suggestion, LanguageProvider lang) async {
    await context.read<HabitProvider>().addHabit(
          name: lang.tr(suggestion.nameKey),
          emoji: suggestion.emoji,
          color: suggestion.habitColor,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${suggestion.emoji} ${lang.tr(suggestion.nameKey)} ${lang.tr(AppLocalizations.kAdded)}'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    context.watch<HabitProvider>();
    final suggestions = _filteredSuggestions(lang);

    final categoryKeys = [
      AppLocalizations.kAll, AppLocalizations.kHealth,
      AppLocalizations.kFitness, AppLocalizations.kMind,
      AppLocalizations.kLifestyle,
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
              Text(lang.tr(AppLocalizations.kExplore), style: AppTextStyles.heading2.copyWith(color: context.textP)),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: AppTextStyles.body.copyWith(color: context.textP),
                decoration: InputDecoration(
                  hintText: lang.tr(AppLocalizations.kSearchHabits),
                  hintStyle: AppTextStyles.body.copyWith(color: context.textH),
                  prefixIcon: Icon(Icons.search, color: context.textS, size: 20),
                  filled: true,
                  fillColor: context.card,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: context.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryKeys.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isActive = categoryKeys[i] == _selectedCategoryKey;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryKey = categoryKeys[i]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : context.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isActive ? AppColors.primary : context.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            lang.tr(categoryKeys[i]),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive ? Colors.white : context.textS,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Suggested habits
              _SectionHeader(title: lang.tr(AppLocalizations.kSuggestedForYou)),
              const SizedBox(height: 12),
              if (suggestions.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: context.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: context.border),
                  ),
                  child: Center(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? lang.tr(AppLocalizations.kNoMatchingHabits)
                          : lang.tr(AppLocalizations.kAllSuggestedAdded),
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 140,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) => _SuggestedCard(
                      suggestion: suggestions[i],
                      lang: lang,
                      onAdd: () => _addSuggested(suggestions[i], lang),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Quick add grid
              _SectionHeader(title: lang.tr(AppLocalizations.kQuickAdd)),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: suggestions.take(8).map((s) {
                  return GestureDetector(
                    onTap: () => _addSuggested(s, lang),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            lang.tr(s.nameKey),
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Challenges
              _SectionHeader(title: lang.tr(AppLocalizations.kChallenges)),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _ChallengeCard(
                      title: lang.tr(AppLocalizations.kChallenge7Day),
                      subtitle: lang.tr(AppLocalizations.kChallenge7DaySub),
                      emoji: '🔥',
                    ),
                    const SizedBox(width: 12),
                    _ChallengeCard(
                      title: lang.tr(AppLocalizations.kChallengeEarlyBird),
                      subtitle: lang.tr(AppLocalizations.kChallengeEarlyBirdSub),
                      emoji: '🌅',
                    ),
                    const SizedBox(width: 12),
                    _ChallengeCard(
                      title: lang.tr(AppLocalizations.kChallengePerfectWeek),
                      subtitle: lang.tr(AppLocalizations.kChallengePerfectWeekSub),
                      emoji: '⭐',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tips
              _SectionHeader(title: lang.tr(AppLocalizations.kTipsMotivation)),
              const SizedBox(height: 12),
              _TipCard(
                title: lang.tr(AppLocalizations.kTipStartSmall),
                body: lang.tr(AppLocalizations.kTipStartSmallBody),
                emoji: '🌱',
              ),
              const SizedBox(height: 12),
              _TipCard(
                title: lang.tr(AppLocalizations.kTipStackHabits),
                body: lang.tr(AppLocalizations.kTipStackHabitsBody),
                emoji: '📚',
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.subtitle.copyWith(color: context.textP));
  }
}

class _SuggestedCard extends StatelessWidget {
  final _SuggestedHabit suggestion;
  final LanguageProvider lang;
  final VoidCallback onAdd;

  const _SuggestedCard({
    required this.suggestion,
    required this.lang,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: suggestion.bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(suggestion.emoji, style: const TextStyle(fontSize: 24)),
              GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 18, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            lang.tr(suggestion.nameKey),
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(lang.tr(suggestion.detailKey), style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String emoji;

  const _ChallengeCard({
    required this.title,
    required this.subtitle,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String body;
  final String emoji;

  const _TipCard({
    required this.title,
    required this.body,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.textP,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: AppTextStyles.bodySmall.copyWith(color: context.textS),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}