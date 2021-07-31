import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_listar_page.dart';
import 'package:petmapp_cliente/src/pages/alertas_tipos/tipos_alertas_listar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_listar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios/negocios_listar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_listar_page.dart';
import 'package:petmapp_cliente/src/pages/razas/raza_listar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones/ubicaciones_listar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones_tipos/tipos_ubicaciones_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_page.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/itemMenu.dart';

class AdministradorPagePage extends StatefulWidget {
  final int rutUsuario;
  AdministradorPagePage({this.rutUsuario});

  @override
  _AdministradorPagePageState createState() => _AdministradorPagePageState();
}

class _AdministradorPagePageState extends State<AdministradorPagePage> {
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
          title: Text('Administrador :) '),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
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
                    child: Column(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                  message: 'Lista de usuarios',
                                  child: ElevatedButton(
                                      child: Text('Usuarios'),
                                      onPressed: () =>
                                          _navegarListarUsuarios(context)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                  message: 'Especies Existentes',
                                  child: ElevatedButton(
                                      child: Text('Especies'),
                                      onPressed: () =>
                                          _navegarEspecies(context)),
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Razas Existentes',
                                    child: ElevatedButton(
                                        child: Text('Razas'),
                                        onPressed: () =>
                                            _navegarRazas(context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Alertass Existentes',
                                    child: ElevatedButton(
                                        child: Text('Alertas'),
                                        onPressed: () =>
                                            _navegarListarAlertas(context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Ubicaciones Existentes',
                                    child: ElevatedButton(
                                        child: Text('Ubicaciones'),
                                        onPressed: () =>
                                            _navegarListarUbicaciones(
                                                context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Negocios Existentes',
                                    child: ElevatedButton(
                                        child: Text('Negocios'),
                                        onPressed: () =>
                                            _navegarListarNegocios(context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Tipos de negocios existentes',
                                    child: ElevatedButton(
                                        child: Text('Tipos Negocios'),
                                        onPressed: () =>
                                            _navegarTiposNegocios(context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Tipos de ubicaciones existentes',
                                    child: ElevatedButton(
                                        child: Text('Tipos Ubicaciones'),
                                        onPressed: () =>
                                            _navegarTiposUbicaciones(
                                                context))))),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: Tooltip(
                                    message: 'Tipos de alertas existentes',
                                    child: ElevatedButton(
                                        child: Text('Tipos Alertas'),
                                        onPressed: () =>
                                            _navegarTiposAlertas(context))))),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = UsuarioProvider();
    return await provider.mostrarUsuario(widget.rutUsuario);
  }

  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferencess.getStringList('usuario')[3];
    });
  }

  PopupMenuItem<MenuItem> buildItem(MenuItem item) => PopupMenuItem<MenuItem>(
      value: item,
      child: Row(
        children: [Icon(item.icon, color: Colors.black), Text(item.text)],
      ));

  void onSelected(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.itemConfig:
      /* Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => UsuarioEditarPage()));
        break; */
      case MenuItems.itemSalir:
        /* sharedPreferences.clear();
        sharedPreferences.commit(); */
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
        break;
    }
  }

  _navegarListarUsuarios(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => UsuarioListarPage());
    Navigator.push(context, route);
  }

  _navegarEspecies(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => EspecieListarPage());
    Navigator.push(context, route);
  }

  _navegarRazas(BuildContext context) {
    var route = new MaterialPageRoute(builder: (context) => RazaListarPage());
    Navigator.push(context, route);
  }

  _navegarListarUbicaciones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => UbicacionesListarPage());
    Navigator.push(context, route);
  }

  _navegarListarAlertas(BuildContext context) {
    var route = new MaterialPageRoute(builder: (context) => AlertaListarPage());
    Navigator.push(context, route);
  }

  _navegarListarNegocios(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => NegociosListarPage());
    Navigator.push(context, route);
  }

  _navegarTiposAlertas(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => TipoAlertaListarPage());
    Navigator.push(context, route);
  }

  _navegarTiposUbicaciones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => TipoUbicacionListarPage());
    Navigator.push(context, route);
  }

  _navegarTiposNegocios(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => TipoNegocioListarPage());
    Navigator.push(context, route);
  }
}
