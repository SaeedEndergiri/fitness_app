// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'category.dart';

class Food {
  int id;
  String name;
  String description;
  String imageUrl;
  String servingSize;
  int servings;
  Nutrition nutritions;
  List<Category>? categories;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.servingSize,
    required this.servings,
    required this.nutritions,
    this.categories,
  });

  Food copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? servingSize,
    int? servings,
    Nutrition? nutritions,
    List<Category>? categories,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      servingSize: servingSize ?? this.servingSize,
      servings: servings ?? this.servings,
      nutritions: nutritions ?? this.nutritions,
      categories: categories ?? this.categories,
    );
  }
}

class Nutrition {
  int calories;
  int fat;
  int protein;
  int carbohydrates;
  Nutrition({
    required this.calories,
    required this.fat,
    required this.protein,
    required this.carbohydrates,
  });

  Nutrition copyWith({
    int? calories,
    int? fat,
    int? protein,
    int? carbohydrates,
  }) {
    return Nutrition(
      calories: calories ?? this.calories,
      fat: fat ?? this.fat,
      protein: protein ?? this.protein,
      carbohydrates: carbohydrates ?? this.carbohydrates,
    );
  }
}
