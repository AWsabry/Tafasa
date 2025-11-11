import 'dart:math';

import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  IconData getIconForCategory() {
    switch (widget.category) {
      case 'فطور':
        return Icons.wb_sunny;
      case 'غداء':
        return Icons.restaurant;
      case 'عشاء':
        return Icons.dinner_dining;
      case 'تحلية':
        return Icons.cake;
      case 'سناكس':
        return Icons.fastfood;
      case 'صحي':
        return Icons.spa;
      default:
        return Icons.restaurant_menu;
    }
  }

  Color getColorForCategory() {
    switch (widget.category) {
      case 'فطور':
        return Colors.orange;
      case 'غداء':
        return Colors.red;
      case 'عشاء':
        return Colors.purple;
      case 'تحلية':
        return Colors.pink;
      case 'سناكس':
        return Colors.amber;
      case 'صحي':
        return Colors.green;
      default:
        return Colors.pinkAccent;
    }
  }

  // Color getColorForCategory() {
  //   // Alternate between purple and orange for variety
  //   final categoryIndex = [
  //     'فطور',
  //     'غداء',
  //     'عشاء',
  //     'تحلية',
  //     'سناكس',
  //     'صحي',
  //   ].indexOf(widget.category);

  //   if (categoryIndex == -1 || categoryIndex % 2 == 0) {
  //     return AppTheme.primaryPurple;
  //   } else {
  //     return AppTheme.primaryOrange;
  //   }
  // }

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
              color: Colors.white.withOpacity(0.05),
              border: Border.all(
                color: getColorForCategory().withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: getColorForCategory().withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Stack(
                children: [
                  // Gradient Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          getColorForCategory().withOpacity(0.15),
                          getColorForCategory().withOpacity(0.05),
                          Colors.transparent,
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
                              Colors.white.withOpacity(0.05),
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

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon Container
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                getColorForCategory(),
                                getColorForCategory().withOpacity(0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: getColorForCategory().withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Icon(
                            getIconForCategory(),
                            color: Colors.white,
                            size: 36,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Category Text
                        Text(
                          widget.category,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'FFKhallab',
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Corner Accent
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            getColorForCategory().withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
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
