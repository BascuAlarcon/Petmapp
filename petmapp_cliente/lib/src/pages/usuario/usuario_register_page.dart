import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
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
  TextEditingController otpCtrl = TextEditingController();
  bool submitValid = false;
  bool existenciaRut = false;
  bool existenciaEmail = false;

  final _formKey = GlobalKey<FormState>();
  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final _rutRegex = r"^(\d{1,2}(?:\.\d{1,3}){2}-[\dkK])$";

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
                //_txtCodigo(),
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
          //_calcularDigitoVerificador(rutCtrl.text);
          //_comprobarExistenciaRut(rutCtrl.text);
          if (value.isEmpty) {
            return 'Indique Rut';
          }
          // CALCULO VERIFICADOR //
          /* if (!RegExp(_rutRegex).hasMatch(value)) {
            return 'Rut invalido';
          } */
          return null;
        },
      ),
    );
  }

  _comprobarExistenciaRut(rut) async {
    var provider = UsuarioProvider();
    var usuarios = await provider.getUsuarios();
    for (var usuario in usuarios) {
      if (usuario['rut'] == rut) {
        existenciaRut = true;
      }
    }
  }

  _calcularDigitoVerificador(String rut) {
    var digitoVerificador = rut.replaceRange(0, 11, "");
    var verificador1 = int.tryParse(digitoVerificador);
    rut = rut.replaceRange(2, 3, "");
    rut = rut.replaceRange(5, 6, "");
    rut = rut.replaceRange(8, 10, "");
    var digitoRut = rut.trim().split("");
    int sumaTotal = 0;
    int contador = 7;
    for (var multiplicador = 2; contador >= 0;) {
      sumaTotal = sumaTotal + (int.parse(digitoRut[contador]) * multiplicador);
      if (multiplicador == 7) {
        multiplicador = 2;
      } else {
        multiplicador++;
      }
      contador--;
    }
    num truncado = (sumaTotal ~/ 11);
    num casi = truncado * 11;
    num verificador2 = sumaTotal - casi;
    print(verificador2);
    if (verificador1 == verificador2) {}
  }

  Widget _txtEmail() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: emailCtrl,
        // keyboardType: TextInputType.emailAddress,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.email, color: Colors.white70),
          hintText: "Email",
          /* suffixIcon: TextButton(
            child: Text('Enviar verificacion'),
            onPressed: () => sendOtp(),
          ), */
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
        validator: (value) {
          _comprobarExistenciaEmail(emailCtrl.text);
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

  Widget _txtCodigo() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
      child: TextFormField(
        controller: otpCtrl,
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          icon: Icon(Icons.email, color: Colors.white70),
          hintText: "Codigo",
          suffixIcon: TextButton(
            child: Text('Validar'),
            onPressed: () => verify(),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(color: Colors.white70)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.white70)),
          hintStyle: TextStyle(color: Colors.white70),
        ),
      ),
    );
  }

  _comprobarExistenciaEmail(email) async {
    var provider = UsuarioProvider();
    var usuarios = await provider.getUsuarios();
    for (var usuario in usuarios) {
      if (usuario['email'] == email) {
        existenciaEmail = true;
      }
    }
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
          if (existenciaEmail == true || existenciaRut == true) {
            Text('Usuario ya existente');
          } else {
            if (_formKey.currentState.validate()) {
              signUp(rutCtrl.text, emailCtrl.text, passwordCtrl.text,
                  nombreCtrl.text);
              Navigator.of(context).pop();
            }
          }
        },
      ),
    );
  }

  signUp(String rut, String email, String password, String nombre) async {
    var provider = UsuarioProvider();
    return await provider.registrar(rut, email, password, nombre);
  }

  void verify() {
    var res = (EmailAuth.validate(
        receiverMail: emailCtrl.text, userOTP: otpCtrl.text));
    if (res) {
      print('OTP VERIFICADO');
    } else {
      print('CODIGO INVALIDO');
    }
  }

  void sendOtp() async {
    EmailAuth.sessionName = "Test Session";
    bool result = await EmailAuth.sendOtp(receiverMail: emailCtrl.text);
    if (result) {
      print('Otp Sent');
      /* setState(() {
        submitValid = true;
      }); */
    } else {
      print('Otp dont sent');
    }
  }
}
