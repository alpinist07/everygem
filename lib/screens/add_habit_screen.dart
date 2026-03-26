import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

// ─── Emoji suggestion mapping ─────────────────────────────────────────────────

const _emojiKeywords = <String, List<String>>{
  '💧': ['water', '물', 'drink', '음료', 'hydrat'],
  '🏃': ['run', '달리기', 'jog', '조깅', 'walk', '걷기', 'step'],
  '📚': ['read', '독서', 'book', '책', 'study', '공부', 'learn', '학습'],
  '🧘': ['meditat', '명상', 'yoga', '요가', 'breath', '호흡', 'relax', '이완'],
  '💪': ['exercis', '운동', 'gym', '헬스', 'workout', 'strength', '근력', 'muscle'],
  '🌿': ['plant', '식물', 'nature', '자연', 'garden', '정원', 'outside', '야외'],
  '📝': ['journal', '일기', 'write', '쓰기', 'diary', '다이어리', 'note'],
  '🎨': ['art', '그림', 'draw', '그리기', 'paint', '색칠', 'creat', '창작'],
  '🎵': ['music', '음악', 'sing', '노래', 'guitar', '기타', 'piano', '피아노', 'instrument', '악기'],
  '🍎': ['fruit', '과일', 'eat', '식사', 'diet', '다이어트', 'food', '음식', 'vegetable', '채소'],
  '😴': ['sleep', '수면', '잠', 'rest', '휴식', 'bed', '침대', 'night', '밤'],
  '🧹': ['clean', '청소', 'tidy', '정리', 'organiz', '정돈', 'wash', '세탁'],
  '💊': ['vitamin', '비타민', 'medicine', '약', 'supplement', '영양제', 'pill'],
  '🚶': ['walk', '산책', 'stroll', 'step', '걸음', 'hike', '등산'],
  '🧠': ['learn', '학습', 'brain', '뇌', 'mind', '마음', 'think', '생각', 'mental'],
  '☀️': ['morning', '아침', 'sunrise', 'early', '일찍', 'wakeup', '기상'],
  '🍳': ['cook', '요리', 'kitchen', '주방', 'meal', '식사', 'recipe', '레시피'],
  '🙏': ['gratitude', '감사', 'pray', '기도', 'thankful', '감사일기'],
  '📵': ['phone', '폰', 'screen', '화면', 'digital', '디지털', 'detox'],
  '🌬️': ['breath', '호흡', 'inhale', '깊은', 'breath', 'air', '공기'],
  '🇬🇧': ['english', '영어', 'language', '언어', 'foreign', '외국어'],
  '🐕': ['dog', '강아지', '개', 'pet', '반려동물', 'animal', '동물'],
  '🤸': ['stretch', '스트레칭', 'flex', '유연', 'warm', '준비운동'],
  '🚿': ['shower', '샤워', 'cold', '냉수', 'wash', '씻기'],
  '🗒️': ['plan', '계획', 'schedule', '일정', 'todo', '할일', 'list', '목록'],
};

/// Returns ranked emoji suggestions for the given input text.
List<String> _suggestEmojis(String input) {
  if (input.trim().isEmpty) return [];
  final lower = input.toLowerCase();
  final scores = <String, int>{};
  for (final entry in _emojiKeywords.entries) {
    for (final kw in entry.value) {
      if (lower.contains(kw) || kw.contains(lower)) {
        scores[entry.key] = (scores[entry.key] ?? 0) + (lower.contains(kw) ? 2 : 1);
      }
    }
  }
  final sorted = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  return sorted.take(5).map((e) => e.key).toList();
}

// ─── All available emojis ─────────────────────────────────────────────────────

const _allEmojis = [
  '💧', '🏃', '📚', '🧘', '💪', '🌿', '📝', '🎨',
  '🎵', '🍎', '😴', '🧹', '💊', '🚶', '🧠', '☀️',
  '🍳', '🙏', '📵', '🌬️', '🇬🇧', '🐕', '🤸', '🚿',
  '🗒️', '🎯', '🏊', '🧗', '🚴', '⚽', '🏋️', '🧪',
  '🌍', '💼', '🎭', '🎤', '🍵', '🥗', '💻', '📖',
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class AddHabitScreen extends StatefulWidget {
  final Habit? habit;
  const AddHabitScreen({super.key, this.habit});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  late final TextEditingController _nameController;
  late String _selectedEmoji;
  late Color _selectedColor;
  TimeOfDay? _reminderTime;
  late Set<int> _activeDays;
  bool _showAllEmojis = false;
  List<String> _suggestedEmojis = [];

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    _nameController = TextEditingController(text: h?.name ?? '');
    _selectedEmoji = h?.emoji ?? '💧';
    _selectedColor = h?.color ?? AppColors.habitColors[0];
    _reminderTime = h?.reminderTime;
    _activeDays = h != null ? Set<int>.from(h.activeDays) : {1, 2, 3, 4, 5, 6, 7};
    if (h?.name != null) {
      _suggestedEmojis = _suggestEmojis(h!.name);
    }
    _nameController.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    final suggestions = _suggestEmojis(_nameController.text);
    setState(() {
      _suggestedEmojis = suggestions;
      // Auto-select top suggestion only if user hasn't manually chosen yet
      // (only when still on default or a previous suggestion)
      if (suggestions.isNotEmpty &&
          widget.habit == null &&
          (_selectedEmoji == '💧' || _suggestedEmojis.contains(_selectedEmoji))) {
        _selectedEmoji = suggestions.first;
      }
    });
  }

  Future<void> _save() async {
    final lang = context.read<LanguageProvider>();
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr(AppLocalizations.kPleaseEnterHabitName))),
      );
      return;
    }

    final provider = context.read<HabitProvider>();
    if (widget.habit != null) {
      await provider.updateHabit(
        widget.habit!.copyWith(
          name: _nameController.text.trim(),
          emoji: _selectedEmoji,
          color: _selectedColor,
          reminderTime: _reminderTime,
          activeDays: _activeDays.toList()..sort(),
        ),
      );
    } else {
      await provider.addHabit(
        name: _nameController.text.trim(),
        emoji: _selectedEmoji,
        color: _selectedColor,
        reminderTime: _reminderTime,
        activeDays: _activeDays.toList()..sort(),
      );
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final dayLabels = [
      lang.tr(AppLocalizations.kMon), lang.tr(AppLocalizations.kTue),
      lang.tr(AppLocalizations.kWed), lang.tr(AppLocalizations.kThu),
      lang.tr(AppLocalizations.kFri), lang.tr(AppLocalizations.kSat),
      lang.tr(AppLocalizations.kSun),
    ];

    final displayedEmojis = _showAllEmojis ? _allEmojis
        : (_suggestedEmojis.isNotEmpty
            ? _suggestedEmojis
            : _allEmojis.take(16).toList());

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.habit != null
              ? lang.tr(AppLocalizations.kEditHabit)
              : lang.tr(AppLocalizations.kCreateCustomHabit),
          style: AppTextStyles.heading3.copyWith(color: context.textP),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Habit name
            TextField(
              controller: _nameController,
              style: AppTextStyles.body.copyWith(color: context.textP),
              decoration: InputDecoration(
                hintText: lang.tr(AppLocalizations.kHabitName),
                hintStyle: AppTextStyles.body.copyWith(color: context.textH),
                filled: true,
                fillColor: context.card,
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
            const SizedBox(height: 24),

            // Emoji section header with toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _suggestedEmojis.isNotEmpty && !_showAllEmojis
                      ? lang.tr(AppLocalizations.kSuggestedIcons)
                      : lang.tr(AppLocalizations.kChooseIcon),
                  style: AppTextStyles.label.copyWith(color: context.textS),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showAllEmojis = !_showAllEmojis),
                  child: Row(
                    children: [
                      Icon(
                        _showAllEmojis ? Icons.expand_less : Icons.grid_view,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _showAllEmojis
                            ? lang.tr(AppLocalizations.kSuggestedIcons)
                            : lang.tr(AppLocalizations.kAllIcons),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Emoji grid
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: displayedEmojis.map((emoji) {
                final isSelected = emoji == _selectedEmoji;
                final isSuggested = _suggestedEmojis.contains(emoji);
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedEmoji = emoji;
                    _showAllEmojis = false;
                  }),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : context.card,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : context.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(emoji, style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      // Sparkle badge on suggested emojis
                      if (isSuggested && !_showAllEmojis)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: AppColors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('✦', style: TextStyle(fontSize: 8, color: Colors.white)),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Color selection with category hint
            Row(
              children: [
                Expanded(
                  child: Text(
                    lang.tr(AppLocalizations.kColorCategory),
                    style: AppTextStyles.label.copyWith(color: context.textS),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              lang.tr(AppLocalizations.kColorCategoryHint),
              style: AppTextStyles.caption.copyWith(color: context.textS),
            ),
            const SizedBox(height: 12),
            Row(
              children: AppColors.habitColors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: AppColors.textPrimary, width: 3)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Active days
            Text(lang.tr(AppLocalizations.kRepeatOn),
                style: AppTextStyles.label.copyWith(color: context.textS)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = index + 1;
                final isActive = _activeDays.contains(day);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isActive) {
                      _activeDays.remove(day);
                    } else {
                      _activeDays.add(day);
                    }
                  }),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : context.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive ? AppColors.primary : context.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        dayLabels[index],
                        style: AppTextStyles.body.copyWith(
                          color: isActive ? Colors.white : context.textP,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Reminder
            Text(lang.tr(AppLocalizations.kAddReminder),
                style: AppTextStyles.label.copyWith(color: context.textS)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime ?? TimeOfDay.now(),
                );
                if (time != null) setState(() => _reminderTime = time);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: context.border),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: context.textS, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : lang.tr(AppLocalizations.kSetReminderTime),
                      style: AppTextStyles.body.copyWith(
                        color: _reminderTime != null ? context.textP : context.textH,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  widget.habit != null
                      ? lang.tr(AppLocalizations.kSaveChanges)
                      : lang.tr(AppLocalizations.kAddHabit),
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
