import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tafasa/core/theme/app_theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );

    _contentAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          color: Colors.grey[200],
          child: SafeArea(
            child: Column(
              children: [
                // Header
                FadeTransition(
                  opacity: _headerAnimation,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'من نحن',
                                style: TextStyle(
                                  fontFamily: 'FFKhallab',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_rounded),
                              color: AppTheme.primaryPurple,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                Expanded(
                  child: FadeTransition(
                    opacity: _contentAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Logo Section
                          Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryPurple,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryPurple.withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/TAFASA WHITE LOGO.svg',
                              height: 100,
                              width: 100,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // App Name
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                AppTheme.primaryPurple,
                                AppTheme.primaryOrange,
                              ],
                            ).createShader(bounds),
                            child: const Text(
                              'طفاسة',
                              style: TextStyle(
                                fontFamily: 'FFKhallab',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // About Section
                          _buildInfoCard(
                            title: 'عن التطبيق',
                            content:
                                'طفاسة هو تطبيقك المثالي لاكتشاف وصفات الطعام المصرية الأصيلة. نهدف إلى تسهيل تجربة الطهي وإلهامك بأفكار جديدة ومبتكرة لوجباتك اليومية.',
                            icon: Icons.restaurant_menu_rounded,
                            gradientColors: [
                              AppTheme.primaryPurple,
                              AppTheme.primaryPurple.withOpacity(0.7),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Features Section
                          _buildInfoCard(
                            title: 'مميزات التطبيق',
                            content:
                                '• وصفات متنوعة من المطبخ المصري\n• اقتراحات وجبات يومية\n• حفظ الوصفات المفضلة\n• خطوات تحضير مفصلة\n• صور جذابة لكل وصفة',
                            icon: Icons.star_rounded,
                            gradientColors: [
                              AppTheme.primaryOrange,
                              AppTheme.primaryOrange.withOpacity(0.7),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Mission Section
                          _buildInfoCard(
                            title: 'رسالتنا',
                            content:
                                'نسعى لنشر ثقافة الطهي المصري الأصيل والحفاظ على تراثنا الغذائي من خلال توفير وصفات سهلة ومميزة للجميع.',
                            icon: Icons.flag_rounded,
                            gradientColors: [
                              Colors.green,
                              Colors.green.withOpacity(0.7),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Contact Section
                          _buildInfoCard(
                            title: 'تواصل معنا',
                            content:
                                'نحب أن نسمع منك! شاركنا آرائك واقتراحاتك لتحسين تجربتك معنا.',
                            icon: Icons.email_rounded,
                            gradientColors: [
                              Colors.blue,
                              Colors.blue.withOpacity(0.7),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Version Info
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'الإصدار 1.0.0',
                                  style: TextStyle(
                                    fontFamily: 'FFKhallab',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '© 2025 طفاسة - جميع الحقوق محفوظة',
                                  style: TextStyle(
                                    fontFamily: 'FFKhallab',
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String content,
    required IconData icon,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'FFKhallab',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontFamily: 'FFKhallab',
                fontSize: 15,
                color: Colors.grey[700],
                height: 1.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
