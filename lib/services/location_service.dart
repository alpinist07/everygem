import 'package:geolocator/geolocator.dart';
import '../models/location_reminder.dart';

class LocationService {
  /// Check and request location permission.
  Future<bool> ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  /// Get current position.
  Future<Position?> getCurrentPosition() async {
    final ok = await ensurePermission();
    if (!ok) return null;
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  /// Check if user is within a location reminder's radius.
  bool isWithinRadius(Position position, LocationReminder reminder) {
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      reminder.latitude,
      reminder.longitude,
    );
    return distance <= reminder.radiusMeters;
  }

  /// Listen to position changes and trigger callback when entering/exiting a zone.
  Stream<Position> positionStream({int distanceFilter = 50}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
