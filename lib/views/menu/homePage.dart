import 'dart:convert';

import 'package:cadastroapp/views/grupos/grupo.dart';
import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
import 'package:cadastroapp/views/usuarios/usuario.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:flutter/services.dart';
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

  String usuario = "", nome = "", statusUser = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usuario = preferences.getString("usuario");
      nome = preferences.getString("nome");
      statusUser = preferences.getString("statusUser");
      print(statusUser);
    });
  }

  //LOGOUT

  var loading = false;
  final list = <PessoaModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    getPref();
    _listarPessoas();
  }

  FocusNode focusNode = FocusNode();
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
                      color: Colors.grey[100],
                    ),
                    child: ListTile(
                      title: Text(
                        'Sair',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black38.withOpacity(0.2),
                        ),
                        textAlign: TextAlign.left,
                      ),
                      trailing: Icon(
                        Icons.power_settings_new,
                        color: Colors.red[700],
                      ),
                      onTap: () {
                        widget.signOut();
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
                    leading: Icon(Icons.settings),
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
                    leading: Icon(Icons.account_circle),
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
                      focusNode: focusNode,
                      onChanged: (textoPesquisa) {
                        setState(() {
                          _listarPessoasFiltradas(textoPesquisa.toLowerCase());
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
                      this.actionIcon =
                          Icon(Icons.search, color: Colors.redAccent);
                      this.appBarTitle = Text(
                        "Pesquisar cadastro",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, color: Colors.black),
                      );
                    });
                  }
                  FocusScope.of(context).requestFocus(focusNode);
                },
              ),
            ],
          ),

//FLOATING
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            mini: true,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InserirPessoa(_listarPessoas)));
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
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final x = list[i];
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
                                  fontSize: 15, fontWeight: FontWeight.bold)),
                          subtitle: Text(x.celularPessoa),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => PessoaDetalhes(x)));
                          },
                        );
                      },
                    ),
                  ),
          )),
    );
  }

/*METODOS*/

  Future<void> _listarPessoas() async {
    list.clear();
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
          api['nome'],
          api['image'],
          api['DataSelecionada'],
        );

        list.add(ab);
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _listarPessoasFiltradas(String textoPesquisa) async {
    list.clear();
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
          api['nome'],
          api['image'],
          api['DataSelecionada'],
        );
        if ((ab.nomePessoa.toLowerCase()).contains(textoPesquisa) ||
            (ab.membroObreiro.toLowerCase()).contains(textoPesquisa) ||
            (ab.grupo.toLowerCase()).contains(textoPesquisa)) {
          list.add(ab);
        }
      });
      if (!mounted) return;
      setState(() {
        loading = false;
      });
    }
  }

  _delete(String id) async {
    var url = Uri.parse(BaseUrl.deletarPessoa);
    final response = await http.post(url, body: {"idPessoa": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        Navigator.pop(context);
        _listarPessoas();
        print(aviso);
      });
    } else {
      print(aviso);
    }
  }

/*COMPONENTES*/

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text(
                  "Deseja deletar ?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text("Não")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: () {
                          _delete(id);
                        },
                        child: Text("Sim")),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
