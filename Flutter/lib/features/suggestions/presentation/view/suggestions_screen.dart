import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafasa/core/services/locator/service_locator.dart';
import 'package:tafasa/core/theme/app_theme.dart';
import 'package:tafasa/features/favorites/domain/repository/favorites_repository.dart';
import 'package:tafasa/features/favorites/presentation/view/favorites_screen.dart';
import 'package:tafasa/features/home/data/model/categories_model.dart';
import 'package:tafasa/features/recipe_detail/presentation/view/recipe_detialed_screen.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';
import 'package:tafasa/features/suggestions/presentation/controller/suggestions_cubit.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({super.key, this.category});
  final Category? category;

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen>
    with TickerProviderStateMixin {
  late Map<String, dynamic> currentMeal;
  RecipeModel? currentRecipe;
  late AnimationController _controller;
  late AnimationController _sparkleController;
  late AnimationController _heartController;
  late AnimationController _floatingController;
  late AnimationController _descriptionController;
  late AnimationController _swipeController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _heartBeatAnimation;
  late Animation<double> _descriptionSlideAnimation;
  late Animation<Offset> _swipeAnimation;

  final categories = const ['فطور', 'غداء', 'عشاء', 'تحلية', 'سناكس', 'صحي'];
  String currentCategory = '';
  bool _isFavorite = false;
  final FavoritesRepository _favoritesRepository = sl<FavoritesRepository>();

  // Swipe variables
  double _dragDistance = 0;
  bool _isSwipeInProgress = false;

  @override
  void initState() {
    super.initState();

    // Data will come from Cubit, just initialize animations
    currentMeal = {};
    currentCategory = widget.category?.name ?? '';

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400), // كان 800
    );

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _descriptionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // كان 600
    );
    _descriptionController.forward();

    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200), // كان 300
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _swipeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250), // كان 400
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _slideAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _sparkleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _sparkleController, curve: Curves.easeInOut),
    );

    _heartBeatAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _heartController, curve: Curves.easeOut));

    _descriptionSlideAnimation = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _descriptionController,
        curve: Curves.easeOutCubic,
      ),
    );

    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0)).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!_isSwipeInProgress) {
      setState(() {
        _dragDistance += details.primaryDelta ?? 0;
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isSwipeInProgress) return;

    final screenWidth = MediaQuery.of(context).size.width;
    final threshold = screenWidth * 0.3;

    if (_dragDistance.abs() > threshold) {
      _performSwipeAnimation();
    } else {
      setState(() {
        _dragDistance = 0;
      });
    }
  }

  void _performSwipeAnimation() {
    setState(() {
      _isSwipeInProgress = true;
    });

    final direction = _dragDistance < 0 ? -1.0 : 1.0;

    _swipeController.reset();
    _swipeAnimation =
        Tween<Offset>(
          begin: Offset(_dragDistance / MediaQuery.of(context).size.width, 0),
          end: Offset(2.0 * direction, 0),
        ).animate(
          CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
        );

    _swipeController.forward().then((_) {
      _descriptionController.reverse().then((_) {
        // Trigger new meal fetch from Cubit
        context.read<SuggestionsCubit>().suggestNewMeal(currentMeal["name"]);
        setState(() {
          _dragDistance = 0;
        });

        // Reset swipe animation from opposite side
        _swipeAnimation =
            Tween<Offset>(
              begin: Offset(-2.0 * direction, 0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: _swipeController,
                curve: Curves.easeOutCubic,
              ),
            );

        _swipeController.reset();
        _swipeController.forward().then((_) {
          setState(() {
            _isSwipeInProgress = false;
          });
        });

        Future.delayed(const Duration(milliseconds: 100), () {
          // كان 200
          _descriptionController.forward();
        });
      });
    });
  }

  void suggestAgain() {
    if (_isSwipeInProgress) return;

    _controller.reverse().then((_) {
      _descriptionController.reverse().then((_) {
        // Trigger new meal fetch from Cubit
        context.read<SuggestionsCubit>().suggestNewMeal(currentMeal["name"]);
        _controller.forward();
        Future.delayed(const Duration(milliseconds: 200), () {
          _descriptionController.forward();
        });
      });
    });
  }

  void toggleFavorite() async {
    if (currentRecipe == null) return;

    if (_isFavorite) {
      final result = await _favoritesRepository.removeFavorite(
        currentRecipe!.id,
      );
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل إزالة الوجبة: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          setState(() {
            _isFavorite = false;
          });
          _heartController.forward().then((_) => _heartController.reverse());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.heart_broken, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '💔 تمت إزالة "${currentMeal["name"]}" من المفضلة',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.grey.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      );
    } else {
      final result = await _favoritesRepository.addFavorite(currentRecipe!.id);
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل إضافة الوجبة: ${failure.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          setState(() {
            _isFavorite = true;
          });
          _heartController.forward().then((_) => _heartController.reverse());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '❤️ تمت إضافة "${currentMeal["name"]}" إلى المفضلة!',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.pink,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'عرض',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavoritesScreen(),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      );
    }
  }

  IconData getCategoryIcon() {
    switch (currentCategory) {
      case 'فطور':
        return Icons.wb_sunny_rounded;
      case 'غداء':
        return Icons.restaurant_rounded;
      case 'عشاء':
        return Icons.nightlight_round;
      case 'تحلية':
        return Icons.cake_rounded;
      case 'سناكس':
        return Icons.cookie_rounded;
      case 'صحي':
        return Icons.eco_rounded;
      default:
        return Icons.fastfood_rounded;
    }
  }

  Color getCategoryColor() {
    switch (currentCategory) {
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

  Widget _buildFloatingParticle(double left, double top, double delay, Color color) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final offset = sin((_floatingController.value + delay) * 2 * pi) * 25;
        final opacity =
            (sin((_floatingController.value + delay) * 2 * pi) + 1) / 2;
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
  void dispose() {
    _controller.dispose();
    _sparkleController.dispose();
    _heartController.dispose();
    _floatingController.dispose();
    _descriptionController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SuggestionsCubit, SuggestionsState>(
      listener: (context, state) {
        if (state is SuggestionsLoaded) {
          setState(() {
            currentMeal = state.currentMeal;
            currentCategory = state.currentCategory;
            _isFavorite = state.recipe?.isFavorite ?? false;
            currentRecipe = state.recipe;
          });
        }
      },
      builder: (context, state) {
        if (state is SuggestionsLoading) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryPurple,
                ),
              ),
            ),
          );
        }

        if (state is SuggestionsError) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontFamily: 'FFKhallab',
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'رجوع',
                        style: TextStyle(fontFamily: 'FFKhallab'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is! SuggestionsLoaded) {
          return const SizedBox();
        }

        debugPrint(currentMeal["description"]);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  // Floating particles (subtle)
                  _buildFloatingParticle(30, 150, 0, AppTheme.primaryPurple.withOpacity(0.3)),
                  _buildFloatingParticle(
                    MediaQuery.of(context).size.width - 50,
                    250,
                    0.3,
                    AppTheme.primaryOrange.withOpacity(0.3),
                  ),
                  _buildFloatingParticle(50, 450, 0.6, AppTheme.primaryPurple.withOpacity(0.2)),
                  _buildFloatingParticle(
                    MediaQuery.of(context).size.width - 70,
                    550,
                    0.9,
                    AppTheme.primaryOrange.withOpacity(0.2),
                  ),

                  Column(
                    children: [
                      // Custom App Bar - Clean white style
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_rounded),
                                color: Colors.grey[700],
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getCategoryColor().withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      getCategoryIcon(),
                                      color: getCategoryColor(),
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'اقتراح $currentCategory',
                                    style: TextStyle(
                                      fontFamily: 'FFKhallab',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AnimatedBuilder(
                                    animation: _sparkleController,
                                    builder: (context, child) {
                                      return Transform.rotate(
                                        angle: _sparkleController.value * 2 * pi,
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: getCategoryColor(),
                                          size: 20,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),

                      // Swipe hint text
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: getCategoryColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.swipe,
                                size: 16,
                                color: getCategoryColor(),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'اسحب يميناً أو يساراً لوجبة جديدة',
                                style: TextStyle(
                                  fontFamily: 'FFKhallab',
                                  fontSize: 12,
                                  color: getCategoryColor(),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Main Content
                      Expanded(
                        child: Center(
                            child: SingleChildScrollView(
                              child: GestureDetector(
                                onHorizontalDragUpdate: _onHorizontalDragUpdate,
                                onHorizontalDragEnd: _onHorizontalDragEnd,
                                child: AnimatedBuilder(
                                  animation: _isSwipeInProgress
                                      ? _swipeAnimation
                                      : _slideAnimation,
                                  builder: (context, child) {
                                    return Transform.translate(
                                      offset: _isSwipeInProgress
                                          ? Offset(
                                              _swipeAnimation.value.dx *
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,
                                              0,
                                            )
                                          : Offset(
                                              _dragDistance,
                                              _slideAnimation.value,
                                            ),
                                      child: Transform.rotate(
                                        angle: _isSwipeInProgress
                                            ? _swipeAnimation.value.dx * 0.2
                                            : (_dragDistance /
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width) *
                                                  0.2,
                                        child: Opacity(
                                          opacity: _isSwipeInProgress
                                              ? 1.0 -
                                                    _swipeAnimation.value.dx
                                                            .abs() *
                                                        0.5
                                              : 1.0 -
                                                    (_dragDistance.abs() /
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.width) *
                                                        0.3,
                                          child: child,
                                        ),
                                      ),
                                    );
                                  },
                                  child: FadeTransition(
                                    opacity: _fadeAnimation,
                                    child: ScaleTransition(
                                      scale: _scaleAnimation,
                                      child: Container(
                                        margin: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(25),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
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
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  25,
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    // Category Badge
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: getCategoryColor().withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(
                                                          color: getCategoryColor().withOpacity(0.3),
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            getCategoryIcon(),
                                                            color: getCategoryColor(),
                                                            size: 16,
                                                          ),
                                                          const SizedBox(width: 6),
                                                          Text(
                                                            currentCategory,
                                                            style: TextStyle(
                                                              fontFamily: 'FFKhallab',
                                                              color: getCategoryColor(),
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    // Meal Name
                                                    Text(
                                                      currentMeal["name"],
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily: 'FFKhallab',
                                                        fontSize: 26,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey[800],
                                                        height: 1.3,
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    // Image Container
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.1),
                                                            blurRadius: 15,
                                                            offset: const Offset(0, 4),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Stack(
                                                          children: [
                                                            Image.network(
                                                              currentMeal["image"] ??
                                                                  'https://media.istockphoto.com/id/1208512719/vector/mother-and-kid-girl-preparing-healthy-food-at-home-together-best-mom-ever-mother-and.jpg?s=612x612&w=0&k=20&c=NT_rtgElOHYlbXAzrHdxlClYmtCby8BD9QQLEstZ-j8=',
                                                              height: 240,
                                                              width: double
                                                                  .infinity,
                                                              fit: BoxFit.cover,
                                                              loadingBuilder:
                                                                  (
                                                                    context,
                                                                    child,
                                                                    loadingProgress,
                                                                  ) {
                                                                    if (loadingProgress ==
                                                                        null)
                                                                      return child;
                                                                    return Container(
                                                                      height:
                                                                          240,
                                                                      decoration: BoxDecoration(
                                                                        gradient: LinearGradient(
                                                                          colors: [
                                                                            getCategoryColor().withOpacity(
                                                                              0.2,
                                                                            ),
                                                                            getCategoryColor().withOpacity(
                                                                              0.1,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      child: Center(
                                                                        child: CircularProgressIndicator(
                                                                          color:
                                                                              getCategoryColor(),
                                                                          strokeWidth:
                                                                              3,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                              errorBuilder:
                                                                  (
                                                                    context,
                                                                    error,
                                                                    stackTrace,
                                                                  ) => Container(
                                                                    height: 240,
                                                                    color: Colors
                                                                        .grey[300],
                                                                    child: Icon(
                                                                      Icons
                                                                          .restaurant_rounded,
                                                                      color: Colors
                                                                          .grey,
                                                                      size: 80,
                                                                    ),
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),

                                                    const SizedBox(height: 20),

                                                    // Description Section
                                                    AnimatedBuilder(
                                                      animation:
                                                          _descriptionSlideAnimation,
                                                      builder: (context, child) {
                                                        return Transform.translate(
                                                          offset: Offset(
                                                            0,
                                                            _descriptionSlideAnimation
                                                                .value,
                                                          ),
                                                          child: FadeTransition(
                                                            opacity:
                                                                _descriptionController,
                                                            child: child,
                                                          ),
                                                        );
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding: const EdgeInsets.all(16),
                                                            decoration: BoxDecoration(
                                                              color: Colors.grey[50],
                                                              borderRadius: BorderRadius.circular(15),
                                                              border: Border.all(
                                                                color: Colors.grey[200]!,
                                                                width: 1,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.restaurant,
                                                                      color: getCategoryColor(),
                                                                      size: 18,
                                                                    ),
                                                                    const SizedBox(width: 8),
                                                                    Text(
                                                                      'نبذة عن الوصفة',
                                                                      style: TextStyle(
                                                                        fontFamily: 'FFKhallab',
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.grey[800],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 10),
                                                                Text(
                                                                  currentMeal["description"] ?? '',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                    fontFamily: 'FFKhallab',
                                                                    fontSize: 13,
                                                                    color: Colors.grey[700],
                                                                    height: 1.6,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(height: 12),
                                                          // Detailed Recipe Button
                                                          Container(
                                                            decoration: BoxDecoration(
                                                              color: getCategoryColor(),
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: getCategoryColor().withOpacity(0.3),
                                                                  blurRadius: 10,
                                                                  offset: const Offset(0, 4),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  final cubitState = context.read<SuggestionsCubit>().state;
                                                                  if (cubitState is SuggestionsLoaded && cubitState.recipe != null) {
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => RecipeDetailScreen(
                                                                          mealId: cubitState.recipe!.id,
                                                                          categoryColor: getCategoryColor(),
                                                                          categoryIcon: getCategoryIcon(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                },
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    vertical: 14,
                                                                    horizontal: 20,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                      Icon(
                                                                        Icons.menu_book_rounded,
                                                                        color: Colors.white,
                                                                        size: 20,
                                                                      ),
                                                                      SizedBox(width: 10),
                                                                      Text(
                                                                        'طريقة التحضير بالتفصيل',
                                                                        style: TextStyle(
                                                                          fontFamily: 'FFKhallab',
                                                                          color: Colors.white,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons.arrow_back_rounded,
                                                                        color: Colors.white,
                                                                        size: 18,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    // Buttons
                                                    Row(
                                                      children: [
                                                        // Refresh Button
                                                        Expanded(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              color: getCategoryColor(),
                                                              borderRadius: BorderRadius.circular(15),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: getCategoryColor().withOpacity(0.3),
                                                                  blurRadius: 10,
                                                                  offset: const Offset(0, 4),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Material(
                                                              color: Colors.transparent,
                                                              child: InkWell(
                                                                onTap: suggestAgain,
                                                                borderRadius: BorderRadius.circular(15),
                                                                child: Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                    vertical: 14,
                                                                    horizontal: 10,
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: const [
                                                                      Icon(
                                                                        Icons.refresh_rounded,
                                                                        color: Colors.white,
                                                                        size: 20,
                                                                      ),
                                                                      SizedBox(width: 8),
                                                                      Text(
                                                                        'وجبة أخرى',
                                                                        style: TextStyle(
                                                                          fontFamily: 'FFKhallab',
                                                                          color: Colors.white,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                                        const SizedBox(width: 12),

                                                        // Favorite Button
                                                        Expanded(
                                                          child: AnimatedBuilder(
                                                            animation: _heartBeatAnimation,
                                                            builder: (context, child) {
                                                              return Transform.scale(
                                                                scale: _heartBeatAnimation.value,
                                                                child: child,
                                                              );
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: _isFavorite ? Colors.pink : Colors.grey[200],
                                                                borderRadius: BorderRadius.circular(15),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: (_isFavorite ? Colors.pink : Colors.grey[400]!).withOpacity(0.3),
                                                                    blurRadius: 10,
                                                                    offset: const Offset(0, 4),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Material(
                                                                color: Colors.transparent,
                                                                child: InkWell(
                                                                  onTap: toggleFavorite,
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      vertical: 14,
                                                                      horizontal: 16,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                      children: [
                                                                        Icon(
                                                                          _isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                                                          color: _isFavorite ? Colors.white : Colors.grey[600],
                                                                          size: 20,
                                                                        ),
                                                                        const SizedBox(width: 8),
                                                                        Text(
                                                                          _isFavorite ? 'مفضلة!' : 'أعجبتني',
                                                                          style: TextStyle(
                                                                            fontFamily: 'FFKhallab',
                                                                            color: _isFavorite ? Colors.white : Colors.grey[600],
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
