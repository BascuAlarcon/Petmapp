import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class RegistrarPage extends StatefulWidget {
  RegistrarPage({Key key}) : super(key: key);

  @override
  _RegistrarPageState createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController password2Ctrl = TextEditingController();
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController rutCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(84, 101, 255, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(84, 101, 255, 1.0),
        elevation: 0,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 30.0),
                    child: Text("Regístrate!",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 1.0),
                    child: Text("¿Por qué necesitamos tu rut?",
                        style: TextStyle(
                            fontFamily: 'Raleway',
                            color: Colors.white,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                _txtRut(),
                _txtNombre(),
                _txtEmail(),
                _txtPassword(),
                _txtPassword2(),
                _btnRegistrar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _txtRut() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: rutCtrl,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.format_list_numbered, color: Colors.white70),
          hintText: "Rut",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Indique Rut';
          }
          return null;
        },
      ),
    );
  }

  Widget _txtEmail() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: emailCtrl,
        keyboardType: TextInputType.emailAddress,
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
        validator: (value) {
          if (value.isEmpty) {
            return 'Indique Email';
          }
          if (!RegExp(_emailRegex).hasMatch(value)) {
            return 'Email Invalido';
          }
          return null;
        },
      ),
    );
  }

  Widget _txtNombre() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: nombreCtrl,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.people_outline, color: Colors.white70),
          hintText: "Nombre",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Indique Nombre';
          }
          return null;
        },
      ),
    );
  }

  Widget _txtPassword() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: passwordCtrl,
        obscureText: true,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.vpn_key, color: Colors.white70),
          hintText: "Contraseña",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Indique contraseña';
          }
          return null;
        },
      ),
    );
  }

  Widget _txtPassword2() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: password2Ctrl,
        obscureText: true,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.vpn_key, color: Colors.white70),
          hintText: "Confirmar Contraseña",
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) {
          if (value != passwordCtrl.text) {
            return 'Contraseñas no coinciden';
          }
          return null;
        },
      ),
    );
  }

  Widget _btnRegistrar() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: Text('Crear Cuenta',
            style: TextStyle(color: Colors.black, fontFamily: 'Raleway')),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signUp(rutCtrl.text, emailCtrl.text, passwordCtrl.text,
                nombreCtrl.text);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  signUp(String rut, String email, String password, String nombre) async {
    var provider = UsuarioProvider();
    return await provider.registrar(rut, email, password, nombre);
  }
}
