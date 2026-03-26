import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/habit_provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

// ─── Habit suggestion model ──────────────────────────────────────────────────

class _SuggestedHabit {
  final String emoji;
  final String nameKey;
  final String detailKey;
  final Color bgColor;
  final Color habitColor;

  /// Tags for personalization: roles, purposes, timeOfDay
  final List<String> roles;      // role key constants or 'any'
  final List<String> purposes;   // purpose key constants or 'any'
  final String timeOfDay;        // 'morning', 'evening', 'any'

  const _SuggestedHabit({
    required this.emoji,
    required this.nameKey,
    required this.detailKey,
    required this.bgColor,
    required this.habitColor,
    this.roles = const ['any'],
    this.purposes = const ['any'],
    this.timeOfDay = 'any',
  });
}

const _allSuggestions = <_SuggestedHabit>[
  // ── Universal
  _SuggestedHabit(
    emoji: '💧', nameKey: AppLocalizations.kSugDrinkWater,
    detailKey: AppLocalizations.kSugDetail8Glasses,
    bgColor: Color(0xFFE8F4FD), habitColor: Color(0xFF3B82F6),
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '😴', nameKey: AppLocalizations.kSugSleepEarly,
    detailKey: AppLocalizations.kSugDetailBefore11,
    bgColor: Color(0xFFF0E8FD), habitColor: Color(0xFF8B5CF6),
    purposes: ['purposeHealth', 'purposeMindfulness', 'any'],
    timeOfDay: 'evening',
  ),
  _SuggestedHabit(
    emoji: '🍎', nameKey: AppLocalizations.kSugEatFruits,
    detailKey: AppLocalizations.kSugDetail2Servings,
    bgColor: Color(0xFFE8FDF0), habitColor: Color(0xFF22C55E),
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '💊', nameKey: AppLocalizations.kSugVitamin,
    detailKey: AppLocalizations.kSugDetailMorning,
    bgColor: Color(0xFFFDE8EF), habitColor: Color(0xFFEC4899),
    purposes: ['purposeHealth', 'any'],
    timeOfDay: 'morning',
  ),

  // ── Health & Fitness
  _SuggestedHabit(
    emoji: '🏃', nameKey: AppLocalizations.kSugWalk,
    detailKey: AppLocalizations.kSugDetail10kSteps,
    bgColor: Color(0xFFFDE8E8), habitColor: Color(0xFFEF4444),
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '💪', nameKey: AppLocalizations.kSugExercise,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFFDE8F4), habitColor: Color(0xFFEC4899),
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🏊', nameKey: AppLocalizations.kSugSwim,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFE8E8FD), habitColor: Color(0xFF4B3FF5),
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🧘', nameKey: AppLocalizations.kSugMeditate,
    detailKey: AppLocalizations.kSugDetail10min,
    bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E),
    purposes: ['purposeMindfulness', 'purposeHealth', 'any'],
    timeOfDay: 'morning',
  ),
  _SuggestedHabit(
    emoji: '🤸', nameKey: AppLocalizations.kSugStretch,
    detailKey: AppLocalizations.kSugDetail10min,
    bgColor: Color(0xFFFDE8E8), habitColor: Color(0xFFEF4444),
    purposes: ['purposeHealth', 'any'],
    timeOfDay: 'morning',
  ),
  _SuggestedHabit(
    emoji: '🚿', nameKey: AppLocalizations.kSugColdShower,
    detailKey: AppLocalizations.kSugDetail1min,
    bgColor: Color(0xFFE8F4FD), habitColor: Color(0xFF3B82F6),
    purposes: ['purposeHealth', 'any'],
    timeOfDay: 'morning',
  ),
  _SuggestedHabit(
    emoji: '🍬', nameKey: AppLocalizations.kSugNoSugar,
    detailKey: AppLocalizations.kSugDetailDaily,
    bgColor: Color(0xFFFDFDE8), habitColor: Color(0xFFF5A623),
    purposes: ['purposeHealth', 'any'],
  ),

  // ── Mindfulness
  _SuggestedHabit(
    emoji: '📝', nameKey: AppLocalizations.kSugJournal,
    detailKey: AppLocalizations.kSugDetail5min,
    bgColor: Color(0xFFFDFDE8), habitColor: Color(0xFFF5A623),
    purposes: ['purposeMindfulness', 'purposeLearning', 'any'],
    timeOfDay: 'evening',
  ),
  _SuggestedHabit(
    emoji: '🙏', nameKey: AppLocalizations.kSugGratitude,
    detailKey: AppLocalizations.kSugDetail5min,
    bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E),
    purposes: ['purposeMindfulness', 'any'],
    timeOfDay: 'evening',
  ),
  _SuggestedHabit(
    emoji: '🌬️', nameKey: AppLocalizations.kSugDeepBreath,
    detailKey: AppLocalizations.kSugDetail1min,
    bgColor: Color(0xFFE8F4FD), habitColor: Color(0xFF3B82F6),
    purposes: ['purposeMindfulness', 'purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '📵', nameKey: AppLocalizations.kSugNoPhone,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFF0E8FD), habitColor: Color(0xFF8B5CF6),
    purposes: ['purposeMindfulness', 'purposeProductivity', 'any'],
    timeOfDay: 'evening',
  ),

  // ── Learning & Productivity
  _SuggestedHabit(
    emoji: '📕', nameKey: AppLocalizations.kSugRead,
    detailKey: AppLocalizations.kSugDetail20min,
    bgColor: Color(0xFFFDEFE8), habitColor: Color(0xFFF5A623),
    purposes: ['purposeLearning', 'purposeProductivity', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🗒️', nameKey: AppLocalizations.kSugPlanDay,
    detailKey: AppLocalizations.kSugDetail5min,
    bgColor: Color(0xFFE8F0FD), habitColor: Color(0xFF14B8A6),
    purposes: ['purposeProductivity', 'any'],
    timeOfDay: 'morning',
  ),
  _SuggestedHabit(
    emoji: '🇬🇧', nameKey: AppLocalizations.kSugStudyEnglish,
    detailKey: AppLocalizations.kSugDetail20min,
    bgColor: Color(0xFFFDE8EF), habitColor: Color(0xFFEC4899),
    roles: ['roleStudent', 'roleWorker', 'any'],
    purposes: ['purposeLearning', 'purposeProductivity', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🎨', nameKey: AppLocalizations.kSugPracticeMusic,
    detailKey: AppLocalizations.kSugDetail20min,
    bgColor: Color(0xFFFDE8EF), habitColor: Color(0xFFEC4899),
    purposes: ['purposeLearning', 'any'],
  ),

  // ── Lifestyle & Home
  _SuggestedHabit(
    emoji: '🧹', nameKey: AppLocalizations.kSugCleanUp,
    detailKey: AppLocalizations.kSugDetail15min,
    bgColor: Color(0xFFE8F0FD), habitColor: Color(0xFF14B8A6),
    roles: ['roleHomemaker', 'roleParent', 'any'],
    purposes: ['any'],
  ),
  _SuggestedHabit(
    emoji: '🍳', nameKey: AppLocalizations.kSugCooking,
    detailKey: AppLocalizations.kSugDetailDaily,
    bgColor: Color(0xFFFDFDE8), habitColor: Color(0xFFF5A623),
    roles: ['roleHomemaker', 'roleParent', 'any'],
    purposes: ['purposeHealth', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🌿', nameKey: AppLocalizations.kSugGoOutside,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E),
    purposes: ['purposeHealth', 'purposeMindfulness', 'any'],
  ),
  _SuggestedHabit(
    emoji: '🐕', nameKey: AppLocalizations.kSugWalkDog,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFFDE8E8), habitColor: Color(0xFFEF4444),
    purposes: ['any'],
  ),

  // ── Parent-specific
  _SuggestedHabit(
    emoji: '🧒', nameKey: AppLocalizations.kSugChildPlay,
    detailKey: AppLocalizations.kSugDetail30min,
    bgColor: Color(0xFFFDEFE8), habitColor: Color(0xFFF5A623),
    roles: ['roleParent'],
    purposes: ['any'],
  ),
];

// ─── Daily tips pool ─────────────────────────────────────────────────────────

class _TipData {
  final String emoji;
  final String titleKey;
  final String bodyKey;
  const _TipData({required this.emoji, required this.titleKey, required this.bodyKey});
}

const _tipsPool = <_TipData>[
  _TipData(emoji: '🌱', titleKey: AppLocalizations.kTipStartSmall, bodyKey: AppLocalizations.kTipStartSmallBody),
  _TipData(emoji: '📚', titleKey: AppLocalizations.kTipStackHabits, bodyKey: AppLocalizations.kTipStackHabitsBody),
  _TipData(emoji: '💡', titleKey: AppLocalizations.kTipConsistency, bodyKey: AppLocalizations.kTipConsistencyBody),
  _TipData(emoji: '🧠', titleKey: AppLocalizations.kTipIdentity, bodyKey: AppLocalizations.kTipIdentityBody),
  _TipData(emoji: '⏰', titleKey: AppLocalizations.kTipTiming, bodyKey: AppLocalizations.kTipTimingBody),
  _TipData(emoji: '🎯', titleKey: AppLocalizations.kTipTrack, bodyKey: AppLocalizations.kTipTrackBody),
  _TipData(emoji: '🌅', titleKey: AppLocalizations.kTipMorning, bodyKey: AppLocalizations.kTipMorningBody),
];

// ─── ExploreScreen ───────────────────────────────────────────────────────────

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  static const _categoryKeys = [
    AppLocalizations.kAll, AppLocalizations.kHealth,
    AppLocalizations.kFitness, AppLocalizations.kMind,
    AppLocalizations.kLifestyle,
  ];

  static const _catTagMap = {
    AppLocalizations.kHealth: ['purposeHealth'],
    AppLocalizations.kFitness: ['purposeHealth'],
    AppLocalizations.kMind: ['purposeMindfulness'],
    AppLocalizations.kLifestyle: ['roleHomemaker', 'roleParent'],
  };

  String _searchQuery = '';
  String _selectedCategoryKey = AppLocalizations.kAll;

  // Bookmarked tip indices
  final Set<int> _bookmarkedTips = {};
  final Set<int> _likedTips = {};

  @override
  void initState() {
    super.initState();
    _loadTipPrefs();
  }

  Future<void> _loadTipPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = prefs.getStringList('tip_bookmarks') ?? [];
    final likes = prefs.getStringList('tip_likes') ?? [];
    if (mounted) {
      setState(() {
        _bookmarkedTips.addAll(bookmarks.map(int.parse));
        _likedTips.addAll(likes.map(int.parse));
      });
    }
  }

  Future<void> _toggleBookmark(int tipIndex) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_bookmarkedTips.contains(tipIndex)) {
        _bookmarkedTips.remove(tipIndex);
      } else {
        _bookmarkedTips.add(tipIndex);
      }
    });
    await prefs.setStringList('tip_bookmarks', _bookmarkedTips.map((e) => '$e').toList());
  }

  Future<void> _toggleLike(int tipIndex) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_likedTips.contains(tipIndex)) {
        _likedTips.remove(tipIndex);
      } else {
        _likedTips.add(tipIndex);
      }
    });
    await prefs.setStringList('tip_likes', _likedTips.map((e) => '$e').toList());
  }

  /// Daily tip index rotates by day-of-year.
  int get _todayTipIndex {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return dayOfYear % _tipsPool.length;
  }

  /// Filter suggestions based on user profile + search + category.
  List<_SuggestedHabit> _filteredSuggestions(
      LanguageProvider lang, AppUser? user) {
    final habitProvider = context.read<HabitProvider>();
    final existingNames =
        habitProvider.habits.map((h) => h.name.toLowerCase()).toSet();

    final userRole = user?.role ?? 'any';
    final userPurpose = user?.purpose ?? 'any';
    var list = _allSuggestions.where((s) {
      if (existingNames.contains(lang.tr(s.nameKey).toLowerCase())) return false;
      final roleMatch = s.roles.contains('any') || s.roles.contains(userRole);
      final purposeMatch = s.purposes.contains('any') || s.purposes.contains(userPurpose);
      return roleMatch && purposeMatch;
    }).toList();

    if (_selectedCategoryKey != AppLocalizations.kAll) {
      final cats = _catTagMap[_selectedCategoryKey] ?? const [];
      if (cats.isNotEmpty) {
        list = list
            .where((s) =>
                s.purposes.any(cats.contains) || s.roles.any(cats.contains))
            .toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list
          .where((s) => lang.tr(s.nameKey).toLowerCase().contains(query))
          .toList();
    }

    list.sort((a, b) {
      final aScore = (a.roles.contains(userRole) ? 1 : 0) +
          (a.purposes.contains(userPurpose) ? 1 : 0);
      final bScore = (b.roles.contains(userRole) ? 1 : 0) +
          (b.purposes.contains(userPurpose) ? 1 : 0);
      return bScore.compareTo(aScore);
    });

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
        content: Text(
            '${suggestion.emoji} ${lang.tr(suggestion.nameKey)} ${lang.tr(AppLocalizations.kAdded)}'),
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
    final user = context.watch<UserProvider>().user;
    final suggestions = _filteredSuggestions(lang, user);

    final tipIndex = _todayTipIndex;

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(lang.tr(AppLocalizations.kExplore),
                  style: AppTextStyles.heading2.copyWith(color: context.textP)),
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
                  itemCount: _categoryKeys.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isActive = _categoryKeys[i] == _selectedCategoryKey;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategoryKey = _categoryKeys[i]),
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
                            lang.tr(_categoryKeys[i]),
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

              // Suggested for you
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
                    separatorBuilder: (_, _) => const SizedBox(width: 12),
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
                            style: GoogleFonts.inter(
                                fontSize: 11, fontWeight: FontWeight.w500),
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

              // Today's tip (daily rotation)
              _SectionHeader(title: lang.tr(AppLocalizations.kTodaysTip)),
              const SizedBox(height: 12),
              _DailyTipCard(
                tip: _tipsPool[tipIndex],
                lang: lang,
                isBookmarked: _bookmarkedTips.contains(tipIndex),
                isLiked: _likedTips.contains(tipIndex),
                onBookmark: () => _toggleBookmark(tipIndex),
                onLike: () => _toggleLike(tipIndex),
              ),

              // Bookmarked tips section
              if (_bookmarkedTips.isNotEmpty) ...[
                const SizedBox(height: 24),
                _SectionHeader(title: lang.tr(AppLocalizations.kTipBookmarked)),
                const SizedBox(height: 12),
                ..._bookmarkedTips
                    .where((i) => i != tipIndex)
                    .map((i) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _DailyTipCard(
                            tip: _tipsPool[i],
                            lang: lang,
                            isBookmarked: true,
                            isLiked: _likedTips.contains(i),
                            onBookmark: () => _toggleBookmark(i),
                            onLike: () => _toggleLike(i),
                          ),
                        )),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) =>
      Text(title, style: AppTextStyles.subtitle.copyWith(color: context.textP));
}

class _SuggestedCard extends StatelessWidget {
  final _SuggestedHabit suggestion;
  final LanguageProvider lang;
  final VoidCallback onAdd;

  const _SuggestedCard(
      {required this.suggestion, required this.lang, required this.onAdd});

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
          Text(lang.tr(suggestion.nameKey),
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
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

  const _ChallengeCard(
      {required this.title, required this.subtitle, required this.emoji});

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
          Text(title,
              style: GoogleFonts.inter(
                  fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 2),
          Text(subtitle,
              style: GoogleFonts.inter(fontSize: 11, color: Colors.white70),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  final _TipData tip;
  final LanguageProvider lang;
  final bool isBookmarked;
  final bool isLiked;
  final VoidCallback onBookmark;
  final VoidCallback onLike;

  const _DailyTipCard({
    required this.tip,
    required this.lang,
    required this.isBookmarked,
    required this.isLiked,
    required this.onBookmark,
    required this.onLike,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tip.emoji, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lang.tr(tip.titleKey),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.textP,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lang.tr(tip.bodyKey),
                      style: AppTextStyles.bodySmall.copyWith(color: context.textS),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _TipAction(
                icon: isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? AppColors.red : context.textS,
                onTap: onLike,
              ),
              const SizedBox(width: 16),
              _TipAction(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: isBookmarked ? AppColors.primary : context.textS,
                onTap: onBookmark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _TipAction({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 22),
    );
  }
}
