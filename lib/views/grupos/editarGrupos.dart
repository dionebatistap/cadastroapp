import 'dart:convert';

import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/model/api.dart';
import 'package:nb_utils/nb_utils.dart';

class EditarUsuario extends StatefulWidget {
  final UsuarioModel model;
  final VoidCallback reload;
  EditarUsuario(this.model, this.reload);

  @override
  _EditarUsuario createState() => _EditarUsuario();
}

class _EditarUsuario extends State<EditarUsuario> {
  final _key = new GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController senhaConfirmaController = TextEditingController();

  String clstatusUsuario, cllevel, levelSelecionado, idUsuarioString;
  int idUsuarioInt;

  bool _secureText = true;

  var validate = true;

  setup() async {
    nomeController = TextEditingController(text: widget.model.nome);
    usuarioController = TextEditingController(text: widget.model.usuario);
    clstatusUsuario = widget.model.statusUser;
    levelSelecionado = widget.model.levelUser;
    cllevel = levelSelecionado;
    idUsuarioString = widget.model.id;
    idUsuarioInt = int.parse(idUsuarioString);
  }

  @override
  void initState() {
    super.initState();
    setup();
    _carregaItensDropdown();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var tamanho = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Usuário"),
        toolbarHeight: 70,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
        ),
      ),
      body: Container(
        child: OrientationBuilder(builder: (context, orientation) {
          return Form(
            //autovalidate: validate,
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                //padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 45)),
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          textCapitalization: TextCapitalization.words,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Por favor, inserir nome completo";
                            } else {
                              return null;
                            }
                          },
                          controller: nomeController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            labelText: "Nome Completo",
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          enabled: false,
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Preenchimento obrigatório";
                            } else if (!e.contains("@")) {
                              return "formato e-mail: exemplo@usuario.com";
                            } else {
                              return null;
                            }
                          },
                          controller: usuarioController,
                          decoration: InputDecoration(
                            labelText: "Usuário (e-mail)",
                            hintText: "obrigatório email",
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          obscureText: _secureText,
                          controller: senhaConfirmaController,
                          validator: (e) {
                            if ((e.length < 6)) {
                              return " min. 6 caracteres";
                            } else if (senhaConfirmaController.text !=
                                senhaController.text) {
                              return "As senhas não conferem";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Senha",
                            suffixIcon: IconButton(
                              onPressed: showHide,
                              icon: Icon(
                                _secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        TextFormField(
                          obscureText: _secureText,
                          validator: (e) {
                            if ((e.length < 6)) {
                              return " min. 6 caracteres";
                            } else if (senhaConfirmaController.text !=
                                senhaController.text) {
                              return "As senhas não conferem";
                            } else {
                              return null;
                            }
                          },
                          controller: senhaController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            labelText: "Confirmar senha",
                          ),
                        ),
                        const SizedBox(height: 8.0),

// SELECIONAR GRUPO QUE PERTENCE
                        Container(
                          height: tamanho.size.height * 0.1,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border:
                                Border.all(width: 1.1, color: Colors.grey[500]),
                            color: Colors.grey[50],
                          ),
                          padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: DropdownButtonFormField(
                                  validator: (value) => value == null
                                      ? 'Por favor selecione uma opção...'
                                      : null,
                                  decoration:
                                      InputDecoration.collapsed(hintText: ''),
                                  //decoration:,
                                  hint: Text("Selecione o level",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[700])),
                                  value: levelSelecionado,
                                  items: _listaLevels,
                                  onChanged: (level) {
                                    setState(() {
                                      cllevel = level;
                                    });
                                  },
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.0),

                        Container(
                          height: tamanho.size.height * 0.09,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            border:
                                Border.all(width: 1.1, color: Colors.grey[500]),
                            //color: Colors.grey[200],
                            //border: Border.fromBorderSide(),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            0,
                            0,
                            55,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Spacer(
                                flex: 5,
                              ),
                              Text("Ativo",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),
                              Radio(
                                value: "ativo",
                                groupValue: clstatusUsuario,
                                onChanged: (String valor) {
                                  setState(() {
                                    clstatusUsuario = valor;
                                  });
                                },
                              ),
                              Spacer(
                                flex: 3,
                              ),
                              Text("Inativo",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[700])),
                              Radio(
                                value: "inativo",
                                groupValue: clstatusUsuario,
                                onChanged: (String valor) {
                                  setState(() {
                                    clstatusUsuario = valor;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15.0),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0)),
                          elevation: 3.0,
                          color: Colors.grey[300],
                          clipBehavior: Clip.antiAlias,
                          child: MaterialButton(
                            splashColor: Colors.grey[400],
                            focusColor: Colors.grey[400],
                            hoverColor: Colors.grey[400],
                            highlightColor: Colors.grey[400],
                            minWidth: 200.0,
                            height: 35,
                            onPressed: () {
                              check();
                            },
                            child: Text("Atualizar",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey[700])),
                          ),
                        ),
                        const SizedBox(height: 15.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  save() async {
    String nome = nomeController.text;
    String usuario = usuarioController.text;
    String senha = senhaController.text;

    var url = Uri.parse(BaseUrl.editarUsuario);

    final response = await http.post(
      url,
      body: {
        "usuario": "$usuario",
        "senha": "$senha",
        "levelUser": "$cllevel",
        "nome": "$nome",
        "statusUser": "$clstatusUsuario",
        "idUsuario": '$idUsuarioInt',
      },
    );

    final data = jsonDecode(response.body);
    int value = data['value'];
    print(value);
    String aviso = data['message'];
    if (value == 1) {
      setState(() {
        widget.reload();
        Navigator.pop(context);
        print(aviso);
      });
    } else {
      print(data);
    }
  }

//DROPDOWN LIST GRUPOS
  List<DropdownMenuItem<String>> _listaLevels = [];
  _carregaItensDropdown() {
    _listaLevels.add(
      DropdownMenuItem(
          child: Text("Admin",
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          value: "1"),
    );

    _listaLevels.add(
      DropdownMenuItem(
          child: Text("Level 2 - (Cadastrar e editar)",
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          value: "2"),
    );

    _listaLevels.add(
      DropdownMenuItem(
          child: Text("Level 3 - (Somente Cadastrar)",
              style: TextStyle(fontSize: 16, color: Colors.black87)),
          value: "3"),
    );

    _listaLevels.add(
      DropdownMenuItem(
          child: Text("Level 4 - (Somente Visualizar)",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "4"),
    );
  }
} //CLASS
