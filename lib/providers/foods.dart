import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../models/category.dart';
import '../models/food.dart';
import '../services/database_services.dart';

class Foods with ChangeNotifier {
  List<Food> _items = [];

  List<Food> get items {
    return [..._items];
  }

  Food findById(String id) {
    return _items.firstWhere((food) => food.id == id);
  }

  List<Food> mealTypeItems(String mealType) {
    List<Food> resList = [];
    resList = _items
        .where((food) => food.categories!
            .any((category) => category.title == mealType.toLowerCase()))
        .toList();
    return resList;
  }

  static int totalCalories(List<Food> foods) {
    return foods.fold(
        0, (int sum, Food food) => sum + food.nutritions!.calories);
  }

  Future<void> fetchAndSetFoods(String mealType) async {
    final dataList = await DatabaseServices.getFoodData();
    try {
      _items = dataList
          .map(
            (food) => Food.fromMap(snapshot: food.data(), id: food.id),
          )
          .toList();
    } on Exception catch (e) {
      print(e);
    }
    // print(_items);
    notifyListeners();
  }
}
