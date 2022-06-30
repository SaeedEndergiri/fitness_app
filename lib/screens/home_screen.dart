import 'package:fitness_app/screens/tracker_screen.dart';
import 'package:fitness_app/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/foods.dart';
import '../widgets/food_tracking_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _currentIndex = 0;
  late PageController _controller;
  late DateTime now;
  late DateTime date;
  var current = 0;
  late Future<void> foodFuture;

  @override
  void initState() {
    print('initState');
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    _controller = PageController(initialPage: 3560);
    current = _controller.initialPage;
    // foodFuture = getFuture();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getFuture() async {
    return Provider.of<Foods>(context, listen: false).fetchAndSetFoods(date);
  }

  String formatDate(DateTime date) {
    DateTime now = DateTime.now();
    DateTime nowDate = DateTime(now.year, now.month, now.day);
    if (nowDate.difference(date).inDays == 0) {
      return 'Today';
    }
    if (nowDate.difference(date).inDays == 1) {
      return 'Yesterday';
    }
    if (nowDate.difference(date).inDays == -1) {
      return 'Tomorrow';
    }
    if (nowDate.difference(date).inDays > 365 ||
        nowDate.difference(date).inDays < -365) {
      return DateFormat('EEEE, MMMd, y').format(date);
    }
    return DateFormat('EEEE, MMM d').format(date);
  }

  DateTime updateDate(DateTime date, int duration) {
    return date.add(Duration(days: duration));
  }

  int dateDifference(DateTime from, DateTime to) {
    return from.difference(to).inDays;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != date) {
      _controller.jumpToPage(
          ((_controller.page as double) - dateDifference(date, picked))
              .round());
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('rebuilt');
    foodFuture = getFuture();
    var diff = 0;
    return PageView.builder(
      controller: _controller,
      onPageChanged: (index) {
        diff = index - current;
        setState(() {
          date = updateDate(date, diff);
          // foodFuture = getFuture();
        });
        current = index;
      },
      itemBuilder: (context, index) {
        return Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.previousPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 8.0),
                        child: Text(
                          formatDate(date),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                      },
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Text('Diary'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(TrackerScreen.routeName, arguments: date)
                          .then((value) {
                        setState(() {
                          date = value as DateTime;
                        });
                      });
                    },
                    child: FoodTrackingCard()),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: foodFuture,
                    builder: (ctx, dataSnapshot) {
                      if (dataSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (dataSnapshot.error != null) {
                        return Text(dataSnapshot.error.toString());
                      } else {
                        return Consumer<Foods>(
                            builder: (context, foodData, child) {
                          return Container(
                            // margin: const EdgeInsets.symmetric(horizontal: 24),
                            child: ListView(
                              shrinkWrap: true,
                              padding: EdgeInsets.all(0),
                              children: [
                                MealCard('breakfast', date, foodData),
                                MealCard('lunch', date, foodData),
                                MealCard('dinner', date, foodData),
                                MealCard('snacks', date, foodData),
                              ],
                            ),
                          );
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            selectedItemColor: Theme.of(context).colorScheme.onPrimary,
            unselectedItemColor: Colors.grey[350],
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
            onTap: (idx) {
              setState(() {
                _currentIndex = idx;
              });
            },
          ),
        );
      },
    );
  }
}
