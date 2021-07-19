import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioEditarPage extends StatefulWidget {
  final int rut;
  UsuarioEditarPage(this.rut);

  @override
  _UsuarioEditarPageState createState() => _UsuarioEditarPageState();
}

class _UsuarioEditarPageState extends State<UsuarioEditarPage> {
  // Controllers //
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController nameCtrl = new TextEditingController();
  TextEditingController sexoCtrl = new TextEditingController();
  TextEditingController fechaNacimientoCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController numeroTelefonicoCtrl = new TextEditingController();
  var _sexo = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var sexo = '';

  bool _validate = false;
  DateTime _fechaNacimiento;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarSexo();
  }

  String rut = '';
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar datos'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No hay data'),
                  );
                } else {
                  emailCtrl.text = snapshot.data['email'];
                  nameCtrl.text = snapshot.data['name'];
                  snapshot.data['sexo'] != null
                      ? sexoCtrl.text = snapshot.data['sexo'].toString()
                      : sexoCtrl.text = '';
                  fechaNacimientoCtrl.text = snapshot.data['fecha_nacimiento'];
                  fotoCtrl.text = snapshot.data['foto'];
                  snapshot.data['sexo'] != null
                      ? numeroTelefonicoCtrl.text =
                          snapshot.data['numero_telefonico'].toString()
                      : numeroTelefonicoCtrl.text = '';
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: emailCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Email',
                                    hintText: 'Email',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar un email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nameCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Nombre',
                                    hintText: 'Nombre',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar su nombre';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: DropdownButtonFormField(
                                value: _valorSeleccionado,
                                items: _sexo,
                                hint: Text('Sexo'),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                onChanged: (value) {
                                  setState(() {
                                    sexo = value.toString();
                                    _valorSeleccionado = value;
                                  });
                                },
                                validator: (valor) {
                                  if (valor == null) {
                                    return 'Seleccione un valor';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: fechaNacimientoCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Fecha de Nacimiento',
                                    hintText: 'Fecha de Nacimiento',
                                    suffixIcon: Icon(Icons.flag)),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: TextFormField(
                                controller: fechaNacimientoCtrl,
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate:
                                              fechaNacimientoCtrl == null
                                                  ? DateTime.now()
                                                  : _fechaNacimiento,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now())
                                      .then((value) => setState(() {
                                            _fechaNacimiento = value;
                                            fechaNacimientoCtrl.text =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(value)
                                                    .toString();
                                          }));
                                  // fechaNacimientoCtrl.text =
                                  //     DateFormat('dd-MM-yyyy')
                                  //         .format(_fechaNacimiento)
                                  //         .toString();
                                },
                                /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  labelText: 'Fecha de nacimiento',
                                  hintText: 'Fecha de nacimiento',
                                  suffixIcon: Icon(Icons.date_range),
                                  errorText: _validate
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: numeroTelefonicoCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Número telefonico',
                                    hintText: 'Número telefonico',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar su número telefonico';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider()
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: 180,
                              child: ElevatedButton(
                                child: Text('Volver'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(199, 199, 183, 1.0)),
                                ),
                                onPressed: () => _navegarCancelar(context),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: 180,
                              child: ElevatedButton(
                                child: Text('Guardar Cambios'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(120, 139, 255, 1.0)),
                                ),
                                onPressed: () => _usuarioEditar(context),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = UsuarioProvider();
    return await provider.mostrarUsuario(widget.rut);
  }

  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
    });
  }

  void _usuarioEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new UsuarioProvider();
      provider.perfilEditar(rut, emailCtrl.text, nameCtrl.text, sexo,
          fechaNacimientoCtrl.text, fotoCtrl.text, numeroTelefonicoCtrl.text);
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarSexo() async {
    _sexo.add(DropdownMenuItem(child: Text("Superior"), value: 0));
    _sexo.add(DropdownMenuItem(child: Text("Inferior"), value: 1));
  }
}
