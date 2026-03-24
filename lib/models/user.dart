class AppUser {
  final String name;
  final String? surname;
  final String? birthdate;
  final String? gender;
  final bool onboardingCompleted;

  AppUser({
    required this.name,
    this.surname,
    this.birthdate,
    this.gender,
    this.onboardingCompleted = false,
  });

  AppUser copyWith({
    String? name,
    String? surname,
    String? birthdate,
    String? gender,
    bool? onboardingCompleted,
  }) {
    return AppUser(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      birthdate: birthdate ?? this.birthdate,
      gender: gender ?? this.gender,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'birthdate': birthdate,
      'gender': gender,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      name: json['name'] as String,
      surname: json['surname'] as String?,
      birthdate: json['birthdate'] as String?,
      gender: json['gender'] as String?,
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    );
  }
}
