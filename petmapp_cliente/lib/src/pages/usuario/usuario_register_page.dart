import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';

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
      appBar: AppBar(
        title: Text('Registrar Usuario'),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
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
    return TextFormField(
      controller: rutCtrl,
      decoration: InputDecoration(labelText: 'Rut'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique Rut';
        }
        return null;
      },
    );
  }

  Widget _txtEmail() {
    return TextFormField(
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique Email';
        }
        if (!RegExp(_emailRegex).hasMatch(value)) {
          return 'Email Invalido';
        }
        return null;
      },
    );
  }

  Widget _txtNombre() {
    return TextFormField(
      controller: nombreCtrl,
      decoration: InputDecoration(labelText: 'Nombre'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique Nombre';
        }
        return null;
      },
    );
  }

  Widget _txtPassword() {
    return TextFormField(
      controller: passwordCtrl,
      obscureText: true,
      decoration: InputDecoration(labelText: 'Contraseña'),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique contraseña';
        }
        return null;
      },
    );
  }

  Widget _txtPassword2() {
    return TextFormField(
      controller: password2Ctrl,
      obscureText: true,
      decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
      validator: (value) {
        if (value != passwordCtrl.text) {
          return 'Contraseñas no coinciden';
        }
        return null;
      },
    );
  }

  Widget _btnRegistrar() {
    return Container(
      child: ElevatedButton(
        child: Text('Crear Cuenta'),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signUp(rutCtrl.text, emailCtrl.text, passwordCtrl.text,
                nombreCtrl.text);
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  signUp(String rut, String email, String password, String nombre) async {
    var provider = PetmappProvider();
    return await provider.registrar(rut, email, password, nombre);
  }
}
