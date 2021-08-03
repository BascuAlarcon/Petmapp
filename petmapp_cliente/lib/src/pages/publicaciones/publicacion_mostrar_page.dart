import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_editar_page.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
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
  // DATA DEL USUARIO //
  String rut, email, estado, perfil, name, token = '';
  bool habilitado = false;
  bool usuarioHabilitado = true;
  // DATA DEL HOGAR //
  int tipoHogar, disponibilidadPatio;
  String direccion, descripcion, foto;

  // DATA DE LA PUBLICACION //
  String titulo;
  int idPeticion;
  bool peticionExistente = false;

  // OTROS //
  int contador = 0;
  dynamic snapshotData;
  dynamic snapshotDataUsuario;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    comprobarExistenciaPeticion();
    validarUsuario();
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
        flex: 2,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else {
                titulo = snapshot.data['titulo'];
                snapshotData = snapshot.data;
                return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: _mostrarDataPublicacion(snapshotData)),
                );
              }
            },
          ),
        ));
  }

  _mostrarDataPublicacion(snapshotData) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Fecha publicación: ${snapshotData['created_at'].replaceRange(10, 27, '')}',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                alignment: Alignment.centerRight,
                width: 200,
                height: 200,
                child: snapshotData['foto'] != 'xD'
                    ? Image(image: FileImage(File(foto)))
                    : Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tipoHogar == 0
                      ? Text('- El hogar es una casa')
                      : Text('- El hogar es un departamento'),
                  disponibilidadPatio == 0
                      ? Text('- Cuenta con patio')
                      : Text('- No cuenta con patio'),
                  Text(snapshotData['descripcion']),
                  Container(
                    child: Text(descripcion),
                  )
                  // PONER LA DATA DE LA PUBLICACIÓN
                ],
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(direccion),
            )
          ],
        ),
        Expanded(child: Divider()),
        widget.rutUsuario.toString() != rut
            ? _botones(snapshotData['usuario_rut'], snapshotData['id'])
            : Text('')
      ],
    );
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
                    snapshotDataUsuario = snapshot.data;
                    return Card(
                      child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: _mostrarDataUsuario(snapshotDataUsuario)),
                    );
                  }
                })));
  }

  _mostrarDataUsuario(snapshotData) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 150,
                  height: 150,
                  child: CircleAvatar(
                      child: ClipOval(
                          child: snapshotData['foto'] != 'xD'
                              ? Image(
                                  image: FileImage(File(snapshotData['foto'])))
                              : Image(
                                  image: NetworkImage(
                                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))))),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${snapshotData['name']}',
                    textAlign: TextAlign.start,
                  ),
                  Text('Usuario desde el ' +
                      '${snapshotData['created_at']}'.replaceRange(10, 27, '')),
                  Text('Nacio el: ' +
                      snapshotData['fecha_nacimiento'].toString()),
                  snapshotData['rut'].toString().length == 8
                      ? Text(snapshotData['rut']
                          .toString()
                          .replaceRange(7, 7, '-'))
                      : Text(snapshotData['rut']
                          .toString()
                          .replaceRange(8, 8, '-'))
                ],
              ))
            ],
          ),
        ),

        // SI TIENE NOTAS, MUESTRA CUANTAS SON Y EL PROMEDIO, SI NO, MUETRA UN MENSAJE CORRESPONDIENTE
        snapshotData['promedio_evaluaciones'] != null
            ? Text(
                'La calificación promedio del usuario es de ' +
                    snapshotData['promedio_evaluaciones'].toString() +
                    '/10' +
                    '\nEste usuario ha participado en ' +
                    contador.toString() +
                    ' servicios de cuidado',
                style: TextStyle(fontStyle: FontStyle.italic),
              )
            : Text('Aún no tiene calificaciones'),
      ],
    );
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
      return PeticionEditarPage(
        idPeticion: idPeticion,
        idPublicacion: idPublicacion,
      );
    });
    Navigator.push(context, route);
  }

  // FETCH DATA PUBLICACION
  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    setState(() {
      comprobarDatos();
    });
    var providerPublicacion = PublicacionProvider();
    var providerHogar = HogarProvider();
    var publicacion =
        await providerPublicacion.getpublicacion(widget.idPublicacion);
    // SE BUSCA LA DATA DEL HOGAR DE LA PUBLICACIÓN //
    var hogares = await providerHogar.hogarListar();
    for (var hogar in hogares) {
      if (hogar['id'] == publicacion['hogar_id']) {
        tipoHogar = hogar['tipo_hogar'];
        disponibilidadPatio = hogar['disponibilidad_patio'];
        direccion = hogar['direccion'];
        descripcion = hogar['descripcion'];
        foto = hogar['foto'];
      }
    }
    return publicacion;
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
                'Para poder hacer una petición, es necesario que usted agrege una mascota \n\nEsta información la puede completar en su perfil'),
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

  // FETCH DATA USUARIO
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

  validarUsuario() {
    if (widget.rutUsuario.toString() == rut) {
      usuarioHabilitado = false;
    }
  }
}
