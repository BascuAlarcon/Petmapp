import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/perfil_usuario_page.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionMostrarPage extends StatefulWidget {
  final int idPublicacion;
  final int rutUsuario;
  PublicacionMostrarPage({this.idPublicacion, this.rutUsuario});

  @override
  _PublicacionMostrarPageState createState() => _PublicacionMostrarPageState();
}

class _PublicacionMostrarPageState extends State<PublicacionMostrarPage> {
  String rut, email, estado, perfil, name, token = '';
  bool habilitado = false;
  bool peticionExistente = false;
  int idPeticion;
  int contador = 0;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    comprobarExistenciaPeticion();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Ver Publicación'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [_dataUsuario(), _dataPublicacion()],
        ));
  }

  Widget _dataPublicacion() {
    return Expanded(
        child: Container(
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
                    ListTile(
                      title:
                          Text('descripcion: ' + snapshot.data['descripcion']),
                      subtitle: Text(
                          'Fecha publicación: ${snapshot.data['created_at']}'),
                    ),
                    ListTile(
                      title:
                          Text('Precio por día: ${snapshot.data['tarifa']}clp'),
                    ),
                    Expanded(child: Divider()),
                    _botones(snapshot.data['usuario_rut'], snapshot.data['id'])
                  ],
                ),
              ),
            );
          }
        },
      ),
    ));
  }

  Widget _dataUsuario() {
    return Expanded(
        child: Container(
            child: FutureBuilder(
                future: _fetchUsuario(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  } else {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image(
                                image: NetworkImage(
                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                                height: 200,
                              ),
                            ),
                            ListTile(
                              title: Text('${snapshot.data['name']}'),
                              subtitle: Text(
                                  'Usuario creado hace: ${snapshot.data['created_at']}'),
                            ),
                            // SI TIENE NOTAS, MUESTRA CUANTAS SON Y EL PROMEDIO, SI NO, MUETRA UN MENSAJE CORRESPONDIENTE
                            snapshot.data['promedio_evaluaciones'] != null
                                ? Text('Promedio de notas: ' +
                                    snapshot.data['promedio_evaluaciones']
                                        .toString() +
                                    '\nNúmero de servicios: ' +
                                    contador.toString())
                                : Text('Aún no tiene calificaciones'),
                          ],
                        ),
                      ),
                    );
                  }
                })));
  }

  Widget _botones(rutUsuarioPerfil, idPublicacion) {
    return Column(children: [
      peticionExistente == true
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      child: Text('Editar peticion'),
                      onPressed: () => habilitado == true
                          ? _navegarEditarPeticion(context, idPublicacion)
                          : _mostrarAviso(context))))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      child: Text('Agregar peticion'),
                      onPressed: () => habilitado == true
                          ? _navegarAgregarPeticion(context, idPublicacion)
                          : _mostrarAviso(context))))
    ]);
  }

  _navegarAgregarPeticion(BuildContext context, int idPublicacion) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PeticionesAgregarPage(idPublicacion: idPublicacion);
    });
    Navigator.push(context, route).then((value) {
      setState(() {
        comprobarExistenciaPeticion();
      });
    });
  }

  _navegarEditarPeticion(BuildContext context, int idPublicacion) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PeticionEditarPage(idPeticion: idPeticion);
    });
    Navigator.push(context, route);
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    setState(() {
      comprobarDatos();
    });
    var provider = PublicacionProvider();
    return await provider.getpublicacion(widget.idPublicacion);
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
      perfil = sharedPreferencess.getStringList('usuario')[3];
      token = sharedPreferencess.getStringList('usuario')[4];
      estado = sharedPreferencess.getStringList('usuario')[5];
    });
    var provider = MascotaProvider();
    var mascotas = await provider.mascotaListar();

    for (var mascota in mascotas) {
      if (mascota['usuario_rut'] == rut) {
        habilitado = true;
      }
    }
  }

  // COMPROBAR QUE EL USUARIO TENGA MASCOTAS //
  Future<void> comprobarDatos() async {
    var provider = MascotaProvider();
    var mascotas = await provider.mascotaListar();

    for (var mascota in mascotas) {
      if (mascota['usuario_rut'].toString() == rut) {
        habilitado = true;
      }
    }
  }

  // COMPROBAR QUE NO EXISTA UNA PETICIÓN YA CREADA //
  Future<void> comprobarExistenciaPeticion() async {
    var provider = PeticionProvider();
    var peticiones = await provider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'].toString() == rut &&
          peticion['publicacion_id'] == widget.idPublicacion) {
        peticionExistente = true;
        idPeticion = peticion['id'];
      }
    }
  }

  _mostrarAviso(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Es necesario completar los siguientes datos: '),
            content: Text(
                'Para poder hacer una petición, es necesario que usted agrege una mascota \nEsta información la puede completar en su perfil'),
            actions: [
              MaterialButton(
                  child: Text('Acceptar',
                      style: TextStyle(
                        color: Colors.blueAccent,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<LinkedHashMap<String, dynamic>> _fetchUsuario() async {
    var provider = UsuarioProvider();
    _contarEvaluaciones(widget.rutUsuario);
    return await provider.mostrarUsuario(widget.rutUsuario);
  }

  _contarEvaluaciones(rutUsuario) async {
    var publicacionProvider = PublicacionProvider();
    var publicaciones = await publicacionProvider.publicacionListar();
    for (var publicacion in publicaciones) {
      if (publicacion['usuario_rut'] == rutUsuario) {
        if (publicacion['nota'] != null) {
          contador++;
        }
      }
    }
    // AÚN NO ESTAN LOS CAMPOS DE NOTA Y COMENTARIO EN LA BD //
    var peticionProvider = PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == rutUsuario) {
        if (peticion['nota'] != null) {
          contador++;
        }
      }
    }
    return contador;
  }
}
