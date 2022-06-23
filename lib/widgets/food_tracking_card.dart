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
        var totalCalories = Foods.totalCalories(
            foods.mealTypeItems('breakfast') +
                foods.mealTypeItems('lunch') +
                foods.mealTypeItems('dinner') +
                foods.mealTypeItems('snacks'));
        final targetCalories = 5000;
        final prctCalories = double.parse(
            ((totalCalories / targetCalories) * 100).toStringAsFixed(2));
        return Container(
          //color: Colors.green,
          width: double.infinity,
          height: 250,
          margin: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyPieChart(
                      targetCalories: targetCalories.toDouble(),
                      totalCalories: totalCalories.toDouble(),
                      prctCalories: prctCalories.round(),
                    ),
                    Card(
                      elevation: 4,
                      child: Container(
                        // color: Colors.lightGreen,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Calories',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '$totalCalories',
                              style: TextStyle(fontSize: 50),
                            ),
                            Text(
                              '$prctCalories% of daily target',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              'Target Calories: $targetCalories',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              MyBarChart(),
              //BarChart()
            ],
          ),
        );
      },
    );
  }
}
