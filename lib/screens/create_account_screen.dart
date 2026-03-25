import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/language_provider.dart';
import '../providers/user_provider.dart';
import '../providers/habit_provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  // Step 1: Name
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthdateController = TextEditingController();

  // Step 2: Gender
  String? _selectedGender;

  // Step 3: Initial habits
  final Set<String> _selectedHabits = {};

  static const _habitOptionKeys = [
    {'emoji': '💧', 'key': AppLocalizations.kHabitDrinkWater},
    {'emoji': '🏃', 'key': AppLocalizations.kHabitRun},
    {'emoji': '📚', 'key': AppLocalizations.kHabitReadBooks},
    {'emoji': '🧘', 'key': AppLocalizations.kHabitMeditate},
    {'emoji': '👨‍💻', 'key': AppLocalizations.kHabitStudy},
    {'emoji': '📕', 'key': AppLocalizations.kHabitJournal},
    {'emoji': '🌿', 'key': AppLocalizations.kHabitPlants},
    {'emoji': '🥳', 'key': AppLocalizations.kHabitSocialize},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _birthdateController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final lang = context.read<LanguageProvider>();
    if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.tr(AppLocalizations.kPleaseEnterName))),
      );
      return;
    }
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _createAccount();
    }
  }

  Future<void> _createAccount() async {
    final userProvider = context.read<UserProvider>();
    final habitProvider = context.read<HabitProvider>();
    final lang = context.read<LanguageProvider>();

    await userProvider.createUser(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      birthdate: _birthdateController.text.trim(),
      gender: _selectedGender,
    );

    // Add selected initial habits
    final colors = AppColors.habitColors;
    int colorIndex = 0;
    for (final key in _selectedHabits) {
      final option = _habitOptionKeys.firstWhere((o) => o['key'] == key);
      await habitProvider.addHabit(
        name: lang.tr(option['key']!),
        emoji: option['emoji']!,
        color: colors[colorIndex % colors.length],
      );
      colorIndex++;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon:
                    const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
        title: Text(lang.tr(AppLocalizations.kCreateAccount), style: AppTextStyles.heading3),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentStep = index);
              },
              children: [
                _buildNameStep(lang),
                _buildGenderStep(lang),
                _buildHabitsStep(lang),
              ],
            ),
          ),
          // Next button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == 2
                      ? lang.tr(AppLocalizations.kGetStarted)
                      : lang.tr(AppLocalizations.kNext),
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildLabel(lang.tr(AppLocalizations.kName)),
          _buildTextField(_nameController, lang.tr(AppLocalizations.kEnterName)),
          const SizedBox(height: 20),
          _buildLabel(lang.tr(AppLocalizations.kSurname)),
          _buildTextField(_surnameController, lang.tr(AppLocalizations.kEnterSurname)),
          const SizedBox(height: 20),
          _buildLabel(lang.tr(AppLocalizations.kBirthdate)),
          _buildTextField(_birthdateController, lang.tr(AppLocalizations.kBirthdateHint)),
        ],
      ),
    );
  }

  Widget _buildGenderStep(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(lang.tr(AppLocalizations.kChooseGender), style: AppTextStyles.subtitle),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildGenderOption(lang.tr(AppLocalizations.kMale), '🧑'),
              const SizedBox(width: 16),
              _buildGenderOption(lang.tr(AppLocalizations.kFemale), '👩'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsStep(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(lang.tr(AppLocalizations.kChooseFirstHabits), style: AppTextStyles.subtitle),
          const SizedBox(height: 4),
          Text(
            lang.tr(AppLocalizations.kAddMoreLater),
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: _habitOptionKeys.length,
              itemBuilder: (context, index) {
                final option = _habitOptionKeys[index];
                final key = option['key']!;
                final isSelected = _selectedHabits.contains(key);
                return _buildHabitOption(
                  option['emoji']!,
                  lang.tr(key),
                  key,
                  isSelected,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.label,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      ),
    );
  }

  Widget _buildGenderOption(String label, String emoji) {
    final isSelected = _selectedGender == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.cardBorder,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(height: 8),
              Text(label, style: AppTextStyles.subtitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHabitOption(String emoji, String name, String key, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedHabits.remove(key);
          } else {
            _selectedHabits.add(key);
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(name, style: AppTextStyles.body),
          ],
        ),
      ),
    );
  }
}
