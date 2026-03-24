import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';
import '../repositories/habit_repository.dart';

class HabitProvider extends ChangeNotifier {
  final HabitRepository _repo;
  List<Habit> _habits = [];

  HabitProvider(this._repo) {
    _habits = _repo.getAllHabits();
  }

  List<Habit> get habits => _habits;

  List<Habit> get todayHabits => habitsForDate(DateTime.now());

  int get todayCompleted => completedForDate(DateTime.now());

  List<Habit> habitsForDate(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    return _habits.where((h) => h.activeDays.contains(weekday)).toList();
  }

  int completedForDate(DateTime date) {
    return habitsForDate(date).where((h) => h.isCompletedOn(date)).length;
  }

  Future<void> addHabit({
    required String name,
    required String emoji,
    required Color color,
    String? description,
    TimeOfDay? reminderTime,
    List<int>? activeDays,
  }) async {
    final habit = Habit(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      color: color,
      description: description,
      reminderTime: reminderTime,
      activeDays: activeDays ?? [1, 2, 3, 4, 5, 6, 7],
    );
    _habits.add(habit);
    await _repo.saveHabit(habit);
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId, DateTime date) async {
    final index = _habits.indexWhere((h) => h.id == habitId);
    if (index == -1) return;

    final habit = _habits[index];
    final key =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final newLog = Map<String, bool>.from(habit.completionLog);
    newLog[key] = !(newLog[key] ?? false);
    _habits[index] = habit.copyWith(completionLog: newLog);
    await _repo.saveHabit(_habits[index]);
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index == -1) return;
    _habits[index] = habit;
    await _repo.saveHabit(habit);
    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await _repo.deleteHabit(habitId);
    notifyListeners();
  }
}
