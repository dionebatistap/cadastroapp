import 'dart:async';

import 'package:cadastroapp/views/login/login.dart';
import 'package:cadastroapp/views/welcome/passoapasso.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class TelaAbertura extends StatefulWidget {
  // static String tag = '/TelaAbertura';

  @override
  TelaAberturaState createState() => TelaAberturaState();
}

class TelaAberturaState extends State<TelaAbertura>
    with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.dark));
    getPref();
    super.initState();
    init();
  }

  init() async {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInCubic);

    animationController.forward();

    startTime();
  }

  startTime() async {
    await Future.delayed(Duration(seconds: 3));

    finish(context);

    if (controleTela.isEmptyOrNull) {
      PassoAPasso().launch(context);
    } else {
      Login().launch(context);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        key: scaffoldKey,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ScaleTransition(
                scale: animation,
                child: Image.asset('./images/cadBranco.png',
                    height: 140, width: 180, fit: BoxFit.cover)),
            8.height,
            Text("Cadastro de Membros",
                style: boldTextStyle(size: 25, color: Colors.white)),
          ],
        ).center(),
      ),
    );
  }

  String controleTela;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      controleTela = preferences.getString("id");
      print(controleTela);
    });
  }
} //CLASS
