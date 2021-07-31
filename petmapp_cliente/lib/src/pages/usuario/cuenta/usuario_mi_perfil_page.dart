import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/hogar/hogares_listar_page.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuenta/cambiar_password_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuenta/mis_publicaciones_usuario_listar.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuenta/usuario_editar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuario_login_page.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/comentarios_alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/comentarios_negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/comentarios_ubicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/itemMenu.dart';

class UsuarioPerfilPage extends StatefulWidget {
  final int rutUsuario,
      wrutOtro,
      wtipoUsuario,
      widDataPeticion,
      westado,
      widDataPublicacion,
      wnota,
      widHogar;
  final mascotas;
  final bool wultimoDia;
  UsuarioPerfilPage(
      {this.rutUsuario,
      this.wrutOtro,
      this.widDataPublicacion,
      this.widDataPeticion,
      this.wtipoUsuario,
      this.wultimoDia,
      this.westado,
      this.wnota,
      this.widHogar,
      this.mascotas});

  @override
  _UsuarioPerfilPageState createState() => _UsuarioPerfilPageState();
}

class _UsuarioPerfilPageState extends State<UsuarioPerfilPage> {
  SharedPreferences sharedPreferences;
  String token = '';
  var fechaNacimiento;

  String edadd;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    print(widget);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Mi Perfilardo',
              style: TextStyle(color: Colors.white, fontFamily: 'Raleway')),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(MdiIcons.arrowLeft),
              onPressed: () => Navigator.pop(context)),
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
                snapshot.data['fecha_nacimiento'] == null
                    ? null
                    : fechaNacimiento =
                        DateTime.parse(snapshot.data['fecha_nacimiento']);
                snapshot.data['fecha_nacimiento'] == null
                    ? null
                    : edadd = ecalcularEdad(fechaNacimiento);
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Container(
                            width: 200,
                            height: 200,
                            child: CircleAvatar(
                                child: ClipOval(
                                    child: snapshot.data['foto'] != 'xD'
                                        ? Image(
                                            image: FileImage(
                                                File(snapshot.data['foto'])))
                                        : Image(
                                            image: NetworkImage(
                                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))))),
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
                            ? snapshot.data['sexo'] == 0
                                ? Text('Hombre')
                                : Text('Mujer')
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
        _crearAlertaCuenta();
        break;
      case MenuItems.itemSalir:
        /* sharedPreferences.clear();
        sharedPreferences.commit(); */
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
        break;
    }
  }

  void _navegarEditarPerfil(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => UsuarioEditarPage(widget.rutUsuario));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarMisPublicaciones(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => MisPublicacionesPage(
              estado: widget.westado,
              idPublicacion: widget.widDataPublicacion,
            ));
    Navigator.push(context, route);
  }

  void _navegarCambiarPW(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => CambiarPasswordPage(
              rut: widget.rutUsuario,
            ));
    Navigator.push(context, route);
  }

  void _navegarListarMascotas(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => MascotaListarPage(mascotas: widget.mascotas));
    Navigator.push(context, route);
  }

  void _navegarListarHogares(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => HogarListarPage(
            idPeticion: widget.widDataPeticion,
            estado: widget.westado,
            idHogar: widget.widHogar));
    Navigator.push(context, route);
  }

  void _navegarListarPeticiones(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => MisPeticionesPage());
    Navigator.push(context, route);
  }

  _crearAlertaCuenta() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Mi cuenta', textAlign: TextAlign.center),
            children: [
              Text('¿Qué desea hacer?', textAlign: TextAlign.center),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                        child: Text('Editar mi perfil'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _navegarEditarPerfil(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                        child: Text('Cambiar contraseña'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _navegarCambiarPW(context),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 200,
                      child: ElevatedButton(
                        child: Text('Deshabilitar mi cuenta'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(199, 199, 183, 1.0)),
                        ),
                        onPressed: () => _alertaDeshabilitar(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  _alertaDeshabilitar() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Deshabilitar mi cuenta', textAlign: TextAlign.center),
            children: [
              Text('Ingrese su contraseña para confirmar',
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Contraseña",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text('¿Esta seguro de que desea deshabilitar su cuenta?',
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                    onPressed: () => _deshabilitarUsuario(),
                    child: Text('Si, estoy seguro')),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
              )
            ],
          );
        });
  }

  void _deshabilitarUsuario() async {
    var provider = UsuarioProvider();
    await provider.deshabilitar(widget.rutUsuario.toString(), '3');

    // BORRAMOS LAS ALERTAS Y SUS COMENTARIOS //
    var alertaProvider = AlertaProvider();
    var alertas = await alertaProvider.alertaListar();
    for (var alerta in alertas) {
      if (alerta['usuario_rut'] == widget.rutUsuario) {
        await alertaProvider.alertaBorrar(alerta['id']);
      }
    }

    // BORRAR COMENTARIOS ALERTA //
    var comentariosProvider = new ComentarioAlertaProvider();
    var comentarios = await comentariosProvider.comentarioListar();
    for (var comentario in comentarios) {
      if (comentario['usuario_rut'] == widget.rutUsuario) {
        await comentariosProvider.comentarioBorrar(comentario['id']);
      }
    }

    // BORRAR COMENTARIOS NEGOCIOS //
    var negocioComentarioProvider = ComentarioNegocioProvider();
    var negocios = await negocioComentarioProvider.comentarioListar();
    for (var negocio in negocios) {
      if (negocio['usuario_rut'] == widget.rutUsuario) {
        await negocioComentarioProvider.comentarioBorrar(negocio['id']);
      }
    }

    // BORRAR COMENTARIO UBICACIONES //
    var ubicacionComentarioProvider = ComentarioUbicacionProvider();
    var ubicaciones = await ubicacionComentarioProvider.comentarioListar();
    for (var ubicacion in ubicaciones) {
      if (ubicacion['usuario_rut'] == widget.rutUsuario) {
        await ubicacionComentarioProvider.comentarioBorrar(ubicacion['id']);
      }
    }

    // VALIDAR QUE NO HAY NADA ACCEPTADO ANTES DE BORRAR //

    // BORRAR PUBLICACIONES //
    var publicacionProvider = PublicacionProvider();
    var publicaciones = await publicacionProvider.publicacionListar();
    for (var publicacion in publicaciones) {
      if (publicacion['usuario_rut'] == widget.rutUsuario) {
        await publicacionProvider.publicacionesBorrar(publicacion['id']);
      }
    }

    // BORRAR PETICIONES //
    var peticionProvider = PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == widget.rutUsuario) {
        await peticionProvider.peticionesBorrar(peticion['id']);
      }
    }
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }
}
