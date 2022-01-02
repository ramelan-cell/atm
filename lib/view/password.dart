import 'dart:convert';
import 'package:atm/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  @override
  _PasswordState createState() => _PasswordState();
}

String id;

class _PasswordState extends State<Password> {
  String passwordlama, passwordbaru, passwordconfirm;
  final _key = new GlobalKey<FormState>();
  String msg = "";
  bool _secureText = true;
  bool _secureText1 = true;
  bool _secureText2 = true;
  bool _apiCall = false;

  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  showHide1() {
    setState(() {
      _secureText1 = !_secureText1;
    });
  }

  showHide2() {
    setState(() {
      _secureText2 = !_secureText2;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (this.mounted) {
      super.initState();
      getPref();
    }
  }

  void _snackbar(String str) {
    if (str.isEmpty) return;
    _scaffoldState.currentState.showSnackBar(new SnackBar(
      backgroundColor: Colors.orange,
      content: new Text(str,
          style: new TextStyle(fontSize: 15.0, color: Colors.white)),
      duration: new Duration(seconds: 5),
    ));
  }

  Widget progressWidget() {
    if (_apiCall)
      return Column(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.all(8.0),
          ),
          CircularProgressIndicator(),
          Text("Please wait")
        ],
      );
    else
      // jika sudah selesai kirim API
      return Center(
        child:
            Text('', style: new TextStyle(fontSize: 15.0, color: Colors.red)),
      );
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _apiCall = true;
      });
      gantipassword();
    }
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  gantipassword() async {
    final response = await http.post(BaseUrl.gantipassword, body: {
      "id": id,
      "passwordlama": passwordlama,
      "passwordbaru": passwordbaru,
      "passwordconfirm": passwordconfirm
    });
    final data = jsonDecode(response.body);

    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
    } else {
      // _apiCall = false;
      _snackbar(pesan);
      setState(() {
        _apiCall = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
          title: Text(
        'Ganti Password',
        style: TextStyle(fontSize: 16.0, color: Colors.white),
      )),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Form(
              key: _key,
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: _secureText,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Password lama anda";
                          }
                        },
                        onSaved: (e) => passwordlama = e,
                        decoration: InputDecoration(
                          labelText: "Password Lama",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0),
                          errorStyle: TextStyle(color: Colors.red),
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        obscureText: _secureText1,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Password baru anda";
                          }
                        },
                        onSaved: (e) => passwordbaru = e,
                        decoration: InputDecoration(
                          labelText: "Password Baru",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0),
                          errorStyle: TextStyle(color: Colors.red),
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          suffixIcon: IconButton(
                            onPressed: showHide1,
                            icon: Icon(_secureText1
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: _secureText2,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        validator: (e) {
                          if (e.isEmpty) {
                            return "Konfirmasi password baru anda";
                          }
                        },
                        onSaved: (e) => passwordconfirm = e,
                        decoration: InputDecoration(
                          labelText: "Confirm password",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 12.0),
                          errorStyle: TextStyle(color: Colors.red),
                          focusColor: Colors.black,
                          hoverColor: Colors.black,
                          fillColor: Colors.black,
                          suffixIcon: IconButton(
                            onPressed: showHide2,
                            icon: Icon(_secureText2
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
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
                                color: Colors.orange[900]),
                            child: Center(
                              child: _apiCall
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      "Proses",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          )),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
