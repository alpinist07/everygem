import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  static const String _userKey = 'user_data';
  static const String _onboardingKey = 'onboarding_completed';

  final SharedPreferences _prefs;

  LocalAuthRepository(this._prefs);

  @override
  bool get isOnboardingCompleted => _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  @override
  Future<void> createUser(AppUser user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  AppUser? getCurrentUser() {
    final data = _prefs.getString(_userKey);
    if (data == null) return null;
    return AppUser.fromJson(jsonDecode(data));
  }

  @override
  Future<void> updateUser(AppUser user) async {
    await _prefs.setString(_userKey, jsonEncode(user.toJson()));
  }
}
