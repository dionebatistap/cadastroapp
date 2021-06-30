import 'dart:convert';

import 'package:cadastroapp/model/grupoModel.dart';
import 'package:cadastroapp/views/grupos/editarGrupo.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';

import 'inserirGrupo.dart';

class Grupo extends StatefulWidget {
  @override
  _GrupoState createState() => _GrupoState();
}

class _GrupoState extends State<Grupo> {
  var loading = false;
  final list = <GrupoModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getPref();
    _listarGrupos();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Grupos"),
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
                    builder: (context) => InserirGrupo(_listarGrupos)));
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // bottomNavigationBar: build(context),
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.grey[50],
        notchMargin: 4.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.menu,
              ),
              color: Colors.grey[50],
            ),
          ],
        ),
      ),
      //FLOATINR
      body: RefreshIndicator(
        onRefresh: _listarGrupos,
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
                              Icons.groups_rounded,
                              size: 35,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    x.nomeGrupo,
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            (permissaoUsuario != '1')
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
                                              builder: (context) => EditarGrupo(
                                                  x, _listarGrupos)));
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
                                      toast("Opção desabilitada");
                                      //dialogDeletarUsuario(x.id);
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

  String permissaoUsuario;
  getPref() async {
    String levelUserPref;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      levelUserPref = preferences.getString("levelUser");
      permissaoUsuario = levelUserPref;
    });
  }

  Future<void> _listarGrupos() async {
    list.clear();
    if (!mounted) return;
    setState(() {
      loading = true;
    });

    var url = Uri.parse(BaseUrl.listarGrupos);
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new GrupoModel(
          api['id'],
          api['nomeGrupo'],
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
  Future<void> _delete(String id) async {
    var url = Uri.parse(BaseUrl.deletarGrupo);
    final response = await http.post(url, body: {"idGrupo": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    //String aviso = data['message'];
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        _listarGrupos();
        snackBar(context,
            title: "Grupo deletado com sucesso.",
            backgroundColor: Colors.green[600]);
      });
    } else {
      snackBar(context,
          title: "Este grupo não pode ser deletado.",
          backgroundColor: Colors.red[600]);
    }
  }

  dialogDeletarUsuario(String id) {
    showConfirmDialogCustom(
      context,
      title: "Deletar este registro permanentemente?",
      dialogType: DialogType.DELETE,
      onAccept: () {
        _delete(id);
      },
    );
  }
} //CLASS
