import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/location_reminder.dart';
import '../location_repository.dart';

class LocalLocationRepository implements LocationRepository {
  static const String _boxName = 'location_reminders';
  final Box _box;

  LocalLocationRepository(this._box);

  static Future<LocalLocationRepository> create() async {
    final box = await Hive.openBox(_boxName);
    return LocalLocationRepository(box);
  }

  @override
  List<LocationReminder> getAll() {
    return _box.values
        .map((e) => LocationReminder.fromJson(jsonDecode(e as String)))
        .toList();
  }

  @override
  Future<void> save(LocationReminder reminder) async {
    await _box.put(reminder.id, jsonEncode(reminder.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}
