import '../models/friendship.dart';

abstract class FriendRepository {
  /// Get all accepted friends for the current user.
  Future<List<FriendProfile>> getFriends(String myUid);

  /// Get pending friend requests (incoming).
  Future<List<Friendship>> getPendingRequests(String myUid);

  /// Send a friend request by invite code.
  Future<bool> sendRequest({
    required String fromUid,
    required String toInviteCode,
    String relationshipType = 'friend',
  });

  /// Accept a friend request.
  Future<void> acceptRequest(String friendshipId);

  /// Decline / remove a friendship.
  Future<void> removeFriendship(String friendshipId);

  /// Get a user's invite code.
  Future<String> getInviteCode(String uid);

  /// Get a friend's habit completion rate for today.
  Future<double> getFriendTodayRate(String friendUid);

  /// Stream of friend profiles for realtime updates.
  Stream<List<FriendProfile>> friendsStream(String myUid);
}
