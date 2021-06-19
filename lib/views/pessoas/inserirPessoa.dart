import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class InserirPessoa extends StatefulWidget {
  final VoidCallback reload;
  InserirPessoa(this.reload);

  @override
  _InserirPessoaState createState() => _InserirPessoaState();
}

class _InserirPessoaState extends State<InserirPessoa> {
  String nomePessoa, quantidade, estadoCivil, grupo, idUsuario;
  final _key = new GlobalKey<FormState>();
  String clestadoCivil, clgrupo;
  var validarCampos = true;
  File _imageFile;
  final picker = ImagePicker();

  //VARIAVEIS DATAPICKER
  String selecionaData, labelText;
  DateTime variavelData = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    getPref();
    _carregaItensDropdown();
    _recuperaCep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        //autovalidate: validarCampos,
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            //padding: EdgeInsets.all(16.0),
            //padding: EdgeInsets.fromLTRB(14, 1, 14.0, 14.0),
            children: <Widget>[

//CONTAINER DA FOTO
              Container(
                child: InkWell(
                  onTap: () {
                    displayBottomSheet(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 300.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: _imageFile == null
                                ? AssetImage('./images/placeholder.png')
                                : FileImage(File(_imageFile.path)),
                            fit: BoxFit.fill,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              /*inicio*/
              SizedBox(
                height: 1,
              ),

//CONTAINER DOS FORMULARIOS
              Padding(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 5,
                                spreadRadius: 2)
                          ]),
                      child: Column(
                        children: <Widget>[
//FORMUALARIO DE TEXTO
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "*nome obrigatório";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => nomePessoa = e,
                            decoration: InputDecoration(labelText: 'Nome'),
                          ),

//TODO: INSERIR SOBRENOME

//FORMUALARIO DE TEXTO
                          TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "*Campo obrigatório";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (e) => quantidade = e,
                            decoration:
                                InputDecoration(labelText: 'Quantidade'),
                          ),

//FORMUALARIO RADIO BUTTON
                          Container(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Text("Solteiro"),
                                Radio(
                                  value: "Solteiro",
                                  groupValue: clestadoCivil,
                                  onChanged: (String selecionaEstadoCivil) {
                                    setState(() {
                                      clestadoCivil = selecionaEstadoCivil;
                                    });
                                  },
                                ),
                                Text("Casado"),
                                Radio(
                                  value: "Casado",
                                  groupValue: clestadoCivil,
                                  onChanged: (String selecionaEstadoCivil) {
                                    setState(() {
                                      clestadoCivil = selecionaEstadoCivil;
                                    });
                                    print("resultado " +
                                        clestadoCivil.toString());
                                  },
                                ),
                              ],
                            ),
                          ),

//FORMUALARIO DROPDOWN
                          Container(
                            padding: EdgeInsets.all(0.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: DropdownButtonFormField(
                                    hint: Text("Grupo"),
                                    items: _listaItensDropGrupo,
                                    onChanged: (itemGrupo) {
                                      setState(() {
                                        clgrupo = itemGrupo;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

//FORMUALARIO DE DATA
                          DateDropDown(
                            labelText: labelText,
                            valueText:
                                new DateFormat.yMd().format(variavelData),
                            valueStyle: valueStyle,
                            onPressed: () {
                              _selectedDate(context);
                            },
                          ),

//TODO: INSERIR PR QUE BATIZOU

                          //FORMATAÇÃO
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 30,
                    ),
//BOTÃO
                    InkWell(
                      onTap: () {
                        check();
                      },
                      child: Text("Salvar"),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    //Text("Fim"),
                  ],
                ),
              ),

              /*Fim*/
            ],
          ),
        ),
      ),
    );
  }

/* METODOS */

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = preferences.getString("id");
    });
  }

  Future obterImagemCamera() async {
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

  Future obterImagemGaleria() async {
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
      submterComFoto();
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      submterSemFoto();
    } else {
      setState(() {
        validarCampos = true;
      });
    }
  }

  submterSemFoto() async {
    var url = Uri.parse(BaseUrl.inserirPessoaSemFoto);
    final response = await http.post(url, body: {
      "nomePessoa": nomePessoa,
      "quantidade": quantidade,
      "dataSelecionada": "$variavelData",
      "idUsuario": idUsuario,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      print(aviso);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(aviso);
      print(print);
    }
  }

  submterComFoto() async {
    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.inserirPessoaComFoto);
      var request = http.MultipartRequest('POST', uri);
      request.fields['nomePessoa'] = nomePessoa;
      request.fields['quantidade'] = quantidade;
      request.fields['estadoCivil'] = "$clestadoCivil";
      request.fields['grupo'] = "$clgrupo";
      request.fields['idUsuario'] = idUsuario;
      request.fields['dataSelecionada'] = "$variavelData";

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

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: variavelData,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));
    if (picked != null && picked != variavelData) {
      setState(() {
        variavelData = picked;
        selecionaData = new DateFormat.yMd().format(variavelData);
      });
    } else {}
  }

  _recuperaCep() async {
//testar cepe digitar e retornar erro
//https://github.com/rodrigobastosv/search_cep/blob/master/lib/src/via_cep/via_cep_search_cep.dart

    String baseUrl = 'https://viacep.com.br/ws/';
    String cep = '13276280';
    String tiporetorno = '/json/';
    final uri = Uri.parse('$baseUrl/$cep/$tiporetorno');
    http.Response response;

    response = await http.get(uri);

    Map<String, dynamic> retorno = json.decode(response.body);
    String logradouro = retorno["logradouro"];
    String complemento = retorno["complemento"];
    String bairro = retorno["bairro"];

    setState(() {
      // _resultado = "${logradouro}, ${complemento}, ${bairro} ";
    });

    print(" $logradouro complemento: $complemento bairro: $bairro ");
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
              TextButton(
                onPressed: () {
                  this.obterImagemCamera();
                },
                child: const Text('Câmera'),
              ),
              TextButton(
                onPressed: () {
                  this.obterImagemGaleria();
                },
                child: const Text('Galeria'),
              ),
            ],
          ));
        });
  }

//DROPDOWN LIST GRUPOS
  List<DropdownMenuItem<String>> _listaItensDropGrupo = [];
  _carregaItensDropdown() {
    _listaItensDropGrupo.add(
      DropdownMenuItem(child: Text("Obreiro"), value: "Obreiro"),
    );
    _listaItensDropGrupo.add(
      DropdownMenuItem(child: Text("Membro"), value: "Membro"),
    );
  }
} //CLASS
