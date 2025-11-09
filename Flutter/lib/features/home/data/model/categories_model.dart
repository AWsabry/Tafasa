import 'package:equatable/equatable.dart';

class CategoriesResponse extends Equatable {
  final List<Category> categories;

  const CategoriesResponse({required this.categories});

  factory CategoriesResponse.fromJson(List json) {
    return CategoriesResponse(
      categories: json.map((item) => Category.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'categories': categories.map((c) => c.toJson()).toList(),
  };

  @override
  List<Object?> get props => [categories];
}

class Category extends Equatable {
  final int id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
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
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  @override
  List<Object?> get props => [id, name, description, createdAt, updatedAt];
}
