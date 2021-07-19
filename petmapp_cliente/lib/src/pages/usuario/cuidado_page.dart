import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/servicios/servicios_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuidado_perfil_page.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuidadoPage extends StatefulWidget {
  @override
  _CuidadoPageState createState() => _CuidadoPageState();
}

class _CuidadoPageState extends State<CuidadoPage> {
  String rut = '';
  int rutOtro;
  String email = '';
  String token = '';
  String estado = '';
  String name = '';
  String perfil = '';

  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController notaCtrl = new TextEditingController();
  int tipoUsuario;
  int rutUsuario;
  int id;
  int contador = 0;
  double _valorActual = 0;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Servicio de Cuidado'),
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text('Loading...');
                  } else {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView(
                          children: [
                            ListTile(
                                title: Text(
                                    'Usuario: ${snapshot.data['usuario_rut']}'),
                                subtitle: Text(
                                  'VER PERFIL DEL USUARIO',
                                  style: TextStyle(color: Colors.black),
                                ),
                                leading: Icon(MdiIcons.account),
                                tileColor: Colors.blue,
                                onTap: () => _navegarPerfilUsuario(context)),
                            //
                            Divider(color: Colors.black),
                            ListTile(
                              title: Text(
                                  'Fecha de la petición: ${snapshot.data['fecha_inicio']}'),
                              subtitle: Text(
                                  'Precio del servicio: ${snapshot.data['boleta']}'),
                            ),
                            tipoUsuario == 1
                                ? Column()
                                : buttonServicios(context, snapshot.data['id'],
                                    snapshot.data['boleta']),
                            buttonEvaluaciones() // VALIDAR QUE SEA POST snapshot.data['fecha_fin]
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _fetchServicios(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text('Loading...');
                    } else {
                      List<dynamic> safeCards = snapshot.data;
                      return Column(
                        children: [
                          Text('Lista de servicios'),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _refresh(),
                              child: ListView.builder(
                                itemCount: safeCards.length,
                                itemBuilder: (context, index) {
                                  return Slidable(
                                    actionPane: SlidableDrawerActionPane(),
                                    actionExtentRatio: 0.25,
                                    child: ListTile(
                                      leading: Icon(MdiIcons.dogService),
                                      title: Text(
                                          '${snapshot.data[index]['comentario']}'),
                                      subtitle: Text(
                                          'Costo: ${snapshot.data[index]['monto'].toString()}'),
                                      onTap: () {},
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }),
            )
          ],
        ));
  }

  /* print('Datos del cuidador:\nTipo de usuario: ' +
                tipoUsuario.toString() +
                '\nID de la publicacion: ' +
                id.toString() +
                '\nRut: ' +
                publicacion['usuario_rut'].toString()); */

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PeticionProvider();
    var peticiones = await provider.peticionListar();
    var providerPublicacion = PublicacionProvider();
    var publicaciones = await providerPublicacion.publicacionListar();
    for (var peticion in peticiones) {
      // AGREGAR OTRA VALIDACION: QUE PETICION['FECHA_INICIO'] == HOY //
      if (peticion['estado'] == 2) {
        // buscamos si es el dueño
        if (peticion['usuario_rut'].toString() == rut) {
          tipoUsuario = 1;
          for (var publicacion in publicaciones) {
            if (publicacion['id'] == peticion['publicacion_id']) {
              rutOtro = publicacion['usuario_rut'];
              break;
            }
          }
        }
        // buscamos si es el cuidador
        for (var publicacion in publicaciones) {
          if (publicacion['usuario_rut'].toString() == rut &&
              publicacion['id'] == peticion['publicacion_id']) {
            tipoUsuario = 2;
            for (var peticion in peticiones) {
              if (publicacion['id'] == peticion['publicacion_id']) {
                rutOtro = peticion['usuario_rut'];
                break;
              }
            }
          }
        }
      }
    }

    var provi = PeticionProvider();
    return await provi.getpeticion(id);
  }
  // USUARIO 1 == DUEÑO DE LAS MASCOTAS
  // USUARIO 2 == CUIDADOR DE LAS MASCOTAS

  Future<List<dynamic>> _fetchServicios() async {
    var provider = ServiciosProvider();
    return await provider.serviciosPeticion(id);
  }

  Future<Null> _refresh() async {
    await _fetchServicios();
    setState(() {});
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
  }

  buttonServicios(BuildContext context, int id, int boleta) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Servicios Adicionales'),
                onPressed: () => _navegarServicios(context, id, boleta))));
  }

  buttonEvaluaciones() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Evaluar el servicio!'),
                onPressed: () => _mostrarConfirmacion(context))));
  }

  _navegarServicios(BuildContext context, int id, int boleta) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ServicioListarPage(idPeticion: id, boleta: boleta);
    });
    Navigator.push(context, route);
  }

  _navegarPerfilUsuario(BuildContext context) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PerfilCuidadoPage(rutUsuario: rutOtro);
    });
    Navigator.push(context, route);
  }

  _contarEvaluaciones() async {
    var publicacionProvider = PublicacionProvider();
    var publicaciones = await publicacionProvider.publicacionListar();
    for (var publicacion in publicaciones) {
      if (publicacion['usuario_rut'] == rut) {
        if (publicacion['nota'] != null) {
          contador++;
        }
      }
    }
    // AÚN NO ESTAN LOS CAMPOS DE NOTA Y COMENTARIO EN LA BD //
    var peticionProvider = PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == rut) {
        if (peticion['nota'] != null) {
          contador++;
        }
      }
    }
    return contador;
  }

  Future<void> enviarComentariosDuenio() async {
    var provider = PublicacionProvider();
    var cont = _contarEvaluaciones();
    return await provider.publicacionComentario(
        id, descripcionCtrl.text, _valorActual.toString());
  }

  Future<void> enviarComentariosCuidador() async {
    var provider = PeticionProvider();
    var cont = _contarEvaluaciones();
    return await provider.peticionComentario(
        id, descripcionCtrl.text, _valorActual.toString());
  }

  _mostrarConfirmacion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: tipoUsuario == 1
                ? Text('Evaluar al cuidador')
                : Text('Evaluar al dueño'),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: descripcionCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Comentario',
                      hintText: 'Añada una descripcion a su comentario',
                      suffixIcon: Icon(MdiIcons.accountBox)),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slider(
                    value: _valorActual,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: _valorActual.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _valorActual = value;
                      });
                    },
                  )),
              MaterialButton(
                  child: Text('Volver',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                child: Text('Enviar :)'),
                onPressed: () {
                  tipoUsuario == 1
                      ? enviarComentariosDuenio()
                      : enviarComentariosCuidador();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
