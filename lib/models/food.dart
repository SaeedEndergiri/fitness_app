// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';
import 'category.dart';

class Food {
  String? id;
  String name;
  String description;
  String mealType;
  String imageUrl;
  double servingSize;
  String servingUnit;
  int servings;
  Nutrition? nutritions;
  List<Category>? categories;

  Food({
    this.id,
    required this.name,
    required this.description,
    required this.mealType,
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
    String? mealType,
    String? imageUrl,
    double? servingSize,
    String? servingUnit,
    int? servings,
    Nutrition? nutritions,
    List<Category>? categories,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      mealType: mealType ?? this.mealType,
      imageUrl: imageUrl ?? this.imageUrl,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      servings: servings ?? this.servings,
      nutritions: nutritions ?? this.nutritions,
      categories: categories ?? this.categories,
    );
  }

  factory Food.fromSnapshot(
      {required QueryDocumentSnapshot<Map<String, dynamic>> snapshot}) {
    var data = snapshot.data();
    //print(data['categories']);
    return Food.fromJson(data).copyWith(id: snapshot.id);
  }

  Food.fromJson(Map<String, dynamic> data)
      : this(
            name: data['name'] ?? '',
            description: data['description'] ?? '',
            mealType: data['mealType'] ?? '',
            imageUrl: data['imageUrl'] ?? '',
            nutritions: data['nutritions'] == null
                ? null
                : Nutrition.fromMap(data['nutritions']),
            servings: data['servings'] != null
                ? int.parse(data['servings'].toString())
                : 0,
            servingSize: data['servingSize'] != null
                ? double.parse(data['servingSize'].toString())
                : 0,
            servingUnit: data['servingUnit'] ?? '',
            categories: data['categories'] == null
                ? []
                : (data['categories'] as List)
                    .map((e) => Category(title: e as String))
                    .toList());

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'mealType': mealType,
      'imageUrl': imageUrl,
      'servingSize': servingSize,
      'servingUnit': servingUnit,
      'servings': servings,
      'categories':
          categories == null ? {} : categories!.map((e) => e.title).toList(),
      'nutritions': nutritions?.toMap()
    };
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
      calories:
          data['calories'] != null ? int.parse(data['calories'].toString()) : 0,
      fat: data['fats'] != null ? int.parse(data['fats'].toString()) : 0,
      carbohydrates: data['carbohydrates'] != null
          ? int.parse(data['carbohydrates'].toString())
          : 0,
      protein:
          data['protein'] != null ? int.parse(data['protein'].toString()) : 0,
    );
  }

  Map toMap() {
    return {
      'calories': calories,
      'fat': fat,
      'protein': protein,
      'carbohydrates': carbohydrates,
    };
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
