import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/location_reminder.dart';
import '../repositories/location_repository.dart';

class LocationProvider extends ChangeNotifier {
  final LocationRepository _repo;
  List<LocationReminder> _reminders = [];

  LocationProvider(this._repo) {
    _reminders = _repo.getAll();
  }

  List<LocationReminder> get reminders => _reminders;

  /// Get reminders linked to a specific habit.
  List<LocationReminder> remindersForHabit(String habitId) {
    return _reminders.where((r) => r.habitId == habitId).toList();
  }

  Future<void> addReminder({
    required String name,
    required double latitude,
    required double longitude,
    double radiusMeters = 200,
    String triggerType = 'enter',
    String? habitId,
  }) async {
    final reminder = LocationReminder(
      id: const Uuid().v4(),
      name: name,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      triggerType: triggerType,
      habitId: habitId,
    );
    _reminders.add(reminder);
    await _repo.save(reminder);
    notifyListeners();
  }

  Future<void> updateReminder(LocationReminder reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index == -1) return;
    _reminders[index] = reminder;
    await _repo.save(reminder);
    notifyListeners();
  }

  Future<void> deleteReminder(String id) async {
    _reminders.removeWhere((r) => r.id == id);
    await _repo.delete(id);
    notifyListeners();
  }
}
