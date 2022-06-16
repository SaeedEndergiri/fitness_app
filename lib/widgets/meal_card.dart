// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/screens/add_food_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/foods.dart';

class MealCard extends StatefulWidget {
  final String mealType;
  const MealCard(
    this.mealType,
  );

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  void openAddFoodScreen(String mealType) {
    Navigator.of(context)
        .pushNamed(AddFoodScreen.routeName, arguments: mealType);
  }

  String capitalize(String text) {
    if (text.trim().isEmpty) return "";

    return "${text[0].toUpperCase()}${text.substring(1)}";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Foods>(context, listen: false)
          .fetchAndSetFoods(widget.mealType),
      builder: (ctx, dataSnapshot) {
        // print(dataSnapshot);
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (dataSnapshot.error != null) {
          return Text('Error Occurred');
        } else {
          return Consumer<Foods>(
            builder: (context, foodData, child) {
              var meals = foodData.mealTypeItems(widget.mealType);
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${capitalize(widget.mealType)}',
                          style: TextStyle(fontSize: 23),
                        ),
                        Text(
                          '${Foods.totalCalories(meals)}',
                          style: TextStyle(fontSize: 23),
                        ),
                      ],
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: meals.length,
                        itemBuilder: (ctx, i) {
                          //print(foodData.items.length);
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      meals[i].name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      meals[i].nutritions!.calories.toString(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (meals[i].description.isNotEmpty)
                                  Text(
                                    meals[i].description,
                                  ),
                              ],
                            ),
                          );
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                          onPressed: () {
                            openAddFoodScreen(widget.mealType);
                          },
                          child: Text('Add food'.toUpperCase()),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {},
                          child: Icon(Icons.more_horiz),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
