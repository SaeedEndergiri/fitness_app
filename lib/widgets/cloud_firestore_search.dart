import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:fitness_app/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/food.dart';
import '../providers/foods.dart';

class CloudFirestoreSearch extends StatefulWidget {
  final String mealType;
  final DateTime date;

  const CloudFirestoreSearch({required this.mealType, required this.date});
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = '';
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FirestoreSearchBar(
          tag: 'example',
        ),
        FirestoreSearchResults.builder(
          limitOfRetrievedData: 10,
          tag: 'example',
          firestoreCollectionName: 'food',
          searchBy: 'name',
          initialBody: null,
          dataListFromSnapshot: Foods().dataListFromSnapshot,
          resultsBodyBackgroundColor: Colors.transparent,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<Food>? dataList = snapshot.data;
              if (dataList!.isEmpty) {
                return const Center(
                  child: Text('No Results Returned'),
                );
              }
              return Consumer<Foods>(builder: (context, foodData, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final Food data = dataList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    FoodDetailScreen.routeName,
                                    arguments: data);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(data.name),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                //print(widget.mealType);
                                Food newFood =
                                    data.copyWith(mealType: widget.mealType);
                                foodData.addFood(newFood, widget.date);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('${data.name} Added!'),
                                ));
                              },
                              icon: Icon(Icons.add))
                        ],
                      ),
                    );
                  },
                );
              });
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Results Returned'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }
}
