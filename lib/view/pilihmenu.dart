import 'package:atm/view/historypemasukan.dart';
import 'package:atm/view/historypengeluaran.dart';
import 'package:atm/view/pemasukan.dart';
import 'package:atm/view/pengeluaran.dart';
import 'package:flutter/material.dart';

class Pilihmenu extends StatefulWidget {
  String title;
  Pilihmenu({this.title});

  @override
  _PilihmenuState createState() => _PilihmenuState();
}

class _PilihmenuState extends State<Pilihmenu> {
  String menu;

  menubar() {
    menu = widget.title;
    if (menu == 'pemasukan') {
      return Pemasukan();
    } else if (menu == 'history_pemasukan') {
      return HistoryPemasukan();
    } else if (menu == 'pengeluaran') {
      return Pengeluaran();
    } else if (menu == 'history_pengeluaran') {
      return HistoryPengeluaran();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      child: menubar(),
    ));
  }
}
