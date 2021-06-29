import 'dart:convert';

import 'package:cadastroapp/model/grupoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/model/api.dart';
import 'package:nb_utils/nb_utils.dart';

//CLASSE QUE REGISTRA USUARIOS

class EditarGrupo extends StatefulWidget {
  final GrupoModel model;
  final VoidCallback reload;
  EditarGrupo(this.model, this.reload);

  @override
  _EditarGrupo createState() => _EditarGrupo();
}

class _EditarGrupo extends State<EditarGrupo> {
  final _key = new GlobalKey<FormState>();

  TextEditingController nomeGrupoController = TextEditingController();
  int idGrupoInt;
  String idGrupoString;

  var validate = true;

  setup() async {
    nomeGrupoController = TextEditingController(text: widget.model.nomeGrupo);
    idGrupoString = widget.model.id;
    idGrupoInt = int.parse(idGrupoString);
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Grupo"),
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
                              return "Por favor, inserir grupo";
                            } else {
                              return null;
                            }
                          },
                          controller: nomeGrupoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            labelText: "Nome do grupo",
                          ),
                        ),
                        const SizedBox(height: 50.0),
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
                            child: Text("Salvar",
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

  save() async {
    String nomeGrupo = nomeGrupoController.text;
    var url = Uri.parse(BaseUrl.editarGrupo);
    final response = await http.post(
      url,
      body: {
        "nomeGrupo": "$nomeGrupo",
        "idGrupo": "$idGrupoInt",
      },
    );

    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      setState(() {
        print(aviso);
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print("Erro ao atualizar grupo");
    }
  }
} //CLASS
