import 'dart:convert';
import 'package:atm/model/api.dart';
import 'package:atm/view/login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class LupaPassword extends StatefulWidget {
  static final String TAG = '/lupapassword';
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

enum LupaPasswordStatus { notSignIn, signIn }

class _LupaPasswordState extends State<LupaPassword> {
  LupaPasswordStatus _LupaPasswordStatus = LupaPasswordStatus.notSignIn;
  String email;
  final _key = new GlobalKey<FormState>();
  String msg = "";
  bool _secureText = true;
  bool _apiCall = false;

  showHide() {
    if (this.mounted) {
      setState(() {
        _secureText = !_secureText;
      });
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (this.mounted) {
        setState(() {
          _apiCall = true;
        });
      }
      lupaPassword();
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  void _snackbar(String str) {
    if (str.isEmpty) return;
    _scaffoldState.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.orange,
      content: new Text(str,
          style: new TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: new Duration(seconds: 5),
    ));
  }

  lupaPassword() async {
    final response =
        await http.post(BaseUrl.lupaPassword, body: {"email": email});
    final data = jsonDecode(response.body);
    // print(data);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _snackbar(pesan);
      setState(() {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => new Login()));
      });
    } else {
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (this.mounted) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: new Text("LupaPassword"),),
      key: _scaffoldState,
      body: Form(
        key: _key,
        child: new Container(
          padding: EdgeInsets.only(top: 50.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.orange[900],
            Colors.orange[700],
            Colors.orange[500]
          ])),
          child: new Center(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Lupa password",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Sistem atm",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                alignment: Alignment.centerRight,
                                child: new Image.asset(
                                  "gambar/logo.png",
                                  width: 150,
                                  height: 100,
                                ),
                              )
                            ],
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          bottomRight: Radius.circular(50))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(225, 95, 27, 3),
                                    blurRadius: 5,
                                    offset: Offset(0, 2))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.orange[200]))),
                                child: TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "Please insert  email";
                                    }
                                  },
                                  onSaved: (e) => email = e,
                                  decoration: InputDecoration(
                                      hintText: "Masukan email anda",
                                      hintStyle: TextStyle(
                                          color: Colors.black, fontSize: 12.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              check();
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orange),
                              child: Center(
                                child: _apiCall
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        "Submit",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      new Login()));
                            },
                            child: Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.orangeAccent),
                              child: Center(
                                child: Text(
                                  "Kembali",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
