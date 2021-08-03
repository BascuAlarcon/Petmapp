import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/servicios/servicios_listar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuidado_perfil_page.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuidadoPage extends StatefulWidget {
  final int wrutUsuario,
      wtipoUsuario,
      widData,
      westado,
      widDataPublicacion,
      wnota;
  final bool wultimoDia;
  CuidadoPage(
      {this.wrutUsuario,
      this.widDataPublicacion,
      this.widData,
      this.wtipoUsuario,
      this.wultimoDia,
      this.westado,
      this.wnota});
  @override
  _CuidadoPageState createState() => _CuidadoPageState();
}

class _CuidadoPageState extends State<CuidadoPage> {
  String rut = '';
  String email = '';
  String token = '';
  String estado = '';
  String name = '';
  String perfil = '';

  bool finalizar = false;
  bool intento = true;
  bool mostrarEvaluacion = false;
  int idPeticion;
  int rutOtro;
  int tipoUsuario;
  int rutUsuario;
  int id;
  int contador = 0;
  double _valorActual = 0;
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController notaCtrl = new TextEditingController();
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    if (widget.westado == 6 || widget.westado == 7) {
      if (widget.wnota != 11 || widget.wnota == null) {
        mostrarEvaluacion = true;
      }
    }
    if (widget.wnota == 1) {
      finalizar = true;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Servicio de Cuidado'),
          actions: [
            widget.wultimoDia &&
                    (widget.westado == 2 || widget.westado == 5) &&
                    (widget.wnota == null || widget.wnota == 11) &&
                    finalizar == false
                ? IconButton(
                    icon: Icon(MdiIcons.alert),
                    onPressed: () {
                      _dialogoFin(context);
                    })
                : Text('')
          ],
        ),
        body: Column(
          children: [
            verDataPeticion(),
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

  Widget verDataPeticion() {
    return Expanded(
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
                        title: Text('VER PERFIL DEL USUARIO'),
                        leading: Icon(MdiIcons.account),
                        tileColor: Colors.blue,
                        onTap: () => _navegarPerfilUsuario(context)),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            'Fecha de la petición: del ${snapshot.data['fecha_inicio']} al ${snapshot.data['fecha_fin']}'),
                      ],
                    ),
                    Text(
                        'Precio total del cuidado: ${snapshot.data['boleta']}'),
                    widget.wtipoUsuario == 1
                        ? Column()
                        : buttonServicios(context, snapshot.data['id'],
                            snapshot.data['boleta']),
                    mostrarEvaluacion ? buttonEvaluaciones() : Text(''),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _dialogoFin(context) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Último día del cuidado', textAlign: TextAlign.center),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Sólo debe finalizar el servicio una vez las mascotas fueron entregadas.',
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('¿Desea finalizar el servicio?',
                    textAlign: TextAlign.center),
              ),
              ElevatedButton(
                  onPressed: () => _finalizarServicio(),
                  child: Text('Finalizar'),
                  style: ButtonStyle()),
            ],
          );
        });
  }

  _finalizarServicio() async {
    var provider = PeticionProvider();
    var peticion = await provider.getpeticion(widget.widData);
    if (peticion['estado'] == 2) {
      await provider.peticionTerminada(widget.widData.toString(), '5');
      if (widget.wtipoUsuario == 2) {
        var providerPublicacion = PublicacionProvider();
        await providerPublicacion.publicacionComentario(
            widget.widDataPublicacion, 'Sinco', '1');
      }
      setState(() {
        finalizar = true;
      });
      Navigator.of(context).pop();
    }
    // AHORA PUEDEN DAR FIN AL SERVICIO //
    if (peticion['estado'] == 5) {
      await provider.peticionTerminada(widget.widData.toString(), '6');
      if (widget.wtipoUsuario == 1) {
        await provider.peticionComentario(widget.widData, 'Sinco', '1');
      }
      setState(() {
        finalizar = true;
        mostrarEvaluacion = true;
      });
      Navigator.of(context).pop();
    }
    // AHORA SE PUEDEN EVALUAR //
    if (peticion['estado'] == 6) {
      await provider.peticionTerminada(widget.widData.toString(), '7');
      Navigator.of(context).pop();
    }
    if (peticion['estado'] == 7) {
      await provider.peticionTerminada(widget.widData.toString(), '4');
      Navigator.of(context).pop();
    }
  }

  /* print('Datos del cuidador:\nTipo de usuario: ' +
                tipoUsuario.toString() +
                '\nID de la publicacion: ' +
                id.toString() +
                '\nRut: ' +
                publicacion['usuario_rut'].toString()); */

  /* _fetchData() async {
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
          id = peticion['id'];
          for (var publicacion in publicaciones) {
            if (publicacion['id'] == peticion['publicacion_id']) {
              rutOtro = publicacion['usuario_rut'];
              DateTime fechaFin = DateTime.parse(peticion['fecha_fin']);
              var today = DateTime.now();
              if (fechaFin.compareTo(today) < 0) {
                _ultimoDia = true;
              }
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
                id = peticion['id'];
                DateTime fechaFin = DateTime.parse(peticion['fecha_fin']);
                var today = DateTime.now();
                if (fechaFin.compareTo(today) < 0) {
                  _ultimoDia = true;
                }
              }
            }
          }
        }
      }
    }
  } */

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PeticionProvider();
    return await provider.getpeticion(widget.widData);
  }
  // USUARIO 1 == DUEÑO DE LAS MASCOTAS
  // USUARIO 2 == CUIDADOR DE LAS MASCOTAS

  Future<List<dynamic>> _fetchServicios() async {
    var provider = ServiciosProvider();
    return await provider.serviciosPeticion(widget.widData);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Servicios Adicionales'),
                onPressed: () => _navegarServicios(context, id, boleta)))
      ],
    );
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

  /* _navegarMainPage(context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
        (Route<dynamic> route) => false);
  } */

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

  Future<void> enviarComentariosDuenio() async {
    var provider = PublicacionProvider();
    var providerPeticion = PeticionProvider();
    var peticion = await providerPeticion.getpeticion(widget.widData);
    if (peticion['nota'] == null || peticion['nota'] == 1) {
      await providerPeticion.peticionComentario(
          widget.widData, 'Sin comentarios', '11');
    }
    mostrarEvaluacion = false;
    await provider.publicacionComentario(
        widget.widDataPublicacion, descripcionCtrl.text, notaCtrl.text);
    _finalizarServicio();
  }

  Future<void> enviarComentariosCuidador() async {
    var provider = PeticionProvider();
    var providerPublicacion = PublicacionProvider();
    var publicacion =
        await providerPublicacion.getpublicacion(widget.widDataPublicacion);
    if (publicacion['nota'] == null || publicacion['nota'] == 1) {
      await providerPublicacion.publicacionComentario(
          widget.widDataPublicacion, 'Sin comentarios', '11');
    }

    mostrarEvaluacion = false;
    await provider.peticionComentario(
        widget.widData, descripcionCtrl.text, notaCtrl.text);
    _finalizarServicio();
  }

  _mostrarConfirmacion(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: widget.wtipoUsuario == 1
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
                child: TextField(
                  controller: notaCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Nota',
                      hintText: 'Añada una nota a su comentario',
                      suffixIcon: Icon(MdiIcons.accountBox)),
                ),
              ),
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
                  _calcularPromedioNotas(
                      widget.wrutUsuario, int.tryParse(notaCtrl.text));
                  widget.wtipoUsuario == 1
                      ? enviarComentariosDuenio()
                      : enviarComentariosCuidador();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _calcularPromedioNotas(int rut, int nota) async {
    var usuarioProvider = UsuarioProvider();
    var peticionProvider = PeticionProvider();
    var publicacionProvider = PublicacionProvider();
    var usuario = await usuarioProvider.mostrarUsuario(rut);
    var publicaciones = await publicacionProvider.publicacionListar();
    var peticiones = await peticionProvider.peticionListar();
    int cantidadTotales = 0;
    int sumaNotas = 0;
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == rut && peticion['estado'] == 4) {
        cantidadTotales++;
        sumaNotas = sumaNotas + peticion['nota'];
      }
    }
    for (var publicacion in publicaciones) {
      if (publicacion['usuario_rut'] == rut) {
        for (var peticion in peticiones) {
          if (peticion['usuario_rut'] == rut && peticion['estado'] == 4) {
            cantidadTotales++;
            sumaNotas = sumaNotas + publicacion['nota'];
          }
        }
      }
    }
    cantidadTotales++;
    sumaNotas = sumaNotas + nota;
    var promedioUsuario = sumaNotas / cantidadTotales;
    await usuarioProvider.promedio(rut.toString(), promedioUsuario.toString());
  }
}
