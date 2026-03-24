import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constants/colors.dart';
import '../constants/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingData(
      title: 'Create\nGood Habits',
      subtitle:
          'Change your life by slowly adding new healthy habits and sticking to them.',
      emoji: '✨',
      illustrationEmojis: ['🏃‍♂️', '📚', '🧘', '💧'],
    ),
    _OnboardingData(
      title: 'Track\nYour Progress',
      subtitle:
          'Everyday you become one step closer to your goal. Don\'t give up!',
      emoji: '📊',
      illustrationEmojis: ['💧', '🚶', '🧘‍♀️', '🌱'],
    ),
    _OnboardingData(
      title: 'Stay Together\nand Strong',
      subtitle:
          'Find friends to discuss common topics. Complete challenges together.',
      emoji: '🤝',
      illustrationEmojis: ['🏆', '⭐', '🎯', '💪'],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.createAccount);
    }
  }

  void _onSkip() {
    Navigator.pushReplacementNamed(context, AppRoutes.createAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.splashGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onSkip,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return _OnboardingPage(data: page);
                  },
                ),
              ),
              // Page indicator
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: _pages.length,
                  effect: const WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    spacing: 12,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white30,
                  ),
                ),
              ),
              // Continue button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String subtitle;
  final String emoji;
  final List<String> illustrationEmojis;

  const _OnboardingData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.illustrationEmojis,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const Spacer(flex: 1),
          // Illustration area with emoji cards
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background circles
                ...List.generate(2, (i) {
                  return Container(
                    width: 160.0 + i * 80,
                    height: 160.0 + i * 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                  );
                }),
                // Floating emoji cards
                for (int i = 0; i < data.illustrationEmojis.length; i++)
                  Positioned(
                    left: _emojiPosition(i).dx,
                    top: _emojiPosition(i).dy,
                    child: _EmojiCard(
                      emoji: data.illustrationEmojis[i],
                      isMain: i == 0,
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(flex: 1),
          // Title
          Text(
            data.title,
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            data.subtitle,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }

  Offset _emojiPosition(int index) {
    const positions = [
      Offset(40, 60),
      Offset(200, 30),
      Offset(120, 170),
      Offset(250, 150),
    ];
    return positions[index % positions.length];
  }
}

class _EmojiCard extends StatelessWidget {
  final String emoji;
  final bool isMain;

  const _EmojiCard({required this.emoji, this.isMain = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMain ? 20 : 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isMain ? 0.25 : 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: isMain ? 36 : 28),
      ),
    );
  }
}
