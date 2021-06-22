import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:http/http.dart' as http;
import 'package:cadastroapp/views/pessoas/detalharPessoa.dart';

class MenuUsuarios extends StatefulWidget {
  final VoidCallback signOut;
  MenuUsuarios(this.signOut);
  @override
  _MenuUsuariosState createState() => _MenuUsuariosState();
}

class _MenuUsuariosState extends State<MenuUsuarios> {
  var loading = false;
  final list = <PessoaModel>[];
  // ignore: unused_field
  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _listarData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                widget.signOut();
              });
            },
            icon: Icon(Icons.lock_open),
          ),
        ],
      ),
      body: Container(child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetalharPessoa(x)));
                  },
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Hero(
                            tag: x.id,
                            child: Image.network(
                              BaseUrl.upload + x.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Text(
                          x.nomePessoa,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      )),
    );
  }

  Future<void> _listarData() async {
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
          api['grupoSimNao'],
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
}
