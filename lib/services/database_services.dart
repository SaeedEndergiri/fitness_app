import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../models/food.dart';

class DatabaseServices {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static CollectionReference<Map<String, dynamic>> getCollectionRef(
      DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return _db
        .collection('usersMeals')
        .doc(_auth.currentUser?.uid)
        .collection('date')
        .doc(formattedDate)
        .collection('foods');
  }

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getFoodData(
      DateTime date) async {
    final foodSnapshot = await getCollectionRef(date).get();
    final foodData = foodSnapshot.docs.map((doc) => doc).toList();
    print('fetch done!');
    return foodData;
  }

  static Future<void> addNewFood(
      Map<String, dynamic> data, DateTime date) async {
    final foodCollectionRef = getCollectionRef(date);
    foodCollectionRef.add(data);
    print('add done!');
  }

//usersMeals/${_auth.currentUser?.uid}/date/$date/$mealType/foods
  static Future<void> updateFood(Map<String, dynamic> newFood) async {
    final foodCollectionRef = getCollectionRef(DateTime.now());
    foodCollectionRef.add(newFood);
    print('update done!');
  }
}
