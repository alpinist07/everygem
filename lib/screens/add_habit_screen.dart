import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  final Habit? habit; // null = 추가 모드, non-null = 편집 모드

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

  final List<String> _emojis = [
    '💧', '🏃', '📚', '🧘', '💪', '🌿', '📝', '🎨',
    '🎵', '🍎', '😴', '🧹', '💊', '🚶', '🧠', '☀️',
  ];

  final List<String> _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  void initState() {
    super.initState();
    final h = widget.habit;
    _nameController = TextEditingController(text: h?.name ?? '');
    _selectedEmoji = h?.emoji ?? '💧';
    _selectedColor = h?.color ?? AppColors.habitColors[0];
    _reminderTime = h?.reminderTime;
    _activeDays = h != null ? Set<int>.from(h.activeDays) : {1, 2, 3, 4, 5, 6, 7};
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a habit name')),
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
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.habit != null ? 'Edit Habit' : 'Create Custom Habit',
            style: AppTextStyles.heading3.copyWith(color: context.textP)),
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
                hintText: 'Habit name',
                hintStyle:
                    AppTextStyles.body.copyWith(color: context.textH),
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
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Icon selection
            Text('CHOOSE AN ICON', style: AppTextStyles.label.copyWith(color: context.textS)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _emojis.map((emoji) {
                final isSelected = emoji == _selectedEmoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : context.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : context.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(emoji,
                          style: const TextStyle(fontSize: 22)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Color selection
            Text('CHOOSE A COLOR', style: AppTextStyles.label.copyWith(color: context.textS)),
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
                        ? const Icon(Icons.check,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Active days
            Text('REPEAT ON', style: AppTextStyles.label.copyWith(color: context.textS)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = index + 1;
                final isActive = _activeDays.contains(day);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isActive) {
                        _activeDays.remove(day);
                      } else {
                        _activeDays.add(day);
                      }
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : context.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : context.border,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _dayLabels[index],
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
            Text('ADD REMINDER', style: AppTextStyles.label.copyWith(color: context.textS)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _reminderTime ?? TimeOfDay.now(),
                );
                if (time != null) {
                  setState(() => _reminderTime = time);
                }
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
                    Icon(Icons.access_time,
                        color: context.textS, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _reminderTime != null
                          ? _reminderTime!.format(context)
                          : 'Set reminder time',
                      style: AppTextStyles.body.copyWith(
                        color: _reminderTime != null
                            ? context.textP
                            : context.textH,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Add button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(widget.habit != null ? 'Save Changes' : 'Add Habit', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
