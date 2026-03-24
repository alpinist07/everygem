class FriendProfile {
  final String uid;
  final String name;
  final String? avatarUrl;
  final int totalGems;
  final int level;
  final String? role; // 'parent', 'child', or null

  FriendProfile({
    required this.uid,
    required this.name,
    this.avatarUrl,
    this.totalGems = 0,
    this.level = 1,
    this.role,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'avatarUrl': avatarUrl,
        'totalGems': totalGems,
        'level': level,
        'role': role,
      };

  factory FriendProfile.fromJson(Map<String, dynamic> json) => FriendProfile(
        uid: json['uid'] as String,
        name: json['name'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        totalGems: json['totalGems'] as int? ?? 0,
        level: json['level'] as int? ?? 1,
        role: json['role'] as String?,
      );
}

class Friendship {
  final String id;
  final String fromUid;
  final String toUid;
  final String status; // 'pending', 'accepted'
  final String? relationshipType; // 'friend', 'parent-child'
  final DateTime createdAt;

  Friendship({
    required this.id,
    required this.fromUid,
    required this.toUid,
    this.status = 'pending',
    this.relationshipType = 'friend',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Friendship copyWith({String? status}) => Friendship(
        id: id,
        fromUid: fromUid,
        toUid: toUid,
        status: status ?? this.status,
        relationshipType: relationshipType,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromUid': fromUid,
        'toUid': toUid,
        'status': status,
        'relationshipType': relationshipType,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Friendship.fromJson(Map<String, dynamic> json) => Friendship(
        id: json['id'] as String,
        fromUid: json['fromUid'] as String,
        toUid: json['toUid'] as String,
        status: json['status'] as String? ?? 'pending',
        relationshipType: json['relationshipType'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
