import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AksharaaSetuApp());
}

class AksharaaSetuApp extends StatelessWidget {
  const AksharaaSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AksharaaSetu',
      theme: AppTheme.theme,
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.96,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.navy,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isWide = constraints.maxWidth >= 760;

            return Stack(
              children: [
                // Background decoration
                Positioned(
                  top: -100,
                  right: -90,
                  child: _backgroundCircle(
                    270,
                    AppTheme.gold.withValues(alpha: 0.06),
                  ),
                ),

                Positioned(
                  bottom: -130,
                  left: -90,
                  child: _backgroundCircle(
                    300,
                    AppTheme.terracotta.withValues(alpha: 0.07),
                  ),
                ),

                // Main scrollable content
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    isWide ? 40 : 20,
                    20,
                    isWide ? 40 : 20,
                    32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 1120,
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _buildBrand(),

                              const SizedBox(height: 28),

                              if (isWide)
                                _buildWideHero()
                              else
                                _buildMobileHero(),

                              const SizedBox(height: 28),

                              _buildSectionHeading(),

                              const SizedBox(height: 16),

                              _buildLearningCards(),

                              const SizedBox(height: 26),

                              _buildBenefits(),

                              const SizedBox(height: 24),

                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _backgroundCircle(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // --------------------------------------------------
  // BRAND
  // --------------------------------------------------

  Widget _buildBrand() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.navyLight,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: AppTheme.gold.withValues(alpha: 0.5),
            ),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: AppTheme.gold,
            size: 27,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AksharaaSetu',
              style: GoogleFonts.playfairDisplay(
                color: AppTheme.gold,
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'LEARN • TRANSLATE • GROW',
              style: GoogleFonts.poppins(
                color: AppTheme.cream.withValues(alpha: 0.7),
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --------------------------------------------------
  // WIDE HERO
  // --------------------------------------------------

  Widget _buildWideHero() {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        color: AppTheme.navyLight,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.2),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: _buildHeroText(
                isWide: true,
              ),
            ),
          ),
          Expanded(
            flex: 10,
            child: SizedBox(
              height: 420,
              child: _heroImage(),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // MOBILE HERO
  // --------------------------------------------------

  Widget _buildMobileHero() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.navyLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.2),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: _heroImage(),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: _buildHeroText(
              isWide: false,
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // HERO IMAGE
  // --------------------------------------------------

  Widget _heroImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/education_hero.jpg',
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: AppTheme.navyDark,
              child: const Center(
                child: Icon(
                  Icons.menu_book_rounded,
                  size: 100,
                  color: AppTheme.gold,
                ),
              ),
            );
          },
        ),

        // Dark gradient over image
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                AppTheme.navyDark.withValues(alpha: 0.65),
              ],
            ),
          ),
        ),

        // Image label
        Positioned(
          left: 20,
          bottom: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: AppTheme.navyDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.gold.withValues(alpha: 0.5),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  color: AppTheme.gold,
                  size: 17,
                ),
                SizedBox(width: 8),
                Text(
                  'Learning in every language',
                  style: TextStyle(
                    color: AppTheme.cream,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // HERO TEXT
  // --------------------------------------------------

  Widget _buildHeroText({
    required bool isWide,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: AppTheme.terracotta.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'MOTHER TONGUE BASED LEARNING',
            style: TextStyle(
              color: AppTheme.goldLight,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Every child deserves to learn in their own language.',
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.cream,
            fontSize: isWide ? 39 : 31,
            fontWeight: FontWeight.w700,
            height: 1.22,
          ),
        ),

        const SizedBox(height: 16),

        Text(
          'Helping teachers bridge Hindi and Santali '
          'through AI-powered speech recognition and translation.',
          style: GoogleFonts.poppins(
            color: AppTheme.cream.withValues(alpha: 0.8),
            fontSize: 14,
            height: 1.8,
          ),
        ),

        const SizedBox(height: 26),

        SizedBox(
          width: isWide ? 230 : double.infinity,
          child: ElevatedButton.icon(
            onPressed: _openLogin,
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 20,
            ),
            label: const Text(
              'Get Started',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.terracotta,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 17,
              ),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        Text(
          'A learning bridge between languages and classrooms.',
          style: TextStyle(
            color: AppTheme.goldLight.withValues(alpha: 0.85),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // SECTION HEADING
  // --------------------------------------------------

  Widget _buildSectionHeading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning without language barriers',
          style: GoogleFonts.playfairDisplay(
            color: AppTheme.cream,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          'Tools designed to support teachers and their classrooms.',
          style: GoogleFonts.poppins(
            color: AppTheme.cream.withValues(alpha: 0.72),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // LEARNING CARDS
  // --------------------------------------------------

  Widget _buildLearningCards() {
    final cards = [
      const _LearningCardData(
        image: 'assets/images/mother_tongue_learning.jpg',
        icon: Icons.record_voice_over_rounded,
        title: 'Mother Tongue Learning',
        description:
            'Make lessons more accessible in the language children understand.',
      ),
      const _LearningCardData(
        image: 'assets/images/tribal_learning.jpg',
        icon: Icons.groups_rounded,
        title: 'Teacher Support',
        description:
            'Support teachers working with multilingual classrooms.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool horizontal = constraints.maxWidth >= 600;

        if (horizontal) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _learningCard(cards[0]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _learningCard(cards[1]),
              ),
            ],
          );
        }

        return Column(
          children: [
            _learningCard(cards[0]),
            const SizedBox(height: 14),
            _learningCard(cards[1]),
          ],
        );
      },
    );
  }

  Widget _learningCard(
    _LearningCardData data,
  ) {
    return Card(
      color: AppTheme.cream,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 175,
            width: double.infinity,
            child: Image.asset(
              data.image,
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: AppTheme.creamDark,
                  child: Icon(
                    data.icon,
                    size: 60,
                    color: AppTheme.terracotta,
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      data.icon,
                      color: AppTheme.terracotta,
                      size: 21,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          color: AppTheme.darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 9),

                Text(
                  data.description,
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------
  // BENEFITS
  // --------------------------------------------------

  Widget _buildBenefits() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.navyLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.2),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 520;

          const benefits = [
            _BenefitData(
              Icons.translate_rounded,
              'AI Translation',
              'Hindi to Santali',
            ),
            _BenefitData(
              Icons.mic_rounded,
              'Speech Recognition',
              'Speak naturally',
            ),
            _BenefitData(
              Icons.cloud_off_rounded,
              'Offline-first',
              'Access saved lessons',
            ),
          ];

          if (compact) {
            return Column(
              children: [
                _benefitItem(benefits[0]),
                const SizedBox(height: 18),
                _benefitItem(benefits[1]),
                const SizedBox(height: 18),
                _benefitItem(benefits[2]),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _benefitItem(benefits[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _benefitItem(benefits[1]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _benefitItem(benefits[2]),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _benefitItem(
    _BenefitData data,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          data.icon,
          color: AppTheme.gold,
          size: 25,
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: AppTheme.cream,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.description,
                style: TextStyle(
                  color: AppTheme.cream.withValues(
                    alpha: 0.7,
                  ),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------
  // FOOTER
  // --------------------------------------------------

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 42,
            height: 2,
            color: AppTheme.gold.withValues(
              alpha: 0.6,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'AksharaaSetu',
            style: GoogleFonts.playfairDisplay(
              color: AppTheme.gold,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Connecting classrooms through language.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: AppTheme.cream.withValues(
                alpha: 0.65,
              ),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// DATA CLASSES
// --------------------------------------------------

class _LearningCardData {
  final String image;
  final IconData icon;
  final String title;
  final String description;

  const _LearningCardData({
    required this.image,
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _BenefitData {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitData(
    this.icon,
    this.title,
    this.description,
  );
}