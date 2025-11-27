import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tafasa/core/theme/app_theme.dart';

// Option 1: Lighter overlay with colored text and subtle shadow
class CategoryCardOption1 extends StatefulWidget {
  final String category;
  final VoidCallback? onTap;

  const CategoryCardOption1({super.key, required this.category, this.onTap});

  @override
  State<CategoryCardOption1> createState() => _CategoryCardOption1State();
}

class _CategoryCardOption1State extends State<CategoryCardOption1>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  String getImageForCategory() {
    switch (widget.category) {
      case 'فطور':
        return 'assets/images/breakfast.webp';
      case 'غداء':
        return 'assets/images/lunch.webp';
      case 'عشاء':
        return 'assets/images/dinner.webp';
      case 'تحلية':
        return 'assets/images/desserts.webp';
      case 'سناكس':
        return 'assets/images/snacks.webp';
      case 'صحي':
        return 'assets/images/healthy.webp';
      default:
        return 'assets/images/lunch.webp';
    }
  }

  Color getColorForCategory() {
    final categoryIndex = [
      'فطور',
      'غداء',
      'عشاء',
      'تحلية',
      'سناكس',
      'صحي',
    ].indexOf(widget.category);

    if (categoryIndex == -1 || categoryIndex % 2 == 0) {
      return AppTheme.primaryPurple;
    } else {
      return AppTheme.primaryOrange;
    }
  }

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isPressed ? 0.95 : _pulseAnimation.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // Full container image background
                  Positioned.fill(
                    child: Image.asset(
                      getImageForCategory(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: getColorForCategory().withOpacity(0.3),
                          child: Icon(
                            Icons.restaurant_menu,
                            color: Colors.white,
                            size: 48,
                          ),
                        );
                      },
                    ),
                  ),

                  // Very light overlay for brightness
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),

                  // Shimmer Effect
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                            ],
                            stops: [
                              max(0.0, (_shimmerController.value * 2) - 1),
                              _shimmerController.value,
                              min(1.0, (_shimmerController.value * 2)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // Category Text with colored accent
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      child: Text(
                        widget.category,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'FFKhallab',
                          color: getColorForCategory(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          shadows: const [
                            Shadow(
                              color: Colors.white,
                              offset: Offset(0, 1),
                              blurRadius: 8,
                            ),
                            Shadow(
                              color: Colors.white,
                              offset: Offset(0, 2),
                              blurRadius: 12,
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
      ),
    );
  }
}
