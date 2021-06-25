import 'dart:convert';

import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
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

  String usuario = "", nome = "";
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usuario = preferences.getString("usuario");
      nome = preferences.getString("nome");
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                          'https://static.vecteezy.com/ti/vetor-gratis/p1/2275847-avatar-masculino-perfil-icone-de-homem-caucasiano-sorridente-vetor.jpg'),
                    ),
                    accountName: Text("Dione"),
                    accountEmail: Text("dionebatistap@gmail.com"),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(width: 2.0, color: Colors.grey[50]),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  ListTile(
                    title: Text("Membros"),
                    subtitle: Text("Membros Cadastrados"),
                    leading: Icon(Icons.home),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomePage(signOut)));
                    },
                  ),
                  ListTile(
                    title: Text("Opções"),
                    subtitle: Text("Editar/Remover Membro"),
                    leading: Icon(Icons.settings),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Pessoa()));
                    },
                  ),
                  ListTile(
                    title: Text("Usuários"),
                    subtitle: Text("Gerenciar"),
                    leading: Icon(Icons.account_circle),
                    onTap: () {
                      print("home");
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Divider(
                      height: 1,
                      color: Colors.grey.withOpacity(0.6),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Sair',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    trailing: Icon(
                      Icons.power_settings_new,
                      color: Colors.red,
                    ),
                    onTap: () {
                      widget.signOut();
                    },
                  ),
                ],
              ),
            ),
          ),
          appBar: AppBar(
            title: Text("Menu Principal"),
            toolbarHeight: 70,
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
            ),
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
