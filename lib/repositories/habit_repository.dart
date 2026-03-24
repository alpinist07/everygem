import '../models/habit.dart';

/// Habit data abstraction.
/// Swap implementations to switch backends (Local → Firebase → Supabase).
abstract class HabitRepository {
  /// Get all habits for the current user.
  List<Habit> getAllHabits();

  /// Save (create or update) a habit.
  Future<void> saveHabit(Habit habit);

  /// Delete a habit by id.
  Future<void> deleteHabit(String id);
}
