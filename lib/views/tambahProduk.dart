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

  var validaCampos = true;

  File _imageFile;
  final picker = ImagePicker();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
  }

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        Navigator.pop(context);
      });
    } else {
      return;
    }
  }

  Future getImageGallery() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        Navigator.pop(context);
      });
    } else {
      return;
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      submitWithImage();
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      submitNoImage();
    } else {
      setState(() {
        validaCampos = true;
      });
    }
  }

  submitNoImage() async {
    print(harga.replaceAll(",", ""));
    final response = await http.post(BaseUrl.tambahProduk2, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga.replaceAll(",", ""),
      "expDate": "$tgl",
      "idUsers": idUsers,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(pesan);
      print(print);
    }
  }

  submitWithImage() async {
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
        lastDate: DateTime(2099));
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

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton(
                onPressed: () {
                  this.getImageCamera();
                },
                child: const Text('Câmera'),
              ),
              FlatButton(
                onPressed: () {
                  this.getImageGallery();
                },
                child: const Text('Galeria'),
              ),
            ],
          ));
        });
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
        //autovalidate: validaCampos,
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 150.0,
              child: InkWell(
                onTap: () {
                  displayBottomSheet(context);
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
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert nama produk";
                } else {
                  return null;
                }
              },
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert username";
                } else {
                  return null;
                }
              },
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Qty'),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert username";
                } else {
                  return null;
                }
              },
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
