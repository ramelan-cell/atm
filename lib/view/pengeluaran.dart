import 'package:atm/view/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:atm/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class Pengeluaran extends StatefulWidget {
  @override
  _PengeluaranState createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  final snackbarKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldState =
      new GlobalKey<ScaffoldState>();
  final _key = new GlobalKey<FormState>();

  void _snackbar(String str) {
    if (str.isEmpty) return;
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[600],
        textColor: Colors.white,
        fontSize: 16.0);
  }

  bool _isLoading = false;
  DateTime tanggal;
  String tipepengeluaran;
  String nominal;
  String keterangan, atasnama, norekening, namabank;

  TextEditingController txtnominal = TextEditingController();
  TextEditingController txtnorekneing = TextEditingController();
  TextEditingController txtatasnama = TextEditingController();
  TextEditingController txtnorekening = TextEditingController();
  TextEditingController txtnamabank = TextEditingController();
  TextEditingController txtketerangan = TextEditingController();
  TextEditingController txttipepengeluaran = TextEditingController();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userid = preferences.getString("id");
    });
  }

  check() {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
    }
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      if (tanggal == null) {
        _snackbar('Tanggal wajib diisi !');
        setState(() {
          _isLoading = false;
        });
      } else if (tipepengeluaran == null) {
        _snackbar('Kolom Jenis dana wajib disi !');
        setState(() {
          _isLoading = false;
        });
      } else if (norekening == '') {
        _snackbar('Kolom no rekening wajib disi');
        setState(() {
          _isLoading = false;
        });
      } else if (namabank == '') {
        _snackbar('Kolom bank wajib disi');
        setState(() {
          _isLoading = false;
        });
      } else if (atasnama == '') {
        _snackbar('Kolom atas atasnama wajib disi');
        setState(() {
          _isLoading = false;
        });
      } else if (nominal == '') {
        _snackbar('Kolom nominal wajib disi');
        setState(() {
          _isLoading = false;
        });
      } else if (keterangan == '') {
        _snackbar('Kolom keterangan wajib disi');
        setState(() {
          _isLoading = false;
        });
      } else {
        prosessimpan();
      }
    }
  }

  prosessimpan() async {
    final response = await http.post(BaseUrl.inputPengeluaran, body: {
      "user_id": userid,
      "tanggal": tanggal.toString(),
      "tipe_pengeluaran": tipepengeluaran,
      "no_rekening": norekening,
      "atas_nama": atasnama,
      "nama_bank": namabank,
      "nominal": nominal,
      "keterangan": keterangan
    });

    final data = jsonDecode(response.body);
    print(data);
    String value = data['value'].toString();
    String message = data['message'];
    _snackbar(message);
    _isLoading = false;
    if (value == '1') {
      setState(() {
        Navigator.of(context).pop(context);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text(
          'Input Transfer',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key,
            child: ListView(
              children: <Widget>[
                DateTimePickerFormField(
                  style: TextStyle(fontSize: 13.0, color: Colors.black),
                  inputType: InputType.date,
                  format: DateFormat("dd-MM-yyyy"),
                  initialDate: DateTime.now(),
                  editable: false,
                  decoration: InputDecoration(
                    labelText: 'Tanggal',
                    labelStyle: TextStyle(fontSize: 13.0, color: Colors.blue),
                  ),
                  onChanged: (dt) {
                    setState(() => tanggal = dt);
                    print(tanggal);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                DropdownButton<String>(
                  itemHeight: 100.0,
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('TRANSFER BANK'),
                      value: 'TRANSFER BANK',
                    ),
                  ],
                  onChanged: (String value) {
                    setState(() {
                      tipepengeluaran = value;
                      print(tipepengeluaran);
                    });
                  },
                  hint: Text('Tipe Transfer'),
                  value: tipepengeluaran,
                ),
                TextFormField(
                  controller: txtnamabank,
                  onSaved: (e) => namabank = e,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(labelText: 'Masukan nama bank anda'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: txtnorekening,
                  onSaved: (e) => norekening = e,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Masukan no rekening'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: txtatasnama,
                  onSaved: (e) => atasnama = e,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Masukan atas nama'),
                ),
                TextFormField(
                  controller: txtnominal,
                  onSaved: (e) => nominal = e,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Masukan nominal'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: txtketerangan,
                  onSaved: (e) => keterangan = e,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: 'Masukan keterangan'),
                ),
                SizedBox(
                  height: 10,
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
                        child: _isLoading
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                "Simpan",
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
        ),
      ),
    );
  }
}
