// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyPieChart extends StatefulWidget {
  final Map<String, int> calories;
  final double targetCalories;
  final double totalCalories;
  final int prctCalories;

  const MyPieChart(
      {required this.calories,
      required this.targetCalories,
      required this.totalCalories,
      required this.prctCalories});

  @override
  _PieChart2State createState() => _PieChart2State();
}

class _PieChart2State extends State<MyPieChart> {
  int touchedIndex = -1;

  double getMealCalPrct(double mealCals) {
    return mealCals / widget.totalCalories * 100.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Indicator(
              color: const Color(0xff0293ee),
              text: 'Breakfast',
              isSquare: false,
              size: touchedIndex == 0 ? 18 : 16,
              textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xfff8b250),
              text: 'Lunch',
              isSquare: false,
              size: touchedIndex == 1 ? 18 : 16,
              textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xff845bef),
              text: 'Dinner',
              isSquare: false,
              size: touchedIndex == 2 ? 18 : 16,
              textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
            ),
            Indicator(
              color: const Color(0xff13d38e),
              text: 'Snacks',
              isSquare: false,
              size: touchedIndex == 3 ? 18 : 16,
              textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.2,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback:
                          (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }
                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: showingSections()),
                ),
              ),
            ),
            Container(
              // color: Colors.lightGreen,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calories',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '${widget.totalCalories.toInt()}',
                    style: TextStyle(fontSize: 50),
                  ),
                  Text(
                    '${widget.prctCalories}% of daily target',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    'Target Calories: ${widget.targetCalories.toInt()}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Calories Remaining',
                style: TextStyle(fontSize: 18),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.targetCalories.toInt()}',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        'Target',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '-',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(''),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.totalCalories.toInt()}',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(
                        'Food',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '=',
                        style: TextStyle(fontSize: 23),
                      ),
                      Text(''),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.targetCalories.toInt() - widget.totalCalories.toInt()}',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Remaining',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    var totalCalories = widget.calories.values
        .reduce((sum, element) => sum + element)
        .toDouble();
    double breakfastCalories = widget.calories['breakfast']!.toDouble();
    double lunchCalories = widget.calories['lunch']!.toDouble();
    double dinnerCalories = widget.calories['dinner']!.toDouble();
    double snacksCalories = widget.calories['snacks']!.toDouble();

    return totalCalories == 0
        ? List.generate(1, (i) {
            final isTouched = i == touchedIndex;
            final fontSize = isTouched ? 20.0 : 16.0;
            final radius = 70.0;

            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: Colors.grey,
                  value: 100,
                  titlePositionPercentageOffset: 0.7,
                  title:
                      isTouched ? '${widget.targetCalories.toInt()}' : '100%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              default:
                throw 'Oh no';
            }
          })
        : List.generate(5, (i) {
            final isTouched = i == touchedIndex;
            final fontSize = isTouched ? 20.0 : 16.0;
            final radius = 70.0;

            switch (i) {
              case 0:
                return PieChartSectionData(
                  color: const Color(0xff0293ee),
                  value: getMealCalPrct(breakfastCalories),
                  titlePositionPercentageOffset: 0.7,
                  title: isTouched
                      ? '${widget.calories['breakfast']}'
                      : '${getMealCalPrct(breakfastCalories).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 1:
                return PieChartSectionData(
                  color: const Color(0xfff8b250),
                  value: getMealCalPrct(lunchCalories),
                  titlePositionPercentageOffset: 0.7,
                  title: isTouched
                      ? '${widget.calories['lunch']}'
                      : '${getMealCalPrct(lunchCalories).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 2:
                return PieChartSectionData(
                  color: const Color(0xff845bef),
                  value: getMealCalPrct(dinnerCalories),
                  titlePositionPercentageOffset: 0.7,
                  title: isTouched
                      ? '${widget.calories['dinner']}'
                      : '${getMealCalPrct(dinnerCalories).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              case 3:
                return PieChartSectionData(
                  color: const Color(0xff13d38e),
                  value: getMealCalPrct(snacksCalories),
                  titlePositionPercentageOffset: 0.7,
                  title: isTouched
                      ? '${widget.calories['snacks']}'
                      : '${getMealCalPrct(snacksCalories).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
              default:
                return PieChartSectionData(
                  color: Colors.grey,
                  value: 100 - getMealCalPrct(totalCalories),
                  titlePositionPercentageOffset: 0.7,
                  title:
                      isTouched ? '${widget.targetCalories.toInt()}' : '100%',
                  radius: radius,
                  titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffffffff)),
                );
            }
          });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 12,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          softWrap: true,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
