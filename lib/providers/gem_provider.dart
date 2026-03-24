import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/gem_log.dart';
import '../models/reward.dart';
import '../repositories/gem_repository.dart';

class GemProvider extends ChangeNotifier {
  final GemRepository _repo;
  int _totalGems = 0;
  List<GemLog> _logs = [];
  List<Reward> _rewards = [];

  GemProvider(this._repo) {
    _totalGems = _repo.getTotalGems();
    _logs = _repo.getGemLogs();
    _rewards = _repo.getRewards();
  }

  int get totalGems => _totalGems;
  List<GemLog> get logs => _logs;
  List<Reward> get rewards => _rewards;

  // Level system
  int get level {
    if (_totalGems >= 501) return 5;
    if (_totalGems >= 301) return 4;
    if (_totalGems >= 151) return 3;
    if (_totalGems >= 51) return 2;
    return 1;
  }

  String get levelName {
    const names = ['', '🌱 Seedling', '🌿 Sprout', '🌳 Tree', '💎 Gem', '👑 Diamond'];
    return names[level];
  }

  int get gemsToNextLevel {
    const thresholds = [0, 51, 151, 301, 501];
    if (level >= 5) return 0;
    return thresholds[level] - _totalGems;
  }

  double get levelProgress {
    const thresholds = [0, 51, 151, 301, 501];
    if (level >= 5) return 1.0;
    final prev = level > 1 ? thresholds[level - 1] : 0;
    final next = thresholds[level];
    return (_totalGems - prev) / (next - prev);
  }

  /// Award random gems for completing a habit.
  /// Returns the amount awarded (for UI animation).
  Future<int> awardGems({required String habitId, int currentStreak = 0}) async {
    final rng = Random();
    int base = rng.nextInt(5) + 1; // 1~5
    if (currentStreak >= 7) base += 3; // streak bonus
    if (currentStreak >= 30) base += 5; // monthly bonus
    if (rng.nextInt(100) < 5) base += 10; // 5% jackpot

    final log = GemLog(
      id: const Uuid().v4(),
      amount: base,
      reason: 'habit_complete',
      habitId: habitId,
    );

    _totalGems += base;
    _logs.insert(0, log);
    await _repo.saveTotalGems(_totalGems);
    await _repo.addGemLog(log);
    notifyListeners();
    return base;
  }

  /// Redeem a reward (spend gems).
  Future<bool> redeemReward(String rewardId) async {
    final index = _rewards.indexWhere((r) => r.id == rewardId);
    if (index == -1) return false;
    final reward = _rewards[index];
    if (_totalGems < reward.cost) return false;

    _totalGems -= reward.cost;
    _rewards[index] = reward.copyWith(isRedeemed: true);

    final log = GemLog(
      id: const Uuid().v4(),
      amount: -reward.cost,
      reason: 'reward_redeem',
    );
    _logs.insert(0, log);

    await _repo.saveTotalGems(_totalGems);
    await _repo.saveReward(_rewards[index]);
    await _repo.addGemLog(log);
    notifyListeners();
    return true;
  }

  /// Add a reward (parent creates).
  Future<void> addReward({
    required String name,
    required String emoji,
    required int cost,
    required String createdBy,
  }) async {
    final reward = Reward(
      id: const Uuid().v4(),
      name: name,
      emoji: emoji,
      cost: cost,
      createdBy: createdBy,
    );
    _rewards.add(reward);
    await _repo.saveReward(reward);
    notifyListeners();
  }

  Future<void> deleteReward(String id) async {
    _rewards.removeWhere((r) => r.id == id);
    await _repo.deleteReward(id);
    notifyListeners();
  }
}
