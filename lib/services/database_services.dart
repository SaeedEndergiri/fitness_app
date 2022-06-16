import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getFoodData() async {
    final _foodCollectionRef = _db.collection('food');
    final foodSnapshot = await _foodCollectionRef.get();
    final foodData = foodSnapshot.docs.map((doc) => doc).toList();
    return foodData;
  }
}
