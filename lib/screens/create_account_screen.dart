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
  static const _totalSteps = 5;

  // Step 0: Credentials
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  // Step 1: Name/birthdate
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  DateTime? _selectedBirthdate;

  // Step 2: Gender
  String? _selectedGender;

  // Step 3: Role & Purpose
  String? _selectedRole;
  String? _selectedPurpose;

  // Step 4: Initial habits
  final Set<String> _selectedHabits = {};

  static const _roleOptions = [
    (AppLocalizations.kRoleStudent, '🎓'),
    (AppLocalizations.kRoleWorker, '💼'),
    (AppLocalizations.kRoleHomemaker, '🏠'),
    (AppLocalizations.kRoleParent, '👨‍👧'),
    (AppLocalizations.kRoleOther, '✨'),
  ];

  static const _purposeOptions = [
    (AppLocalizations.kPurposeHealth, '💪'),
    (AppLocalizations.kPurposeProductivity, '⚡'),
    (AppLocalizations.kPurposeMindfulness, '🧘'),
    (AppLocalizations.kPurposeLearning, '📚'),
    (AppLocalizations.kPurposeOther, '🌟'),
  ];

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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthdate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year - 5, now.month, now.day),
    );
    if (picked != null) setState(() => _selectedBirthdate = picked);
  }

  String _formatBirthdate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  bool _isValidEmail(String email) {
    final re = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    return re.hasMatch(email.trim());
  }

  void _nextStep() {
    final lang = context.read<LanguageProvider>();

    if (_currentStep == 0) {
      final email = _emailController.text.trim();
      final pw = _passwordController.text;
      final cpw = _confirmPasswordController.text;
      if (!_isValidEmail(email)) {
        _showError(lang.tr(AppLocalizations.kInvalidEmail));
        return;
      }
      if (pw.length < 6) {
        _showError(lang.tr(AppLocalizations.kPasswordTooShort));
        return;
      }
      if (pw != cpw) {
        _showError(lang.tr(AppLocalizations.kPasswordsDoNotMatch));
        return;
      }
    }

    if (_currentStep == 1 && _nameController.text.trim().isEmpty) {
      _showError(lang.tr(AppLocalizations.kPleaseEnterName));
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _createAccount();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _createAccount() async {
    final userProvider = context.read<UserProvider>();
    final habitProvider = context.read<HabitProvider>();
    final lang = context.read<LanguageProvider>();

    await userProvider.createUser(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      birthdate: _selectedBirthdate != null ? _formatBirthdate(_selectedBirthdate!) : null,
      gender: _selectedGender,
      email: _emailController.text.trim(),
      role: _selectedRole,
      purpose: _selectedPurpose,
    );

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
                icon: const Icon(Icons.chevron_left, color: AppColors.textPrimary),
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              )
            : null,
        title: Text(lang.tr(AppLocalizations.kCreateAccount), style: AppTextStyles.heading3),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: AppColors.cardBorder,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 3,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentStep = index),
              children: [
                _buildCredentialsStep(lang),
                _buildNameStep(lang),
                _buildGenderStep(lang),
                _buildRolePurposeStep(lang),
                _buildHabitsStep(lang),
              ],
            ),
          ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Text(
                  _currentStep == _totalSteps - 1
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

  // ── Step 0: Credentials ──
  Widget _buildCredentialsStep(LanguageProvider lang) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildLabel(lang.tr(AppLocalizations.kEmail)),
          _buildTextField(
            _emailController,
            lang.tr(AppLocalizations.kEmailHint),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          _buildLabel(lang.tr(AppLocalizations.kPassword)),
          _buildPasswordField(
            _passwordController,
            lang.tr(AppLocalizations.kPasswordHint),
            obscure: _obscurePassword,
            onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
          const SizedBox(height: 20),
          _buildLabel(lang.tr(AppLocalizations.kConfirmPassword)),
          _buildPasswordField(
            _confirmPasswordController,
            lang.tr(AppLocalizations.kConfirmPasswordHint),
            obscure: _obscureConfirm,
            onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Step 1: Name / birthdate ──
  Widget _buildNameStep(LanguageProvider lang) {
    return SingleChildScrollView(
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
          _buildDatePicker(lang),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Step 2: Gender ──
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

  // ── Step 3: Role & Purpose ──
  Widget _buildRolePurposeStep(LanguageProvider lang) {

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(lang.tr(AppLocalizations.kChooseRole), style: AppTextStyles.subtitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _roleOptions.map((opt) {
              final isSelected = _selectedRole == opt.$1;
              return _buildChipOption(
                emoji: opt.$2,
                label: lang.tr(opt.$1),
                isSelected: isSelected,
                onTap: () => setState(() => _selectedRole = opt.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          Text(lang.tr(AppLocalizations.kChoosePurpose), style: AppTextStyles.subtitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _purposeOptions.map((opt) {
              final isSelected = _selectedPurpose == opt.$1;
              return _buildChipOption(
                emoji: opt.$2,
                label: lang.tr(opt.$1),
                isSelected: isSelected,
                onTap: () => setState(() => _selectedPurpose = opt.$1),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Step 4: Initial habits ──
  Widget _buildHabitsStep(LanguageProvider lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(lang.tr(AppLocalizations.kChooseFirstHabits), style: AppTextStyles.subtitle),
          const SizedBox(height: 4),
          Text(lang.tr(AppLocalizations.kAddMoreLater), style: AppTextStyles.bodySmall),
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
                return _buildHabitOption(option['emoji']!, lang.tr(key), key, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Shared widgets ──
  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: AppTextStyles.label),
      );

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cardBorder)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.cardBorder)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primary, width: 2)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
        suffixIcon: suffixIcon,
      );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.body,
      decoration: _inputDecoration(hint),
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    String hint, {
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: AppTextStyles.body,
      decoration: _inputDecoration(
        hint,
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: AppColors.textSecondary, size: 20),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildDatePicker(LanguageProvider lang) {
    return GestureDetector(
      onTap: _pickBirthdate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedBirthdate != null
                    ? _formatBirthdate(_selectedBirthdate!)
                    : lang.tr(AppLocalizations.kBirthdateHint),
                style: AppTextStyles.body.copyWith(
                  color: _selectedBirthdate != null
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
              ),
            ),
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
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

  Widget _buildChipOption({
    required String emoji,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitOption(String emoji, String name, String key, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          _selectedHabits.remove(key);
        } else {
          _selectedHabits.add(key);
        }
      }),
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
