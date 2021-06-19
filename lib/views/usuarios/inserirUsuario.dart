import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/model/api.dart';


//CLASSE QUE REGISTRA USUARIOS

class InserirUsuario extends StatefulWidget {
  @override
  _InserirUsuario createState() => _InserirUsuario();
}

class _InserirUsuario extends State<InserirUsuario> {
  String usuario, senha, nome;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  var validate = true;
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

    var url = Uri.parse(BaseUrl.register);
    final response = await http.post(url,
        body: {"nome": nome, "usuario": usuario, "senha": senha});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        print(aviso);
      });
    } else {
      print(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        //autovalidate: validate,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _key,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: <Widget>[
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert fullname";
                } else {
                  return null;
                }
              },
              onSaved: (e) => nome = e,
              decoration: InputDecoration(
                labelText: "Nome Completo",
              ),
            ),
            TextFormField(
              validator: (e) {
                if (e.isEmpty) {
                  return "Please insert usuario";
                } else {
                  return null;
                }
              },
              onSaved: (e) => usuario = e,
              decoration: InputDecoration(
                labelText: "Usuario",
              ),
            ),
            TextFormField(
              obscureText: _secureText,
              validator: (e) {
                if (e.length < 8) {
                  return "No minimo 8 caracteres";
                } else {
                  return null;
                }
              },
              onSaved: (e) => senha = e,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: showHide,
                  icon: Icon(
                    _secureText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}