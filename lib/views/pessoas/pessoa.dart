import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:cadastroapp/views/pessoas/editarPessoa.dart';
import 'package:cadastroapp/views/pessoas/inserirPessoa.dart';
import 'package:http/http.dart' as http;

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
    _listarPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => InserirPessoa(_listarPessoas)));
          },
        ),
        body: RefreshIndicator(
          onRefresh: _listarPessoas,
          key: _refresh,
          child: loading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            //'http://www.dionebatistap.com.br/login/upload/'
                            BaseUrl.upload + x.image,
                            width: 100.0,
                            height: 100.0,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  x.nomePessoa,
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(x.quantidade),
                                Text(x.nome),
                                Text(x.createdDate),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      EditarPessoa(x, _listarPessoas)));
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              dialogDelete(x.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  }),
        ));
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
          api['quantidade'],
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
