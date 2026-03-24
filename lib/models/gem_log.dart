class GemLog {
  final String id;
  final int amount;
  final String reason; // 'habit_complete', 'streak_bonus', 'reward_redeem'
  final String? habitId;
  final DateTime createdAt;

  GemLog({
    required this.id,
    required this.amount,
    required this.reason,
    this.habitId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'reason': reason,
        'habitId': habitId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory GemLog.fromJson(Map<String, dynamic> json) => GemLog(
        id: json['id'] as String,
        amount: json['amount'] as int,
        reason: json['reason'] as String,
        habitId: json['habitId'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
