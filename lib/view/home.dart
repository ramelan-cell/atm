import 'dart:convert';

import 'package:carousel_slider/carousel_options.dart';
import 'package:atm/model/api.dart';
import 'package:atm/view/login.dart';
import 'package:atm/view/pilihmenu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

String userid, username, namalengkap = "";
double saldoakhir = 0;

class _HomeState extends State<Home> {
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id");
      username = preferences.getString("username");
      namalengkap = preferences.getString("nama");
      saldoakhir = preferences.getDouble("saldoakhir");
    });
  }

  getSaldo() async {
    if (userid != null) {
      final response = await http.post(BaseUrl.getSaldoakhir, body: {
        "user_id": userid,
      });

      final data = jsonDecode(response.body);
      setState(() {
        saldoakhir = double.parse(data['saldo_akhir']);
      });
    } else {
      saldoakhir = 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getSaldo();
  }

  static final List<String> imgSlider = ['1.jpg', '2.jpg', '3.jpg', '4.jpg'];
  final CarouselSlider autoPlayImage = CarouselSlider(
    options: CarouselOptions(
      autoPlay: true,
      aspectRatio: 2.0,
      enlargeCenterPage: true,
    ),
    items: imgSlider.map((fileImage) {
      return Container(
        margin: EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'gambar/slider' + '/${fileImage}',
            fit: BoxFit.fill,
          ),
        ),
      );
    }).toList(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: Stack(
        children: [
          Container(
            height: 180,
            //SAMA HALNYA DENGAN CONTAINER SEBELUMNYA, WARNANYA DI-SET DAN BORDERRADIUSNYA KALI INI BERBEDA KITA SET KE-4 SISINYA AGAR MELENGKUNG
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
          ),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: Text(
                  'Selamat datang  ' + namalengkap ?? '',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              autoPlayImage,
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: Colors.orange,
                  child: Center(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saldo akhir anda',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.money,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  NumberFormat.currency(
                                              locale: 'id', symbol: 'Rp. ')
                                          .format(saldoakhir ?? 0) ??
                                      '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        new MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                new Login()));
                                  },
                                  child: Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              MenuUtama(),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuUtama extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: GridView.count(
        childAspectRatio: 4 / 3,
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          Card(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Pilihmenu(
                          title: "pemasukan",
                        )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'gambar/pemasukan.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text('Deposit')
                ],
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Pilihmenu(
                          title: "history_pemasukan",
                        )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'gambar/logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text('Riwayat Deposit')
                ],
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Pilihmenu(
                          title: "pengeluaran",
                        )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'gambar/pengeluaran.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text("Transfer")
                ],
              ),
            ),
          ),
          Card(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new Pilihmenu(
                          title: "history_pengeluaran",
                        )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'gambar/logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Text("Riwayat Transfer")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
