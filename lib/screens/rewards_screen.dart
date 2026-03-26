import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/gem_provider.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final gem = context.watch<GemProvider>();

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.tr(AppLocalizations.kRewards), style: AppTextStyles.heading3.copyWith(color: context.textP)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRewardDialog(context, gem, lang),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gem balance & level
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('💎', style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 8),
                  Text('${gem.totalGems}',
                      style: GoogleFonts.inter(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                  Text(lang.tr(AppLocalizations.kGems), style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(lang.tr(gem.levelName),
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: gem.levelProgress,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  if (gem.gemsToNextLevel > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                          lang.trWith(AppLocalizations.kGemsToNextLevel, {'count': '${gem.gemsToNextLevel}'}),
                          style: GoogleFonts.inter(fontSize: 11, color: Colors.white60)),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Available rewards
            Text(lang.tr(AppLocalizations.kAvailableRewards), style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            if (gem.rewards.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: Center(
                  child: Text(lang.tr(AppLocalizations.kNoRewardsYet),
                      style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
                ),
              )
            else
              ...gem.rewards.where((r) => !r.isRedeemed).map((reward) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.border),
                    ),
                    child: Row(
                      children: [
                        Text(reward.emoji, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(reward.name,
                                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: context.textP)),
                              Text('💎 ${reward.cost} ${lang.tr(AppLocalizations.kGems)}',
                                  style: GoogleFonts.inter(fontSize: 12, color: context.textS)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: gem.totalGems >= reward.cost
                              ? () async {
                                  final ok = await gem.redeemReward(reward.id);
                                  if (ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('🎉 ${reward.name} ${lang.tr(AppLocalizations.kRedeemed)}')),
                                    );
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: context.border,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: Text(lang.tr(AppLocalizations.kRedeem)),
                        ),
                      ],
                    ),
                  )),
            const SizedBox(height: 24),

            // Recent gem history
            Text(lang.tr(AppLocalizations.kRecentHistory), style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),
            ...gem.logs.take(20).map((log) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        log.amount > 0 ? Icons.add_circle_outline : Icons.remove_circle_outline,
                        color: log.amount > 0 ? AppColors.green : AppColors.red,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _reasonLabel(log.reason, lang),
                          style: GoogleFonts.inter(fontSize: 13, color: context.textP),
                        ),
                      ),
                      Text(
                        '${log.amount > 0 ? '+' : ''}${log.amount}',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: log.amount > 0 ? AppColors.green : AppColors.red,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _reasonLabel(String reason, LanguageProvider lang) {
    switch (reason) {
      case 'habit_complete':
        return lang.tr(AppLocalizations.kHabitCompleted);
      case 'streak_bonus':
        return lang.tr(AppLocalizations.kStreakBonus);
      case 'habit_uncomplete':
        return lang.tr(AppLocalizations.kHabitUncompleted);
      case 'reward_redeem':
        return lang.tr(AppLocalizations.kRewardRedeemed);
      default:
        return reason;
    }
  }

  void _showAddRewardDialog(BuildContext context, GemProvider gem, LanguageProvider lang) {
    final nameCtrl = TextEditingController();
    final costCtrl = TextEditingController();
    String emoji = '🎁';
    final emojis = ['🍦', '🎮', '🎬', '🍕', '📱', '🎁', '🏆', '⭐'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(lang.tr(AppLocalizations.kAddReward)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 8,
                children: emojis
                    .map((e) => GestureDetector(
                          onTap: () => setState(() => emoji = e),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: emoji == e ? AppColors.primary.withValues(alpha: 0.1) : null,
                              borderRadius: BorderRadius.circular(8),
                              border: emoji == e ? Border.all(color: AppColors.primary) : null,
                            ),
                            child: Text(e, style: const TextStyle(fontSize: 24)),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(hintText: lang.tr(AppLocalizations.kRewardName)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: costCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: lang.tr(AppLocalizations.kCostInGems)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(lang.tr(AppLocalizations.kCancel)),
            ),
            TextButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final cost = int.tryParse(costCtrl.text.trim());
                if (name.isEmpty || cost == null || cost <= 0) return;
                gem.addReward(name: name, emoji: emoji, cost: cost, createdBy: 'local');
                Navigator.pop(ctx);
              },
              child: Text(lang.tr(AppLocalizations.kAdd)),
            ),
          ],
        ),
      ),
    );
  }
}