import 'dart:convert';
import 'dart:io';

import 'package:cadastroapp/model/grupoModel.dart';
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
import 'package:email_validator/email_validator.dart';

class InserirPessoa extends StatefulWidget {
  final VoidCallback reload;
  InserirPessoa(this.reload);

  @override
  _InserirPessoaState createState() => _InserirPessoaState();
}

class _InserirPessoaState extends State<InserirPessoa> {
  //VARIAVEIS
  String estadoCivil, idUsuario, idGrupo, prefControle, clGrupo;
  final _key = new GlobalKey<FormState>();
  var validate = true;
  File _imageFile;
  final picker = ImagePicker();
  //VARIAVEIS RADIO BUTTONS
  String clestadoCivil = "Solteiro";
  String clsexo = "Masculino";
  String clMembroObreiro = "Membro";
  String isBatizada = "Não";
//CONTROLLERS TEXTFIELD
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController celularController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController enderecoController = TextEditingController();
  final TextEditingController numeroController = TextEditingController();
  final TextEditingController bairroController = TextEditingController();
  final TextEditingController cepController = TextEditingController();
  final TextEditingController cidadeController = TextEditingController();
  final TextEditingController prBatizouController = TextEditingController();
  final TextEditingController pessoaprofissaoController =
      TextEditingController();
  final TextEditingController pessoaemailController = TextEditingController();
  final TextEditingController pessoauniversalController =
      TextEditingController();
  final TextEditingController estadocidadeController = TextEditingController();
  final TextEditingController pesquisaArimateiaController =
      TextEditingController();

  //VARIAVEIS DATAPICKER
  String selecionaData, selecionaDataNasc, labelText;
  DateTime variavelData = new DateTime.now();
  DateTime nascimentoData = new DateTime.now();
  final TextStyle valueStyle = TextStyle(fontSize: 14.0);

//FORMATADORES
  var formataCelular = new MaskTextInputFormatter(
      mask: '(##)#####-####', filter: {"#": RegExp(r'[0-9]')});

  var formataTelefone = new MaskTextInputFormatter(
      mask: '(##)####-####', filter: {"#": RegExp(r'[0-9]')});

  var formataCep = new MaskTextInputFormatter(
      mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    super.initState();
    getPref();
    _listarGrupos();
    _listaAddDropGrupos();
    //_carregaItensDropdown();
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
              //autovalidateMode: AutovalidateMode.always,
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
//CADASTRO DE MEMBROS
                                Column(
                                  children: [Divider()],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Cadastro de Membros",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ]),

                                Column(
                                  children: [Divider()],
                                ),
                                const SizedBox(height: 5.0),
//FORMUALARIO DE TEXTO NOME
                                TextFormField(
                                  validator: (e) {
                                    if (e.trim().isEmpty) {
                                      return "*campo obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText:
                                        'Por favor, iserir nome completo.',
                                    labelText: 'Nome*',
                                  ),
                                  controller: nomeController,
                                ),
                                const SizedBox(height: 10.0),

//FORMULARIO DATA DE NASCIMENTO

                                Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 30, 0),
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  child: new DateDropDown(
                                    labelText: labelText = "Nascimento",
                                    valueText: new DateFormat.yMd('pt_Br')
                                        .format(nascimentoData),
                                    valueStyle: valueStyle,
                                    onPressed: () {
                                      _selectedDateNasc(context);
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10.0),
//FORMULARIO RADIO BUTTON *SEXO*
                                Row(children: <Widget>[
                                  Text("Sexo:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
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
                                      Text("Feminino",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Feminino",
                                        groupValue: clsexo,
                                        onChanged: (String selecionaSexo) {
                                          setState(() {
                                            clsexo = selecionaSexo;
                                          });
                                        },
                                      ),
                                      Spacer(
                                        flex: 3,
                                      ),
                                      Text("Masculino",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        value: "Masculino",
                                        groupValue: clsexo,
                                        onChanged: (String selecionaSexo) {
                                          setState(() {
                                            clsexo = selecionaSexo;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5.0),

//FORMULARIO ESTADO CIVIL BUTTON
                                Row(children: <Widget>[
                                  Text("Estado civil:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(0, 0, 55, 0),
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
                                const SizedBox(height: 12.0),

//FORMUALARIO DE TEXTO PROFISSÃO
                                TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "*campo obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Por favor, iserir profissão.',
                                    labelText: 'Profissão*',
                                  ),
                                  controller: pessoaprofissaoController,
                                ),
                                const SizedBox(height: 5.0),

//INFORMAÇÕES ENDEREÇO
                                Column(
                                  children: [Divider()],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Endereço",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ]),

                                Column(
                                  children: [Divider()],
                                ),
                                const SizedBox(height: 5.0),
//FORMUALARIO DE TEXTO ENDEREÇO
                                TextFormField(
                                  // validator: (e) {
                                  //   if (e.isEmpty) {
                                  //     return "*campo obrigatório";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  inputFormatters: [formataCep],
                                  maxLength: 9,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: '00000-000',
                                    labelText: 'CEP*',
                                    suffixIcon: IconButton(
                                      onPressed: _recuperaCep,
                                      icon: Icon(Icons.search),
                                      //onPressed: _recuperaCep,
                                    ),
                                    counterText: '',
                                    counterStyle: TextStyle(fontSize: 0),
                                  ),
                                  controller: cepController,
                                ),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "*obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
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
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "*obrigatório";
                                          } else {
                                            return null;
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(15.0),
                                            ),
                                          ),
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
                                        validator: (e) {
                                          if (e.isEmpty) {
                                            return "*obrigatório";
                                          } else {
                                            return null;
                                          }
                                        },
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(15.0),
                                            ),
                                          ),
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
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "*campo obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Cidade',
                                    labelText: 'Cidade*',
                                  ),
                                  controller: cidadeController,
                                ),

                                const SizedBox(height: 5.0),

                                TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "*campo obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'Estado',
                                    labelText: 'Estado*',
                                  ),
                                  controller: estadocidadeController,
                                ),

                                const SizedBox(height: 5.0),

//INFORMAÇÕES CONTATO
                                Column(
                                  children: [Divider()],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Contato",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ]),

                                Column(
                                  children: [Divider()],
                                ),
                                const SizedBox(height: 5.0),

//FOMULARIO CELULAR
                                TextFormField(
                                  // validator: (e) {
                                  //   if (e.isEmpty) {
                                  //     return "*campo obrigatório";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  inputFormatters: [formataCelular],
                                  keyboardType: TextInputType.number,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'nº cel.',
                                    labelText: 'Celular*',
                                  ),
                                  controller: celularController,
                                ),
                                const SizedBox(height: 5.0),

//FORMULARIO DE TELEFONE
                                TextFormField(
                                  // validator: (e) {
                                  //   if (e.isEmpty) {
                                  //     return "*campo obrigatório";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  inputFormatters: [formataTelefone],
                                  keyboardType: TextInputType.number,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText: 'nº Tel.',
                                    labelText: 'Telefone*',
                                  ),
                                  controller: telefoneController,
                                ),
                                const SizedBox(height: 5.0),

//FORMUALARIO DE TEXTO EMAIL
                                TextFormField(
                                  // validator: (e) {
                                  //   if (e.isEmpty) {
                                  //     return "*campo obrigatório";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  validator: (e) {
                                    if (e.isEmptyOrNull) {
                                      return null;
                                    }
                                    if (e == "Não informado") {
                                      return null;
                                    }
                                    if (EmailValidator.validate(e)) {
                                      return null;
                                    } else {
                                      snackBar(context,
                                          title: "E-mail inválido",
                                          backgroundColor: Colors.red[600]);
                                      return "exemplo@email.com";
                                    }
                                  },
                                  //textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText:
                                        'Por favor, iserir nome completo.',
                                    labelText: 'E-mail*',
                                  ),
                                  controller: pessoaemailController,
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

//FORMUALARIO DE TEXTO UNIVERSAL
                                TextFormField(
                                  validator: (e) {
                                    if (e.isEmpty) {
                                      return "*campo obrigatório";
                                    } else {
                                      return null;
                                    }
                                  },
                                  textCapitalization: TextCapitalization.words,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                    ),
                                    filled: true,
                                    //icon: Icon(Icons.person),
                                    hintText:
                                        'Por favor, iserir universal atual',
                                    labelText: 'Universal Atual*',
                                  ),
                                  controller: pessoauniversalController,
                                ),
                                const SizedBox(height: 12.0),

//MEMBRO OU OBREIRO
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
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
                                      Spacer(
                                        flex: 3,
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
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
//BATIZADO NAS AGUAS
                                Row(children: <Widget>[
                                  Text("Batizado nas águas:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
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
                                        //  activeColor: Colors.green[600],
                                        value: "Sim",
                                        groupValue: isBatizada,
                                        onChanged:
                                            (String selecionaIsBatizado) {
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
                                              fontSize: 16,
                                              color: Colors.grey[700])),
                                      Radio(
                                        //  activeColor: Colors.red[600],
                                        value: "Não",
                                        groupValue: isBatizada,
                                        onChanged:
                                            (String selecionaIsBatizado) {
                                          setState(() {
                                            isBatizada = selecionaIsBatizado;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8.0),
//FORMULARIO DE DATA DO BATISMO
                                isBatizada == 'Sim'
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 5, 30, 0),
                                        height: tamanho.size.height * 0.09,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey[700]),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          color: Colors.grey[100],
                                          //border: Border.fromBorderSide(),
                                        ),
                                        child: new DateDropDown(
                                          labelText: labelText =
                                              "Batismo nas águas",
                                          valueText: new DateFormat.yMd('pt_Br')
                                              .format(variavelData),
                                          valueStyle: valueStyle,
                                          onPressed: () {
                                            _selectedDate(context);
                                          },
                                        ),
                                      )
                                    : Container(),
                                const SizedBox(height: 5.0),

//FORMULARIO DE TEXTO PASTOR QUE BATIZOU
                                isBatizada == 'Sim'
                                    ? TextFormField(
                                        textCapitalization:
                                            TextCapitalization.words,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                const BorderRadius.all(
                                              const Radius.circular(15.0),
                                            ),
                                          ),
                                          filled: true,
                                          //icon: Icon(Icons.person),
                                          hintText:
                                              'Nome do pastor que batizou.',
                                          labelText: 'Pastor que batizou*',
                                        ),
                                        controller: prBatizouController,
                                      )
                                    : Container(),

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
                                  height: tamanho.size.height * 0.08,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
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
                                          decoration: InputDecoration.collapsed(
                                              hintText: ''),
                                          //decoration:,
                                          hint: Text("Selecione o grupo...",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.grey[700])),
                                          items: _listaItensDropGrupo,
                                          onChanged: (itemGrupo) {
                                            setState(() {
                                              idGrupo = itemGrupo;
                                              textoPesquisaGrupo = idGrupo;
                                              _filtrarGrupo(textoPesquisaGrupo);
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
                                const SizedBox(height: 5.0),

//INFORMAÇÕES ARIMATEIA
                                Column(
                                  children: [Divider()],
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text("Arimatéia",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey[700])),
                                    ]),

                                Column(
                                  children: [Divider()],
                                ),
                                const SizedBox(height: 5.0),

//RG REGULARIZADO
                                Row(children: <Widget>[
                                  Text("RG regularizado ?",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
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
                                        //  activeColor: Colors.green[600],
                                        value: "Sim",
                                        groupValue: isRgRegularizado,
                                        onChanged:
                                            (String selecionaisRgRegularizado) {
                                          setState(() {
                                            isRgRegularizado =
                                                selecionaisRgRegularizado;
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
                                        //  activeColor: Colors.red[600],
                                        value: "Não",
                                        groupValue: isRgRegularizado,
                                        onChanged:
                                            (String selecionaisRgRegularizado) {
                                          setState(() {
                                            isRgRegularizado =
                                                selecionaisRgRegularizado;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),

//CHECKBOX VACINA
                                Row(children: <Widget>[
                                  Text("Vacina COVID19",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.08,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
                                    //border: Border.fromBorderSide(),
                                  ),
                                  padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          activeColor: Colors.green[600],
                                          value: primeiraDose,
                                          onChanged: (bool valor) {
                                            setState(() {
                                              primeiraDose = valor;
                                            });
                                          }),
                                      Text("1ª dose"),
                                      Spacer(
                                        flex: 1,
                                      ),
                                      Checkbox(
                                          activeColor: Colors.green[600],
                                          value: segundaDose,
                                          onChanged: (bool valor) {
                                            setState(() {
                                              segundaDose = valor;
                                            });
                                          }),
                                      Text("2ª dose"),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),

//TITULO
                                Row(children: <Widget>[
                                  Text("Título de eleitor regularizado ?",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey[700])),
                                ]),
                                Container(
                                  height: tamanho.size.height * 0.09,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey[700]),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Colors.grey[100],
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
                                        // activeColor: Colors.green[600],
                                        groupValue: isTituloRegularizado,
                                        onChanged: (String
                                            selecionaisTituloRegularizado) {
                                          setState(() {
                                            isTituloRegularizado =
                                                selecionaisTituloRegularizado;
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
                                        //  activeColor: Colors.red[600],
                                        value: "Não",
                                        groupValue: isTituloRegularizado,
                                        onChanged: (String
                                            selecionaisTituloRegularizado) {
                                          setState(() {
                                            isTituloRegularizado =
                                                selecionaisTituloRegularizado;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10.0),

//PESQUISA DE AJUDA
                                TextFormField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: pesquisaArimateiaController,
                                  //focusNode: addressFocus,
                                  style: primaryTextStyle(),
                                  decoration: InputDecoration(
                                    // prefixIcon: Icon(Icons.message,
                                    //     color: Colors.grey[500]),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey[700])),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.grey[700])),
                                    labelText: 'Pesquisa Arimatéia*',
                                    //labelStyle: primaryTextStyle(),
                                    alignLabelWithHint: true,
                                  ),
                                  maxLines: 3,
                                  keyboardType: TextInputType.multiline,
                                  // validator: (s) {
                                  //   if (s.trim().isEmpty)
                                  //     return 'Address is required';
                                  //   return null;
                                  // },
                                  maxLength: 200,
                                ),
                                const SizedBox(height: 10.0),
//BOTÃO SALVAR
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  elevation: 3.0,
                                  color: Colors.grey[800],
                                  clipBehavior: Clip.antiAlias,
                                  child: MaterialButton(
                                    splashColor: Colors.grey[400],
                                    focusColor: Colors.grey[400],
                                    hoverColor: Colors.grey[400],
                                    highlightColor: Colors.grey[400],
                                    minWidth: 200.0,
                                    height: 35,
                                    onPressed: () {
                                      print(prefControle);
                                      if (prefControle == 'inativo') {
                                        toast("Sem permissão para cadastrar");
                                      } else {
                                        if (_imageFile == null) {
                                          snackBar(context,
                                              title: "Foto é obrigatório",
                                              backgroundColor: Colors.red[600]);
                                        } else {
                                          check();
                                          //imprimir();
                                        }
                                      }
                                    },
                                    child: Text("Salvar",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[200])),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
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

  String isRgRegularizado;
  String isTituloRegularizado;
  bool primeiraDose = false;
  bool segundaDose = false;

/* METODOS */

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsuario = preferences.getString("id");
      prefControle = preferences.getString("statusUser");
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate() && _imageFile != null) {
      form.save();
      _submterComFoto();
    }
    if (form.validate() && _imageFile == null) {
      if (idGrupo == null) {
        idGrupo = "Não possui grupo";
      }
      form.save();
      _submterSemFoto();
      print(prefControle);
    } else {
      setState(() {
        validate = true;
      });
    }
  }

  Future<void> _submterSemFoto() async {
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String estado = estadocidadeController.text;
    String celular = celularController.text;
    String telefone = telefoneController.text;
    String profissao = pessoaprofissaoController.text;
    String email = pessoaemailController.text;
    String universal = pessoauniversalController.text;
    String pastorBatizou = prBatizouController.text;
    String pesquisaArimateia = pesquisaArimateiaController.text;

    if (telefone.isEmptyOrNull) {
      telefone = 'Não informado';
    }
    if (email.isEmptyOrNull) {
      email = 'Não informado';
    }
    if (cep.isEmptyOrNull) {
      cep = '00000-000';
    }
    if (pastorBatizou.isEmptyOrNull) {
      pastorBatizou = 'Não informado';
    }
    try {
      var url = Uri.parse(BaseUrl.inserirPessoaSemFoto);
      final response = await http.post(url, body: {
        "nomePessoa": "$nome",
        "enderecoPessoa": "$endereco",
        "numeroPessoa": "$numero",
        "bairroPessoa": "$bairro",
        "cepPessoa": "$cep",
        "cidadePessoa": "$cidade",
        "estadocidade": "$estado",
        "celularPessoa": "$celular",
        "telefonePessoa": "$telefone",
        "pessoaprofissao": "$profissao",
        "pessoaemail": "$email",
        "pessoauniversal": "$universal",
        "pessoanascimento": "$nascimentoData",
        "membroObreiro": "$clMembroObreiro",
        "prBatizou": "$pastorBatizou",
        "estadoCivil": "$clestadoCivil",
        "pessoasexo": "$clsexo",
        "grupo": "$clGrupo",
        "isBatizada": "$isBatizada",
        "isRgRegularizado": "$isRgRegularizado",
        "isTituloRegularizado": "$isTituloRegularizado",
        "primeiraDose": "$primeiraDose",
        "segundaDose": "$segundaDose",
        "pesquisaArimateia": "$pesquisaArimateia",
        "idUsuario": idUsuario,
        "idGrupo": idGrupo,
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
          snackBar(context,
              title: "Cadastrado com sucesso.",
              backgroundColor: Colors.green[600]);
        });
      } else {
        snackBar(context,
            title: "Falha ao cadastrar.", backgroundColor: Colors.red[600]);
      }
    } catch (e) {
      debugPrint("Inserir pessoa sem foto: $e");
    }
  }

  Future<void> _submterComFoto() async {
    print("COM FOTO: " + clGrupo);
    String nome = nomeController.text;
    String endereco = enderecoController.text;
    String numero = numeroController.text;
    String bairro = bairroController.text;
    String cep = cepController.text;
    String cidade = cidadeController.text;
    String celular = celularController.text;
    String telefone = telefoneController.text;
    String estado = estadocidadeController.text;
    String profissao = pessoaprofissaoController.text;
    String email = pessoaemailController.text;
    String universal = pessoauniversalController.text;
    String pesquisaArimateia = pesquisaArimateiaController.text;
    String pastorBatizou = prBatizouController.text;
    if (telefone.isEmptyOrNull) {
      telefone = 'Não informado';
    }
    if (email.isEmptyOrNull) {
      email = 'não informado';
    }
    if (cep.isEmptyOrNull) {
      cep = '00000-000';
    }
    if (pastorBatizou.isEmptyOrNull) {
      pastorBatizou = 'Não informado';
    }
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
      request.fields['pessoasexo'] = "$clsexo";
      request.fields['estadocidade'] = "$estado";
      request.fields['pessoaemail'] = "$email";
      request.fields['pessoaprofissao'] = "$profissao";
      request.fields['pessoauniversal'] = "$universal";
      request.fields['celularPessoa'] = "$celular";
      request.fields['telefonePessoa'] = "$telefone";
      request.fields['membroObreiro'] = "$clMembroObreiro";
      request.fields['prBatizou'] = "$pastorBatizou";
      request.fields['estadoCivil'] = "$clestadoCivil";
      request.fields['grupo'] = "$clGrupo";
      request.fields['isBatizada'] = "$isBatizada";
      request.fields['idUsuario'] = idUsuario;
      request.fields['idGrupo'] = idGrupo;
      request.fields['isRgRegularizado'] = "$isRgRegularizado";
      request.fields['isTituloRegularizado'] = "$isTituloRegularizado";
      request.fields['primeiraDose'] = "$primeiraDose";
      request.fields['segundaDose'] = "$segundaDose";
      request.fields['pesquisaArimateia'] = "$pesquisaArimateia";

      request.fields['pessoanascimento'] = "$nascimentoData";
      request.fields['dataSelecionada'] = "$variavelData";

      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(_imageFile.path)));

      var response = await request.send();
      if (response.statusCode > 2) {
        setState(() {
          widget.reload();
          Navigator.pop(context);
          snackBar(context,
              title: "Cadastrado com sucesso.",
              backgroundColor: Colors.green[600]);
        });
      } else {
        snackBar(context,
            title: "Falha ao cadastrar.", backgroundColor: Colors.red[600]);
      }
    } catch (e) {
      debugPrint("Inserir pessoa com foto: $e");
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

  Future<Null> _selectedDateNasc(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: nascimentoData,
        firstDate: DateTime(1900),
        lastDate: DateTime(2099));
    if (picked != null && picked != nascimentoData) {
      setState(() {
        nascimentoData = picked;
        selecionaDataNasc = new DateFormat.yMd().format(nascimentoData);
      });
    } else {}
  }

  String cepNaoEncontrado;
  Future<void> _recuperaCep() async {
    final int ok = 200;
    final int badRequest = 400;

    String cep = cepController.text;

    String baseUrl = 'https://viacep.com.br/ws/';
    String cepDigitado = '$cep';
    String tiporetorno = '/json/';
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
        String estadoAPI = retorno["uf"];
        bool cepNaoEncontradoApi = retorno["erro"];
        if (cepNaoEncontradoApi == null) {
          setState(() {
            enderecoController.text = enderecoAPI;
            cidadeController.text = cidadeAPI;
            bairroController.text = bairroAPI;
            estadocidadeController.text = estadoAPI;
            toast("Cep localizado.");
          });
        } else {
          //toast("Cep não encontrado");
          snackBar(context,
              title: "Cep não encontrado.", backgroundColor: Colors.red[600]);
        }
      } else if (response.statusCode == badRequest) {
        print("Servidor de cep offline");
      }
    } else {
      snackBar(context,
          title: "Cep Inválido.", backgroundColor: Colors.red[600]);
    }
  }

  Future<void> _obterImagemCamera() async {
    try {
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
        return "Erro patch called null";
      }
    } catch (e) {
      return "Inserir Pessoa->>> patch called null $e";
    }
  }

  Future<void> _obterImagemGaleria() async {
    try {
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
        return "Erro patch called null";
      }
    } catch (e) {
      return "Inserir Pessoa->>> patch called null $e";
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
                    this._obterImagemCamera();
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
                    this._obterImagemGaleria();
                  },
                  //child: const Text('Galeria'),
                ),
              ],
            ),
          );
        });
  }

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
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
              value: list[i].id),
        );
      }
    });
  }

  String textoPesquisaGrupo = '';
  Future<void> _filtrarGrupo(String texto) async {
//code...

    list.forEach((ab) {
      if ((ab.id.toLowerCase()).contains(textoPesquisaGrupo)) {
        setState(() {
          clGrupo = (ab.nomeGrupo).toString();
        });
      }
    });
  }

  void imprimir() {
    print("Nome: " + nomeController.text);
    print("Celular: " + celularController.text);
    print("Cep: " + cepController.text);
    print("Endereço: " + enderecoController.text);
    print("Numero: " + numeroController.text);
    print("Bairro: " + bairroController.text);
    print("Cidade: " + cidadeController.text);
    print("Estado: " + estadocidadeController.text);
    print("PR batizado: " + prBatizouController.text);
    print("Profissao: " + pessoaprofissaoController.text);
    print("Email: " + pessoaemailController.text);
    print("Universal: " + pessoauniversalController.text);
    print("Sexo: " + clsexo);
    print("Grupo: " + clGrupo);
    print("Cargo: " + clMembroObreiro);
    print("Estado civil: " + clestadoCivil);
    print("Grupo: " + pessoauniversalController.text);
  }
} //CLASS
