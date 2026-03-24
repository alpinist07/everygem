import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../providers/friend_provider.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fp = context.watch<FriendProvider>();

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Friends',
            style: AppTextStyles.heading3.copyWith(color: context.textP)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_outlined, color: context.textP),
            onPressed: () => _showAddFriendDialog(context, fp),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My invite code
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text('My Invite Code',
                      style: GoogleFonts.inter(
                          fontSize: 12, color: Colors.white70)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                          ClipboardData(text: fp.inviteCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Code copied!')),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(fp.inviteCode,
                            style: GoogleFonts.inter(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 4)),
                        const SizedBox(width: 8),
                        const Icon(Icons.copy, color: Colors.white70, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Share this code with friends & family',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: Colors.white60)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pending requests
            if (fp.pendingRequests.isNotEmpty) ...[
              Text('Pending Requests',
                  style: AppTextStyles.subtitle.copyWith(color: context.textP)),
              const SizedBox(height: 12),
              ...fp.pendingRequests.map((req) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Text('👋', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text('Friend request',
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.textP)),
                        ),
                        TextButton(
                          onPressed: () => fp.acceptRequest(req.id),
                          child: const Text('Accept'),
                        ),
                        TextButton(
                          onPressed: () => fp.declineRequest(req.id),
                          child: const Text('Decline',
                              style: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 24),
            ],

            // Friends list
            Text('Friends (${fp.friends.length})',
                style: AppTextStyles.subtitle.copyWith(color: context.textP)),
            const SizedBox(height: 12),

            if (fp.friends.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: context.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.border),
                ),
                child: Column(
                  children: [
                    const Text('👥', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text('No friends yet',
                        style: AppTextStyles.subtitle.copyWith(color: context.textP)),
                    const SizedBox(height: 8),
                    Text('Share your invite code to connect!',
                        style: AppTextStyles.bodySmall.copyWith(color: context.textS)),
                  ],
                ),
              )
            else
              ...fp.friends.map((friend) {
                final rate = fp.friendRates[friend.uid] ?? 0;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.border),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.1),
                        child: Text(
                          friend.name.isNotEmpty
                              ? friend.name[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(friend.name,
                                    style: GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: context.textP)),
                                if (friend.role != null) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.amber.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(friend.role!,
                                        style: GoogleFonts.inter(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.amber)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                                '💎 ${friend.totalGems}  •  Today: ${(rate * 100).round()}%',
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: context.textS)),
                          ],
                        ),
                      ),
                      // Today's progress ring
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: rate,
                              strokeWidth: 3,
                              backgroundColor: context.border,
                              valueColor: AlwaysStoppedAnimation(
                                rate >= 1.0
                                    ? AppColors.green
                                    : AppColors.primary,
                              ),
                            ),
                            Text('${(rate * 100).round()}',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: context.textP)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, FriendProvider fp) {
    final codeCtrl = TextEditingController();
    String relationship = 'friend';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Add Friend'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeCtrl,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  hintText: 'Enter invite code',
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                ),
              ),
              const SizedBox(height: 16),
              Text('Relationship:',
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Friend'),
                    selected: relationship == 'friend',
                    onSelected: (_) =>
                        setState(() => relationship = 'friend'),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                  ChoiceChip(
                    label: const Text('Parent-Child'),
                    selected: relationship == 'parent-child',
                    onSelected: (_) =>
                        setState(() => relationship = 'parent-child'),
                    selectedColor: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final code = codeCtrl.text.trim();
                if (code.isEmpty) return;
                final ok = await fp.sendFriendRequest(code,
                    relationship: relationship);
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(ok
                            ? 'Friend request sent!'
                            : 'Could not find user with that code')),
                  );
                }
              },
              child: const Text('Send Request'),
            ),
          ],
        ),
      ),
    );
  }
}
