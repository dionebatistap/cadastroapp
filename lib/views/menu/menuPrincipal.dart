//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cadastroapp/views/outrastelas/home.dart';
import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:cadastroapp/views/outrastelas/profil.dart';
import 'package:cadastroapp/views/usuarios/usuarios.dart';
import 'package:shared_preferences/shared_preferences.dart';

//CLASSE QUE RETORNA MENU PRINCIPAL
class MenuPrincipal extends StatefulWidget {
  final VoidCallback signOut;
  MenuPrincipal(this.signOut);
  @override
  _MenuPrincipal createState() => _MenuPrincipal();
}

class _MenuPrincipal extends State<MenuPrincipal> {
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
