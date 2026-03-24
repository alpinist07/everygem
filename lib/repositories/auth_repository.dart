import '../models/user.dart';

/// Authentication abstraction.
/// Swap implementations to switch backends (Local → Firebase → Supabase).
abstract class AuthRepository {
  /// Whether onboarding has been completed.
  bool get isOnboardingCompleted;

  /// Mark onboarding as completed.
  Future<void> setOnboardingCompleted();

  /// Create a new user account.
  Future<void> createUser(AppUser user);

  /// Get the currently signed-in user, or null.
  AppUser? getCurrentUser();

  /// Update the current user's profile.
  Future<void> updateUser(AppUser user);
}
