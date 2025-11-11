import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tafasa/core/theme/app_theme.dart';
import 'package:tafasa/features/register/presentation/view/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _buttonController;
  late AnimationController _particlesController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _buttonScale;
  late Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
        );

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _buttonScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.elasticOut),
    );
    _buttonOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _buttonController, curve: Curves.easeIn));

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      _logoController.forward();
      await Future.delayed(const Duration(milliseconds: 600));
      _textController.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      _buttonController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    _particlesController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Widget _buildFloatingParticle(
    double left,
    double top,
    double delay,
    Color color,
  ) {
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, child) {
        final offset = sin((_particlesController.value + delay) * 2 * pi) * 25;
        final opacity =
            (sin((_particlesController.value + delay) * 2 * pi) + 1) / 2;
        return Positioned(
          left: left,
          top: top + offset,
          child: Opacity(
            opacity: opacity * 0.3,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.5), blurRadius: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryPurple.withOpacity(0.70),
                AppTheme.primaryOrange.withOpacity(0.60),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles
              _buildFloatingParticle(
                60,
                100,
                0,
                AppTheme.primaryPurple.withOpacity(0.5),
              ),
              _buildFloatingParticle(
                screenWidth - 80,
                150,
                0.2,
                AppTheme.primaryOrange.withOpacity(0.5),
              ),
              _buildFloatingParticle(
                40,
                300,
                0.4,
                AppTheme.primaryPurple.withOpacity(0.4),
              ),
              _buildFloatingParticle(
                screenWidth - 60,
                400,
                0.6,
                AppTheme.primaryOrange.withOpacity(0.6),
              ),
              _buildFloatingParticle(
                100,
                500,
                0.8,
                AppTheme.primaryPurple.withOpacity(0.3),
              ),
              _buildFloatingParticle(
                screenWidth - 120,
                600,
                0.3,
                AppTheme.primaryOrange.withOpacity(0.4),
              ),
              _buildFloatingParticle(
                80,
                screenHeight - 200,
                0.5,
                AppTheme.primaryPurple.withOpacity(0.6),
              ),
              _buildFloatingParticle(
                screenWidth - 100,
                screenHeight - 150,
                0.7,
                AppTheme.primaryOrange.withOpacity(0.5),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 60),

                          // Logo with animation
                          AnimatedBuilder(
                            animation: _logoController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _logoOpacity.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: child,
                                ),
                              );
                            },
                            child: AnimatedBuilder(
                              animation: _pulseController,
                              builder: (context, child) {
                                return Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        AppTheme.primaryPurple,
                                        AppTheme.primaryOrange,
                                        AppTheme.primaryPurple.withOpacity(0.8),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primaryPurple
                                            .withOpacity(
                                              0.3 +
                                                  _pulseController.value * 0.2,
                                            ),
                                        blurRadius:
                                            40 + _pulseController.value * 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.1),
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/TAFASA WHITE LOGO.svg',
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Title with slide animation
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: Column(
                                children: [
                                  // const Text(
                                  //   'Tafasa',
                                  //   style: TextStyle(
                                  //     fontFamily: 'GraphicSchool',
                                  //     fontSize: 48,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: Colors.white,
                                  //     letterSpacing: 2,
                                  //   ),
                                  // ),
                                  // const SizedBox(height: 16),
                                  Text(
                                    'مساعدك الذكي للوصفات',
                                    style: TextStyle(
                                      fontFamily: 'FFKhallab',
                                      fontSize: 20,
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Features cards
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  _buildFeatureChip(
                                    Icons.restaurant,
                                    'وصفات متنوعة',
                                    AppTheme.primaryPurple,
                                  ),
                                  _buildFeatureChip(
                                    Icons.fastfood,
                                    'أكلات مصرية',
                                    AppTheme.primaryPurple,
                                  ),
                                  _buildFeatureChip(
                                    Icons.favorite,
                                    'مفضلاتك',
                                    AppTheme.primaryPurple,
                                  ),
                                  _buildFeatureChip(
                                    Icons.lightbulb,
                                    'اقتراحات ذكية',
                                    AppTheme.primaryPurple,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Description
                          SlideTransition(
                            position: _textSlide,
                            child: FadeTransition(
                              opacity: _textOpacity,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'اكتشف وصفات شهية من المطبخ المصري\nمع شرح مفصل لطريقة التحضير',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'FFKhallab',
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.7),
                                    height: 1.6,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 50),

                          // Start button
                          FadeTransition(
                            opacity: _buttonOpacity,
                            child: ScaleTransition(
                              scale: _buttonScale,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.primaryPurple,
                                      AppTheme.primaryOrange,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryPurple.withOpacity(
                                        0.4,
                                      ),

                                      blurRadius: 25,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(
                                            milliseconds: 800,
                                          ),
                                          pageBuilder: (_, __, ___) =>
                                              const RegisterScreen(),
                                          transitionsBuilder:
                                              (_, animation, __, child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: ScaleTransition(
                                                    scale:
                                                        Tween<double>(
                                                          begin: 0.9,
                                                          end: 1.0,
                                                        ).animate(
                                                          CurvedAnimation(
                                                            parent: animation,
                                                            curve: Curves
                                                                .easeOutBack,
                                                          ),
                                                        ),
                                                    child: child,
                                                  ),
                                                );
                                              },
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 50,
                                        vertical: 18,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'ابدأ الآن',
                                            style: TextStyle(
                                              fontFamily: 'FFKhallab',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          SizedBox(width: 12),
                                          Icon(
                                            Icons.arrow_back_rounded,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'FFKhallab',
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
