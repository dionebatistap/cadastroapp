import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class PessoaDetalhes extends StatefulWidget {
  final PessoaModel model;
  PessoaDetalhes(this.model);

  @override
  _PessoaDetalhes createState() => _PessoaDetalhes();
}

class _PessoaDetalhes extends State<PessoaDetalhes> {
  String dataCadastroFormatada = '';
  String dataBatismoformatada = '';
  setupFormato() async {
    String recebeDataBatismo = widget.model.dataSelecionada;
    String dataBatismoConvertidaBr =
        new DateFormat.yMd('pt_Br').format(DateTime.parse(recebeDataBatismo));

    String recebeDataCadastro = widget.model.createdDate;
    String dataCadastroConvertidaBr =
        new DateFormat.yMd('pt_Br').format(DateTime.parse(recebeDataCadastro));

    setState(() {
      dataBatismoformatada = dataBatismoConvertidaBr;
      dataCadastroFormatada = dataCadastroConvertidaBr;
    });
  }

  @override
  void initState() {
    super.initState();
    setupFormato();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return SafeArea(
      child: Scaffold(
        appBar: (AppBar(
          title: Text(widget.model.nomePessoa),
          toolbarHeight: 70,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
          ),
        )),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.45,
                floating: true,
                pinned: false,
                snap: false,
                elevation: 50,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  //title: Text(widget.model.nomePessoa),
                  background: Container(
                    child: Hero(
                      tag: widget.model.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25)),
                        child: Image.network(
                          BaseUrl.upload + widget.model.image,
                          fit: BoxFit.cover,
                        ),
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
                                  color: Colors.black26,
                                  fontSize: 17,
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
                                  color: Colors.black26,
                                  fontSize: 17,
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
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                widget.model.celularPessoa,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'whatsapp') {
                                    whatsappAction(widget.model.celularPessoa);
                                    print("Mensagem");
                                  } else if (value == 'call') {
                                    callAction(widget.model.celularPessoa);
                                    print("Ligar");
                                  } else {
                                    smsAction(widget.model.celularPessoa);
                                    print("Whatsapp");
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: Icon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Colors.green[600],
                                        ),
                                        title: Text('Whatsapp')),
                                    value: 'whatsapp',
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.call,
                                          color: Colors.blueAccent,
                                        ),
                                        title: Text('Ligar')),
                                    value: 'call',
                                  ),
                                  PopupMenuItem(
                                    child: ListTile(
                                        leading: Icon(
                                          Icons.message,
                                          color: Colors.blue[600],
                                        ),
                                        title: Text('Mensagem')),
                                    value: 'message',
                                  ),
                                ],
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
                                  color: Colors.black26,
                                  fontSize: 17,
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
                                  color: Colors.black26,
                                  fontSize: 17,
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
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                dataBatismoformatada,
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
                                  color: Colors.black26,
                                  fontSize: 17,
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
                                "Grupo:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
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
                          Card(
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(5, 3, 3, 3),
                              title: Text(
                                "Data do cadastro:",
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontSize: 17,
                                ),
                              ),
                              subtitle: Text(
                                dataCadastroFormatada,
                                style: TextStyle(
                                  color: Colors.black38,
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
      ),
    );
  }

  callAction(String number) async {
    String url = 'tel:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível $number';
    }
  }

  smsAction(String number) async {
    String url = 'sms:$number';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível enviar sms para $number';
    }
  }

  whatsappAction(String number) async {
    var whatsappUrl = "whatsapp://send?phone=+55$number&text=Olá, tudo bem ?";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      throw 'Não foi possível abrir $whatsappUrl';
    }
  }
}
