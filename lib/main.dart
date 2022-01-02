import 'package:atm/view/login.dart';
import 'package:flutter/material.dart';
import 'package:atm/constant/constant.dart';
import 'package:atm/launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "atm",
    home: Launcher(),
    theme: ThemeData(primaryColor: Colors.orange[500]),
    routes: <String, WidgetBuilder>{
      SPLASH_SCREEN: (BuildContext context) => Launcher(),
      HOME_SCREEN: (BuildContext context) => Login(),
    },
  ));
}
