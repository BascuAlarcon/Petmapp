import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  String rut = '';

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Datos'),
        ),
        body: FutureBuilder(
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
                            child: TextField(
                              controller: emailCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Email',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: nameCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  hintText: 'Nombre',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: sexoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Sexo',
                                  hintText: 'Sexo',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fechaNacimientoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Fecha de Nacimiento',
                                  hintText: 'Fecha de Nacimiento',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fotoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Foto',
                                  hintText: 'Foto',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: numeroTelefonicoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Número telefonico',
                                  hintText: 'Número telefonico',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider()
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Guardar Cambios'),
                              onPressed: () => _usuarioEditar(context),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Cancelar'),
                              onPressed: () => _navegarCancelar(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            }));
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
    var provider = new UsuarioProvider();
    provider.perfilEditar(rut, emailCtrl.text, nameCtrl.text, sexoCtrl.text,
        fechaNacimientoCtrl.text, fotoCtrl.text, numeroTelefonicoCtrl.text);
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
