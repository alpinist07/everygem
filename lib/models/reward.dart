class Reward {
  final String id;
  final String name;
  final String emoji;
  final int cost; // gems required
  final String createdBy; // userId of parent
  final bool isRedeemed;

  Reward({
    required this.id,
    required this.name,
    required this.emoji,
    required this.cost,
    required this.createdBy,
    this.isRedeemed = false,
  });

  Reward copyWith({bool? isRedeemed}) => Reward(
        id: id,
        name: name,
        emoji: emoji,
        cost: cost,
        createdBy: createdBy,
        isRedeemed: isRedeemed ?? this.isRedeemed,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'cost': cost,
        'createdBy': createdBy,
        'isRedeemed': isRedeemed,
      };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: json['emoji'] as String,
        cost: json['cost'] as int,
        createdBy: json['createdBy'] as String,
        isRedeemed: json['isRedeemed'] as bool? ?? false,
      );
}
