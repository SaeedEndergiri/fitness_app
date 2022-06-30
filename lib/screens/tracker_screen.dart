import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TrackerScreen extends StatefulWidget {
  static const routeName = '/tracker-screen';

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  late PageController _controller;
  late DateTime _date;
  var current = 0;
  var diff = 0;
  List<int> _chartData = [
    30,
    20,
    40,
    10,
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: 3560);
    current = _controller.initialPage;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _date = ModalRoute.of(context)!.settings.arguments as DateTime;
    super.didChangeDependencies();
  }

  DateTime updateDate(DateTime date, int duration) {
    return date.add(Duration(days: duration));
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

  int dateDifference(DateTime from, DateTime to) {
    return from.difference(to).inDays;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _date) {
      _controller.jumpToPage(
          ((_controller.page as double) - dateDifference(_date, picked))
              .round());
    }
  }

  Widget createChart() {
    return Container(
      height: 150,
      child: SfCircularChart(
        // backgroundColor: Colors.red,
        palette: [
          Colors.cyan,
          Colors.pink.shade200,
          Colors.yellow.shade700,
          Colors.green.shade300,
        ],
        margin: EdgeInsets.symmetric(vertical: 15),
        series: [
          PieSeries<int, int>(
              animationDuration: 0,
              strokeWidth: 3,
              radius: '100%',
              dataSource: _chartData,
              xValueMapper: (data, _) => data,
              yValueMapper: (data, _) => data,
              dataLabelMapper: (data, _) => '${data.toString()}%',
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverAppBar(
                  pinned: false,
                  title: Text('Sliver TabBar'),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_outlined),
                    onPressed: () {
                      Navigator.of(context).pop(_date);
                    },
                  )),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                    widget: Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: TabBar(indicatorColor: Colors.white, tabs: [
                        Tab(
                          text: 'CALORIES',
                        ),
                        Tab(
                          text: 'NUTRIENTS',
                        ),
                        Tab(
                          text: 'MACROS',
                        ),
                      ]),
                    ),
                  )),
              SliverPersistentHeader(
                  pinned: true,
                  delegate: PersistentHeader(
                    widget: PreferredSize(
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
                                  formatDate(_date),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
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
                  ))
            ];
          },
          body: PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              diff = index - current;
              setState(() {
                _date = updateDate(_date, diff);
                // foodFuture = getFuture();
              });
              current = index;
            },
            itemBuilder: (ctx, indx) =>
                TabBarView(physics: NeverScrollableScrollPhysics(), children: [
              SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.all(14),
                  elevation: 0,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      createChart(),
                      SizedBox(
                        height: 14,
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.zero,
                        childAspectRatio: 4,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.cyan,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Breakfast'),
                                  Text('23% (74 cal'),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.pink.shade200,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Breakfast'),
                                  Text('23% (74 cal'),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.yellow.shade700,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Breakfast'),
                                  Text('23% (74 cal'),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.green.shade300,
                                height: 15,
                                width: 15,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Breakfast'),
                                  Text('23% (74 cal'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Calories'),
                            Text('321'),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Net Calories'),
                            Text('456'),
                          ],
                        ),
                      ),
                      Divider(
                        height: 0,
                        thickness: 0.8,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Goal'),
                            Text('7800'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.red,
                child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('List$index'),
                        ),
                      );
                    }),
              ),
              Container(
                color: Colors.yellow,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  final Widget widget;

  PersistentHeader({required this.widget});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 56.0,
      color: Colors.blue,
      child: widget,
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
