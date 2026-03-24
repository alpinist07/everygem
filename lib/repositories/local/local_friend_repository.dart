import 'dart:convert';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/friendship.dart';
import '../friend_repository.dart';

/// Local stub for FriendRepository.
/// Works without Firebase for prototyping/testing.
class LocalFriendRepository implements FriendRepository {
  static const String _boxName = 'friends';
  final Box _box;
  final String _myInviteCode;

  LocalFriendRepository(this._box)
      : _myInviteCode = _generateCode();

  static Future<LocalFriendRepository> create() async {
    final box = await Hive.openBox(_boxName);
    return LocalFriendRepository(box);
  }

  static String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    return List.generate(8, (_) => chars[rng.nextInt(chars.length)]).join();
  }

  @override
  Future<List<FriendProfile>> getFriends(String myUid) async {
    final raw = _box.get('friends_list');
    if (raw == null) return [];
    final list = jsonDecode(raw as String) as List;
    return list.map((e) => FriendProfile.fromJson(e)).toList();
  }

  @override
  Future<List<Friendship>> getPendingRequests(String myUid) async {
    return []; // No pending requests in local mode
  }

  @override
  Future<bool> sendRequest({
    required String fromUid,
    required String toInviteCode,
    String relationshipType = 'friend',
  }) async {
    return false; // Cannot send requests in local mode
  }

  @override
  Future<void> acceptRequest(String friendshipId) async {}

  @override
  Future<void> removeFriendship(String friendshipId) async {}

  @override
  Future<String> getInviteCode(String uid) async => _myInviteCode;

  @override
  Future<double> getFriendTodayRate(String friendUid) async => 0;

  @override
  Stream<List<FriendProfile>> friendsStream(String myUid) {
    return Stream.value([]);
  }
}
