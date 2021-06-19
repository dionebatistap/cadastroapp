import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';

class DetalharPessoa extends StatefulWidget {
  final PessoaModel model;
  DetalharPessoa(this.model);
  @override
  _DetalharPessoaState createState() => _DetalharPessoaState();
}

class _DetalharPessoaState extends State<DetalharPessoa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: widget.model.id,
                  child: Image.network(
                    BaseUrl.upload + widget.model.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 30.0,
              right: 10.0,
              left: 10.0,
              
              child: Column(
                children: <Widget>[
                  Text(widget.model.nomePessoa),
                  Text(widget.model.preco),
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Material(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.circular(10.0),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(
                      "AddCart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
