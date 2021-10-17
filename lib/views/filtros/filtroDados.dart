import 'dart:convert';
import 'dart:ui';
import 'package:cadastroapp/model/grupoModel.dart';
import 'package:cadastroapp/views/pessoas/pessoaDetalhes.dart';
import 'package:flutter/material.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

class FiltroPage extends StatefulWidget {
  @override
  _FiltroPage createState() => _FiltroPage();
}

//LOGOUT
class _FiltroPage extends State<FiltroPage> {
  //final _key = new GlobalKey<FormState>();
  var loading = false;
  final list = <PessoaModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  List<DropdownMenuItem<String>> _listaItensDropGrupoMembro = [];
  final _carregarApiGrupos = [];
  List _listafiltrarMembros = [];
  String textoGrupo, textoCargo;

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _listarGrupos();
    _listaAddDropGrupos();
    _listarPessoas();
    _carregaItensDropdownMembro();
  }

  Widget appBarTitle = Text("Pesquisar cadastros",
      style: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var tamanho = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          toolbarHeight: 60,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(2, 8, 2, 1),
          child: Column(
            children: [
              Card(
                elevation: 2,
                child: Container(
                  // margin: EdgeInsets.fromLTRB(50, 12, 50, 12),
                  margin: EdgeInsets.fromLTRB(15, 12, 50, 12),
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          validator: (value) => value == null
                              ? 'Por favor selecione uma opção...'
                              : null,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          //decoration:,
                          hint: Text("Selecione pesquisa...",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[500])),
                          items: _listaItensDropGrupo,
                          onChanged: (itemGrupo) {
                            setState(() {
                              textoGrupo = itemGrupo;
                              _listarNomeGrupo();
                            });
                          },
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //const SizedBox(height: 2),
              Card(
                elevation: 2,
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 12, 50, 12),
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Icon(Icons.search, color: Colors.grey[400]),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: DropdownButtonFormField(
                          //value: textoCargo,
                          validator: (value) => value == null
                              ? 'Por favor selecione uma opção...'
                              : null,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          //decoration:,
                          hint: Text("Selecione pesquisa...",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[500])),
                          items: _listaItensDropGrupoMembro,
                          onChanged: (itemObreiroMembro) {
                            setState(() {
                              textoCargo =
                                  itemObreiroMembro.toString().toLowerCase();
                            });
                          },
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _filtrarMembros();
                    },
                    label: Text(
                      "Pesquisar",
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    ),
                    icon: Icon(
                      Icons.search,
                      size: 15,
                      color: Colors.grey[800],
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        textoCargo = '';
                        textoGrupo = '';
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.widget));
                      });
                    },
                    label: Text(
                      "Limpar",
                      style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                    ),
                    icon: Icon(
                      Icons.clear_sharp,
                      size: 15,
                      color: Colors.red[600],
                    ),
                  ),
                ],
              ),
              Divider(),
              // Container(
              //   height: 5,
              // ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _listarPessoas,
                  key: _refresh,
                  child: loading
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  radiusOnly(topLeft: 10, topRight: 10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey[200],
                                    blurRadius: 1,
                                    spreadRadius: 1),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: _listafiltrarMembros.isNotEmpty &&
                                    verDados != 'inativo'
                                ? ListView.builder(
                                    itemCount: _listafiltrarMembros.length,
                                    itemBuilder: (context, i) {
                                      final x = _listafiltrarMembros[i];
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold)),
                                        subtitle: Text(x.celularPessoa),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      PessoaDetalhes(x)));
                                        },
                                      );
                                    },
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                ),
              ),
              _listafiltrarMembros.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: radiusOnly(topLeft: 2, topRight: 2),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey[200],
                                blurRadius: 1,
                                spreadRadius: 1),
                          ]),
                      height: tamanho.size.height * 0.06,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Divider(),
                          Container(
                            margin: EdgeInsets.fromLTRB(8, 8, 20, 8),
                            child: Text(
                              textoInforma.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                          ),
                          Container(
                            // margin: EdgeInsets.fromLTRB(15, 12, 50, 12),
                            child: Text(
                              contador.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

/*METODOS*/

  String verDados;
  getPref() async {
    String statusUserPref;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      statusUserPref = preferences.getString("statusUser");
      verDados = statusUserPref;
    });
  }

  Future<void> _listarPessoas() async {
    contador = 0;
    list.clear();
    _listafiltrarMembros.clear();
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
          //atualização 25-09
          api['isRgRegularizado'],
          api['isTituloRegularizado'],
          api['primeiraDose'],
          api['segundaDose'],
          api['pesquisaArimateia'],
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
        _listafiltrarMembros.add(ab);
        setState(() {
          contador = contador + 1;
        });
      });

      if (!mounted) return;
      setState(() {
        loading = false;
        textoInforma = 'Total geral CADASTRADO:';
      });
    }
  }

  int contador = 0;
  String textoInforma = '';
  String textoImpressao = '';
  Future<void> _filtrarMembros() async {
    if ((textoGrupo.isEmptyOrNull) && (textoCargo.isEmptyOrNull)) {
      toast("Nada para pesquisar");
      return;
    } else if ((!textoGrupo.isEmptyOrNull) && (textoCargo.isEmptyOrNull)) {
      contador = 0;
      _listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.idGrupo.toLowerCase()).contains(textoGrupo)) {
            _listafiltrarMembros.add(ab);
            setState(() {
              contador++;
            });
          } else {
            return;
          }
        },
      ); //fimListaLogica
      setState(() {
        if (textoImpressao.toLowerCase() != 'sem grupo') {
          textoInforma = 'Total geral grupo $textoImpressao :';
        } else {
          textoInforma = 'Total geral $textoImpressao :';
        }
      });
    } else if ((textoGrupo.isEmptyOrNull) && (!textoCargo.isEmptyOrNull)) {
      contador = 0;
      _listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.membroObreiro.toLowerCase()).contains(textoCargo)) {
            _listafiltrarMembros.add(ab);
            setState(() {
              contador = contador + 1;
            });
          } else {
            return;
          }
        },
      );
      setState(() {
        textoInforma = 'Total $textoCargo(s) :';
      }); //fimListaLogica
    } else if ((!textoGrupo.isEmptyOrNull) && (!textoCargo.isEmptyOrNull)) {
      contador = 0;
      _listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.idGrupo.toLowerCase()).contains(textoGrupo) &&
              (ab.membroObreiro.toLowerCase()).contains(textoCargo)) {
            _listafiltrarMembros.add(ab);
            setState(() {
              contador = contador + 1;
            });
          } else {
            return;
          }
        },
      );
      setState(() {
        if (textoGrupo != 'sem grupo') {
          textoInforma = 'TOTAL DE $textoCargo(S) GRUPO $textoImpressao:';
        } else {
          textoInforma = 'TOTAL DE $textoCargo(S) $textoGrupo:';
        }
      });
    }
    setState(() {});
  }

  List<DropdownMenuItem<String>> _listaItensDropGrupo = [];
  final listGrupos = <GrupoModel>[];
  Future<void> _listarGrupos() async {
    listGrupos.clear();
    if (!mounted) return;
    setState(() {
      //  loading = true;
    });
    var url = Uri.parse(BaseUrl.listarGrupos);
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new GrupoModel(
          api['id'],
          api['nomeGrupo'],
        );
        listGrupos.add(ab);
      });
      if (!mounted) return;
      setState(() {
        _listaAddDropGrupos();
      });
    }
  }

  Future<void> _listaAddDropGrupos() async {
    setState(() {
      for (int i = 0; i < listGrupos.length; i++) {
        _carregarApiGrupos.add(listGrupos[i].nomeGrupo);
        _listaItensDropGrupo.add(
          DropdownMenuItem(
              child: Text(listGrupos[i].nomeGrupo,
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
              value: listGrupos[i].id),
        );
      }
    });

//DROPDOWN LIST GRUPOS
  }

  Future<void> _carregaItensDropdownMembro() async {
    _listaItensDropGrupoMembro.add(
      DropdownMenuItem(
          child: Text("Membro",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "Membro"),
    );
    _listaItensDropGrupoMembro.add(
      DropdownMenuItem(
          child: Text("Obreiro",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "Obreiro"),
    );
  }

  final listNomeGrupos = <GrupoModel>[];
  Future<void> _listarNomeGrupo() async {
    listNomeGrupos.clear();
    var url = Uri.parse(BaseUrl.listarGrupos);
    final response = await http.get(url);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = new GrupoModel(
          api['id'],
          api['nomeGrupo'],
        );
        if (api['id'] == (textoGrupo)) {
          setState(() {
            listNomeGrupos.add(ab);
            textoImpressao = listNomeGrupos[0].nomeGrupo;
          });
        }
      });
    }
  }
} //CLASS
