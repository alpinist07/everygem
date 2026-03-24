import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/auth_repository.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository _auth;
  AppUser? _user;

  UserProvider(this._auth) {
    _user = _auth.getCurrentUser();
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isOnboardingCompleted => _auth.isOnboardingCompleted;

  Future<void> createUser({
    required String name,
    String? surname,
    String? birthdate,
    String? gender,
  }) async {
    _user = AppUser(
      name: name,
      surname: surname,
      birthdate: birthdate,
      gender: gender,
      onboardingCompleted: true,
    );
    await _auth.createUser(_user!);
    await _auth.setOnboardingCompleted();
    notifyListeners();
  }

  Future<void> updateUser({String? name, String? surname}) async {
    if (_user == null) return;
    _user = _user!.copyWith(
      name: name,
      surname: surname,
    );
    await _auth.updateUser(_user!);
    notifyListeners();
  }
}
