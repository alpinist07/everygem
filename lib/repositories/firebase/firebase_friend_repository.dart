import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/friendship.dart';
import '../friend_repository.dart';

class FirebaseFriendRepository implements FriendRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<List<FriendProfile>> getFriends(String myUid) async {
    // Get friendships where I am involved and status is accepted
    final q1 = await _db
        .collection('friendships')
        .where('fromUid', isEqualTo: myUid)
        .where('status', isEqualTo: 'accepted')
        .get();
    final q2 = await _db
        .collection('friendships')
        .where('toUid', isEqualTo: myUid)
        .where('status', isEqualTo: 'accepted')
        .get();

    final friendUids = <String>{};
    for (final doc in [...q1.docs, ...q2.docs]) {
      final data = doc.data();
      final from = data['fromUid'] as String;
      final to = data['toUid'] as String;
      friendUids.add(from == myUid ? to : from);
    }

    if (friendUids.isEmpty) return [];

    final profiles = <FriendProfile>[];
    for (final uid in friendUids) {
      final userDoc = await _db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final d = userDoc.data()!;
        profiles.add(FriendProfile(
          uid: uid,
          name: d['name'] as String? ?? 'User',
          totalGems: d['totalGems'] as int? ?? 0,
          level: d['level'] as int? ?? 1,
          role: d['role'] as String?,
        ));
      }
    }
    return profiles;
  }

  @override
  Future<List<Friendship>> getPendingRequests(String myUid) async {
    final snap = await _db
        .collection('friendships')
        .where('toUid', isEqualTo: myUid)
        .where('status', isEqualTo: 'pending')
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return Friendship.fromJson(data);
    }).toList();
  }

  @override
  Future<bool> sendRequest({
    required String fromUid,
    required String toInviteCode,
    String relationshipType = 'friend',
  }) async {
    // Find user by invite code
    final snap = await _db
        .collection('users')
        .where('inviteCode', isEqualTo: toInviteCode.toUpperCase())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) return false;

    final toUid = snap.docs.first.id;
    if (toUid == fromUid) return false;

    // Check if friendship already exists
    final existing = await _db
        .collection('friendships')
        .where('fromUid', isEqualTo: fromUid)
        .where('toUid', isEqualTo: toUid)
        .get();
    if (existing.docs.isNotEmpty) return false;

    await _db.collection('friendships').add({
      'fromUid': fromUid,
      'toUid': toUid,
      'status': 'pending',
      'relationshipType': relationshipType,
      'createdAt': DateTime.now().toIso8601String(),
    });

    return true;
  }

  @override
  Future<void> acceptRequest(String friendshipId) async {
    await _db
        .collection('friendships')
        .doc(friendshipId)
        .update({'status': 'accepted'});
  }

  @override
  Future<void> removeFriendship(String friendshipId) async {
    await _db.collection('friendships').doc(friendshipId).delete();
  }

  @override
  Future<String> getInviteCode(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists && doc.data()!.containsKey('inviteCode')) {
      return doc.data()!['inviteCode'] as String;
    }
    // Generate if missing
    final code = uid.substring(0, 8).toUpperCase();
    await _db.collection('users').doc(uid).update({'inviteCode': code});
    return code;
  }

  @override
  Future<double> getFriendTodayRate(String friendUid) async {
    final now = DateTime.now();
    final dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    final habitsSnap = await _db
        .collection('users')
        .doc(friendUid)
        .collection('habits')
        .get();

    if (habitsSnap.docs.isEmpty) return 0;

    int total = 0, done = 0;
    for (final doc in habitsSnap.docs) {
      final data = doc.data();
      final activeDays = List<int>.from(data['activeDays'] ?? []);
      if (!activeDays.contains(now.weekday)) continue;
      total++;
      final log = Map<String, dynamic>.from(data['completionLog'] ?? {});
      if (log[dateKey] == true) done++;
    }

    return total > 0 ? done / total : 0;
  }

  @override
  Stream<List<FriendProfile>> friendsStream(String myUid) {
    // Listen to friendships collection for changes
    return _db
        .collection('friendships')
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .asyncMap((snap) async {
      final friendUids = <String>{};
      for (final doc in snap.docs) {
        final data = doc.data();
        final from = data['fromUid'] as String;
        final to = data['toUid'] as String;
        if (from == myUid) friendUids.add(to);
        if (to == myUid) friendUids.add(from);
      }

      final profiles = <FriendProfile>[];
      for (final uid in friendUids) {
        final userDoc = await _db.collection('users').doc(uid).get();
        if (userDoc.exists) {
          final d = userDoc.data()!;
          profiles.add(FriendProfile(
            uid: uid,
            name: d['name'] as String? ?? 'User',
            totalGems: d['totalGems'] as int? ?? 0,
            level: d['level'] as int? ?? 1,
            role: d['role'] as String?,
          ));
        }
      }
      return profiles;
    });
  }
}
