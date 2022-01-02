import 'dart:convert';
import 'package:atm/view/detailpemasukan.dart';
import 'package:flutter/material.dart';
import 'package:atm/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPemasukan extends StatefulWidget {
  @override
  _HistoryPemasukanState createState() => _HistoryPemasukanState();
}

String userid;

class _HistoryPemasukanState extends State<HistoryPemasukan> {
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
      print("Tidak ada Riwayat");
    } else {
      print(userid);
      final response = await http
          .post(BaseUrl.getHistoryPemasukan, body: {"user_id": userid});
      return jsonDecode(response.body);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        backgroundColor: Colors.orange,
        title: Text('History Pemasukan',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.0)),
      ),
      body: Container(
        child: new FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? new ItemList(
                    list: snapshot.data,
                  )
                : new Center(
                    child: Text("Belum ada transaksi"),
                  );
          },
        ),
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});
  final formatter = new NumberFormat("#,###,###,###,###");

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        print(list);

        return new Container(
            child: Column(
          children: [
            new GestureDetector(
              onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => DetailPemasukan(
                        list: list,
                        index: i,
                      ))),
              child: new Card(
                // color: Colors.amber[700],
                child: DefaultTextStyle(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  child: new ListTile(
                    title: new Text(list[i]['jenis_dana'] ?? ''),
                    leading: new Icon(Icons.widgets),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tanggal'),
                            Text(
                              list[i]['tanggal'] ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nominal'),
                            Text(
                              formatter.format(int.parse(list[i]['nominal'])) ??
                                  '',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
      },
    );
  }
}
