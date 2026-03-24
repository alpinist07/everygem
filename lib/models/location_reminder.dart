class LocationReminder {
  final String id;
  final String name; // e.g. "Home", "Gym", "Office"
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String triggerType; // 'enter' or 'exit'
  final String? habitId;

  LocationReminder({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 200,
    this.triggerType = 'enter',
    this.habitId,
  });

  LocationReminder copyWith({
    String? name,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? triggerType,
    String? habitId,
  }) =>
      LocationReminder(
        id: id,
        name: name ?? this.name,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        radiusMeters: radiusMeters ?? this.radiusMeters,
        triggerType: triggerType ?? this.triggerType,
        habitId: habitId ?? this.habitId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radiusMeters': radiusMeters,
        'triggerType': triggerType,
        'habitId': habitId,
      };

  factory LocationReminder.fromJson(Map<String, dynamic> json) =>
      LocationReminder(
        id: json['id'] as String,
        name: json['name'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 200,
        triggerType: json['triggerType'] as String? ?? 'enter',
        habitId: json['habitId'] as String?,
      );
}
