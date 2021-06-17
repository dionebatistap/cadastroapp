import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/modal/api.dart';
import 'package:cadastroapp/views/home.dart';
import 'package:cadastroapp/views/menuUsuarios.dart';
import 'package:cadastroapp/views/pessoa.dart';
import 'package:cadastroapp/views/profil.dart';
import 'package:cadastroapp/views/usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Login(),
  ));
}

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

  var _autovalidate = true;

//logica para validar os dados antes de salvar
  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //print("$usuario, $senha"); *verificar retorno*
      login();
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

//Logica para efetuar o login, push no banco de dados
//antes daqui só passa os dados para o androi, depois para a api
  login() async {
    final response = await http.post(BaseUrl.login,
        body: {"usuario": usuario, "senha": senha});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    String usuarioAPI = data['usuario'];
    String nomeAPI = data['nome'];
    String id = data['id'];
    String level = data['level'];
    if (value == 1) {
      //Control flow Level
      if (level == "1") {
        setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, usuarioAPI, nomeAPI, id, level);
      });
        
      } else {
        setState(() {
        _loginStatus = LoginStatus.signInUsuarios;
        savePref(value, usuarioAPI, nomeAPI, id, level);
        });
      }
      print(aviso);
    } else {
      print(aviso);
    }
  }

  savePref(
      int value, String usuario, String nome, String id, String level) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("nome", nome);
      preferences.setString("usuario", usuario);
      preferences.setString("id", id);
      preferences.setString("level", level);
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getString("level");

      _loginStatus = value == "1" 
      ? LoginStatus.signIn 
      : value == "2"
      ? LoginStatus.signInUsuarios
      : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      preferences.setInt("level", null);
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
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
            autovalidate: _autovalidate,
            key: _key,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
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
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    "Create a new account in here",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );

        break;
      case LoginStatus.signIn:
        return MainMenu(signOut);
      case LoginStatus.signInUsuarios:
        return MenuUsuarios(signOut);
        break;
    }
  }
}

//CLASSE QUE REGISTRA USUARIOS

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
    final response = await http.post(BaseUrl.register,
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
        autovalidate: validate,
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

//CLASSE QUE RETORNA MENU PRINCIPAL
class MainMenu extends StatefulWidget {
  final VoidCallback signOut;
  MainMenu(this.signOut);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String usuario = "", nome = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usuario = preferences.getString("usuario");
      nome = preferences.getString("nome");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              onPressed: () {
                signOut();
              },
              icon: Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            Home(),
            Pessoa(),
            Usuarios(),
            Profile(),
          ],
        ),
        bottomNavigationBar: TabBar(
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(style: BorderStyle.none)),
          controller: tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home),
              text: "Home",
            ),
            Tab(
              icon: Icon(Icons.apps),
              text: "Pessoa",
            ),
            Tab(
              icon: Icon(Icons.group),
              text: "Usuarios",
            ),
            Tab(
              icon: Icon(Icons.account_circle),
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
