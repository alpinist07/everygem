class AppUser {
  final String name;
  final String? surname;
  final String? birthdate;
  final String? gender;
  final String? email;
  final String? role; // 'student', 'worker', 'homemaker', 'parent', 'other'
  final String? purpose; // 'health', 'productivity', 'mindfulness', 'learning', 'other'
  final bool onboardingCompleted;

  AppUser({
    required this.name,
    this.surname,
    this.birthdate,
    this.gender,
    this.email,
    this.role,
    this.purpose,
    this.onboardingCompleted = false,
  });

  AppUser copyWith({
    String? name,
    String? surname,
    String? birthdate,
    String? gender,
    String? email,
    String? role,
    String? purpose,
    bool? onboardingCompleted,
  }) {
    return AppUser(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      role: role ?? this.role,
      purpose: purpose ?? this.purpose,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'birthdate': birthdate,
      'gender': gender,
      'email': email,
      'role': role,
      'purpose': purpose,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      surname: json['surname'] as String?,
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      role: json['role'] as String?,
      purpose: json['purpose'] as String?,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }
}
