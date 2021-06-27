import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class InserirPessoa extends StatefulWidget {
  final VoidCallback reload;
  InserirPessoa(this.reload);

  @override
  _InserirPessoaState createState() => _InserirPessoaState();
}

class _InserirPessoaState extends State<InserirPessoa> {
  //VARIAVEIS
  String estadoCivil, idUsuario, clgrupo;
  final _key = new GlobalKey<FormState>();
  var validarCampos = true;
  File _imageFile;
  final picker = ImagePicker();
  //VARIAVEIS RADIO BUTTONS
  String clestadoCivil = "Casado";
  String clMembroObreiro = "Obreiro";
//CONTROLLERS TEXTFIELD
  final TextEditingController nomeController =
      TextEditingController(text: "Dione Batista Pereira");
  final TextEditingController celularController =
      TextEditingController(text: "19983975315");
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
  final TextEditingController prBatizouController =
      TextEditingController(text: "Pr. Leonardo");

  //VARIAVEIS DATAPICKER
  String selecionaData, labelText;
  DateTime variavelData = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 14.0);

//FORMATADORES
  var formataCelular = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});
  var formataCep = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    getPref();
    _carregaItensDropdown();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var tamanho = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar Membro"),
        toolbarHeight: 60,
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: radiusOnly(bottomLeft: 20, bottomRight: 20),
        ),
      ),
      body: Container(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Form(
              //autovalidate: validarCampos,
              key: _key,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
//CONTAINER DA FOTO
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: _imageFile == null
                          ? Container(
                              width: tamanho.size.width,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey[300],
                                        blurRadius: 0,
                                        spreadRadius: 3),
                                  ]),
                              child: Container(
                                margin: EdgeInsets.all(8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey[600],
                                  child: InkWell(
                                    onTap: () {
                                      displayBottomSheet(context);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(),
                                        Icon(
                                          Icons.add_a_photo,
                                          size: 80,
                                          color: Colors.grey[100],
                                        ),
                                        Text(
                                          "Adicionar",
                                          style: TextStyle(
                                              color: Colors.grey[100]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  radius: 110,
                                ),
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

                    /*inicio*/
                    const SizedBox(
                      height: 3,
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
                                      blurRadius: 0,
                                      spreadRadius: 3),
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

                                TextFormField(
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Cidade',
                                    labelText: 'Cidade*',
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

//FORMULARIO DE DATA DO BATISMO
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
                                    valueText: new DateFormat.yMd('pt_Br')
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

// SELECIONAR GRUPO QUE PERTENCE
                                Row(children: <Widget>[
                                  Text("Faz parte de algum grupo:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                const SizedBox(height: 2.0),
                                Container(
                                  height: tamanho.size.height * 0.1,
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
                                              ? 'Por favor selecione uma opção...'
                                              : null,
                                          decoration: InputDecoration.collapsed(
                                              hintText: ''),
                                          //decoration:,
                                          hint: Text("Selecione o grupo...",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.grey[700])),
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
                                const SizedBox(height: 15.0),
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  elevation: 3.0,
                                  color: Colors.grey[300],
                                  clipBehavior: Clip.antiAlias,
                                  child: MaterialButton(
                                    splashColor: Colors.green[600],
                                    focusColor: Colors.green[600],
                                    hoverColor: Colors.green[600],
                                    highlightColor: Colors.green[600],
                                    minWidth: 200.0,
                                    height: 35,
                                    onPressed: () {
                                      check();
                                    },
                                    child: Text("Salvar",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[700])),
                                  ),
                                ),
                                const SizedBox(height: 15.0),
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

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      submterComFoto();
    }
    if (form.validate() && _imageFile == null) {
      if (clgrupo == null) {
        clgrupo = "Não possui grupo";
      }
      form.save();
      submterSemFoto();
    } else {
      setState(() {
        validarCampos = true;
      });
    }
  }

  submterSemFoto() async {
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String celular = celularController.text;
    String pastorBatizou = prBatizouController.text;

    var url = Uri.parse(BaseUrl.inserirPessoaSemFoto);
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
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String celular = celularController.text;
    String pastorBatizou = prBatizouController.text;

    try {
      var stream = http.ByteStream(_imageFile.openRead());
      stream.cast();
      var length = await _imageFile.length();

      var uri = Uri.parse(BaseUrl.inserirPessoaComFoto);
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
        toolbarTitle: "Editar Imagem",
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
        toolbarTitle: "Editar Imagem",
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
            ),
          );
        });
  }

//DROPDOWN LIST GRUPOS
  List<DropdownMenuItem<String>> _listaItensDropGrupo = [];
  _carregaItensDropdown() {
    _listaItensDropGrupo.add(
      DropdownMenuItem(
          child: Text("Não possui grupo",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "Não possui grupo"),
    );

    _listaItensDropGrupo.add(
      DropdownMenuItem(
          child: Text("FJU",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "FJU"),
    );

    _listaItensDropGrupo.add(
      DropdownMenuItem(
          child: Text("EVG",
              style: TextStyle(fontSize: 18, color: Colors.black87)),
          value: "EVG"),
    );
  }
}
