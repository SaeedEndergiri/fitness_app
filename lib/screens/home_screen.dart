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
  int current = 0;

  @override
  void initState() {
    now = DateTime.now();
    date = DateTime(now.year, now.month, now.day);
    _controller = PageController(initialPage: 3560);
    current = _controller.initialPage;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var diff = 0;
    return PageView.builder(
      controller: _controller,
      onPageChanged: (index) {
        diff = index - current;

        date = updateDate(date, diff);

        current = index;
      },
      itemBuilder: (context, index) {
        return Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _controller.previousPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    formatDate(date),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            title: Text('Diary'),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FoodTrackingCard(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: FutureBuilder(
                  future: Provider.of<Foods>(context, listen: false)
                      .fetchAndSetFoods(date),
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
                ))
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
            // onTap: (idx) {
            //   setState(() {
            //     _currentIndex = idx;
            //   });
            // },
          ),
        );
      },
    );
  }
}
