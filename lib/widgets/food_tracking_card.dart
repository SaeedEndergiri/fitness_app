import 'package:fitness_app/widgets/my_bar_chart.dart';
import 'package:fitness_app/widgets/my_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../providers/foods.dart';

class FoodTrackingCard extends StatefulWidget {
  const FoodTrackingCard({Key? key}) : super(key: key);

  @override
  State<FoodTrackingCard> createState() => _FoodTrackingCardState();
}

class _FoodTrackingCardState extends State<FoodTrackingCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Foods>(
      builder: (context, foods, child) {
        var breakfastCalories =
            Foods.totalCalories(foods.mealTypeItems('breakfast'));
        var lunchCalories = Foods.totalCalories(foods.mealTypeItems('lunch'));
        var dinnerCalories = Foods.totalCalories(foods.mealTypeItems('dinner'));
        var snacksCalories = Foods.totalCalories(foods.mealTypeItems('snacks'));
        var calories = {
          'breakfast': breakfastCalories,
          'lunch': lunchCalories,
          'dinner': dinnerCalories,
          'snacks': snacksCalories,
        };
        var totalCalories =
            calories.values.reduce((sum, element) => sum + element);

        final targetCalories = 5000;
        final prctCalories = double.parse(
            ((totalCalories / targetCalories) * 100).toStringAsFixed(2));
        return Card(
          margin: EdgeInsets.zero,
          child: Container(
            //color: Colors.green,
            width: double.infinity,
            height: 250,
            margin: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: MyPieChart(
              calories: calories,
              targetCalories: targetCalories.toDouble(),
              totalCalories: totalCalories.toDouble(),
              prctCalories: prctCalories.round(),
            ),
          ),
        );
      },
    );
  }
}
