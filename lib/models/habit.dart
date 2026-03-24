import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final String emoji;
  final Color color;
  final String? description;
  final TimeOfDay? reminderTime;
  final List<int> activeDays; // 1=Mon, 7=Sun
  final DateTime createdAt;
  final Map<String, bool> completionLog; // 'yyyy-MM-dd' -> completed

  Habit({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.description,
    this.reminderTime,
    this.activeDays = const [1, 2, 3, 4, 5, 6, 7],
    DateTime? createdAt,
    Map<String, bool>? completionLog,
  })  : createdAt = createdAt ?? DateTime.now(),
        completionLog = completionLog ?? {};

  Habit copyWith({
    String? name,
    String? emoji,
    Color? color,
    String? description,
    TimeOfDay? reminderTime,
    List<int>? activeDays,
    Map<String, bool>? completionLog,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      color: color ?? this.color,
      description: description ?? this.description,
      reminderTime: reminderTime ?? this.reminderTime,
      activeDays: activeDays ?? this.activeDays,
      createdAt: createdAt,
      completionLog: completionLog ?? this.completionLog,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'color': color.toARGB32(),
      'description': description,
      'reminderHour': reminderTime?.hour,
      'reminderMinute': reminderTime?.minute,
      'activeDays': activeDays,
      'createdAt': createdAt.toIso8601String(),
      'completionLog': completionLog,
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      color: Color(json['color'] as int),
      description: json['description'] as String?,
      reminderTime: json['reminderHour'] != null
          ? TimeOfDay(
              hour: json['reminderHour'] as int,
              minute: json['reminderMinute'] as int,
            )
          : null,
      activeDays: List<int>.from(json['activeDays'] ?? [1, 2, 3, 4, 5, 6, 7]),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completionLog: Map<String, bool>.from(json['completionLog'] ?? {}),
    );
  }

  bool isCompletedOn(DateTime date) {
    final key = _dateKey(date);
    return completionLog[key] ?? false;
  }

  int get currentStreak {
    int streak = 0;
    DateTime date = DateTime.now();
    while (true) {
      if (isCompletedOn(date)) {
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
