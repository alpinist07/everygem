import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/habit.dart';
import '../habit_repository.dart';

class LocalHabitRepository implements HabitRepository {
  static const String _boxName = 'habits';

  final Box _box;

  LocalHabitRepository(this._box);

  /// Call before constructing: opens the Hive box.
  static Future<LocalHabitRepository> create() async {
    await Hive.initFlutter();
    final box = await Hive.openBox(_boxName);
    return LocalHabitRepository(box);
  }

  @override
  List<Habit> getAllHabits() {
    return _box.values.map((e) {
      return Habit.fromJson(jsonDecode(e as String));
    }).toList();
  }

  @override
  Future<void> saveHabit(Habit habit) async {
    await _box.put(habit.id, jsonEncode(habit.toJson()));
  }

  @override
  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
  }
}
