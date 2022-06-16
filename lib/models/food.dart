// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'category.dart';

class Food {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String id;
  String name;
  String description;
  String imageUrl;
  String servingSize;
  String servingUnit;
  int servings;
  Nutrition? nutritions;
  List<Category>? categories;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.servingSize,
    required this.servingUnit,
    required this.servings,
    required this.nutritions,
    this.categories,
  });

  Food copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? servingSize,
    String? servingUnit,
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
      servingUnit: servingUnit ?? this.servingUnit,
      servings: servings ?? this.servings,
      nutritions: nutritions ?? this.nutritions,
      categories: categories ?? this.categories,
    );
  }

  factory Food.fromMap({required Map snapshot, required String id}) {
    return Food(
        id: id,
        description: snapshot['description'] ?? '',
        name: snapshot['name'] ?? '',
        imageUrl: snapshot['imageUrl'] ?? '',
        nutritions: snapshot['nutritions'] == null
            ? null
            : Nutrition.fromMap(snapshot['nutritions']),
        servings: snapshot['servings'] ?? 0,
        servingSize: snapshot['servingSize'] ?? '',
        servingUnit: snapshot['servingUnit'] ?? '',
        categories: snapshot['categories'] == null
            ? []
            : (snapshot['categories'] as List)
                .map((e) => Category(title: e as String))
                .toList());
  }

  // Stream<List<Food>> streamFood() {
  //   return _db.collection('food').snapshots().map((snap) =>
  //       snap.docs.map((doc) => Food.fromMap(doc.data(), doc.id)).toList());
  // }
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

  factory Nutrition.fromMap(Map<String, dynamic> data) {
    return Nutrition(
        calories: data['calories'] ?? 0,
        fat: data['fat'] ?? 0,
        carbohydrates: data['carbohydrates'] ?? 0,
        protein: data['protein'] ?? 0);
  }

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
