import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:cadastroapp/custom/datePicker.dart';
import 'package:cadastroapp/model/api.dart';
import 'package:cadastroapp/model/pessoaModel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
  String itemGrupoSelecionado;
  //VARIAVEIS DROPDOWN
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
    _carregaItensDropdown();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    var tamanho = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Cadastro"),
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
                                    fontSize: 15, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
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
    } else {
      print(aviso);
      print(print);
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
      request.fields['idUsuario'] = idUsuario;
      request.fields['idPessoa'] = widget.model.id;
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
        vardata = formatarData.format(variavelData);
        String convertidaBr =
            new DateFormat.yMd('pt_Br').format(DateTime.parse(vardata));
        dataFormatada = convertidaBr;
      });
    } else {}
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      editarPessoaComFoto();
    }
    if (form.validate() && _imageFile == null) {
      form.save();
      editarPessoaSemFoto();
    } else {
      return "Erro!";
    }
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
} //CLASS
