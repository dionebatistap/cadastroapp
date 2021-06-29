import 'dart:convert';

import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:cadastroapp/views/menu/homePage.dart';
import 'package:cadastroapp/views/usuarios/menuUsuarios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

enum LoginStatus { notSignIn, signIn, signInUsuarios }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String usuario, senha;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.grey[850],
        statusBarIconBrightness: Brightness.light));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          body: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.7,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[400].withOpacity(0.7),
                                blurRadius: 2,
                                spreadRadius: 3),
                          ],
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(90))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.only(top: 30)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.grey[200],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.groups,
                                  size: 150,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: const EdgeInsets.only(top: 8)),
                          Spacer(),
                          //Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 25, right: 32),
                              child: Text(
                                'Cadastro de Membros',
                                style: TextStyle(
                                    color: Colors.grey[200],
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 80),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 55,
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: TextField(
                              controller: usuarioController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                                hintText: 'E-mail',
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 55,
                            margin: EdgeInsets.only(top: 12),
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: TextField(
                              controller: senhaController,
                              obscureText: _secureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(
                                    _secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.vpn_key,
                                  color: Colors.grey,
                                ),
                                hintText: 'Password',
                              ),
                            ),
                          ),
                          Spacer(),
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            elevation: 4.0,
                            color: Colors.grey[850],
                            clipBehavior: Clip.antiAlias,
                            child: MaterialButton(
                              splashColor: Colors.grey[400],
                              focusColor: Colors.grey[400],
                              hoverColor: Colors.grey[400],
                              minWidth: 300.0,
                              height: 35,
                              onPressed: () {
                                check();
                              },
                              child: Text("Login",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[100],
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
    usuario = usuarioController.text;
    senha = senhaController.text;

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
  void dispose() {
    super.dispose();
    usuarioController.dispose();
    senhaController.dispose();
  }
} //CLASS
