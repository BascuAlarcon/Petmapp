import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/main_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/cuidado_page.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class PeticionMostrarPage extends StatefulWidget {
  final int idPeticion;
  final int rutUsuario;
  var data;
  PeticionMostrarPage({this.idPeticion, this.rutUsuario});

  @override
  _PeticionMostrarPageState createState() => _PeticionMostrarPageState();
}

class _PeticionMostrarPageState extends State<PeticionMostrarPage> {
  DateTime _inicio, _fin;
  String fechaInicio = '';
  String fechaFin = '';
  String precioTotal = '';

  @override
  void initState() {
    super.initState();
    _cargarListaRazas();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Petición de cuidado'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [
            _datosUsuario(),
            _datosPeticion(),
          ],
        ));
  }

  Widget _datosPeticion() {
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
              var data = snapshot.data;
              _inicio = DateTime.parse(snapshot.data['fecha_inicio']);
              _fin = DateTime.parse(snapshot.data['fecha_fin']);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                            'Fecha en que inicia el cuidado: ${snapshot.data['fecha_inicio']} '),
                        subtitle: Text(
                            '    Fecha en que finaliza el cuidado: ${snapshot.data['fecha_fin']}'),
                      ),
                      Text('Monto a pagar: ' +
                          snapshot.data['precio_total'].toString()),
                      Expanded(
                        child: _mostrarMascotas(snapshot.data['mascotas']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () => _mostrarConfirmacion(
                                      context,
                                      snapshot.data['fecha_inicio'],
                                      snapshot.data['fecha_fin'],
                                    ),
                                child: Text('Responder Petición'))),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _datosUsuario() {
    return Center(
      child: Container(
          child: FutureBuilder(
        future: _fetchUsuario(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('loading...');
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: 200,
                    height: 200,
                    child: CircleAvatar(
                        child: ClipOval(
                            child: snapshot.data['foto'] != 'xD'
                                ? Image(
                                    image:
                                        FileImage(File(snapshot.data['foto'])))
                                : Image(
                                    image: NetworkImage(
                                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))))),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        snapshot.data['sexo'] == 0
                            ? Text((snapshot.data['name'] + ', Hombre'))
                            : Text((snapshot.data['name'] + ', Mujer')),
                        Text('Fecha de nacimiento: ' +
                            snapshot.data['fecha_nacimiento']),
                        snapshot.data['promedio_evaluaciones'] == null
                            ? Text(
                                'Promedio de evaluaciones: Aún sin evaluaciones')
                            : Text('Promedio de evaluaciones: ' +
                                snapshot.data['promedio_evaluaciones']
                                    .toString()),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      )),
    );
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PeticionProvider();
    return await provider.getpeticion(widget.idPeticion);
  }

  Future<LinkedHashMap<String, dynamic>> _fetchUsuario() async {
    var provider = UsuarioProvider();
    return await provider.mostrarUsuario(widget.rutUsuario);
  }

  _mostrarConfirmacion(BuildContext context, fechaInicio, fechaFin) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Responder Petición'),
            content: Text('¿Desea acceptar esta petición?'),
            actions: [
              ElevatedButton(
                  child: Text('Volver'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              MaterialButton(
                  child: Text('No',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  onPressed: () =>
                      peticionResponder('3', fechaInicio, fechaFin)),
              ElevatedButton(
                  child: Text('Si'),
                  onPressed: () =>
                      peticionResponder('2', fechaInicio, fechaFin))
            ],
          );
        });
  }

  Widget _mostrarMascotas(List<dynamic> mascotas) {
    return ListView.separated(
      itemCount: mascotas.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        return Wrap(
          children: [
            Image(
                height: 200,
                width: 500,
                image: FileImage(File(mascotas[index]['foto']))),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  razasLista[mascotas[index]['raza_id']]['especie_id'] == 1
                      ? Text(
                          '  ' +
                              mascotas[index]['nombre'] +
                              ', Perro ' +
                              razasLista[mascotas[index]['raza_id']]['nombre'],
                          textAlign: TextAlign.center,
                        )
                      : Text(
                          '  ' +
                              mascotas[index]['nombre'] +
                              ', Gato ' +
                              razasLista[mascotas[index]['raza_id']]['nombre'],
                          textAlign: TextAlign.center,
                        ),
                  Text('Alimentos: ' + mascotas[index]['alimentos']),
                  Text('Personalidad: ' + mascotas[index]['personalidad']),
                  mascotas[index]['condicion_medica'] == 0
                      ? Text('Sano')
                      : Text('Enfermo'),
                  mascotas[index]['estirilizacion'] == 0
                      ? Text('Esta estirilizado')
                      : Text('No esta esterilizado'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  int cont = 0;
  List<dynamic> razasLista = [];

  _cargarListaRazas() async {
    for (var i = 0; i < 100; i++) {
      razasLista.add(i);
    }
    var provider = RazasProvider();
    var razas = await provider.getRazas();
    for (var raza in razas) {
      razasLista[raza['id']] = raza;
    }
  }

  void peticionResponder(String respuesta, fechaInicio, fechaFin) {
    var provider = PeticionProvider();
    if (respuesta == '2') {
      borrarOtrasPeticiones();
    }
    provider.peticionRespuesta(widget.idPeticion, respuesta);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => MainPage()),
        (Route<dynamic> route) => false);
  }

  void borrarOtrasPeticiones() async {
    var provider = PeticionProvider();
    var peticiones = await provider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == widget.rutUsuario &&
          peticion['id'].toString() != widget.idPeticion.toString()) {
        if (DateTime.parse(peticion['fecha_inicio']).compareTo(_inicio) >= 0) {
          if (DateTime.parse(peticion['fecha_inicio']).compareTo(_fin) <= 0) {
            provider.peticionesBorrar(peticion['id']);
            print(peticion);
          }
        }
      }
    }
  }
}
