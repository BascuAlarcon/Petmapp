import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primaryColor: Color(0xFF003E59),
            accentColor: Color(0xFFF76161),
            buttonTheme: ButtonThemeData(
                buttonColor: Color(0xFF534E88),
                textTheme: ButtonTextTheme.primary)),
        home: MainPage() /* HomePage() */);
  }
}
