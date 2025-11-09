import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_gpt/core/services/locator/service_locator.dart';
import 'package:food_gpt/features/recipe_detail/presentation/controller/recipe_detail_cubit.dart';
import 'package:food_gpt/features/suggestions/data/model/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final int mealId;
  final Color categoryColor;
  final IconData categoryIcon;

  const RecipeDetailScreen({
    super.key,
    required this.mealId,
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RecipeDetailCubit>()..getRecipeDetail(mealId),
      child: _RecipeDetailScreenView(
        categoryColor: categoryColor,
        categoryIcon: categoryIcon,
      ),
    );
  }
}

class _RecipeDetailScreenView extends StatefulWidget {
  final Color categoryColor;
  final IconData categoryIcon;

  const _RecipeDetailScreenView({
    required this.categoryColor,
    required this.categoryIcon,
  });

  @override
  State<_RecipeDetailScreenView> createState() =>
      _RecipeDetailScreenViewState();
}

class _RecipeDetailScreenViewState extends State<_RecipeDetailScreenView>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<double> _headerAnimation;
  late Animation<double> _contentSlideAnimation;

  final Set<int> _completedSteps = {};

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

    _contentSlideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
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

  void _toggleStep(int index) {
    setState(() {
      if (_completedSteps.contains(index)) {
        _completedSteps.remove(index);
      } else {
        _completedSteps.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeDetailCubit, RecipeDetailState>(
      builder: (context, state) {
        if (state is RecipeDetailLoading) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      widget.categoryColor.withOpacity(0.1),
                      Colors.white,
                    ],
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        if (state is RecipeDetailError) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('خطأ'),
                backgroundColor: widget.categoryColor,
              ),
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
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('رجوع'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is! RecipeDetailLoaded) {
          return const SizedBox();
        }

        final recipe = state.recipe;
        final ingredients = recipe?.ingredients ?? [];
        final steps = recipe?.preparationSteps ?? [];

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [widget.categoryColor.withOpacity(0.1), Colors.white],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  // App Bar with Image
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    backgroundColor: widget.categoryColor,
                    leading: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: widget.categoryColor,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          FadeTransition(
                            opacity: _headerAnimation,
                            child: Image.network(
                              recipe!.image ??
                                  'https://source.unsplash.com/600x400/?food',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: widget.categoryColor.withOpacity(
                                      0.3,
                                    ),
                                    child: const Icon(
                                      Icons.restaurant_rounded,
                                      color: Colors.white,
                                      size: 80,
                                    ),
                                  ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            right: 20,
                            left: 20,
                            child: FadeTransition(
                              opacity: _headerAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: widget.categoryColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          widget.categoryIcon,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        const SizedBox(width: 6),
                                        const Text(
                                          'طريقة التحضير بالتفصيل',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    recipe.name,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Content
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _contentSlideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _contentSlideAnimation.value),
                          child: FadeTransition(
                            opacity: _contentController,
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ingredients Section
                            if (ingredients.isNotEmpty) ...[
                              _buildSectionHeader(
                                'المقادير',
                                Icons.shopping_basket_rounded,
                              ),
                              const SizedBox(height: 15),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.categoryColor.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: List.generate(
                                    ingredients.length,
                                    (index) => _buildIngredientItem(
                                      ingredients[index],
                                      index,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],

                            // Steps Section
                            if (steps.isNotEmpty) ...[
                              _buildSectionHeader(
                                'خطوات التحضير',
                                Icons.format_list_numbered_rounded,
                              ),
                              const SizedBox(height: 15),
                              ...List.generate(
                                steps.length,
                                (index) =>
                                    _buildStepItem(steps[index], index + 1),
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Completion Message
                            if (_completedSteps.length == steps.length &&
                                steps.isNotEmpty)
                              _buildCompletionCard(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.categoryColor,
                widget.categoryColor.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.categoryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: widget.categoryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient, int index) {
    // Format ingredient display with amount and unit if available
    String ingredientText = ingredient.name;
    if (ingredient.amount != null) {
      ingredientText += ' - ${ingredient.amount}';
      if (ingredient.unit != null) {
        ingredientText += ' ${ingredient.unit}';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: index == 0 ? Colors.transparent : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: widget.categoryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              ingredientText,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(PreparationStep step, int stepNumber) {
    final isCompleted = _completedSteps.contains(stepNumber - 1);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _toggleStep(stepNumber - 1),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isCompleted
                  ? widget.categoryColor.withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted
                    ? widget.categoryColor.withOpacity(0.3)
                    : Colors.grey.shade200,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isCompleted
                      ? widget.categoryColor.withOpacity(0.15)
                      : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Number or Checkmark
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [
                              widget.categoryColor,
                              widget.categoryColor.withOpacity(0.7),
                            ],
                          )
                        : null,
                    color: isCompleted ? null : Colors.grey.shade200,
                    shape: BoxShape.circle,
                    boxShadow: isCompleted
                        ? [
                            BoxShadow(
                              color: widget.categoryColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : Text(
                            '$stepNumber',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 15),
                // Step Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الخطوة $stepNumber',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: widget.categoryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade800,
                          height: 1.6,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: widget.categoryColor,
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
    );
  }

  Widget _buildCompletionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.categoryColor, widget.categoryColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: widget.categoryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: Colors.white,
              size: 50,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'أحسنت! 🎉',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'لقد أكملت جميع الخطوات\nبالهنا والشفا!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }
}
