import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class CambiarPasswordPage extends StatefulWidget {
  final int rut;
  CambiarPasswordPage({this.rut});
  @override
  _CambiarPasswordPageState createState() => _CambiarPasswordPageState();
}

class _CambiarPasswordPageState extends State<CambiarPasswordPage> {
  @override
  final _formKey = GlobalKey<FormState>();
  bool passwordValida;
  TextEditingController confirmarCtrl = new TextEditingController();
  TextEditingController passwordCtrl = new TextEditingController();
  TextEditingController password2Ctrl = new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cambiar Contraseña'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                _txtConfirmar(),
                _txtPassword(),
                _txtPassword2(),
                _btnRegistrar(),
                _botonCancelar()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _txtConfirmar() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        obscureText: true,
        controller: confirmarCtrl,
        decoration: InputDecoration(
          hintText: "Ingrese su contraseña actual",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (passwordValida == false) {
            return 'Contraseña incorrecta';
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
        decoration: InputDecoration(
          hintText: "Ingrese su nueva contraseña",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Indique contraseña';
          }
          if (value.length < 6) {
            return 'Contraseña muy corta';
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
        decoration: InputDecoration(
          hintText: "Confirmar contraseña",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        validator: (value) {
          if (value != passwordCtrl.text) {
            return 'Contraseñas no coinciden';
          }
          if (value.length < 6) {
            return 'Contraseña muy corta';
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
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(120, 139, 255, 1.0)),
        ),
        child: Text('Guardar cambios',
            style: TextStyle(color: Colors.white, fontFamily: 'Raleway')),
        onPressed: () {
          _comprobarExistenciaPW();
          if (_formKey.currentState.validate()) {
            _cambiarContrasena();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  _comprobarExistenciaPW() async {
    var provider = UsuarioProvider();
    var respuesta =
        await provider.comprobarPW(widget.rut.toString(), confirmarCtrl.text);
    if (respuesta.statusCode == 200) {
      setState(() {
        passwordValida = true;
      });
    } else {
      setState(() {
        passwordValida = false;
      });
    }
  }

  _cambiarContrasena() async {
    var provider = UsuarioProvider();
    return await provider.cambiarPassword(
        passwordCtrl.text, widget.rut.toString());
  }

  Widget _botonCancelar() {
    return Container(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        child: Text('Cancelar'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(199, 199, 183, 1.0)),
        ),
        onPressed: () => _navegarCancelar(context),
      ),
    );
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
