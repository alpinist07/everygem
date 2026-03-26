import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import 'location_list_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.tr(AppLocalizations.kSettings),
            style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // General section
          Text(lang.tr(AppLocalizations.kGeneral).toUpperCase(),
              style: AppTextStyles.label.copyWith(color: context.textS)),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.person_outline,
                title: lang.tr(AppLocalizations.kEditProfile),
                onTap: () => _showEditProfileDialog(context, lang, userProvider),
              ),
              _SettingsDivider(),
              _SettingsToggle(
                icon: Icons.dark_mode_outlined,
                title: lang.tr(AppLocalizations.kDarkMode),
                value: themeProvider.isDarkMode,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
              _SettingsDivider(),
              _LanguageTile(lang: lang),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                title: lang.tr(AppLocalizations.kNotifications),
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                title: lang.tr(AppLocalizations.kLocationReminders),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const LocationListScreen()),
                ),
              ),
              _SettingsDivider(),
              _SettingsToggle(
                icon: Icons.volume_up_outlined,
                title: lang.tr(AppLocalizations.kSounds),
                value: true,
                onChanged: (_) {},
              ),
            ],
          ),
          const SizedBox(height: 24),

          // About section
          Text(lang.tr(AppLocalizations.kAboutUs).toUpperCase(),
              style: AppTextStyles.label.copyWith(color: context.textS)),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.star_outline,
                title: lang.tr(AppLocalizations.kRateApp),
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.share_outlined,
                title: lang.tr(AppLocalizations.kShareWithFriends),
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.info_outline,
                title: lang.tr(AppLocalizations.kAboutUs),
                onTap: () {},
              ),
              _SettingsDivider(),
              _SettingsTile(
                icon: Icons.help_outline,
                title: lang.tr(AppLocalizations.kSupport),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
      BuildContext context, LanguageProvider lang, UserProvider userProvider) {
    final controller =
        TextEditingController(text: userProvider.user?.name ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.tr(AppLocalizations.kEditName)),
        content: TextField(
          controller: controller,
          decoration:
              InputDecoration(hintText: lang.tr(AppLocalizations.kEnterYourName)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.tr(AppLocalizations.kCancel)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                userProvider.updateUser(name: controller.text.trim());
              }
              Navigator.pop(ctx);
            },
            child: Text(lang.tr(AppLocalizations.kSave)),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final LanguageProvider lang;

  const _LanguageTile({required this.lang});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: lang.toggleLanguage,
      leading: Icon(Icons.language, color: context.textP, size: 22),
      title: Text(lang.tr(AppLocalizations.kLanguage),
          style: AppTextStyles.body.copyWith(color: context.textP)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          lang.isKorean ? '한국어' : 'English',
          style: AppTextStyles.body.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.textP, size: 22),
      title: Text(title,
          style: AppTextStyles.body.copyWith(color: context.textP)),
      trailing: Icon(Icons.chevron_right, color: context.textH, size: 20),
      onTap: onTap,
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.textP, size: 22),
      title: Text(title,
          style: AppTextStyles.body.copyWith(color: context.textP)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.green,
        activeThumbColor: Colors.white,
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, indent: 56, color: context.div);
  }
}
