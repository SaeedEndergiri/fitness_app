import 'package:fitness_app/widgets/my_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class FoodTrackingCard extends StatefulWidget {
  const FoodTrackingCard({Key? key}) : super(key: key);

  @override
  State<FoodTrackingCard> createState() => _FoodTrackingCardState();
}

class _FoodTrackingCardState extends State<FoodTrackingCard> {
  @override
  Widget build(BuildContext context) {
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
                Container(
                  //color: Colors.amber,
                  width: 150,
                  child: PieChart(
                    ringStrokeWidth: 15,
                    dataMap: {
                      'food': 0.3,
                      'exercise': 0.1,
                      'goal': 0.8,
                    },
                    chartType: ChartType.ring,
                    legendOptions: LegendOptions(
                      showLegends: false,
                    ),
                    chartValuesOptions:
                        ChartValuesOptions(showChartValues: false),
                  ),
                ),
                Card(
                  elevation: 4,
                  child: Container(
                    // color: Colors.lightGreen,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Calories',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '690',
                          style: TextStyle(fontSize: 50),
                        ),
                        Text(
                          '50% of daily target',
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
  }
}
