import 'dart:convert';
import 'dart:io';

import 'package:cadastroapp/model/grupoModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class EditarPessoa extends StatefulWidget {
  final PessoaModel model;
  final VoidCallback reload;
  EditarPessoa(this.model, this.reload);

  @override
  _EditarPessoaState createState() => _EditarPessoaState();
}

class _EditarPessoaState extends State<EditarPessoa> {
  final _key = new GlobalKey<FormState>();
  String idUsuario;
  File _imageFile;
  final picker = ImagePicker();

  //DADOS PESSOAIS
  TextEditingController nomeController = TextEditingController();
  //DADOS PESSOAIS
  TextEditingController celularController = TextEditingController();
//ENDEREÇO CONTROLLERS
  TextEditingController enderecoController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
//DADOS ESPIRITUAIS
  TextEditingController prBatizouController = TextEditingController();

//VARIAVEIS RADIO BUTTONS
  String clestadoCivil;
  String clMembroObreiro;
  String isBatizada;
  //VARIAVEIS DROPDOWN
  String itemGrupoSelecionado;
  String clgrupo;
  //VARIAVEIS DATAPICKER
  String vardata, dataFormatada;
  String selecionaData, labelText;
  DateTime variavelData = new DateTime.now();
  var formatarData = new DateFormat('yyyy-MM-dd');
  final TextStyle valueStyle = TextStyle(fontSize: 14.0);

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = preferences.getString("id");
    });
//CONVERTER DATA
    vardata = widget.model.dataSelecionada;
    String convertidaBr =
        new DateFormat.yMd('pt_Br').format(DateTime.parse(vardata));
//FIM CONVERTER DATA
    nomeController = TextEditingController(text: widget.model.nomePessoa);
    celularController = TextEditingController(text: widget.model.celularPessoa);
    numeroController = TextEditingController(text: widget.model.numeroPessoa);
    bairroController = TextEditingController(text: widget.model.bairroPessoa);
    cepController = TextEditingController(text: widget.model.cepPessoa);
    cidadeController = TextEditingController(text: widget.model.cidadePessoa);
    prBatizouController = TextEditingController(text: widget.model.prBatizou);
    enderecoController =
        TextEditingController(text: widget.model.enderecoPessoa);
    clestadoCivil = widget.model.estadoCivil;
    clMembroObreiro = widget.model.membroObreiro;
    clgrupo = widget.model.grupo;
    itemGrupoSelecionado = widget.model.grupo;
    isBatizada = widget.model.isBatizada;
    setState(() {
      dataFormatada = convertidaBr;
    });
  }

  //FORMATADORES
  var formataCelular = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  var formataCep = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    _listarGrupos();
    _listaAddDropGrupos();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var tamanho = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Cadastro"),
        toolbarHeight: 70,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
        ),
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: _imageFile == null
                    ? Container(
                        width: tamanho.size.width,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(
                                    BaseUrl.upload + widget.model.image),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 0,
                                  spreadRadius: 2),
                            ]),
                        child: InkWell(
                          onTap: () {
                            displayBottomSheet(context);
                          },
                        ),
                      )
                    : Container(
                        width: tamanho.size.width,
                        height: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: FileImage(File(_imageFile.path)),
                                fit: BoxFit.cover),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey[200],
                                  blurRadius: 0,
                                  spreadRadius: 2),
                            ]),
                        child: InkWell(
                          onTap: () {
                            displayBottomSheet(context);
                          },
                        ),
                      ),
              ),
              const SizedBox(
                height: 3,
              ),
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
                                blurRadius: 0,
                                spreadRadius: 3),
                          ]),
                      child: Column(
                        children: <Widget>[
//nome
                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              //icon: Icon(Icons.person),
                              hintText: 'Por favor, iserir nome completo.',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  textCapitalization: TextCapitalization.words,
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

                          TextFormField(
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              filled: true,
                              //icon: Icon(Icons.person),
                              hintText: 'Cidade',
                              labelText: '*Cidade',
                            ),
                            controller: cidadeController,
                          ),

                          const SizedBox(height: 5.0),

                          TextFormField(
                            inputFormatters: [formataCep],
                            maxLength: 9,
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
//DADOS
                          const SizedBox(height: 5.0),

                          //FORMUALARIO DE TEXTO
                          TextFormField(
                            inputFormatters: [formataCelular],
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
                                    fontSize: 15, color: Colors.grey[700])),
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
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Solteiro",
                                  groupValue: clestadoCivil,
                                  onChanged: (String selecionaEstadoCivil) {
                                    setState(() {
                                      clestadoCivil = selecionaEstadoCivil;
                                    });
                                  },
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                                Text("Casado",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Casado",
                                  groupValue: clestadoCivil,
                                  onChanged: (String selecionaEstadoCivil) {
                                    setState(() {
                                      clestadoCivil = selecionaEstadoCivil;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 5.0),
//INFORMAÇÕES ESPIRITUAL
                          Divider(),
                          Text("Informação espiritual",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[700])),
                          Divider(),
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
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Obreiro",
                                  groupValue: clMembroObreiro,
                                  onChanged: (String selecionaMembroObreiro) {
                                    setState(() {
                                      clMembroObreiro = selecionaMembroObreiro;
                                    });
                                  },
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                                Text("Membro",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Membro",
                                  groupValue: clMembroObreiro,
                                  onChanged: (String selecionaMembroObreiro) {
                                    setState(() {
                                      clMembroObreiro = selecionaMembroObreiro;
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
                              valueText: dataFormatada,
                              valueStyle: valueStyle,
                              onPressed: () {
                                _selectedDate(context);
                              },
                            ),
                          ),
                          const SizedBox(height: 8.0),
//BATIZADO NAS AGUAS
                          Row(children: <Widget>[
                            Text("Batizado nas águas:",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700])),
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
                                Text("Sim",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Sim",
                                  groupValue: isBatizada,
                                  onChanged: (String selecionaIsBatizado) {
                                    setState(() {
                                      isBatizada = selecionaIsBatizado;
                                    });
                                  },
                                ),
                                Spacer(
                                  flex: 3,
                                ),
                                Text("Não",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700])),
                                Radio(
                                  value: "Não",
                                  groupValue: isBatizada,
                                  onChanged: (String selecionaIsBatizado) {
                                    setState(() {
                                      isBatizada = selecionaIsBatizado;
                                    });
                                  },
                                ),
                              ],
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
                                    fontSize: 15, color: Colors.grey[700])),
                          ]),
                          const SizedBox(height: 2.0),
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
                                    validator: (value) => value == null
                                        ? 'Por favor selecione uma opção'
                                        : null,
                                    decoration:
                                        InputDecoration.collapsed(hintText: ''),
                                    hint: Text(
                                      "Selecione o grupo...",
                                    ),
                                    value: itemGrupoSelecionado,
                                    items: _listaItensDropGrupo,
                                    onChanged: (itemGrupo) {
                                      setState(
                                        () {
                                          clgrupo = itemGrupo;
                                        },
                                      );
                                    },
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[700]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            elevation: 3.0,
                            color: Colors.grey[300],
                            clipBehavior: Clip.antiAlias,
                            child: MaterialButton(
                              splashColor: Colors.grey[400],
                              focusColor: Colors.grey[400],
                              hoverColor: Colors.grey[400],
                              highlightColor: Colors.grey[400],
                              minWidth: 200.0,
                              height: 35,
                              onPressed: () {
                                dialogEditarPessoa();
                              },
                              child: Text("Salvar",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[700])),
                            ),
                          ),
                          const SizedBox(height: 15.0),
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

/* METODOS */

  editarPessoaSemFoto() async {
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String celular = celularController.text;
    String pastorBatizou = prBatizouController.text;
    if (cep.isEmptyOrNull) {
      cep = '00000-000';
    }
    try {
      var url = Uri.parse(BaseUrl.editarPessoaSemFoto);
      final response = await http.post(url, body: {
        "nomePessoa": "$nome",
        "enderecoPessoa": "$endereco",
        "numeroPessoa": "$numero",
        "bairroPessoa": "$bairro",
        "cepPessoa": "$cep",
        "cidadePessoa": "$cidade",
        "celularPessoa": "$celular",
        "membroObreiro": "$clMembroObreiro",
        "prBatizou": "$pastorBatizou",
        "estadoCivil": "$clestadoCivil",
        "grupo": "$clgrupo",
        "isBatizada": "$isBatizada",
        "idUsuario": idUsuario,
        "idPessoa": widget.model.id,
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
      } else {}
    } catch (e) {
      debugPrint("Erro $e");
      print("AQUI");
    }
  }

  editarPessoaComFoto() async {
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String celular = celularController.text;
    String pastorBatizou = prBatizouController.text;
    if (cep.isEmptyOrNull) {
      cep = '00000-000';
    }

    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();

      var uri = Uri.parse(BaseUrl.editarPessoaComFoto);
      var request = http.MultipartRequest('POST', uri);

      request.fields['nomePessoa'] = "$nome";
      request.fields['enderecoPessoa'] = "$endereco";
      request.fields['numeroPessoa'] = "$numero";
      request.fields['bairroPessoa'] = "$bairro";
      request.fields['cepPessoa'] = "$cep";
      request.fields['cidadePessoa'] = "$cidade";
      request.fields['celularPessoa'] = "$celular";
      request.fields['membroObreiro'] = "$clMembroObreiro";
      request.fields['prBatizou'] = "$pastorBatizou";
      request.fields['estadoCivil'] = "$clestadoCivil";
      request.fields['grupo'] = "$clgrupo";
      request.fields['isBatizada'] = "$isBatizada";
      request.fields['idUsuario'] = idUsuario;
      request.fields['idPessoa'] = widget.model.id;
      request.fields['dataSelecionada'] = "$variavelData";
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));
      var response = await request.send();

      if (response.statusCode > 2) {
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
        vardata = formatarData.format(variavelData);
        String convertidaBr =
            new DateFormat.yMd('pt_Br').format(DateTime.parse(vardata));
        dataFormatada = convertidaBr;
      });
    } else {
      print("ERRO selecionar data");
    }
  }

  String msgSnackConfirma = 'inicializada';
  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      editarPessoaComFoto();
      setState(() {
        msgSnackConfirma = 'Registro Atualizado';
      });
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      editarPessoaSemFoto();
      setState(() {
        msgSnackConfirma = 'Registro Atualizado';
      });
    } else {
      return "Erro!";
    }
  }

  String cepNaoEncontrado;
  Future recuperaCep() async {
    final int ok = 200;
    final int badRequest = 400;

    String cep = cepController.text;

    String baseUrl = 'https://viacep.com.br/ws/';
    String cepDigitado = '$cep';
    String tiporetorno = '/json/';
    print(cepDigitado);
    if ((cepDigitado != null) &&
        (cepDigitado.length == 9) &&
        (cepDigitado.isNotEmpty)) {
      final uri = Uri.parse('$baseUrl/$cepDigitado/$tiporetorno');
      http.Response response;
      response = await http.get(uri);
      print(response.body);
      if (response.statusCode == ok) {
        Map<String, dynamic> retorno = json.decode(response.body);
        String enderecoAPI = retorno["logradouro"];
        String cidadeAPI = retorno["localidade"];
        String bairroAPI = retorno["bairro"];
        bool cepNaoEncontradoApi = retorno["erro"];
        if (cepNaoEncontradoApi == null) {
          setState(() {
            enderecoController.text = enderecoAPI;
            cidadeController.text = cidadeAPI;
            bairroController.text = bairroAPI;
            toast("Cep localizado");
          });
        } else {
          snackBar(context, title: "Cep não encontrado");
        }
      } else if (response.statusCode == badRequest) {
        print("Servidor de cep offline");
      }
    } else {
      snackBar(context, title: "Cep Inválido");
      print("Cep invalido");
    }
  }

  Future obterImagemCamera() async {
    final image = await picker.getImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    File pickedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: 1920,
      maxHeight: 1080,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xFF212121),
        toolbarTitle: "Redimensionar Imagem",
        statusBarColor: Colors.black54,
        backgroundColor: Colors.white,
        toolbarWidgetColor: Colors.white,
      ),
    );
    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      setState(() {
        _imageFile = image;
        Navigator.pop(context);
      });
    } else {
      return;
    }
  }

  Future obterImagemGaleria() async {
    final file = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    File pickedFile = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxWidth: 1920,
      maxHeight: 1080,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Color(0xFF212121),
        toolbarTitle: "Redimensionar Imagem",
        statusBarColor: Colors.black54,
        backgroundColor: Colors.white,
        toolbarWidgetColor: Colors.white,
      ),
    );
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

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.black45,
                  backgroundColor: Colors.grey[100],
                  onSurface: Colors.grey,
                ),
                label: Text('Camera'),
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  this.obterImagemCamera();
                },
                //child: const Text('Câmera'),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  primary: Colors.black45,
                  backgroundColor: Colors.grey[100],
                  onSurface: Colors.grey,
                ),
                label: Text('Galeria'),
                icon: Icon(Icons.photo),
                onPressed: () {
                  this.obterImagemGaleria();
                },
                //child: const Text('Galeria'),
              ),
            ],
          ));
        });
  }

  //DROPDOWN LIST GRUPOS
  List<DropdownMenuItem<String>> _listaItensDropGrupo = [];
  final list = <GrupoModel>[];
  Future<void> _listarGrupos() async {
    list.clear();
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
        list.add(ab);
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
      for (int i = 0; i < list.length; i++) {
        _carregarApiGrupos.add(list[i].nomeGrupo);
        _listaItensDropGrupo.add(
          DropdownMenuItem(
              child: Text(list[i].nomeGrupo,
                  style: TextStyle(fontSize: 18, color: Colors.black87)),
              value: list[i].nomeGrupo),
        );
      }
    });
  }

  dialogEditarPessoa() {
    showConfirmDialogCustom(
      context,
      title: "Salvar dados atualizados?",
      dialogType: DialogType.UPDATE,
      onAccept: () {
        check();
        snackBar(context, title: msgSnackConfirma);
      },
    );
  }
} //CLASS
