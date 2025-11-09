import 'package:equatable/equatable.dart';

import '../../../home/data/model/categories_model.dart';

// Ingredient model matching backend structure
class Ingredient extends Equatable {
  final String name;
  final int? amount;
  final String? unit;

  const Ingredient({required this.name, this.amount, this.unit});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] as String,
      amount: json['amount'] as int?,
      unit: json['unit'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    if (amount != null) 'amount': amount,
    if (unit != null) 'unit': unit,
  };

  @override
  List<Object?> get props => [name, amount, unit];
}

// Preparation step model matching backend structure
class PreparationStep extends Equatable {
  final int step;
  final String description;

  const PreparationStep({required this.step, required this.description});

  factory PreparationStep.fromJson(Map<String, dynamic> json) {
    return PreparationStep(
      step: json['step'] as int,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'step': step, 'description': description};

  @override
  List<Object?> get props => [step, description];
}

class RecipeModel extends Equatable {
  final int id;
  final int? mealId;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final List<Ingredient> ingredients;
  final List<PreparationStep> preparationSteps;
  final Category categoryId; // Now an object instead of String
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RecipeModel({
    required this.id,
    required this.mealId,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.ingredients,
    required this.preparationSteps,
    required this.categoryId,
    this.createdAt,
    this.updatedAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      mealId: json.containsKey('mealId')
          ? json['mealId'] as int
          : null, // ✅ هنا
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'] as double,
      image: json['image'] as String?,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((item) => Ingredient.fromJson(item as Map<String, dynamic>))
          .toList(),
      preparationSteps: (json['preparationSteps'] as List<dynamic>)
          .map((item) => PreparationStep.fromJson(item as Map<String, dynamic>))
          .toList(),
      categoryId: json.containsKey('category')
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : Category.fromJson(json['categoryId'] as Map<String, dynamic>),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'image': image,
    'ingredients': ingredients.map((i) => i.toJson()).toList(),
    'preparationSteps': preparationSteps.map((s) => s.toJson()).toList(),
    'categoryId': categoryId.toJson(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  // Helper method to convert to the Map format used in the UI
  Map<String, dynamic> toMealMap() => {
    'name': name,
    'description': description ?? '',
    'ingredients': ingredients.map((i) => i.name).toList(),
    'steps': preparationSteps.map((s) => s.description).toList(),
  };

  // Helper to get simple ingredient names list (backward compatibility)
  List<String> get ingredientNames => ingredients.map((i) => i.name).toList();

  // Helper to get simple steps list (backward compatibility)
  List<String> get stepsList =>
      preparationSteps.map((s) => s.description).toList();

  @override
  List<Object?> get props => [
    id,
    mealId,
    name,
    description,
    price,
    image,
    ingredients,
    preparationSteps,
    categoryId,
    createdAt,
    updatedAt,
  ];
}

class SuggestionsResponse extends Equatable {
  final List<RecipeModel> recipes;

  const SuggestionsResponse({required this.recipes});

  factory SuggestionsResponse.fromJson(Map<String, dynamic> json) {
    return SuggestionsResponse(
      recipes: (json['recipes'] as List<dynamic>)
          .map((item) => RecipeModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'recipes': recipes.map((r) => r.toJson()).toList(),
  };

  @override
  List<Object?> get props => [recipes];
}
