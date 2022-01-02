import 'dart:convert';
import 'package:atm/view/about.dart';
import 'package:atm/view/home.dart';
import 'package:atm/view/accountbalance.dart';
import 'package:atm/view/chart.dart';
import 'package:atm/view/password.dart';
import 'package:atm/view/piechart.dart';
import 'package:atm/view/statistic.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

String notifikasi;

class _MainMenuState extends State<MainMenu> {
  signOut() {
    if (this.mounted) {
      setState(() {
        widget.signOut();
      });
    }
  }

  String username = "", nama = "", userid = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = preferences.getString("user");
        nama = preferences.getString("nama");
        userid = preferences.getString("id");
        // getPesan(userid);
      });
    }
  }

  // void getPesan(userid) async {
  //   final response =
  //       await http.post(BaseUrl.getpesan, body: {"user_id": userid});
  //   final data = jsonDecode(response.body);
  //   if (this.mounted) {
  //     setState(() {
  //       notifikasi = data['notifikasi'];
  //       print(notifikasi);
  //       if (notifikasi == null) {
  //         notifikasi = '0';
  //       }
  //       // startTimer();
  //     });
  //   }
  // }

  @override
  initState() {
    if (this.mounted) {
      super.initState();
      getPref();
    }
  }

  @override
  void dispose() {
    // sub.dispose();
    if (mounted) {
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Row(
            children: [
              new Image.asset(
                "gambar/logo.png",
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: 10.0,
              ),
              new Text(
                "ATM Digital",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              color: Colors.white,
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Profile(),
            PieChartSample2(),
            About(),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.only(top: 5),
          height: 60,
          color: Colors.orange,
          child: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.orange[900],
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
                child: new Text(
                  "Home",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.attach_money),
                child: new Text(
                  "Balance",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.addchart_rounded),
                child: new Text(
                  "Statistic",
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              Tab(
                icon: Icon(Icons.info),
                child: new Text(
                  "About",
                  style: TextStyle(fontSize: 10.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildIconBadge(
  IconData icon,
  String badgeText,
  Color badgeColor,
) {
  return Stack(
    children: <Widget>[
      Icon(
        icon,
        size: 30.0,
      ),
      Positioned(
        top: 2.0,
        right: 4.0,
        child: Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
          ),
          constraints: BoxConstraints(
            minWidth: 18.0,
            minHeight: 18.0,
          ),
          child: Center(
            child: Text(
              badgeText,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
