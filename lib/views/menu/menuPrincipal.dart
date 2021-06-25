//import 'dart:convert';

import 'package:cadastroapp/views/menu/menu.dart';
import 'package:cadastroapp/views/pessoas/pessoasLista.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:cadastroapp/views/outrastelas/profil.dart';
import 'package:cadastroapp/views/usuarios/usuarios.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            //brightness: Brightness.light,
            toolbarHeight: 60,
            title: Text("Menu Principal"),
            //brightness: Brightness.dark,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  signOut();
                },
                icon: Icon(Icons.exit_to_app),
              )
            ],
            elevation: 10.0,
            shape: RoundedRectangleBorder(
                borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20)),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: TabBarView(
              children: <Widget>[
                PessoaLista(),
                Pessoa(),
                BottomAppbar(),
                Profile(),
              ],
            ),
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
      ),
    );
  }
}
