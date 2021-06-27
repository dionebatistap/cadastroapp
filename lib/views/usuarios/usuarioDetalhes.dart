import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class UsuarioDetalhes extends StatefulWidget {
  final UsuarioModel model;
  UsuarioDetalhes(this.model);

  @override
  _UsuarioDetalhes createState() => _UsuarioDetalhes();
}

class _UsuarioDetalhes extends State<UsuarioDetalhes> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        appBar: (AppBar(
          title: Text(widget.model.nome),
          toolbarHeight: 70,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
          ),
        )),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.25,
                floating: true,
                pinned: false,
                snap: false,
                elevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  // title: Text(widget.model.nomePessoa),
                  background: Container(
                    child: Hero(
                      tag: widget.model.id,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                              topLeft: Radius.circular(25)),
                          child: Icon(
                            Icons.account_circle,
                            size: 150,
                          )),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                      child: Column(
                        children: <Widget>[
                          Card(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 3, 3, 3),
                              title: Text(
                                "Nome:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                widget.model.nome,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 3, 3, 3),
                              title: Text(
                                "Usuário:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                widget.model.usuario,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 3, 3, 3),
                              title: Text(
                                "Level:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: widget.model.levelUser == '1'
                                  ? Text(
                                      //widget.model.levelUser,
                                      "Admin",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18,
                                      ),
                                    )
                                  : widget.model.levelUser == '2'
                                      ? Text(
                                          //widget.model.levelUser,
                                          "Level 2 - (Cadastrar e editar)",
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                          ),
                                        )
                                      : widget.model.levelUser == '3'
                                          ? Text(
                                              //widget.model.levelUser,
                                              "Level 3 - (Somente Cadastrar)",
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 18,
                                              ),
                                            )
                                          : Text(""),
                            ),
                          ),
                          Card(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 3, 3, 3),
                              title: Text(
                                "Status:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                widget.model.statusUser,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
