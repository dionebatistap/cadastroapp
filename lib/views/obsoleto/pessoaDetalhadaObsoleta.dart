import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';

class PessoaDetalhada extends StatefulWidget {
  final PessoaModel model;
  PessoaDetalhada(this.model);

  @override
  _PessoaDetalhadaState createState() => _PessoaDetalhadaState();
}

class _PessoaDetalhadaState extends State<PessoaDetalhada> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.nomePessoa),
      ),
      body:

//CONTAINER FOTO
          SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    image: DecorationImage(
                        image:
                            NetworkImage(BaseUrl.upload + widget.model.image),
                        fit: BoxFit.cover)),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.40,
              ),

//FIM CONTAINER FOTO
              Padding(
                padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        dense: true,
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
                        title: Text(
                          "Data Batismo nas águas:",
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          widget.model.dataSelecionada,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
                        contentPadding: const EdgeInsets.fromLTRB(5, 3, 3, 3),
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
//fimPadding
            ],
          ),
        ),
      ),
    );
  }
}
