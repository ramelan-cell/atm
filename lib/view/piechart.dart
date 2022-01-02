import 'dart:ui';

import 'package:atm/model/api.dart';
import 'package:atm/view/indicator.dart';
import 'package:atm/view/password.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PieChartSample2 extends StatefulWidget {
  @override
  _PieChartSample2State createState() => _PieChartSample2State();
}

int touchedIndex = -1;

class _PieChartSample2State extends State<PieChartSample2> {
  String userid, username, namalengkap, nohp, alamat, foto, urlfoto;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        userid = preferences.getString("id");
      });
    }
  }

  Future<List> getData() async {
    if (userid == null) {
    } else {
      final response =
          await http.post(BaseUrl.dataStatik, body: {"user_id": userid});

      // print(jsonDecode(response.body));
      return jsonDecode(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (this.mounted) {
      super.initState();
      getPref();
      getData();
    }
  }

  @override
  void dispose() {
    if (this.mounted) {
      // TODO: implement dispose
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new FutureBuilder<List>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new ItemList(
                      list: snapshot.data,
                    )
                  : new Center(
                      child: new CircularProgressIndicator(),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  final formatter = new NumberFormat("#,###,###,###,###");

  List<PieChartSectionData> showingSections1(String in1, String out1) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 12.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.orange,
            value: double.parse(in1),
            title: in1,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: double.parse(out1),
            title: out1,
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );

        default:
          throw Error();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: new ListView.builder(
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          print(list[i]['in_2']);
          return Column(
            children: [
              new AspectRatio(
                aspectRatio: 1.3,
                child: ListView(
                  children: [
                    (list[i]['in_1'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Januari'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_1'],
                                                  list[i]['out_1'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_2'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Februari'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_2'],
                                                  list[i]['out_2'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_3'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Maret'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_3'],
                                                  list[i]['out_3'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_4'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan April'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_4'],
                                                  list[i]['out_4'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_5'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Mei'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_5'],
                                                  list[i]['out_5'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_6'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Juni'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_6'],
                                                  list[i]['out_6'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_7'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Juli'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_7'],
                                                  list[i]['out_7'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_8'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Agustus'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_8'],
                                                  list[i]['out_8'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_9'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan September'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_9'],
                                                  list[i]['out_9'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_10'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Oktober'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_10'],
                                                  list[i]['out_10'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_11'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan November'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_11'],
                                                  list[i]['out_11'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    (list[i]['in_12'] != '0')
                        ? Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text('Grafik bulan Desember'),
                              Card(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: PieChart(
                                          PieChartData(
                                              pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (pieTouchResponse) {
                                                // setState(() {
                                                final desiredTouch =
                                                    pieTouchResponse.touchInput
                                                            is! PointerExitEvent &&
                                                        pieTouchResponse
                                                                .touchInput
                                                            is! PointerUpEvent;
                                                if (desiredTouch &&
                                                    pieTouchResponse
                                                            .touchedSection !=
                                                        null) {
                                                  touchedIndex =
                                                      pieTouchResponse
                                                          .touchedSectionIndex;
                                                } else {
                                                  touchedIndex = -1;
                                                }
                                                // });
                                              }),
                                              borderData: FlBorderData(
                                                show: false,
                                              ),
                                              sectionsSpace: 0,
                                              centerSpaceRadius: 40,
                                              sections: showingSections1(
                                                  list[i]['in_12'],
                                                  list[i]['out_12'])),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const <Widget>[
                                        Indicator(
                                          color: Colors.orange,
                                          text: 'In',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Indicator(
                                          color: Colors.red,
                                          text: 'Out',
                                          isSquare: true,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 28,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
