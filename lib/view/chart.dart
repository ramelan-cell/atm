import 'dart:convert';

import 'package:atm/model/api.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BarChartStatic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BarChartStaticState();
}

String userid;

class BarChartStaticState extends State<BarChartStatic> {
  final Color leftBarColor = const Color(0xff53fdd7);
  final Color rightBarColor = const Color(0xffff5182);
  final double width = 7;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        userid = preferences.getString("id");
      });
    }
  }

  Future<String> getData() async {
    if (userid != null) {
      final response = await http.post(BaseUrl.dataStatik, body: {
        "user_id": userid,
      });

      final data = jsonDecode(response.body);
      // print(data[0]);

      setState(() {
        final barGroup1 = makeGroupData(
            0,
            double.parse(data[0]['in_1']) / 1000000,
            double.parse(data[0]['out_1']) / 1000000);
        final barGroup2 = makeGroupData(
            1,
            double.parse(data[0]['in_2']) / 1000000,
            double.parse(data[0]['out_2']) / 1000000);
        final barGroup3 = makeGroupData(
            2,
            double.parse(data[0]['in_3']) / 1000000,
            double.parse(data[0]['out_3']) / 1000000);
        final barGroup4 = makeGroupData(
            3,
            double.parse(data[0]['in_4']) / 1000000,
            double.parse(data[0]['out_4']) / 1000000);
        final barGroup5 = makeGroupData(
            4,
            double.parse(data[0]['in_5']) / 1000000,
            double.parse(data[0]['out_5']) / 1000000);
        final barGroup6 = makeGroupData(
            5,
            double.parse(data[0]['in_6']) / 1000000,
            double.parse(data[0]['out_6']) / 1000000);
        final barGroup7 = makeGroupData(
            6,
            double.parse(data[0]['in_7']) / 1000000,
            double.parse(data[0]['out_7']) / 1000000);
        final barGroup8 = makeGroupData(
            7,
            double.parse(data[0]['in_8']) / 1000000,
            double.parse(data[0]['out_8']) / 1000000);
        final barGroup9 = makeGroupData(
            8,
            double.parse(data[0]['in_9']) / 1000000,
            double.parse(data[0]['out_9']) / 1000000);
        final barGroup10 = makeGroupData(
            9,
            double.parse(data[0]['in_10']) / 1000000,
            double.parse(data[0]['out_10']) / 1000000);
        final barGroup11 = makeGroupData(
            10,
            double.parse(data[0]['in_11']) / 1000000,
            double.parse(data[0]['out_11']) / 1000000);
        final barGroup12 = makeGroupData(
            11,
            double.parse(data[0]['in_12']) / 1000000,
            double.parse(data[0]['out_12']) / 1000000);

        final items = [
          barGroup1,
          barGroup2,
          barGroup3,
          barGroup4,
          barGroup5,
          barGroup6,
          barGroup7,
          barGroup8,
          barGroup9,
          barGroup10,
          barGroup11,
          barGroup12,
        ];

        rawBarGroups = items;

        showingBarGroups = rawBarGroups;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  makeTransactionsIcon(),
                  // const SizedBox(
                  //   width: 38,
                  // ),
                  const Text(
                    'Statistik',
                    style: TextStyle(color: Colors.grey, fontSize: 22),
                  ),
                  // const SizedBox(
                  //   width: 4,
                  // ),
                  // const Text(
                  //   'state',
                  //   style: TextStyle(color: Color(0xff77839a), fontSize: 16),
                  // ),
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: BarChart(
                    BarChartData(
                      maxY: 50,
                      barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.white,
                            getTooltipItem: (_a, _b, _c, _d) => null,
                          ),
                          touchCallback: (response) {
                            if (response.spot == null) {
                              setState(() {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              });
                              return;
                            }

                            touchedGroupIndex =
                                response.spot.touchedBarGroupIndex;

                            setState(() {
                              if (response.touchInput is PointerExitEvent ||
                                  response.touchInput is PointerUpEvent) {
                                touchedGroupIndex = -1;
                                showingBarGroups = List.of(rawBarGroups);
                              } else {
                                showingBarGroups = List.of(rawBarGroups);
                                if (touchedGroupIndex != -1) {
                                  double sum = 0;
                                  for (BarChartRodData rod
                                      in showingBarGroups[touchedGroupIndex]
                                          .barRods) {
                                    sum += rod.y;
                                  }
                                  final avg = sum /
                                      showingBarGroups[touchedGroupIndex]
                                          .barRods
                                          .length;

                                  showingBarGroups[touchedGroupIndex] =
                                      showingBarGroups[touchedGroupIndex]
                                          .copyWith(
                                    barRods: showingBarGroups[touchedGroupIndex]
                                        .barRods
                                        .map((rod) {
                                      return rod.copyWith(y: avg);
                                    }).toList(),
                                  );
                                }
                              }
                            });
                          }),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 20,
                          getTitles: (double value) {
                            switch (value.toInt()) {
                              case 0:
                                return 'Jan';
                              case 1:
                                return 'Feb';
                              case 2:
                                return 'Mar';
                              case 3:
                                return 'Apr';
                              case 4:
                                return 'Mei';
                              case 5:
                                return 'Jn';
                              case 6:
                                return 'Jl';
                              case 7:
                                return 'Ags';
                              case 8:
                                return 'Sep';
                              case 9:
                                return 'Okt';
                              case 10:
                                return 'Nov';
                              case 11:
                                return 'Des';
                              default:
                                return '';
                            }
                          },
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          getTextStyles: (value) => const TextStyle(
                              color: Color(0xff7589a2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          margin: 32,
                          reservedSize: 14,
                          getTitles: (value) {
                            if (value == 0) {
                              return '0';
                            } else if (value == 10) {
                              return '1jt';
                            } else if (value == 20) {
                              return '2jt';
                            } else if (value == 30) {
                              return '3jt';
                            } else if (value == 40) {
                              return '4jt';
                            } else if (value == 50) {
                              return '5jt';
                            } else if (value == 60) {
                              return '6jt';
                            } else if (value == 70) {
                              return '7jt';
                            } else if (value == 80) {
                              return '8jt';
                            } else if (value == 90) {
                              return '9jt';
                            } else if (value == 100) {
                              return '10jt';
                            } else if (value == 110) {
                              return '11jt';
                            }
                          },
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(barsSpace: 4, x: x, barRods: [
      BarChartRodData(
        y: y1,
        colors: [leftBarColor],
        width: width,
      ),
      BarChartRodData(
        y: y2,
        colors: [rightBarColor],
        width: width,
      ),
    ]);
  }

  Widget makeTransactionsIcon() {
    const double width = 4.5;
    const double space = 3.5;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 42,
          color: Colors.white.withOpacity(1),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 28,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(
          width: space,
        ),
        Container(
          width: width,
          height: 10,
          color: Colors.white.withOpacity(0.4),
        ),
      ],
    );
  }
}
