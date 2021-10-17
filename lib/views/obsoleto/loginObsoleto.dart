import 'dart:convert';

import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:cadastroapp/views/menu/homePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/views/usuarios/menuUsuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn, signInUsuarios }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String usuario, senha;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  //var _autovalidate = true;

//logica para validar os dados antes de salvar
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //print("$usuario, $senha"); *verificar retorno*
      login();
    } else {
      setState(() {
        // _autovalidate = true;
      });
    }
  }

//Logica para efetuar o login, push no banco de dados
//antes daqui só passa os dados para o androi, depois para a api
  login() async {
    var url = Uri.parse(BaseUrl.login);
    final response =
        await http.post(url, body: {"usuario": usuario, "senha": senha});
    final data = jsonDecode(response.body);
    print(data);
    int value = data['value'];
    String aviso = data['message'];
    String usuarioAPI = data['usuario'];
    String nomeAPI = data['nome'];
    String id = data['id'];
    String levelUser = data['levelUser'];
    String statusUser = data['statusUser'];
    if (value == 1) {
      if (((levelUser == "1") || (levelUser == "2") || (levelUser == "3")) &&
          (statusUser == "ativo")) {
        setState(() {
          _loginStatus = LoginStatus.signIn;
          savePref(value, usuarioAPI, nomeAPI, id, levelUser, statusUser);
        });
      } else {
        setState(() {
          _loginStatus = LoginStatus.signInUsuarios;
          savePref(value, usuarioAPI, nomeAPI, id, levelUser, statusUser);
        });
      }
      print(aviso);
    } else {
      print(aviso);
    }
  }

  savePref(int value, String usuario, String nome, String id, String levelUser,
      String statusUser) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("usuario", usuario);
      preferences.setString("nome", nome);
      preferences.setString("id", id);
      preferences.setString("levelUser", levelUser);
      preferences.setString("statusUser", statusUser);
    });
  }

  String value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("levelUser");

      _loginStatus = value == "1"
          ? LoginStatus.signIn
          : value == "0"
              ? LoginStatus.signInUsuarios
              : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", 0);
      preferences.setString("levelUser", "0");
      preferences.setString("statusUser", "");
      preferences.setString("levelUser", "");
      preferences.setString("id", "");
      preferences.setString("usuario", "");

      _loginStatus = LoginStatus.notSignIn;
    });
  }

  var loading = false;
  final list = <UsuarioModel>[];
  // ignore: unused_element
  Future<void> _listarUsuarios() async {
    list.clear();
    if (!mounted) return;
    setState(() {
      loading = true;
    });

    var url = Uri.parse(BaseUrl.listarUsuarios);
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new UsuarioModel(
          api['id'],
          api['usuario'],
          api['senha'],
          api['levelUser'],
          api['nome'],
          api['statusUser'],
          api['createdDate'],
        );
        list.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(),
          body: Form(
            //autovalidate: _autovalidate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (e) {
                    if (!e.contains("@")) {
                      return "Formato Errado (E-MAIL)";
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
                  child: Text("Login"),
                ),
              ],
            ),
          ),
        );

        break;
      case LoginStatus.signIn:
        return HomePage(signOut);
      case LoginStatus.signInUsuarios:
        return MenuUsuarios(signOut);
        break;
      default:
        return Text("Erro ao carregar menu!");
    }
  }
}
