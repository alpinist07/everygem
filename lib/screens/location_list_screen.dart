import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/location_provider.dart';
import '../services/location_service.dart';

class LocationListScreen extends StatelessWidget {
  const LocationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final locProvider = context.watch<LocationProvider>();
    final reminders = locProvider.reminders;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: context.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: context.textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(lang.tr(AppLocalizations.kLocationReminders),
            style: AppTextStyles.heading3.copyWith(color: context.textP)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, lang, locProvider),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_location_alt, color: Colors.white),
      ),
      body: reminders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📍', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text(lang.tr(AppLocalizations.kNoLocationReminders),
                      style:
                          AppTextStyles.subtitle.copyWith(color: context.textP)),
                  const SizedBox(height: 8),
                  Text(lang.tr(AppLocalizations.kTapToAddLocation),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: context.textS)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final r = reminders[index];
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
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.location_on,
                            color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.name,
                                style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: context.textP)),
                            Text(
                              '${lang.tr(r.triggerType == 'enter' ? AppLocalizations.kOnArrive : AppLocalizations.kOnLeave)}  •  ${r.radiusMeters.round()}m',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: context.textS),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: AppColors.red, size: 20),
                        onPressed: () => locProvider.deleteReminder(r.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(
      BuildContext context, LanguageProvider lang, LocationProvider locProvider) {
    final nameCtrl = TextEditingController();
    String trigger = 'enter';
    double radius = 200;
    final locationService = LocationService();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(lang.tr(AppLocalizations.kAddLocationReminder)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    hintText: lang.tr(AppLocalizations.kLocationNameHint),
                    prefixIcon: const Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Text(lang.tr(AppLocalizations.kTriggerWhen),
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: Text(lang.tr(AppLocalizations.kArrive)),
                      selected: trigger == 'enter',
                      onSelected: (_) => setState(() => trigger = 'enter'),
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(lang.tr(AppLocalizations.kLeave)),
                      selected: trigger == 'exit',
                      onSelected: (_) => setState(() => trigger = 'exit'),
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  lang.trWith(AppLocalizations.kRadius,
                      {'radius': radius.round().toString()}),
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Slider(
                  value: radius,
                  min: 50,
                  max: 1000,
                  divisions: 19,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => radius = v),
                ),
                const SizedBox(height: 8),
                Text(lang.tr(AppLocalizations.kUsesCurrentLocation),
                    style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(lang.tr(AppLocalizations.kCancel)),
            ),
            TextButton(
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;

                final pos = await locationService.getCurrentPosition();
                if (pos == null) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(
                          content: Text(
                              lang.tr(AppLocalizations.kCouldNotGetLocation))),
                    );
                  }
                  return;
                }

                await locProvider.addReminder(
                  name: name,
                  latitude: pos.latitude,
                  longitude: pos.longitude,
                  radiusMeters: radius,
                  triggerType: trigger,
                );

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(lang.tr(AppLocalizations.kSave)),
            ),
          ],
        ),
      ),
    );
  }
}
