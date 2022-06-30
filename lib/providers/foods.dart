import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
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
    resList = _items.where((food) => food.mealType == mealType).toList();
    return resList;
  }

  List<Food> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap =
          snapshot.data() as Map<String, dynamic>;
      return Food.fromJson(dataMap);
    }).toList();
  }

  static int totalCalories(List<Food> foods) {
    return foods.fold(
        0, (int sum, Food food) => sum + food.nutritions!.calories);
  }

  Future<void> fetchAndSetFoods(DateTime date) async {
    final dataList = await DatabaseServices.getFoodData(date);
    try {
      _items = dataList.map(
        (food) {
          // print(food.id);
          return Food.fromSnapshot(snapshot: food);
        },
      ).toList();
    } on Exception catch (e) {
      print(e);
    }
    // print(_items);
    notifyListeners();
  }

  Future<void> removeFood(DateTime date, String id) async {
    final foodIdx = _items.indexWhere((food) => food.id == id);
    if (foodIdx >= 0) {
      _items.removeAt(foodIdx);
      notifyListeners();
      await DatabaseServices.removeFood(date, id);
    } else {
      print('error');
    }
  }

  Future<void> addFood(Food foodData, DateTime date) async {
    try {
      var docId = await DatabaseServices.addNewFood(foodData.toJson(), date);
      Food newFood = foodData.copyWith(id: docId);
      _items.add(newFood);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
    print('successful');
  }

  Future<void> updateFood(String id, DateTime date, Food newFood) async {
    final foodIdx = _items.indexWhere((food) => food.id == id);
    if (foodIdx >= 0) {
      await DatabaseServices.updateFood(
          newFood.id as String, date, newFood.toJson());
      _items[foodIdx] = newFood;
      notifyListeners();
    } else {
      print('error');
    }
  }
}
