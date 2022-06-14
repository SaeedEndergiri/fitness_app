// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fitness_app/models/meal.dart';

import 'category.dart';
import 'food.dart';

class Recipe {
  final int id;
  final String name;
  final int servings;
  final List<Food> ingredients;
  final List<String> steps;
  final List<Category>? categories;

  Recipe({
    required this.id,
    required this.name,
    required this.servings,
    required this.ingredients,
    required this.steps,
    this.categories,
  });

  Recipe copyWith({
    int? id,
    String? name,
    int? servings,
    List<Food>? ingredients,
    List<String>? steps,
    List<Category>? categories,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      servings: servings ?? this.servings,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      categories: categories ?? this.categories,
    );
  }
}
