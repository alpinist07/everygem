import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/gem_log.dart';
import '../../models/reward.dart';
import '../gem_repository.dart';

class LocalGemRepository implements GemRepository {
  static const String _gemsKey = 'total_gems';
  static const String _logsBox = 'gem_logs';
  static const String _rewardsBox = 'rewards';

  final SharedPreferences _prefs;
  final Box _logBox;
  final Box _rewardBox;

  LocalGemRepository(this._prefs, this._logBox, this._rewardBox);

  static Future<LocalGemRepository> create(SharedPreferences prefs) async {
    final logBox = await Hive.openBox(_logsBox);
    final rewardBox = await Hive.openBox(_rewardsBox);
    return LocalGemRepository(prefs, logBox, rewardBox);
  }

  @override
  int getTotalGems() => _prefs.getInt(_gemsKey) ?? 0;

  @override
  Future<void> saveTotalGems(int total) async {
    await _prefs.setInt(_gemsKey, total);
  }

  @override
  List<GemLog> getGemLogs() {
    return _logBox.values
        .map((e) => GemLog.fromJson(jsonDecode(e as String)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> addGemLog(GemLog log) async {
    await _logBox.put(log.id, jsonEncode(log.toJson()));
  }

  @override
  List<Reward> getRewards() {
    return _rewardBox.values
        .map((e) => Reward.fromJson(jsonDecode(e as String)))
        .toList();
  }

  @override
  Future<void> saveReward(Reward reward) async {
    await _rewardBox.put(reward.id, jsonEncode(reward.toJson()));
  }

  @override
  Future<void> deleteReward(String id) async {
    await _rewardBox.delete(id);
  }
}
