// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MealCard extends StatefulWidget {
  final int index;
  const MealCard({
    required this.index,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  var _mealType;

  String get mealTypeText {
    switch (widget.index) {
      case 0:
        _mealType = 'Breakfast';
        break;
      case 1:
        _mealType = 'Lunch';
        break;
      case 2:
        _mealType = 'Dinner';
        break;
      case 3:
        _mealType = 'Snacks';
        break;
    }
    return _mealType;
  }

  Future<int> mealCount(String mealType) async {
    mealType = mealType.toLowerCase();
    int count = -1;
    var ref = await FirebaseFirestore.instance
        .collection('food')
        .where('categories.$mealType', isNull: false)
        .get();
    count = ref.docs.length;
    print(count);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    mealTypeText;
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Text(
                  '$_mealType',
                  style: TextStyle(fontSize: 23),
                )
              ],
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('food')
                  .where('categories.${_mealType.toLowerCase()}', isNull: false)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> foodSnapshot) {
                if (foodSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final foodDocs = foodSnapshot.data!.docs;
                return Container(
                  height: 30,
                  padding: const EdgeInsets.all(5),
                  child: ListView.builder(
                      itemCount: foodDocs.length,
                      itemBuilder: (ctx, i) {
                        return Text(foodDocs[i]['name']);
                      }),
                );
              }),
          Row(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {},
                child: Text('Add food'),
              ),
              Expanded(child: SizedBox()),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_horiz),
              ),
            ],
          )
        ],
      ),
    );
  }
}
