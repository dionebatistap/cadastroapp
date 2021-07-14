import 'dart:convert';

import 'package:cadastroapp/model/usuarioModel.dart';
import 'package:cadastroapp/views/filtros/filtroDados.dart';
import 'package:cadastroapp/views/grupos/grupo.dart';
import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
import 'package:cadastroapp/views/usuarios/usuario.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage(this.signOut);

  @override
  _HomePage createState() => _HomePage();
}

//LOGOUT
class _HomePage extends State<HomePage> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  var loading = false;
  final list = <PessoaModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getPref();
    _listarUsuarios();
    _listarPessoas();
    // _desativarInativo();
  }

  Widget appBarTitle = Text("Cadastro de Membros",
      style: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    //manter barra de status preta
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(35),
                bottomRight: Radius.circular(35)),
            child: Drawer(
              child: ListView(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    child: ListTile(
                      title: Text(
                        'Sair',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black54.withOpacity(0.4),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      trailing: Icon(
                        Icons.power_settings_new,
                        color: Colors.red[700],
                      ),
                      onTap: () {
                        dialogSignOut();
                      },
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Colors.grey.withOpacity(0.6),
                  ),
                  UserAccountsDrawerHeader(
                    currentAccountPicture: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.grey[400],
                        size: 70,
                      ),
                    ),
                    accountName: Text("$nome"),
                    accountEmail: Text("$usuario"),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(width: 5.0, color: Colors.grey[50]),
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  ListTile(
                    title: Text("Membros",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)),
                    subtitle: Text("Editar/Remover",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400],
                            fontSize: 12)),
                    leading: Icon(FontAwesomeIcons.usersCog),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Pessoa()));
                    },
                  ),
                  ListTile(
                    title: Text("Usuários",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)),
                    subtitle: Text("Gerenciar",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400],
                            fontSize: 12)),
                    leading: Icon(FontAwesomeIcons.userAstronaut),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Usuario()));
                    },
                  ),
                  ListTile(
                    title: Text("Grupos",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)),
                    subtitle: Text("Gerenciar",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400],
                            fontSize: 12)),
                    leading: Icon(Icons.groups_rounded),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Grupo()));
                    },
                  ),
                  ListTile(
                    title: Text("Filtros",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15)),
                    subtitle: Text("Pesquisar",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[400],
                            fontSize: 12)),
                    leading: Icon(FontAwesomeIcons.sortAmountDown),
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => FiltroPage()));

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FiltroPage()));
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: appBarTitle,
            toolbarHeight: 70,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
            ),
            actions: [
              IconButton(
                icon: Icon(actionIcon.icon, color: Colors.black),
                onPressed: () {
                  if (this.actionIcon.icon == Icons.search) {
                    this.actionIcon =
                        Icon(Icons.close, color: textPrimaryColor);
                    this.appBarTitle = TextField(
                      autofocus: true,
                      showCursor: true,
                      focusNode: focusNode,
                      onChanged: (textoPesquisa) {
                        setState(() {
                          _filtrarMembros(textoPesquisa.toLowerCase());
                        });
                      },
                      style: TextStyle(color: textPrimaryColor, fontSize: 20),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                        hintText: "Localizar...",
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[500]),
                      ),
                    );
                    setState(() {});
                  } else {
                    setState(() {
                      _listarPessoas();
                      this.actionIcon = Icon(Icons.search, color: Colors.black);
                      this.appBarTitle = Text(
                        "Pesquisar cadastro",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      );
                    });
                  }
                  //FocusScope.of(context).requestFocus(focusNode);
                },
              ),
            ],
          ),

//FLOATING
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              //_listarUsuarios();
              _desativarInativo();

              if (statusUser == 'inativo') {
                toast("Sem permissão");
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InserirPessoa(_listarPessoas)));
              }
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // bottomNavigationBar: build(context),
          bottomNavigationBar: new BottomAppBar(
            shape: CircularNotchedRectangle(),
            color: Colors.grey[50],
            notchMargin: 2.0,
            clipBehavior: Clip.antiAlias,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
          body: RefreshIndicator(
            onRefresh: _listarPessoas,
            key: _refresh,
            child: loading
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: listafiltrarMembros.isNotEmpty
                        ? ListView.builder(
                            itemCount: listafiltrarMembros.length,
                            itemBuilder: (context, i) {
                              final x = listafiltrarMembros[i];
                              return ListTile(
                                dense: true,
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(
                                    BaseUrl.upload + x.image,
                                  ),
                                ),
                                title: Text(x.nomePessoa,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                // subtitle: Text(''),
                                subtitle: Text(x.celularPessoa),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              PessoaDetalhes(x)));
                                },
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.frown,
                                  size: 55,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Nada encontrado!",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "tente outra vez!",
                                  style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
          )),
    );
  }

/*METODOS*/

  Future<void> _listarPessoas() async {
    list.clear();
    listafiltrarMembros.clear();
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    var url = Uri.parse(BaseUrl.listarPessoa);
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new PessoaModel(
          api['id'],
          api['nomePessoa'],
          api['enderecoPessoa'],
          api['numeroPessoa'],
          api['bairroPessoa'],
          api['cepPessoa'],
          api['cidadePessoa'],
          api['celularPessoa'],
          api['membroObreiro'],
          api['prBatizou'],
          api['estadoCivil'],
          api['grupo'],
          api['isBatizada'],
          api['createdDate'],
          api['idUsuario'],
          api['idGrupo'],
          api['nome'],
          api['image'],
          api['DataSelecionada'],
        );

        list.add(ab);
        listafiltrarMembros.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

/*COMPONENTES*/

  List listafiltrarMembros = [];
  bool chave = false;
  //String textoPesquisa;
  Future<void> _filtrarMembros(String textoPesquisa) async {
    listafiltrarMembros.clear();
    if (textoPesquisa.isNotEmpty) {
      setState(() {});
    }
    list.forEach((ab) {
      if ((ab.nomePessoa.toLowerCase()).contains(textoPesquisa) ||
          (ab.membroObreiro.toLowerCase()).contains(textoPesquisa) ||
          (ab.grupo.toLowerCase()).contains(textoPesquisa)) {
        listafiltrarMembros.add(ab);
      } else {
        setState(() {});
      }
    });
    setState(() {});
  }

  dialogSignOut() async {
    showConfirmDialogCustom(
      context,
      title: "Deseja sair?",
      dialogType: DialogType.CONFIRMATION,
      onAccept: () {
        widget.signOut();
      },
    );
  }

  //CONTROLE PARA IDENTIFICAR QUANDO UM USUARIO FOI DESATIVADO DO SISTEMA
  // E NÃO TEM MAIS PERMISSÃO PARA INCLUIR NO CADASTRO

  String usuario = "", nome = "", statusUser = "", idUser = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usuario = preferences.getString("usuario");
      nome = preferences.getString("nome");
      statusUser = preferences.getString("statusUser");
      idUser = preferences.getString("id");
      //print(statusUser);
    });
  }

  String controle = 'ativo';
  Future<void> _desativarInativo() async {
    if (listUsers[0].statusUser == 'inativo') {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        controle = 'inativo';
        preferences.setString("statusUser", "inativo");
      });
    } else {
      return;
    }
  }

  final listUsers = <UsuarioModel>[];
  Future<void> _listarUsuarios() async {
    listUsers.clear();
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
        if (api['id'] == idUser) {
          listUsers.add(ab);
        }
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }
} //CLASS
