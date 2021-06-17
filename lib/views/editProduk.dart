import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/modal/api.dart';
import 'package:cadastroapp/modal/produkModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditProduk extends StatefulWidget {
  final ProdukModel model;
  final VoidCallback reload;
  EditProduk(this.model, this.reload);
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  final _key = new GlobalKey<FormState>();
  String namaProduk, qty, harga, idUsers;

  File _imageFile;
  final picker = ImagePicker();

  Future getImageCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
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
      });
    } else {
      return;
    }
  }

  TextEditingController txtNama, txtQty, txtHarga;
  String tgldate;

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });

    tgldate = widget.model.expDate;
    txtNama = TextEditingController(text: widget.model.namaProduk);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  // check() {
  //   final form = _key.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     submitImage();
  //   } else {}
  // }

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
      return "Erro!";
    }
  }

  submitNoImage() async {
    final response = await http.post(BaseUrl.editProdukNoPhoto, body: {
      "namaProduk": namaProduk,
      "qty": qty,
      "harga": harga,
      "idProduk": widget.model.id,
      "expDate": "$tgldate"
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];

    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
        print(pesan + "Noimage");
        print(data);
      });
    } else {
      print(pesan + "Noimage");
    }
  }

  submitWithImage() async {
    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.editProdukWithPhoto);
      var request = http.MultipartRequest('POST', uri);
      request.fields['namaProduk'] = namaProduk;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga;
      request.fields['idUsers'] = idUsers;
      request.fields['idProduk'] = widget.model.id;
      request.fields['expDate'] = "$tgldate";

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
  }

  String pilihTanggal, labelText;
  DateTime tgl = new DateTime.now();

  var formatTgl = new DateFormat('yyyy-MM-dd');

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
        tgldate = formatTgl.format(tgl);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
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
                  getImageGallery();
                  // getimageCamera();
                },
                child: _imageFile == null
                    ? Image.network(BaseUrl.upload + widget.model.image)
                    : Image.file(
                        _imageFile,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            TextFormField(
              controller: txtNama,
              onSaved: (e) => namaProduk = e,
              decoration: InputDecoration(labelText: 'Nama Produk'),
            ),
            TextFormField(
              controller: txtQty,
              onSaved: (e) => qty = e,
              decoration: InputDecoration(labelText: 'Qty'),
            ),
            TextFormField(
              controller: txtHarga,
              onSaved: (e) => harga = e,
              decoration: InputDecoration(labelText: 'Harga'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: tgldate,
              valueStyle: valueStyle,
              onPressed: () {
                _selectedDate(context);
              },
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}
