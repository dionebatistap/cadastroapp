import 'package:cadastroapp/views/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  //CONTROLLER BARRA DE STATUS
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.grey[850],
    ),
  );
  //CONTROLLER MODO RETRATO
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    theme: ThemeData(
      primaryColor: Colors.white,
      brightness: Brightness.light,
      //fontFamily: 'ProductSans',
      fontFamily: GoogleFonts.poppins().fontFamily,
      //inputDecorationTheme: InputDecorationTheme(focusColor: Colors.amber),
      accentColor: Colors.black87,
      indicatorColor: Colors.black87,
      disabledColor: Colors.grey[300],
      iconTheme: IconThemeData(color: Colors.black87),
      dialogBackgroundColor: Colors.white,
      accentIconTheme: IconThemeData(color: Colors.grey[850]),
      primaryIconTheme: IconThemeData(color: Colors.grey[850]),
      hintColor: Colors.grey[400],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.grey[500],
        selectionColor: Colors.grey[450],
        selectionHandleColor: Colors.grey[600],
      ),
      dialogTheme: DialogTheme(backgroundColor: Colors.white),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: Colors.grey[800]),
    ),
    //OS WIDGETS EM PORTUGUES (datapicker)
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],
    supportedLocales: [const Locale('pt', 'BR')],
    home: TelaAbertura(),
  ));
}
