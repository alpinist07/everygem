import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../providers/habit_provider.dart';

class _SuggestedHabit {
  final String emoji;
  final String name;
  final String detail;
  final Color bgColor;
  final Color habitColor;

  const _SuggestedHabit({
    required this.emoji,
    required this.name,
    required this.detail,
    required this.bgColor,
    required this.habitColor,
  });
}

const _allSuggestions = <_SuggestedHabit>[
  _SuggestedHabit(emoji: '💧', name: 'Drink Water', detail: '8 glasses', bgColor: Color(0xFFE8F4FD), habitColor: Color(0xFF3B82F6)),
  _SuggestedHabit(emoji: '🏃', name: 'Walk', detail: '10,000 steps', bgColor: Color(0xFFFDE8E8), habitColor: Color(0xFFEF4444)),
  _SuggestedHabit(emoji: '🏊', name: 'Swim', detail: '30 min', bgColor: Color(0xFFE8E8FD), habitColor: Color(0xFF4B3FF5)),
  _SuggestedHabit(emoji: '📕', name: 'Read', detail: '20 min', bgColor: Color(0xFFFDEFE8), habitColor: Color(0xFFF5A623)),
  _SuggestedHabit(emoji: '🧘', name: 'Meditate', detail: '10 min', bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E)),
  _SuggestedHabit(emoji: '💪', name: 'Exercise', detail: '30 min', bgColor: Color(0xFFFDE8F4), habitColor: Color(0xFFEC4899)),
  _SuggestedHabit(emoji: '😴', name: 'Sleep Early', detail: 'Before 11pm', bgColor: Color(0xFFF0E8FD), habitColor: Color(0xFF8B5CF6)),
  _SuggestedHabit(emoji: '📝', name: 'Journal', detail: '5 min', bgColor: Color(0xFFFDFDE8), habitColor: Color(0xFFF5A623)),
  _SuggestedHabit(emoji: '🍎', name: 'Eat Fruits', detail: '2 servings', bgColor: Color(0xFFE8FDF0), habitColor: Color(0xFF22C55E)),
  _SuggestedHabit(emoji: '🧹', name: 'Clean Up', detail: '15 min', bgColor: Color(0xFFE8F0FD), habitColor: Color(0xFF14B8A6)),
  _SuggestedHabit(emoji: '🎵', name: 'Practice Music', detail: '20 min', bgColor: Color(0xFFFDE8EF), habitColor: Color(0xFFEC4899)),
  _SuggestedHabit(emoji: '🌿', name: 'Go Outside', detail: '30 min', bgColor: Color(0xFFE8FDE8), habitColor: Color(0xFF22C55E)),
];

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';
  final _categories = ['All', 'Health', 'Fitness', 'Mind', 'Lifestyle'];

  List<_SuggestedHabit> get _filteredSuggestions {
    final habitProvider = context.read<HabitProvider>();
    final existingNames =
        habitProvider.habits.map((h) => h.name.toLowerCase()).toSet();

    var list = _allSuggestions
        .where((s) => !existingNames.contains(s.name.toLowerCase()))
        .toList();

    if (_searchQuery.isNotEmpty) {
      list = list
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return list;
  }

  Future<void> _addSuggested(_SuggestedHabit suggestion) async {
    await context.read<HabitProvider>().addHabit(
          name: suggestion.name,
          emoji: suggestion.emoji,
          color: suggestion.habitColor,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${suggestion.emoji} ${suggestion.name} added!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    context.watch<HabitProvider>();
    final suggestions = _filteredSuggestions;

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Explore', style: AppTextStyles.heading2.copyWith(color: context.textP)),
              const SizedBox(height: 16),

              // Search bar
              TextField(
                onChanged: (v) => setState(() => _searchQuery = v),
                style: AppTextStyles.body.copyWith(color: context.textP),
                decoration: InputDecoration(
                  hintText: 'Search habits...',
                  hintStyle:
                      AppTextStyles.body.copyWith(color: context.textH),
                  prefixIcon: Icon(Icons.search,
                      color: context.textS, size: 20),
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
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category chips
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final isActive = _categories[i] == _selectedCategory;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = _categories[i]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : context.card,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isActive
                                ? AppColors.primary
                                : context.border,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _categories[i],
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: isActive
                                  ? Colors.white
                                  : context.textS,
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
              _SectionHeader(title: 'Suggested for You'),
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
                          ? 'No matching habits found'
                          : 'You\'ve added all suggested habits!',
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
                      onAdd: () => _addSuggested(suggestions[i]),
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Quick add grid
              _SectionHeader(title: 'Quick Add'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: suggestions.take(8).map((s) {
                  return GestureDetector(
                    onTap: () => _addSuggested(s),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.card,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: context.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s.emoji,
                              style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 4),
                          Text(
                            s.name,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
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
              _SectionHeader(title: 'Challenges'),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _ChallengeCard(
                      title: '7 Day Streak',
                      subtitle: 'Complete any habit for 7 days straight',
                      emoji: '🔥',
                    ),
                    SizedBox(width: 12),
                    _ChallengeCard(
                      title: 'Early Bird',
                      subtitle: 'Complete all habits before noon',
                      emoji: '🌅',
                    ),
                    SizedBox(width: 12),
                    _ChallengeCard(
                      title: 'Perfect Week',
                      subtitle: 'Complete all habits every day this week',
                      emoji: '⭐',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tips
              _SectionHeader(title: 'Tips & Motivation'),
              const SizedBox(height: 12),
              _TipCard(
                title: 'Start small, grow big',
                body:
                    'Begin with just 2 minutes a day. Consistency beats intensity.',
                emoji: '🌱',
              ),
              const SizedBox(height: 12),
              _TipCard(
                title: 'Stack your habits',
                body:
                    'Attach a new habit to an existing one. "After I brush my teeth, I will meditate."',
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
  final VoidCallback onAdd;

  const _SuggestedCard({
    required this.suggestion,
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
              Text(suggestion.emoji,
                  style: const TextStyle(fontSize: 24)),
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
            suggestion.name,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(suggestion.detail, style: AppTextStyles.bodySmall),
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
