import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/services/locator/service_locator.dart';
import 'package:food_gpt/core/utils/logger.dart';
import 'package:food_gpt/features/home/data/model/categories_model.dart';
import 'package:food_gpt/features/suggestions/presentation/controller/suggestions_cubit.dart';
import 'package:food_gpt/features/suggestions/presentation/view/suggestions_screen.dart';

import '../../../../widgets/category_card.dart';
import '../../../favorites/presentation/view/favorites_screen.dart';
import '../controller/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..getCategories(),
      child: const _HomeScreenView(),
    );
  }
}

class _HomeScreenView extends StatefulWidget {
  const _HomeScreenView();

  @override
  State<_HomeScreenView> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<_HomeScreenView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _particlesController;
  late AnimationController _headerController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _particlesController.dispose();
    _headerController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedGridItem(
    BuildContext context,
    int index,
    Category category,
  ) {
    final delay = index * 120;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        final safeValue = value.clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, 50 * (1 - safeValue)),
          child: Transform.scale(
            scale: safeValue,
            child: Opacity(opacity: safeValue, child: child),
          ),
        );
      },
      child: CategoryCard(
        category: category.name,
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => BlocProvider(
              create: (context) => sl<SuggestionsCubit>(param1: category.id),
              child: const SuggestionScreen(),
            ),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
        ).then((_) => context.read<HomeCubit>().resetIndex()),
      ),
    );
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
        final offset = sin((_particlesController.value + delay) * 2 * pi) * 20;
        final opacity =
            (sin((_particlesController.value + delay) * 2 * pi) + 1) / 2;
        return Positioned(
          left: left,
          top: top + offset,
          child: Opacity(
            opacity: opacity * 0.25,
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF1a1a2e),
                const Color(0xFF16213e),
                const Color(0xFF0f3460),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Floating particles
                _buildFloatingParticle(50, 120, 0, Colors.pink.shade300),
                _buildFloatingParticle(
                  screenWidth - 70,
                  180,
                  0.2,
                  Colors.orange.shade300,
                ),
                _buildFloatingParticle(60, 320, 0.4, Colors.purple.shade300),
                _buildFloatingParticle(
                  screenWidth - 80,
                  420,
                  0.6,
                  Colors.amber.shade300,
                ),
                _buildFloatingParticle(70, 550, 0.8, Colors.teal.shade300),
                _buildFloatingParticle(
                  screenWidth - 60,
                  680,
                  0.3,
                  Colors.pink.shade400,
                ),

                Column(
                  children: [
                    // Custom App Bar with animation
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _headerController,
                                  builder: (context, child) {
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.pink.shade400.withOpacity(
                                              0.3,
                                            ),
                                            Colors.orange.shade400.withOpacity(
                                              0.3,
                                            ),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.pink.withOpacity(
                                              0.2 +
                                                  _headerController.value * 0.2,
                                            ),
                                            blurRadius:
                                                15 +
                                                _headerController.value * 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        Icons.restaurant_menu,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 14),
                                ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [
                                      Colors.pink.shade300,
                                      Colors.orange.shade300,
                                      Colors.purple.shade300,
                                    ],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'FoodGPT',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 28,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'اكتشف وصفات مصرية أصيلة',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Grid View
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        Logger.debug(state.toString());
                        if (state is HomeLoading || state is HomeInitial) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.pink.shade300,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'جاري تحميل الفئات...',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is HomeError) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red.shade300,
                                    size: 64,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.message,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      context.read<HomeCubit>().getCategories();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('إعادة المحاولة'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink.shade400,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is HomeCategoriesLoaded) {
                          final categories = state.categories.categories;
                          return Expanded(
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: ScaleTransition(
                                scale: _scaleAnimation,
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(20),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 16,
                                        childAspectRatio: 1.0,
                                      ),
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) =>
                                      _buildAnimatedGridItem(
                                        context,
                                        index,
                                        categories[index],
                                      ),
                                ),
                              ),
                            ),
                          );
                        }

                        // Initial state or fallback
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.pink.shade300,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final currentIndex = state is HomeIndexChanged
                ? state.currentIndex
                : 0;
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1a1a2e),
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_rounded,
                        label: 'الرئيسية',
                        isSelected: currentIndex == 0,
                        onTap: () =>
                            context.read<HomeCubit>().setCurrentIndex(0),
                      ),
                      _buildNavItem(
                        icon: Icons.lightbulb_rounded,
                        label: 'اقتراح',
                        isSelected: currentIndex == 1,
                        onTap: () {
                          context.read<HomeCubit>().setCurrentIndex(1);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => BlocProvider(
                                create: (context) => sl<SuggestionsCubit>(),
                                child: const SuggestionScreen(),
                              ),
                              transitionDuration: const Duration(
                                milliseconds: 600,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: 0.8, end: 1.0)
                                        .animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutBack,
                                          ),
                                        ),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          ).then((_) => context.read<HomeCubit>().resetIndex());
                        },
                      ),
                      _buildNavItem(
                        icon: Icons.favorite_rounded,
                        label: 'المفضلة',
                        isSelected: currentIndex == 2,
                        onTap: () {
                          context.read<HomeCubit>().setCurrentIndex(2);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const FavoritesScreen(),
                              transitionDuration: const Duration(
                                milliseconds: 600,
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position:
                                        Tween<Offset>(
                                          begin: const Offset(0, 0.3),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        ),
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          ).then((_) => context.read<HomeCubit>().resetIndex());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 20 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [Colors.pink.shade400, Colors.orange.shade400],
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
