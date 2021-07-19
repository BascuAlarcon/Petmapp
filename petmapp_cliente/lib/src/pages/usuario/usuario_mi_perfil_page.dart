import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_listar_page.dart';
import 'package:petmapp_cliente/src/pages/hogar/hogares_listar_page.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/mis_publicaciones_usuario_listar.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_editar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/itemMenu.dart';

class UsuarioPerfilPage extends StatefulWidget {
  final int rutUsuario;
  UsuarioPerfilPage({this.rutUsuario});

  @override
  _UsuarioPerfilPageState createState() => _UsuarioPerfilPageState();
}

class _UsuarioPerfilPageState extends State<UsuarioPerfilPage> {
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
          title: Text('Mi Perfil',
              style: TextStyle(color: Colors.white, fontFamily: 'Raleway')),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
          centerTitle: true,
          actions: [
            PopupMenuButton<MenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) =>
                  [...MenuItems.itemsFirst.map(buildItem).toList()],
            )
          ],
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
                var fechaNacimiento =
                    DateTime.parse(snapshot.data['fecha_nacimiento']);
                String edadd = ecalcularEdad(fechaNacimiento);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // ACÁ INSERTAR LA IMAGEN DE PERFIL
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://danbooru.donmai.us/data/sample/0f/ee/__kiryu_coco_hololive_drawn_by_beedrops__sample-0fee041361a8ad923821089770bddaca.jpg'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        ListTile(
                          title: Center(
                              child: Text(
                            '${snapshot.data['name']}',
                            style: TextStyle(fontSize: 23.0),
                          )),
                          subtitle:
                              Center(child: Text('${snapshot.data['email']}')),
                        ),
                        Center(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      120, 139, 255, 1.0)))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: Icon(Icons.favorite,
                                        color:
                                            Color.fromRGBO(120, 139, 255, 1.0)),
                                    onPressed: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      120, 139, 255, 1.0)))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: Icon(Icons.star_border,
                                        color:
                                            Color.fromRGBO(120, 139, 255, 1.0)),
                                    onPressed: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              side: BorderSide(
                                                  color: Color.fromRGBO(
                                                      120, 139, 255, 1.0)))),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                    ),
                                    child: Icon(Icons.warning,
                                        color:
                                            Color.fromRGBO(120, 139, 255, 1.0)),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(color: Colors.black),
                        Text('Rut: ${snapshot.data['rut']}'),
                        snapshot.data['fecha_nacimiento'] != null
                            ? Text('Edad: $edadd')
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
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Mis Mascotas'),
                                    onPressed: () =>
                                        _navegarListarMascotas(context)))),
                        Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Mis Publicaciones'),
                                    onPressed: () =>
                                        _navegarMisPublicaciones(context)))),
                        Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Hogares'),
                                    onPressed: () =>
                                        _navegarListarHogares(context)))),
                        Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Mis Peticiones'),
                                    onPressed: () =>
                                        _navegarListarPeticiones(context)))),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  String ecalcularEdad(DateTime fechaNacimiento) {
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    final fechaActual = new DateTime.now();
    final difference = daysBetween(fechaNacimiento, fechaActual);
    double edad = (difference / 365);
    final edadcortada = edad.toString().split('.');
    return edadcortada[0];
  }

  // <LinkedHashMap<String, dynamic>>
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
      case MenuItems.itemEditar:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UsuarioEditarPage(widget.rutUsuario)));
    }
  }

  void _navegarMisPublicaciones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => MisPublicacionesPage());
    Navigator.push(context, route);
  }

  void _navegarListarMascotas(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => MascotaListarPage());
    Navigator.push(context, route);
  }

  void _navegarListarHogares(BuildContext context) {
    var route = new MaterialPageRoute(builder: (context) => HogarListarPage());
    Navigator.push(context, route);
  }

  void _navegarListarPeticiones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => MisPeticionesPage());
    Navigator.push(context, route);
  }
}
