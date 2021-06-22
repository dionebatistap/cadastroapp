import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class InserirPessoa extends StatefulWidget {
  final VoidCallback reload;
  InserirPessoa(this.reload);

  @override
  _InserirPessoaState createState() => _InserirPessoaState();
}

class _InserirPessoaState extends State<InserirPessoa> {
  String nomePessoa, quantidade, estadoCivil, grupo, idUsuario;

  final _key = new GlobalKey<FormState>();
  var validarCampos = true;
  File _imageFile;
  final picker = ImagePicker();

  //VARIAVEIS RADIO BUTTONS
  String clestadoCivil = "Casado";
  String clMembroObreiro = "Obreiro";
  String grupoSimNao = "Sim";

  //VARIAVEIS DROPDOWN
  String clgrupo;

//DADOS PESSOAIS
  final TextEditingController nomeController =
      TextEditingController(text: "Dione Batista Pereira");
  final TextEditingController celularController =
      TextEditingController(text: "19983975315");

//ENDEREÇO CONTROLLERS
  final TextEditingController enderecoController =
      TextEditingController(text: "Rua Visconde de Cairu");
  final TextEditingController numeroController =
      TextEditingController(text: "139");
  final TextEditingController bairroController =
      TextEditingController(text: "Jardim Vela Vista");
  final TextEditingController cepController =
      TextEditingController(text: "13276280");
  final TextEditingController cidadeController =
      TextEditingController(text: "Valinhos");

//DADOS ESPIRITUAIS
  final TextEditingController prBatizouController =
      TextEditingController(text: "Pr. Leonardo");

  //VARIAVEIS DATAPICKER
  String selecionaData, labelText;
  DateTime variavelData = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 16.0);

  @override
  void initState() {
    super.initState();
    getPref();
    _carregaItensDropdown();
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Form(
              //autovalidate: validarCampos,
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  //padding: EdgeInsets.all(16.0),
                  //padding: EdgeInsets.fromLTRB(14, 1, 14.0, 14.0),
                  children: <Widget>[
//CONTAINER DA FOTO
                    Container(
                      child: InkWell(
                        onTap: () {
                          displayBottomSheet(context);
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 300.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: _imageFile == null
                                      ? AssetImage('./images/placeholder.png')
                                      : FileImage(File(_imageFile.path)),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /*inicio*/
                    SizedBox(
                      height: 1,
                    ),

//CONTAINER DOS FORMULARIOS
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 5,
                                      spreadRadius: 2)
                                ]),
                            child: Column(
                              children: <Widget>[
//FORMUALARIO DE TEXTO NOME
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText:
                                        'Por favor, iserir nome completo.',
                                    labelText: 'Nome*',
                                  ),
                                  controller: nomeController,
                                ),
                                const SizedBox(height: 5.0),

//FORMUALARIO DE TEXTO ENDEREÇO
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Rua, Avenida...',
                                    labelText: 'Endereço*',
                                  ),
                                  controller: enderecoController,
                                ),
                                const SizedBox(height: 5.0),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          filled: true,
                                          //icon: Icon(Icons.person),
                                          hintText: 'nº',
                                          labelText: 'Número*',
                                        ),
                                        controller: numeroController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          filled: true,
                                          //icon: Icon(Icons.person),
                                          hintText: 'Bairro',
                                          labelText: 'Bairro*',
                                        ),
                                        controller: bairroController,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),
//DADOS
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: TextFormField(
                                        maxLength: 8,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          border: UnderlineInputBorder(),
                                          filled: true,
                                          //icon: Icon(Icons.person),
                                          hintText: '00000-000',
                                          labelText: 'CEP*',
                                          suffixIcon: IconButton(
                                            onPressed: recuperaCep,
                                            icon: Icon(Icons.search),
                                            //onPressed: _recuperaCep,
                                          ),
                                          counterText: '',
                                          counterStyle: TextStyle(fontSize: 0),
                                        ),
                                        controller: cepController,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: const InputDecoration(
                                          border: UnderlineInputBorder(),
                                          filled: true,
                                          //icon: Icon(Icons.person),
                                          hintText: 'Cidade',
                                          labelText: 'Cidade*',
                                        ),
                                        controller: cidadeController,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5.0),

//FORMUALARIO DE TEXTO NOME
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'nº cel.',
                                    labelText: 'Celular*',
                                  ),
                                  controller: celularController,
                                ),
                                const SizedBox(height: 5.0),

//FORMULARIO RADIO BUTTON
                                Row(children: <Widget>[
                                  Text("Estado civil:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800],
                                        width: 1.0,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    55,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 5,
                                      ),
                                      Text("Solteiro",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Solteiro",
                                        groupValue: clestadoCivil,
                                        onChanged:
                                            (String selecionaEstadoCivil) {
                                          setState(() {
                                            clestadoCivil =
                                                selecionaEstadoCivil;
                                          });
                                        },
                                      ),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Text("Casado",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Casado",
                                        groupValue: clestadoCivil,
                                        onChanged:
                                            (String selecionaEstadoCivil) {
                                          setState(() {
                                            clestadoCivil =
                                                selecionaEstadoCivil;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),
//INFORMAÇÕES ESPIRITUAL
                                Column(
                                  children: [Divider()],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Informação espiritual",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ]),

                                Column(
                                  children: [Divider()],
                                ),
                                const SizedBox(height: 5.0),

//MEMBRO OU OBREIRO
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800],
                                        width: 1.0,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    55,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 5,
                                      ),
                                      Text("Obreiro",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Obreiro",
                                        groupValue: clMembroObreiro,
                                        onChanged:
                                            (String selecionaMembroObreiro) {
                                          setState(() {
                                            clMembroObreiro =
                                                selecionaMembroObreiro;
                                          });
                                        },
                                      ),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Text("Membro",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Membro",
                                        groupValue: clMembroObreiro,
                                        onChanged:
                                            (String selecionaMembroObreiro) {
                                          setState(() {
                                            clMembroObreiro =
                                                selecionaMembroObreiro;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),

//FORMUALARIO DE DATA DO BATISMO
                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 30, 0),
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800],
                                        width: 1.1,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  child: DateDropDown(
                                    labelText: labelText,
                                    valueText: new DateFormat.yMd()
                                        .format(variavelData),
                                    valueStyle: valueStyle,
                                    onPressed: () {
                                      _selectedDate(context);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8.0),

//FORMUALARIO DE TEXTO PASTOR QUE BATIZOU
                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Nome do pastor que batizou.',
                                    labelText: 'Pastor que batizou*',
                                  ),
                                  controller: prBatizouController,
                                ),
                                const SizedBox(height: 5.0),

//FORMULARIO RADIO BUTTON grupo sim ou não
                                Row(children: <Widget>[
                                  Text("Faz parte de algum grupo:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                const SizedBox(height: 1.0),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800],
                                        width: 1.0,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    55,
                                    0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Spacer(
                                        flex: 5,
                                      ),
                                      Text("Sim",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Sim",
                                        groupValue: grupoSimNao,
                                        onChanged:
                                            (String selecionaGrupoSimNao) {
                                          setState(() {
                                            grupoSimNao = selecionaGrupoSimNao;
                                            print(grupoSimNao);
                                          });
                                        },
                                      ),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Text("Não",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Nao",
                                        groupValue: grupoSimNao,
                                        onChanged:
                                            (String selecionaGrupoSimNao) {
                                          setState(() {
                                            grupoSimNao = selecionaGrupoSimNao;
                                            print(prBatizouController.text);
                                          });
                                          print(grupoSimNao);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),

// SELECIONAR GRUPO QUE PERTENCE
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[800],
                                        width: 1.1,
                                      ),
                                    ),
                                    color: Colors.grey[200],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration.collapsed(
                                              hintText: ''),
                                          //decoration:,
                                          hint: Text("Selecione o grupo..."),
                                          items: _listaItensDropGrupo,
                                          onChanged: (itemGrupo) {
                                            setState(() {
                                              clgrupo = itemGrupo;

                                              print("Nome: " +
                                                  nomeController.text);
                                              print("Endereço: " +
                                                  enderecoController.text);
                                              print("Numero: " +
                                                  numeroController.text);
                                              print("Bairro: " +
                                                  bairroController.text);
                                              print(
                                                  "Cep: " + cepController.text);
                                              print("Cidade: " +
                                                  cidadeController.text);
                                              print("Estado Civil: " +
                                                  clestadoCivil);
                                              print(
                                                  "Cargo: " + clMembroObreiro);
                                              print("Data Batismo: " +
                                                  variavelData.toString());
                                              print("Pr Que batizou: " +
                                                  prBatizouController.text);
                                              print("Faz parte grupo? : " +
                                                  grupoSimNao);
                                              print("Que grupo: " + clgrupo);
                                            });
                                          },
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  child: ElevatedButton(
                                    child: Text("Salvar"),
                                    onPressed: () {
                                      check();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green[400],
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 50, vertical: 10),
                                      textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                //FORMATAÇÃO
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
          },
        ),
      ),
    );
  }

/* METODOS */

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = preferences.getString("id");
    });
  }

  Future obterImagemCamera() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        Navigator.pop(context);
      });
    } else {
      return;
    }
  }

  Future obterImagemGaleria() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
        Navigator.pop(context);
      });
    } else {
      return;
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      submterComFoto();
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      submterSemFoto();
    } else {
      setState(() {
        validarCampos = true;
      });
    }
  }

  submterSemFoto() async {
    var url = Uri.parse(BaseUrl.inserirPessoaSemFoto);
    final response = await http.post(url, body: {
      "nomePessoa": "Sem Foto",
      "enderecoPessoa": "Rua Classe Sem fotos",
      "numeroPessoa": "139",
      "bairroPessoa": "Jd Sem Foto",
      "cepPessoa": "13276280",
      "cidadePessoa": "Sem Foto",
      "celularPessoa": "(19)98397-5315",
      "membroObreiro": "Membro",
      "prBatizou": "Pr Sem Foto",
      "grupoSimNao": "Sim",
      "estadoCivil": "$clestadoCivil",
      "grupo": "Valor Teste Sem Foto",
      "idUsuario": idUsuario,
      "dataSelecionada": "$variavelData",
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String aviso = data['message'];
    if (value == 1) {
      print(aviso);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    } else {
      print(aviso);
      print(print);
    }
  }

  submterComFoto() async {
    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();

      var uri = Uri.parse(BaseUrl.inserirPessoaComFoto);
      var request = http.MultipartRequest('POST', uri);

      request.fields['nomePessoa'] = "Com foto";
      request.fields['enderecoPessoa'] = "Rua Classe com Foto";
      request.fields['numeroPessoa'] = "139";
      request.fields['bairroPessoa'] = "Jd Com foto";
      request.fields['cepPessoa'] = "13270000";
      request.fields['cidadePessoa'] = "Com Foto";
      request.fields['celularPessoa'] = "(19)98397-5315";
      request.fields['membroObreiro'] = "Membro";
      request.fields['prBatizou'] = "Pr Com Foto";
      request.fields['grupoSimNao'] = "Não";
      request.fields['estadoCivil'] = "$clestadoCivil";
      request.fields['grupo'] = "Teste Com Foto";
      request.fields['idUsuario'] = idUsuario;
      request.fields['dataSelecionada'] = "$variavelData";

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));

      var response = await request.send();
      if (response.statusCode > 2) {
        print("Imagem carregada");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("Falha ao carregar imagem");
      }
    } catch (e) {
      debugPrint("Erro $e");
      print("AQUI");
    }
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: variavelData,
        firstDate: DateTime(1992),
        lastDate: DateTime(2099));
    if (picked != null && picked != variavelData) {
      setState(() {
        variavelData = picked;
        selecionaData = new DateFormat.yMd().format(variavelData);
      });
    } else {}
  }

  Future recuperaCep() async {
    final int ok = 200;
    final int badRequest = 400;

    String cep = cepController.text;

    String baseUrl = 'https://viacep.com.br/ws/';
    String cepDigitado = '$cep';
    String tiporetorno = '/json/';
    final uri = Uri.parse('$baseUrl/$cepDigitado/$tiporetorno');
    http.Response response;
    response = await http.get(uri);
    print(response.body);

    if (response.statusCode == ok) {
      Map<String, dynamic> retorno = json.decode(response.body);
      String enderecoAPI = retorno["logradouro"];
      String cidadeAPI = retorno["localidade"];
      String bairroAPI = retorno["bairro"];
      setState(() {
        enderecoController.text = enderecoAPI;
        cidadeController.text = cidadeAPI;
        bairroController.text = bairroAPI;
      });
    } else if (response.statusCode == badRequest) {
      print("Errado");
    }
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  this.obterImagemCamera();
                },
                child: const Text('Câmera'),
              ),
              TextButton(
                onPressed: () {
                  this.obterImagemGaleria();
                },
                child: const Text('Galeria'),
              ),
            ],
          ));
        });
  }

//DROPDOWN LIST GRUPOS
  List<DropdownMenuItem<String>> _listaItensDropGrupo = [];
  _carregaItensDropdown() {
    _listaItensDropGrupo.add(
      DropdownMenuItem(child: Text("FJU"), value: "FJU"),
    );
    _listaItensDropGrupo.add(
      DropdownMenuItem(child: Text("EVG"), value: "EVG"),
    );
  }
}
