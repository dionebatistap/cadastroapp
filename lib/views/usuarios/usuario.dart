import 'dart:convert';

import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:cadastroapp/views/usuarios/editarUsuario.dart';
import 'package:cadastroapp/views/usuarios/inserirUsuario.dart';
import 'package:cadastroapp/views/usuarios/usuarioDetalhes.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';

class Usuario extends StatefulWidget {
  @override
  _UsuarioState createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  var loading = false;
  final list = <UsuarioModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getPref();
    _listarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Usuários"),
        toolbarHeight: 70,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
        ),
      ),

//FLOATING
      floatingActionButton: (permissaoUsuario != '1')
          ? FloatingActionButton(
              child: Icon(Icons.add),
              mini: true,
              onPressed: () {
                toast('Sem permissão para inserir usuário');
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => InserirUsuario(_listarUsuarios)));
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.add),
              mini: true,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InserirUsuario(_listarUsuarios)));
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: build(context),
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.grey[50],
        notchMargin: 3.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.menu,
              color: Colors.grey[50],
              size: 40,
            )
          ],
        ),
      ),
      //FLOATINR
      body: RefreshIndicator(
        onRefresh: _listarUsuarios,
        key: _refresh,
        child: loading
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Center(child: CircularProgressIndicator()),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final x = list[i];
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              size: 45,
                              color: Colors.grey[400],
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    x.nome,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    x.usuario,
                                    style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w100),
                                  ),
                                  x.statusUser == 'ativo'
                                      ? Text(
                                          x.statusUser,
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.green[600]),
                                        )
                                      : Text(
                                          x.statusUser,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.redAccent,
                                          ),
                                        )
                                ],
                              ),
                            ),
                            IconButton(
                              color: Colors.blueAccent,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            UsuarioDetalhes(x)));
                              },
                              icon: Icon(
                                Icons.visibility,
                                size: 20,
                              ),
                            ),
                            (permissaoUsuario != "1") && (x.id != idUsuario)
                                ? IconButton(
                                    color: Colors.grey[300],
                                    onPressed: () {
                                      toast('Sem permissão para editar');
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  )
                                : IconButton(
                                    color: Colors.amber[700],
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarUsuario(
                                                      x, _listarUsuarios)));
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                  ),
                            (permissaoUsuario != '1')
                                ? IconButton(
                                    color: Colors.grey[300],
                                    onPressed: () {
                                      toast('Sem permissão para excluir');
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                    ),
                                  )
                                : IconButton(
                                    color: Colors.red[600],
                                    onPressed: () {
                                      dialogDeletarUsuario(x.id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      size: 20,
                                    ),
                                  ),
                          ],
                        ),
                      );
                    }),
              ),
      ),
    );
  }

/*METODOS*/

  String permissaoUsuario, idUsuario;
  getPref() async {
    String levelUserPref;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      levelUserPref = preferences.getString("levelUser");
      idUsuario = preferences.getString("id");
      permissaoUsuario = levelUserPref;
    });
  }

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

//OK
  _delete(String id) async {
    var url = Uri.parse(BaseUrl.deletarUsuario);
    final response = await http.post(url, body: {"idUsuario": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        _listarUsuarios();
        print(aviso);
      });
    } else {
      print(aviso);
    }
  }

  dialogDeletarUsuario(String id) {
    showConfirmDialogCustom(
      context,
      title: "Deletar este registro permanentemente?",
      dialogType: DialogType.DELETE,
      onAccept: () {
        _delete(id);
        snackBar(context, title: 'Deletado');
      },
    );
  }
}
