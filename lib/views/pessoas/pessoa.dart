import 'dart:convert';

import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:cadastroapp/views/pessoas/editarPessoa.dart';
import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';

class Pessoa extends StatefulWidget {
  @override
  _PessoaState createState() => _PessoaState();
}

class _PessoaState extends State<Pessoa> {
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
  Widget appBarTitle = Text("Gerenciar Cadastros",
      style: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
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
                this.actionIcon = Icon(Icons.close, color: textPrimaryColor);
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
                        fontWeight: FontWeight.normal, color: Colors.grey[500]),
                  ),
                );
                setState(() {});
              } else {
                setState(() {
                  _listarPessoas();
                  this.actionIcon = Icon(Icons.search, color: Colors.redAccent);
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => InserirPessoa(_listarPessoas)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                          return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(
                                    BaseUrl.upload + x.image,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        x.nomePessoa,
                                        style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.bold),
                                      ),
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
                                                PessoaDetalhes(x)));
                                  },
                                  icon: Icon(
                                    Icons.visibility,
                                    size: 20,
                                  ),
                                ),
                                (permissaoUsuario == '1' ||
                                        permissaoUsuario == '2')
                                    ? IconButton(
                                        color: Colors.amber[700],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditarPessoa(
                                                      x, _listarPessoas),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 20,
                                        ),
                                      )
                                    : IconButton(
                                        color: Colors.grey[300],
                                        onPressed: () {
                                          toast('Sem permissão para editar');
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
                                          dialogDeletarPessoa(x.id);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          size: 20,
                                        ),
                                      ),
                              ],
                            ),
                          );
                        })
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
          api['telefonePessoa'],
          //atualização 25-09
          api['pessoanascimento'],
          api['pessoasexo'],
          api['estadocidade'],
          api['pessoaemail'],
          api['pessoaprofissao'],
          api['pessoauniversal'],
          //fim
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

  Future<void> _delete(String id) async {
    var url = Uri.parse(BaseUrl.deletarPessoa);
    final response = await http.post(url, body: {"idPessoa": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    //String aviso = data['message'];
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        //Navigator.pop(context);
        _listarPessoas();
        snackBar(context,
            title: "Registro deletado com sucesso",
            backgroundColor: Colors.green[600]);
      });
    } else {
      snackBar(context,
          title: "Erro ao deletar registro", backgroundColor: Colors.red[600]);
    }
  }

  dialogDeletarPessoa(String id) async {
    showConfirmDialogCustom(
      context,
      title: "Deseja deletar este registro permanentemente?",
      dialogType: DialogType.DELETE,
      onAccept: () {
        _delete(id);
      },
    );
  }

  List listafiltrarMembros = [];
  //String textoPesquisa;

  Future<void> _filtrarMembros(String textoPesquisa) async {
    listafiltrarMembros.clear();
    if (textoPesquisa.isNotEmpty) {
      setState(() {});
    }
    list.forEach((ab) {
      if ((ab.nomePessoa.toLowerCase()).contains(textoPesquisa) ||
          (ab.membroObreiro.toLowerCase()).contains(textoPesquisa) ||
          (ab.grupo.toLowerCase()).contains(textoPesquisa))
        listafiltrarMembros.add(ab);
    });
    setState(() {});
  }
}
