import '../models/location_reminder.dart';

abstract class LocationRepository {
  List<LocationReminder> getAll();
  Future<void> save(LocationReminder reminder);
  Future<void> delete(String id);
}
