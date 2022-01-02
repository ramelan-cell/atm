import 'package:atm/view/password.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.orangeGrey,
      body: Stack(
        children: [
          new Center(
            child: ListView(
              children: <Widget>[
                new SizedBox(
                  height: 120.0,
                ),
                new Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Image.asset(
                        "gambar/logo.png",
                        width: 80,
                        height: 80,
                      ),
                      new Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      new Text(
                        "ATM Digital",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),

                      new Padding(padding: EdgeInsets.only(bottom: 10.0)),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new Password()));
                        },
                        child: new Text(
                          "Ubah password anda ?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Colors.orange),
                        ),
                      ),
                      //
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
