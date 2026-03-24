import 'dart:async';
import 'package:flutter/material.dart';
import '../models/friendship.dart';
import '../repositories/friend_repository.dart';

class FriendProvider extends ChangeNotifier {
  final FriendRepository _repo;
  final String _myUid;

  List<FriendProfile> _friends = [];
  List<Friendship> _pendingRequests = [];
  String _inviteCode = '';
  final Map<String, double> _friendRates = {}; // uid → today rate
  StreamSubscription? _friendsSub;

  FriendProvider(this._repo, this._myUid) {
    _init();
  }

  List<FriendProfile> get friends => _friends;
  List<Friendship> get pendingRequests => _pendingRequests;
  String get inviteCode => _inviteCode;
  Map<String, double> get friendRates => _friendRates;

  Future<void> _init() async {
    _inviteCode = await _repo.getInviteCode(_myUid);
    await refresh();

    // Listen for realtime updates
    _friendsSub = _repo.friendsStream(_myUid).listen((profiles) {
      _friends = profiles;
      _loadRates();
      notifyListeners();
    });
  }

  Future<void> refresh() async {
    _friends = await _repo.getFriends(_myUid);
    _pendingRequests = await _repo.getPendingRequests(_myUid);
    await _loadRates();
    notifyListeners();
  }

  Future<void> _loadRates() async {
    for (final f in _friends) {
      _friendRates[f.uid] = await _repo.getFriendTodayRate(f.uid);
    }
  }

  Future<bool> sendFriendRequest(String inviteCode,
      {String relationship = 'friend'}) async {
    final ok = await _repo.sendRequest(
      fromUid: _myUid,
      toInviteCode: inviteCode,
      relationshipType: relationship,
    );
    if (ok) await refresh();
    return ok;
  }

  Future<void> acceptRequest(String friendshipId) async {
    await _repo.acceptRequest(friendshipId);
    await refresh();
  }

  Future<void> declineRequest(String friendshipId) async {
    await _repo.removeFriendship(friendshipId);
    await refresh();
  }

  Future<void> removeFriend(String friendshipId) async {
    await _repo.removeFriendship(friendshipId);
    await refresh();
  }

  @override
  void dispose() {
    _friendsSub?.cancel();
    super.dispose();
  }
}
