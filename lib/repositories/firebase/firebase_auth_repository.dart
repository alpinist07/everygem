import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user.dart';
import '../auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get firebaseUser => _auth.currentUser;
  String? get uid => _auth.currentUser?.uid;

  @override
  bool get isOnboardingCompleted {
    // If there's a Firebase user, onboarding was completed
    return _auth.currentUser != null;
  }

  @override
  Future<void> setOnboardingCompleted() async {
    // No-op for Firebase: user creation implies completion
  }

  @override
  Future<void> createUser(AppUser user) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return;

    await _db.collection('users').doc(fbUser.uid).set({
      'name': user.name,
      'surname': user.surname,
      'birthdate': user.birthdate,
      'gender': user.gender,
      'onboardingCompleted': true,
      'inviteCode': fbUser.uid.substring(0, 8).toUpperCase(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  AppUser? getCurrentUser() {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return null;
    return AppUser(
      name: fbUser.displayName ?? 'User',
      onboardingCompleted: true,
    );
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final fbUser = _auth.currentUser;
    if (fbUser == null) return;

    await _db.collection('users').doc(fbUser.uid).update({
      'name': user.name,
      'surname': user.surname,
    });
  }

  /// Sign in anonymously (for quick prototyping).
  Future<UserCredential> signInAnonymously() async {
    return await _auth.signInAnonymously();
  }

  /// Sign out.
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
