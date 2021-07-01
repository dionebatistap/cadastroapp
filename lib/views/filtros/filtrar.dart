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
  final _key = new GlobalKey<FormState>();
  var loading = false;
  final list = <PessoaModel>[];

  final GlobalKey<RefreshIndicatorState> _refresh =
      GlobalKey<RefreshIndicatorState>();

  List<DropdownMenuItem<String>> _listaItensDropGrupoMembro = [];

  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    _listarPessoas();
    _listarGrupos();
    _listaAddDropGrupos();
    _carregaItensDropdownMembro();
    super.initState();
  }

  String textoGrupo;
  String textoCargo;

  Widget appBarTitle = Text("Tela de Filtros",
      style: TextStyle(
          fontWeight: FontWeight.normal, color: Colors.black, fontSize: 18));
  Icon actionIcon = Icon(Icons.search, color: Colors.white);

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
                        // _filtrarMembros(textoPesquisa.toLowerCase());
                        print("aqui" + contador.toString());
                      });
                    },
                    style: TextStyle(color: textPrimaryColor, fontSize: 20),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      hintText: "Localizar...",
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[500]),
                    ),
                  );
                  setState(() {});
                } else {
                  setState(() {
                    _listarPessoas();
                    this.actionIcon = Icon(Icons.search, color: Colors.black);
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
        body: Padding(
          padding: EdgeInsets.fromLTRB(2, 15, 2, 5),
          child: Column(
            children: [
              Container(
                height: tamanho.size.height * 0.08,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey[700]),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.grey[100],
                  //border: Border.fromBorderSide(),
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        validator: (value) => value == null
                            ? 'Por favor selecione uma opção...'
                            : null,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //decoration:,
                        hint: Text("Selecione o grupo...",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700])),
                        items: _listaItensDropGrupo,
                        onChanged: (itemGrupo) {
                          setState(() {
                            textoGrupo = itemGrupo.toString().toLowerCase();
                          });
                        },
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: tamanho.size.height * 0.08,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey[700]),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.grey[100],
                  //border: Border.fromBorderSide(),
                ),
                padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: DropdownButtonFormField(
                        //value: textoCargo,
                        validator: (value) => value == null
                            ? 'Por favor selecione uma opção...'
                            : null,
                        decoration: InputDecoration.collapsed(hintText: ''),
                        //decoration:,
                        hint: Text("Membro ou obreiro...",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[700])),
                        items: _listaItensDropGrupoMembro,
                        onChanged: (itemObreiroMembro) {
                          setState(() {
                            textoCargo =
                                itemObreiroMembro.toString().toLowerCase();
                          });
                        },
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _filtrarMembros();
                    },
                    child: Text(
                      "Pesquisar",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        textoCargo = '';
                        textoGrupo = '';
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    this.widget));
                        //print("pressionado");
                      });
                    },
                    child: Text(
                      "Limpar",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
              Divider(),
              Container(
                height: 30,
              ),
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
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: listafiltrarMembros.isNotEmpty
                                ? ListView.builder(
                                    itemCount: listafiltrarMembros.length,
                                    itemBuilder: (context, i) {
                                      final x = listafiltrarMembros[i];
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
              Container(
                  height: tamanho.size.height * 0.05,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Divider(),
                      Text(textoInforma.toUpperCase()),
                      Text(contador.toString()),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

/*METODOS*/

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
        listafiltrarMembros.add(ab);
        setState(() {
          contador = contador + 1;
        });
      });

      if (!mounted) return;
      setState(() {
        loading = false;
        textoInforma = 'Total geral:';
      });
    }
  }

  List listafiltrarMembros = [];

  int contador = 0;
  String textoInforma = '';
  Future<void> _filtrarMembros() async {
    if ((textoGrupo.isEmptyOrNull) && (textoCargo.isEmptyOrNull)) {
      // print("Texto grupo é cargo igual nulo ou vazio, não faz nada");
      // print("Texto grupo $textoGrupo");
      // print("Texto cargo $textoCargo");
      toast("Nada para pesquisar");
      return;
    } else if ((!textoGrupo.isEmptyOrNull) && (textoCargo.isEmptyOrNull)) {
      // print("Texto grupo não é nulo ou vazio: $textoGrupo");
      // print("Texto cargo $textoCargo");
      print("Texto grupo $textoGrupo");
      contador = 0;
      listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.grupo.toLowerCase()).contains(textoGrupo)) {
            listafiltrarMembros.add(ab);
            setState(() {
              contador++;
            });
          } else {
            print("nada");
          }
        },
      ); //fimListaLogica

      setState(() {
        textoInforma = 'Total $textoGrupo:';
      });
    } else if ((textoGrupo.isEmptyOrNull) && (!textoCargo.isEmptyOrNull)) {
      // print("Texto cargo não é nulo ou vazio: $textoCargo");
      // print("Texto grupo $textoGrupo");
      print("Texto cargo $textoCargo");
      contador = 0;
      listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.membroObreiro.toLowerCase()).contains(textoCargo)) {
            listafiltrarMembros.add(ab);
            setState(() {
              contador = contador + 1;
            });
          } else {
            print("nada");
          }
        },
      );
      setState(() {
        textoInforma = 'Total $textoGrupo:';
      }); //fimListaLogica
    } else if ((!textoGrupo.isEmptyOrNull) && (!textoCargo.isEmptyOrNull)) {
      print("Texto grupo $textoGrupo");
      print("Texto cargo $textoCargo");
      contador = 0;
      listafiltrarMembros.clear();
      list.forEach(
        (ab) {
          if ((ab.grupo.toLowerCase()).contains(textoGrupo) &&
              (ab.membroObreiro.toLowerCase()).contains(textoCargo)) {
            listafiltrarMembros.add(ab);
            setState(() {
              contador = contador + 1;
            });
          } else {
            print("nada");
          }
        },
      );
    }

    // listafiltrarMembros.clear();
    // list.forEach((ab) {
    //   if ((textoGrupo.isEmptyOrNull) && (textoCargo.isEmptyOrNull)) {
    //     print("Os dois estão vazios e nulos: não faz nada!");
    //   }
    //   setState(() {});
    // },
    // );

    // //CODIGO CORRETO
    // // list.forEach(
    // //   (ab) {
    // //     if ((ab.grupo.toLowerCase()).contains(textoGrupo) ||
    // //         (ab.membroObreiro.toLowerCase()).contains(textoGrupo)) {
    // //       listafiltrarMembros.add(ab);
    // //       setState(() {
    // //         contador = contador + 1;
    // //         print(contador);
    // //       });
    // //     } else {
    // //       setState(() {});
    // //     }
    // //   },
    // // );
    setState(() {});
  }

  List listaEstatica = [];

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
        //loading = false;
        _listaAddDropGrupos();
      });
    }
  }

  final _carregarApiGrupos = [];
  Future<void> _listaAddDropGrupos() async {
    setState(() {
      for (int i = 0; i < listGrupos.length; i++) {
        _carregarApiGrupos.add(listGrupos[i].nomeGrupo);
        _listaItensDropGrupo.add(
          DropdownMenuItem(
              child: Text(listGrupos[i].nomeGrupo,
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
              value: listGrupos[i].nomeGrupo),
        );
      }
    });

//DROPDOWN LIST GRUPOS
  }

  _carregaItensDropdownMembro() {
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

//limpa

} //CLASS
