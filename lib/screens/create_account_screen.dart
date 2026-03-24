import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/routes.dart';
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

  final List<Map<String, String>> _habitOptions = [
    {'emoji': '💧', 'name': 'Drink water'},
    {'emoji': '🏃', 'name': 'Run'},
    {'emoji': '📚', 'name': 'Read books'},
    {'emoji': '🧘', 'name': 'Meditate'},
    {'emoji': '👨‍💻', 'name': 'Study'},
    {'emoji': '📕', 'name': 'Journal'},
    {'emoji': '🌿', 'name': 'Plants'},
    {'emoji': '🥳', 'name': 'Socialize'},
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
    if (_currentStep == 0 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
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

    await userProvider.createUser(
      name: _nameController.text.trim(),
      surname: _surnameController.text.trim(),
      birthdate: _birthdateController.text.trim(),
      gender: _selectedGender,
    );

    // Add selected initial habits
    final colors = AppColors.habitColors;
    int colorIndex = 0;
    for (final habitName in _selectedHabits) {
      final option =
          _habitOptions.firstWhere((o) => o['name'] == habitName);
      await habitProvider.addHabit(
        name: option['name']!,
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
        title: Text('Create Account', style: AppTextStyles.heading3),
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
                _buildNameStep(),
                _buildGenderStep(),
                _buildHabitsStep(),
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
                  _currentStep == 2 ? 'Get Started' : 'Next',
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildLabel('NAME'),
          _buildTextField(_nameController, 'Enter your name'),
          const SizedBox(height: 20),
          _buildLabel('SURNAME'),
          _buildTextField(_surnameController, 'Enter your surname'),
          const SizedBox(height: 20),
          _buildLabel('BIRTHDATE'),
          _buildTextField(_birthdateController, 'mm/dd/yyyy'),
        ],
      ),
    );
  }

  Widget _buildGenderStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Choose your gender', style: AppTextStyles.subtitle),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildGenderOption('Male', '🧑'),
              const SizedBox(width: 16),
              _buildGenderOption('Female', '👩'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Choose your first habits', style: AppTextStyles.subtitle),
          const SizedBox(height: 4),
          Text(
            'You may add more habits later',
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
              itemCount: _habitOptions.length,
              itemBuilder: (context, index) {
                final option = _habitOptions[index];
                final isSelected =
                    _selectedHabits.contains(option['name']);
                return _buildHabitOption(
                  option['emoji']!,
                  option['name']!,
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

  Widget _buildHabitOption(String emoji, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedHabits.remove(name);
          } else {
            _selectedHabits.add(name);
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
