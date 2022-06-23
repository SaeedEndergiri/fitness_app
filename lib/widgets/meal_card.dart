// ignore_for_file: public_member_api_docs, sort_constructors_first

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

  @override
  Widget build(BuildContext context) {
    List<Food> meals = widget.foodData.mealTypeItems(widget.mealType);
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
                return Column(
                  children: [
                    Divider(
                      height: 10,
                      thickness: 0.8,
                    ),
                    Dismissible(
                      key: ValueKey(meals[i].id),
                      background: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.error,
                            borderRadius: BorderRadius.circular(4)),
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      onDismissed: (direction) {
                        meals[i].copyWith(
                            categories: meals[i].categories
                              ?..removeWhere(
                                ((element) {
                                  return element.title == widget.mealType;
                                }),
                              ));
                        widget.foodData
                            .updateFood(meals[i].id as String, meals[i]);
                      },
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (direction) {
                        return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text(
                                'Do you want to remove the item from the cart?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(false);
                                },
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop(true);
                                },
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              FoodDetailScreen.routeName,
                              arguments: meals[i]);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    meals[i].name,
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
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
                      ),
                    ),
                  ],
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
          )
        ],
      ),
    );
  }
}
