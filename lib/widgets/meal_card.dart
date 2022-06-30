// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitness_app/screens/add_food_screen.dart';
import 'package:fitness_app/screens/food_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/food.dart';
import '../providers/foods.dart';

class MealCard extends StatefulWidget {
  final String mealType;
  final DateTime date;
  final Foods foodData;
  const MealCard(
    this.mealType,
    this.date,
    this.foodData,
  );

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  void openAddFoodScreen(String mealType, DateTime date) {
    Navigator.of(context)
        .pushNamed(AddFoodScreen.routeName, arguments: [mealType, date]);
  }

  String capitalize(String text) {
    if (text.trim().isEmpty) return "";

    return "${text[0].toUpperCase()}${text.substring(1)}";
  }

  void updateMealType(
      BuildContext ctx, Food meal, DateTime date, String mealType) {
    var newCategories;
    if (meal.mealType != mealType) {
      if (meal.categories!.any((element) => element.title == mealType)) {
        newCategories = meal.categories;
      } else {
        newCategories = meal.categories!..add(Category(title: mealType));
      }
      var newFood =
          meal.copyWith(mealType: mealType, categories: newCategories);
      widget.foodData.updateFood(meal.id as String, date, newFood);
    }
    Navigator.of(ctx).pop();
  }

  void showMealDialogOnLongTap(meal) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Diary'),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (ictx) {
                            return AlertDialog(
                              title: Text('Move to...'),
                              actionsAlignment: MainAxisAlignment.start,
                              actions: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateMealType(ictx, meal,
                                                  widget.date, 'breakfast');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                'Breakfast',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateMealType(ictx, meal,
                                                  widget.date, 'lunch');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                'Lunch',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateMealType(ictx, meal,
                                                  widget.date, 'dinner');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                'Dinner',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              updateMealType(ictx, meal,
                                                  widget.date, 'snacks');
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  right: 8.0,
                                                  bottom: 8.0),
                                              child: Text(
                                                'Snacks',
                                                style: TextStyle(fontSize: 18),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(pi),
                      child: Icon(
                        Icons.reply,
                      ),
                    ),
                    label: Text('Move to...'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      widget.foodData
                          .removeFood(widget.date, meal.id as String);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Deleted Successfully!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.delete),
                    label: Text('Delete Entry'),
                  ),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Food> meals = widget.foodData.mealTypeItems(widget.mealType);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
      //padding: EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14.0, vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${capitalize(widget.mealType)}',
                    style: TextStyle(fontSize: 23),
                  ),
                  Text(
                    '${Foods.totalCalories(meals)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: meals.length,
                itemBuilder: (ctx, i) {
                  //print(foodData.items.length);
                  return Column(
                    children: [
                      Divider(
                        height: 1,
                        thickness: 0.8,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              FoodDetailScreen.routeName,
                              arguments: [meals[i], widget.date]);
                        },
                        onLongPress: () {
                          // print(meals[i].id);
                          showMealDialogOnLongTap(meals[i]);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      meals[i].name,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    meals[i].nutritions!.calories.toString(),
                                    style: TextStyle(fontSize: 18),
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
                        ),
                      ),
                    ],
                  );
                }),
            Divider(
              height: 1,
              thickness: 0.8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    onPressed: () {
                      openAddFoodScreen(widget.mealType, widget.date);
                    },
                    child: Text('Add food'.toUpperCase()),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {},
                    child: Icon(Icons.more_horiz),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
