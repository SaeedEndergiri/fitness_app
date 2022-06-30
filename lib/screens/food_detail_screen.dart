import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/food.dart';
import '../providers/foods.dart';

class FoodDetailScreen extends StatefulWidget {
  static const routeName = '/food-detail';

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  late List<int> _chartData;
  late int _totalMacros;
  late Food _food;
  String servings = '';
  late String dropdownvalue;
  var textController = TextEditingController();
  late List<String> items;
  late DateTime _date;

  @override
  void didChangeDependencies() {
    _food = (ModalRoute.of(context)!.settings.arguments as List)[0];
    _date = (ModalRoute.of(context)!.settings.arguments as List)[1];
    _chartData = getChartData();
    items = [
      '${_food.servingSize} ${_food.servingUnit}',
      '1.0 g.',
      '1.0 ounce',
      '3.5 ounce',
    ];
    dropdownvalue = items[0];
    getTotalMacros();
    super.didChangeDependencies();
  }

  void showMealTypeDialogOnLongTap(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            insetPadding: EdgeInsets.only(left: 100, top: 100),
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _food = _food.copyWith(mealType: 'breakfast');
                  });
                  print(_food.mealType);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 14,
                  ),
                  child: Text(
                    'Breakfast',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.8,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _food = _food.copyWith(mealType: 'lunch');
                  });
                  print(_food.mealType);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 14,
                  ),
                  child: Text(
                    'Lunch',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.8,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _food = _food.copyWith(mealType: 'dinner');
                  });
                  print(_food.mealType);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Dinner',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.8,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _food = _food.copyWith(mealType: 'snacks');
                  });
                  print(_food.mealType);
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 14,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Snacks',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 0,
                thickness: 0.8,
              ),
            ]);
      },
    );
  }

  void showServingsDialog(BuildContext context) {
    textController.text = _food.servings.toString();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setStateSB) => AlertDialog(
              title: Text('How Much?'),
              actionsAlignment: MainAxisAlignment.end,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: textController,
                      )),
                      Text('Serving(s) of'),
                    ],
                  ),
                  ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      value: dropdownvalue,
                      isExpanded: true,
                      items: items.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        dropdownvalue = newValue!;
                        setStateSB(() {});
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      List<String> res = dropdownvalue.split(' ');
                      _food = _food.copyWith(
                        servings: int.tryParse(textController.text),
                        servingSize: double.parse(res[0]),
                        servingUnit: res[1],
                      );
                    });
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          );
        });
  }

  void getTotalMacros() {
    _totalMacros = _food.nutritions!.carbohydrates +
        _food.nutritions!.fat +
        _food.nutritions!.protein;
  }

  List<int> getChartData() {
    final List<int> chartData = [
      _food.nutritions!.carbohydrates,
      _food.nutritions!.fat,
      _food.nutritions!.protein,
    ];
    return chartData;
  }

  Widget entryRow(
    String entry,
    double fontSize, {
    bool bold = false,
    bool? textButton,
    String? secondEntry,
    void Function()? func,
    String? unit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            entry,
            style: TextStyle(
                fontSize: fontSize, fontWeight: bold ? FontWeight.bold : null),
          ),
          if (textButton != null)
            textButton
                ? TextButton(
                    style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero),
                    onPressed: func,
                    child: Text(
                      '${secondEntry as String}  ${unit ?? ''}',
                      style: TextStyle(fontSize: fontSize),
                    ),
                  )
                : Text(
                    '${secondEntry as String}${unit == null ? '' : ' $unit'}',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
        ],
      ),
    );
  }

  Widget createChart() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14.0),
      height: 100,
      child: Container(
        // color: Colors.amber,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SfCircularChart(
                // backgroundColor: Colors.red,
                palette: [
                  Colors.cyan,
                  Colors.pink.shade200,
                  Colors.yellow.shade700,
                ],
                annotations: [
                  CircularChartAnnotation(
                    widget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_food.nutritions!.calories}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Cal'),
                      ],
                    ),
                  ),
                ],
                margin: EdgeInsets.zero,
                series: [
                  DoughnutSeries<int, String>(
                    strokeWidth: 3,
                    radius: '100%',
                    innerRadius: '80%',
                    dataSource: _chartData,
                    xValueMapper: (data, _) => data.toString(),
                    yValueMapper: (data, _) => data,
                  ),
                ],
              ),
            ),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(_food.nutritions!.carbohydrates / _totalMacros * 100).round()}%',
                  style: TextStyle(
                    color: Colors.cyan,
                  ),
                ),
                Text('${_food.nutritions!.carbohydrates}g'),
                Text('Carbs'),
              ],
            )),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(_food.nutritions!.fat / _totalMacros * 100).round()}%',
                  style: TextStyle(
                    color: Colors.pink.shade200,
                  ),
                ),
                Text('${_food.nutritions!.fat}g'),
                Text('Fat'),
              ],
            )),
            Flexible(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${(_food.nutritions!.protein / _totalMacros * 100).round()}%',
                  style: TextStyle(
                    color: Colors.yellow.shade700,
                  ),
                ),
                Text('${_food.nutritions!.protein}g'),
                Text('Protein'),
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_food.name),
        actions: [
          Consumer<Foods>(
            builder: (context, value, child) {
              return IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    value.updateFood(_food.id as String, _date, _food);
                  },
                  icon: Icon(Icons.check));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              //color: Colors.amber,
              width: double.infinity,
              height: 200,

              child: Image.network(
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                _food.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                entryRow(_food.name, 23, bold: true),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                InkWell(
                    onTap: () {
                      showMealTypeDialogOnLongTap(context);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: entryRow('Meal', 18,
                        bold: false,
                        textButton: true,
                        secondEntry: _food.mealType, func: () {
                      showMealTypeDialogOnLongTap(context);
                    })),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                InkWell(
                  onTap: () {
                    showServingsDialog(context);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: entryRow('Number of Servings', 18,
                      bold: false,
                      textButton: true,
                      secondEntry: _food.servings.toString(), func: () {
                    showServingsDialog(context);
                  }),
                ),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                InkWell(
                  onTap: () {
                    showServingsDialog(context);
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: entryRow('Serving Size', 18,
                      bold: false,
                      textButton: true,
                      secondEntry: dropdownvalue, func: () {
                    showServingsDialog(context);
                  }),
                ),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                entryRow('Description', 18),
                entryRow(_food.description, 14),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                createChart(),
                entryRow('Calories', 18,
                    textButton: false,
                    secondEntry: _food.nutritions!.calories.toString()),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                entryRow(
                  'Carbohydrates',
                  18,
                  textButton: false,
                  secondEntry: _food.nutritions!.carbohydrates.toString(),
                  unit: 'g',
                ),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                entryRow(
                  'Fat',
                  18,
                  textButton: false,
                  secondEntry: _food.nutritions!.fat.toString(),
                  unit: 'g',
                ),
                Divider(
                  height: 0,
                  thickness: 0.8,
                ),
                entryRow(
                  'Protein',
                  18,
                  textButton: false,
                  secondEntry: _food.nutritions!.protein.toString(),
                  unit: 'g',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
