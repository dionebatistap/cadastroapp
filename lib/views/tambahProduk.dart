import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/currency.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/modal/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class TambahProduk extends StatefulWidget {
  final VoidCallback reload;
  TambahProduk(this.reload);
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  String namaProduk, qty, harga, idUsers;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  final picker = ImagePicker();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  //TODO: CERTIFICAR QUE NUNCA VAI SER VAZIO A IMAGEM

  Future getimageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    final File file = File(pickedFile.path);
    setState(() {
      _imageFile = file;
    });
  }

  Future getimageGaleria() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    final File file = File(pickedFile.path);
    setState(() {
      _imageFile = file;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.tambahProduk);
      var request = http.MultipartRequest('POST', uri);
      request.fields['namaProduk'] = namaProduk;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", '');
      request.fields['idUsers'] = idUsers;
      request.fields['expDate'] = "$tgl";

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("Imagem carregada");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Falha ao carregar imagem");
      }
    } catch (e) {
      debugPrint("Erro $e");
    }
  }

  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);
  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: tgl,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099)
        );
    if (picked != null && picked != tgl) {
      setState(() {
        tgl = picked;
        pilihTanggal = new DateFormat.yMd().format(tgl);
      });
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./images/placeholder.png'),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  getimageGaleria();
                  // getimageCamera();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextFormField(
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Qty'),
            ),
            TextFormField(
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                CurrencyFormat()
              ],
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: new DateFormat.yMd().format(tgl),
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Cadastrar"),
            ),
          ],
        ),
      ),
    );
  }
}
