import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/pages/main_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_register_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  textSection(),
                  buttonSection(),
                  buttonRegistrar()
                ],
              ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("PetmApp",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
          child: Text("Conectarse", style: TextStyle(color: Colors.white70)),
          onPressed: () {
            loginUsuario(
                emailController.text.trim(), passwordController.text.trim());
          }),
    );
  }

  Container buttonRegistrar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: ElevatedButton(
        child: Text('Registrarse'),
        onPressed: () {
          final route =
              MaterialPageRoute(builder: (context) => RegistrarPage());
          Navigator.push(context, route);
        },
      ),
    );
  }

  /* signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {'email': email, 'password': pass};
    var jsonResponse = null;
    var response = await http
        .post(Uri.parse("http://192.168.1.86:8000/api/auth/login"), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['access_token']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => MainPage()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      print(response.body);
    }
  } */

  loginUsuario(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var provider = PetmappProvider();
    var respuesta = await provider.login(email, password);
    // en caso de que este todo OK, respuesta debería tener un access_token
    if (respuesta['access_token'] == null) {
      print('no hay access_token');
    } else {
      setState(() {
        _isLoading = false;
      });
      // TRAER A TODOS LOS USUARIOS //
      var usuarios = await provider.getUsuarios();
      // COMPARAR EMAIL DE LISTA CON USUARIO CON EL USUARIO DEL CONTROLLER
      var rut;
      var correo;
      var nombre;
      var token;
      for (var usuario in usuarios) {
        if (usuario['email'] == email) {
          // GUARDAR LOS DATOS CON SHARED PREFERENCES //
          rut = usuario['rut'];
          correo = usuario['email'];
          nombre = usuario['name'];
          token = respuesta['access_token'];
          rut = rut.toString();
          sharedPreferences
              .setStringList("usuario", [rut, correo, nombre, token]);
        }
      }

      sharedPreferences.setString("token", respuesta['access_token']);
      var route = new MaterialPageRoute(builder: (context) => MainPage());
      Navigator.push(context, route);
    }
  }
}
