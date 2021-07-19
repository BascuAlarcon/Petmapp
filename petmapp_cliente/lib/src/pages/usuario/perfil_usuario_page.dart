import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:petmapp_cliente/src/pages/Models/itemMenu.dart';
import 'package:petmapp_cliente/src/pages/usuario/sharedPreferences.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_evaluaciones_peticiones_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_evaluaciones_publicaciones_page.dart';
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
          title: Text('Perfil del usuario'),
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
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text('Evaluaciones de Publicaciones'),
                                  onPressed: () =>
                                      _navegarListarPublicaciones(context)))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text('Evaluaciones de Peticiones'),
                                  onPressed: () =>
                                      _navegarListarPeticiones(context)))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text('Mascotas'),
                                  onPressed: () =>
                                      _navegarListarMascotas(context)))),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                  child: Text('Hogares'),
                                  onPressed: () =>
                                      _navegarListarHogares(context)))),
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

  _navegarListarHogares(BuildContext context) {}

  _navegarListarMascotas(BuildContext context) {}

  _navegarListarPeticiones(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) =>
            UsuarioEvaluacionPeticionListarPage(rut: widget.rut));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  _navegarListarPublicaciones(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => UsuarioEvaluacionPublicacionListarPage(
              rut: widget.rut,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }
}
