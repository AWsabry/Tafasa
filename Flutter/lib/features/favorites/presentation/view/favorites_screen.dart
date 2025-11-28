import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tafasa/core/services/locator/service_locator.dart';
import 'package:tafasa/core/theme/app_theme.dart';
import 'package:tafasa/features/recipe_detail/presentation/view/recipe_detialed_screen.dart';
import 'package:tafasa/features/suggestions/data/model/recipe_model.dart';

import '../controller/favorites_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FavoritesCubit>()..loadFavorites(),
      child: const _FavoritesScreenView(),
    );
  }
}

class _FavoritesScreenView extends StatefulWidget {
  const _FavoritesScreenView();

  @override
  State<_FavoritesScreenView> createState() => _FavoritesScreenViewState();
}

class _FavoritesScreenViewState extends State<_FavoritesScreenView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerAnimation;
  late Animation<double> _listSlideAnimation;

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );

    _listSlideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _listController, curve: Curves.easeOutCubic),
    );

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listController.forward();
    });
  }

  Color _getCategoryColor(String? category) {
    switch (category) {
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

  IconData _getCategoryIcon(String? category) {
    switch (category) {
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
        return Icons.favorite;
    }
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesCubit, FavoritesState>(
      listener: (context, state) {
        if (state is RemoveFavorite) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'تمت إزالة الوجبة من المفضلة',
                      style: const TextStyle(
                        fontFamily: 'FFKhallab',
                        fontWeight: FontWeight.w500,
                      ),
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
      builder: (context, state) {
        final favorites = state is FavoritesLoaded ? state.favorites : [];
        final isLoading = state is FavoritesLoading;
        final cubit = context.read<FavoritesCubit>();

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Container(
              color: Colors.grey[200],
              child: SafeArea(
                child: Column(
                  children: [
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_forward_rounded),
                                  color: AppTheme.primaryPurple,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'وجباتي المفضلة',
                                      style: TextStyle(
                                        fontFamily: 'FFKhallab',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryPurple,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${favorites.length}',
                                        style: const TextStyle(
                                          fontFamily: 'FFKhallab',
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryPurple,
                                strokeWidth: 3,
                              ),
                            )
                          : favorites.isEmpty
                          ? _buildEmptyState()
                          : AnimatedBuilder(
                              animation: _listSlideAnimation,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(0, _listSlideAnimation.value),
                                  child: FadeTransition(
                                    opacity: _listController,
                                    child: child,
                                  ),
                                );
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.all(20),
                                itemCount: favorites.length,
                                itemBuilder: (context, index) {
                                  return _buildFavoriteCard(
                                    favorites[index],
                                    index,
                                    cubit,
                                  );
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_border,
              size: 80,
              color: AppTheme.primaryPurple.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد وجبات مفضلة بعد',
            style: TextStyle(
              fontFamily: 'FFKhallab',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'ابدأ بإضافة وجباتك المفضلة\nلتجدها هنا في أي وقت',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'FFKhallab',
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryPurple.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 30,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.explore, color: Colors.white, size: 22),
                      SizedBox(width: 10),
                      Text(
                        'استكشف الوجبات',
                        style: TextStyle(
                          fontFamily: 'FFKhallab',
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard(RecipeModel meal, int index, FavoritesCubit cubit) {
    final category = meal.categoryId.name;
    final categoryColor = _getCategoryColor(category);
    final categoryIcon = _getCategoryIcon(category);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (value * 0.2),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, categoryColor.withOpacity(0.05)],
          ),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(
                    mealId: meal.mealId!,
                    categoryColor: categoryColor,
                    categoryIcon: categoryIcon,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Image
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            meal.image ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: categoryColor.withOpacity(0.2),
                                  child: Icon(
                                    Icons.restaurant_rounded,
                                    color: categoryColor,
                                    size: 40,
                                  ),
                                ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  categoryColor.withOpacity(0.3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                categoryColor,
                                categoryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(categoryIcon, color: Colors.white, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Meal Name
                        Text(
                          meal.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),

                        // Description
                        Text(
                          meal.description ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Remove Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Colors.red.shade400,
                        size: 24,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              BlocBuilder<FavoritesCubit, FavoritesState>(
                                bloc: cubit,
                                builder: (context, state) {
                                  return Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: Row(
                                        children: [
                                          Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.orange,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'تأكيد الحذف',
                                            style: TextStyle(
                                              fontFamily: 'FFKhallab',
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Text(
                                        'هل تريد إزالة "${meal.name}" من المفضلة؟',
                                        style: const TextStyle(
                                          fontFamily: 'FFKhallab',
                                          fontSize: 16,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'إلغاء',
                                            style: TextStyle(
                                              fontFamily: 'FFKhallab',
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            cubit.removeFavorite(
                                              meal.mealId ?? 0,
                                            );
                                          },
                                          child: const Text(
                                            'حذف',
                                            style: TextStyle(
                                              fontFamily: 'FFKhallab',
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                        );
                      },
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
