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

  String get levelName => levelNameKeys[level];

  static const _levelThresholds = [0, 51, 151, 301, 501];

  /// Returns the l10n key for the current level.
  static const levelNameKeys = [
    '',
    'levelSeedling',
    'levelSprout',
    'levelTree',
    'levelGem',
    'levelDiamond',
  ];

  int get gemsToNextLevel {
    if (level >= 5) return 0;
    return _levelThresholds[level] - _totalGems;
  }

  double get levelProgress {
    if (level >= 5) return 1.0;
    final prev = level > 1 ? _levelThresholds[level - 1] : 0;
    final next = _levelThresholds[level];
    return (_totalGems - prev) / (next - prev);
  }

  /// Award fixed gems for completing a habit (5 per check).
  /// Returns the total amount awarded (including any challenge bonus).
  Future<int> awardGems({required String habitId, int currentStreak = 0}) async {
    const base = 5;

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

    // Award random challenge bonus on streak milestones
    final milestones = [7, 30, 100];
    if (milestones.contains(currentStreak)) {
      final bonus = await _awardChallengeBonus(habitId: habitId, streak: currentStreak);
      return base + bonus;
    }

    return base;
  }

  /// Award a random bonus when a challenge milestone is reached.
  Future<int> _awardChallengeBonus({required String habitId, required int streak}) async {
    final rng = Random();
    int bonus;
    if (streak >= 100) {
      bonus = rng.nextInt(46) + 30; // 30~75
    } else if (streak >= 30) {
      bonus = rng.nextInt(16) + 15; // 15~30
    } else {
      bonus = rng.nextInt(6) + 5; // 5~10
    }

    final log = GemLog(
      id: const Uuid().v4(),
      amount: bonus,
      reason: 'streak_bonus',
      habitId: habitId,
    );
    _totalGems += bonus;
    _logs.insert(0, log);
    await _repo.saveTotalGems(_totalGems);
    await _repo.addGemLog(log);
    notifyListeners();
    return bonus;
  }

  /// Deduct gems when a habit completion is unchecked.
  Future<void> deductGems({required String habitId}) async {
    const amount = 5;
    if (_totalGems < amount) {
      _totalGems = 0;
    } else {
      _totalGems -= amount;
    }

    final log = GemLog(
      id: const Uuid().v4(),
      amount: -amount,
      reason: 'habit_uncomplete',
      habitId: habitId,
    );
    _logs.insert(0, log);
    await _repo.saveTotalGems(_totalGems);
    await _repo.addGemLog(log);
    notifyListeners();
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
