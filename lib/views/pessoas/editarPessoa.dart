import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditarPessoa extends StatefulWidget {
  final PessoaModel model;
  final VoidCallback reload;
  EditarPessoa(this.model, this.reload);

  @override
  _EditarPessoaState createState() => _EditarPessoaState();
}

class _EditarPessoaState extends State<EditarPessoa> {
  final _key = new GlobalKey<FormState>();
  String nomePessoa, quantidade, idUsuario;
  File _imageFile;
  final picker = ImagePicker();
  TextEditingController txtNome, txtQuantidade;

  //VARIAVEIS DATAPICKER
  String vardata;
  String selecionaData, labelText;
  DateTime variavelData = new DateTime.now();
  var formatarData = new DateFormat('yyyy-MM-dd');
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    //TODO: LIBERAR SETUP PARA EDITAR
    setup();
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
                  obterImagemGaleria();
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
              controller: txtNome,
              onSaved: (e) => nomePessoa = e,
              decoration: InputDecoration(labelText: 'Nome Pessoa'),
            ),
            TextFormField(
              controller: txtQuantidade,
              onSaved: (e) => quantidade = e,
              decoration: InputDecoration(labelText: 'Quantidade'),
            ),
            DateDropDown(
              labelText: labelText,
              valueText: vardata,
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

/* METODOS */

  Future obterImagemCamera() async {
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

  Future obterImagemGaleria() async {
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

  submterComFoto() async {
    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.editarPessoaComFoto);
      var request = http.MultipartRequest('POST', uri);
      request.fields['nomePessoa'] = nomePessoa;
      request.fields['quantidade'] = quantidade;
      request.fields['idUsuario'] = idUsuario;
      request.fields['idPessoa'] = widget.model.id;
      request.fields['dataSelecionada'] = "$vardata";
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

  submterSemFoto() async {
    var url = Uri.parse(BaseUrl.editarPessoaSemFoto);
    final response = await http.post(url, body: {
      "nomePessoa": nomePessoa,
      "quantidade": quantidade,
      "idPessoa": widget.model.id,
      "dataSelecionada": "$vardata"
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
        print(aviso + "Noimage");
        print(data);
      });
    } else {
      print(aviso + "Noimage");
    }
  }

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = preferences.getString("id");
    });
    vardata = widget.model.dataSelecionada;
    txtNome = TextEditingController(text: widget.model.nomePessoa);
    txtQuantidade = TextEditingController(text: widget.model.celularPessoa);
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: variavelData,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));
    if (picked != null && picked != variavelData) {
      setState(() {
        variavelData = picked;
        vardata = formatarData.format(variavelData);
      });
    } else {}
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      submterComFoto();
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      submterSemFoto();
    } else {
      return "Erro!";
    }
  }
}
