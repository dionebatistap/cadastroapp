import 'dart:convert';

import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:cadastroapp/views/pessoas/editarPessoa.dart';
import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      appBar: AppBar(
        title: Text("Gerenciar Cadastros"),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    x.nomePessoa,
                                    style: TextStyle(
                                        fontSize: 15.0,
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
                            (permissaoUsuario == '1' || permissaoUsuario == '2')
                                ? IconButton(
                                    color: Colors.amber[700],
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditarPessoa(x, _listarPessoas),
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

  _delete(String id) async {
    var url = Uri.parse(BaseUrl.deletarPessoa);
    final response = await http.post(url, body: {"idPessoa": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      if (!mounted) return;
      setState(() {
        //Navigator.pop(context);
        _listarPessoas();
        print(aviso);
      });
    } else {
      print(aviso);
    }
  }

  dialogDeletarPessoa(String id) {
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
