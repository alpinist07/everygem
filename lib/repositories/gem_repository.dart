import '../models/gem_log.dart';
import '../models/reward.dart';

abstract class GemRepository {
  int getTotalGems();
  Future<void> saveTotalGems(int total);
  List<GemLog> getGemLogs();
  Future<void> addGemLog(GemLog log);
  List<Reward> getRewards();
  Future<void> saveReward(Reward reward);
  Future<void> deleteReward(String id);
}
