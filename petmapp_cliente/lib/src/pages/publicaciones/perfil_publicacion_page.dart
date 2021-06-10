import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmapp_cliente/src/pages/usuario/itemMenu.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPublicacionPage extends StatefulWidget {
  final int rut;
  PerfilPublicacionPage(this.rut);

  @override
  _PerfilPublicacionPageState createState() => _PerfilPublicacionPageState();
}

class _PerfilPublicacionPageState extends State<PerfilPublicacionPage> {
  SharedPreferences sharedPreferences;
  String token = '';
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mi Perfil'),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      ListTile(
                        title: Text('${snapshot.data['name']}'),
                        subtitle: Text('${snapshot.data['email']}'),
                      ),
                      Divider(color: Colors.black),
                      Text('Rut: ${snapshot.data['rut']}'),
                      snapshot.data['fecha_nacimiento'] != null
                          ? Text(
                              'Fecha nacimiento: ${snapshot.data['fecha_nacimiento']}')
                          : Text(''),
                      snapshot.data['sexo'] != null
                          ? Text('Sexo: ${snapshot.data['sexo']}')
                          : Text(''),
                      snapshot.data['foto'] != null
                          ? Text('Foto: ${snapshot.data['foto']}')
                          : Text(''),
                      snapshot.data['numero_telefonico'] != null
                          ? Text(
                              'Numero telefonico: ${snapshot.data['numero_telefonico']}')
                          : Text(''),
                      Expanded(child: Divider()),
                      Text('Evaluaciones...'),
                      Text('Mascotas...'),
                      Text('Hogares...'),
                    ]),
                  ),
                );
              }
            },
          ),
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
      token = sharedPreferencess.getStringList('usuario')[3];
    });
  }
}
