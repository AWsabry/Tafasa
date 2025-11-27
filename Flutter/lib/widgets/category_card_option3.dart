import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tafasa/core/theme/app_theme.dart';

// Option 3: Frosted glass effect with blur
class CategoryCardOption3 extends StatefulWidget {
  final String category;
  final VoidCallback? onTap;

  const CategoryCardOption3({super.key, required this.category, this.onTap});

  @override
  State<CategoryCardOption3> createState() => _CategoryCardOption3State();
}

class _CategoryCardOption3State extends State<CategoryCardOption3>
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

                  // Light white overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.white.withOpacity(0.3),
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

                  // Frosted glass text container
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.4),
                                Colors.white.withOpacity(0.6),
                              ],
                            ),
                            border: Border(
                              top: BorderSide(
                                color: Colors.white.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Text(
                            widget.category,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FFKhallab',
                              color: Colors.grey[800],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
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
