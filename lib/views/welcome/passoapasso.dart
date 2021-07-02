import 'package:cadastroapp/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cadastroapp/views/welcome/images.dart';
import 'package:cadastroapp/views/welcome/widgets.dart';
import 'package:nb_utils/nb_utils.dart';

class PassoAPasso extends StatefulWidget {
  static String tag = '/PassoAPasso';

  @override
  PassoAPassoState createState() => PassoAPassoState();
}

class PassoAPassoState extends State<PassoAPasso>
    with AfterLayoutMixin<PassoAPasso> {
  PageController pageController = PageController();
  List<Widget> pages = [];
  double currentPage = 0;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.easeInCubic;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    pageController.addListener(() {
      setState(() {
        currentPage = pageController.page;
      });
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    pages = [
      passoAPasso(
          gs_walk_through1,
          "Seja bem-vindo(a) ao aplicativo\n para cadastrar membros",
          "CADASTRO"),
      passoAPasso(
          gs_walk_through2,
          "É necessário estar conectado\n à internet para cadastrar",
          "INFORMAÇÃO"),
      passoAPasso(gs_walk_through3,
          "Procure sempre preencher\n todos os campos", "ATENÇÃO"),
    ];
    setState(() {});
  }

  @override
  void dispose() {
    //pageController?.dispose();
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
        key: scaffoldKey,
        body: Stack(
          children: [
            PageView(
                controller: pageController,
                children: pages.map((e) => e).toList()),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                "Pular".toUpperCase(),
                style: primaryTextStyle(
                    size: 16, color: Colors.grey[800], weight: FontWeight.bold),
                textAlign: TextAlign.end,
              ).onTap(() {
                Login().launch(context);
              }),
            ).paddingOnly(right: 16, top: 16),
            Positioned(
              top: context.height() * 0.8,
              left: 16,
              right: 16,
              child: DotIndicator(
                pageController: pageController,
                pages: pages,
                indicatorColor: Colors.grey[900],
                unselectedIndicatorColor: Colors.grey[400],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: gsAppButton(
                context,
                'Próximo',
                () {
                  if (currentPage == 2) {
                    finish(context);
                    Login().launch(context);
                  } else {
                    pageController.nextPage(
                        duration: _kDuration, curve: _kCurve);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
