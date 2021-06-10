import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:petmapp_cliente/src/pages/main_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_register_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Validaciones //
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(84, 101, 255, 1.0),
              Color.fromRGBO(120, 139, 255, 1.0)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: <Widget>[
                    headerSection(),
                    textSection(),
                    buttonSection(),
                    buttonRegistrar(),
                    Container(height: 90),
                    FadeInImage(
                      image: NetworkImage(
                          'http://pa1.narvii.com/6997/545275f0f9d104509ca7db0f7763b956ca00bbear1-270-165_00.gif'),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 60,
                      width: 60,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Center(
        child: Text("PetmApp",
            style: TextStyle(
                fontFamily: 'Raleway',
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold)),
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo';
              }
              return null;
            },
            controller: emailController,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white70)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              return null;
            },
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.white70),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.white70)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
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
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white12))),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
          child: Text("Conectarse",
              style: TextStyle(color: Colors.black, fontFamily: 'Raleway')),
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
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text('Registrarse',
            style: TextStyle(color: Colors.black, fontFamily: 'Raleway')),
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
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var provider = UsuarioProvider();
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
        var perfil;
        for (var usuario in usuarios) {
          if (usuario['email'] == email) {
            // GUARDAR LOS DATOS CON SHARED PREFERENCES //
            rut = usuario['rut'];
            correo = usuario['email'];
            nombre = usuario['name'];
            perfil = usuario['perfil_id'];
            token = respuesta['access_token'];
            rut = rut.toString();
            sharedPreferences.setStringList(
                "usuario", [rut, correo, nombre, perfil.toString(), token]);
          }
        }

        sharedPreferences.setString("token", respuesta['access_token']);
        var route = new MaterialPageRoute(builder: (context) => MainPage());
        Navigator.push(context, route);
      }
    }
  }
}
