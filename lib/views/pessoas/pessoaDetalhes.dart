import 'package:cadastroapp/views/pessoas/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:intl/intl.dart';

class PessoaDetalhes extends StatefulWidget {
  final PessoaModel model;
  PessoaDetalhes(this.model);

  @override
  _PessoaDetalhes createState() => _PessoaDetalhes();
}

class _PessoaDetalhes extends State<PessoaDetalhes> {
  String dataformatada = '';
  setupFormato() async {
    String recebeData = widget.model.dataSelecionada;
    //var parsedDate = DateTime.parse(recebeData);
    String convertidaBr =
        new DateFormat.yMd('pt_Br').format(DateTime.parse(recebeData));
    setState(() {
      dataformatada = convertidaBr;
    });

    print(dataformatada);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupFormato();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(widget.model.nomePessoa),
              expandedHeight: MediaQuery.of(context).size.height * 0.45,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  child: Hero(
                    tag: widget.model.id,
                    child: Image.network(
                      BaseUrl.upload + widget.model.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              // top: 15.0,
              // right: 1.0,
              // left: 1.0,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                    child: Column(
                      children: <Widget>[
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Nome: ",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.nomePessoa,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          //margin: EdgeInsets.fromLTRB(1, 3, 1, 1),
                          // margin: EdgeInsets.zero,
                          //clipBehavior: Clip.antiAlias,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Endereço:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.enderecoPessoa +
                                  ', ' +
                                  widget.model.numeroPessoa +
                                  '\nBairro: ' +
                                  widget.model.bairroPessoa +
                                  '\nCidade: ' +
                                  widget.model.cidadePessoa +
                                  '\nCep: ' +
                                  widget.model.cepPessoa,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Celular:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.celularPessoa,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.message),
                              onPressed: () {
                                //_textMe(phoneNumber);
                              },
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Estado Civil:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.estadoCivil,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Cargo:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.membroObreiro,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Data Batismo nas águas:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              dataformatada,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Pastor que batizou:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.prBatizou,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Faz parte de um grupo ?",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.grupoSimNao,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.fromLTRB(5, 3, 3, 3),
                            title: Text(
                              "Grupo:",
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              widget.model.grupo,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
