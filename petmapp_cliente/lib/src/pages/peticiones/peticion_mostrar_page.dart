import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';

class PeticionMostrarPage extends StatefulWidget {
  final int idPeticion;
  PeticionMostrarPage({this.idPeticion});

  @override
  _PeticionMostrarPageState createState() => _PeticionMostrarPageState();
}

class _PeticionMostrarPageState extends State<PeticionMostrarPage> {
  String fechaInicio = '';
  String fechaFin = '';
  String precioTotal = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Peticion número ${widget.idPeticion}'),
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
                        ListTile(
                          title:
                              Text('Usuario: ${snapshot.data['usuario_rut']}'),
                          subtitle: Text(
                            'VER PERFIL DEL USUARIO',
                            style: TextStyle(color: Colors.black),
                          ),
                          leading: Icon(MdiIcons.account),
                          tileColor: Colors.blue,
                          onTap: () => _navegarPerfilUsuario(
                              context, snapshot.data['usuario_rut']),
                        ),
                        Divider(color: Colors.black),
                        Expanded(
                          child: ListTile(
                            title: Text(
                                'Fecha de la petición: ${snapshot.data['created_at']}'),
                          ),
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
                                      snapshot.data['precio_total']),
                                  child: Text('Responder Petición'))),
                        )
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
    var provider = PeticionProvider();
    return await provider.getpeticion(widget.idPeticion);
  }

  _mostrarConfirmacion(BuildContext context, fechaInicio, fechaFin, precio) {
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
                      peticionResponder('3', fechaInicio, fechaFin, precio)),
              ElevatedButton(
                  child: Text('Si'),
                  onPressed: () =>
                      peticionResponder('2', fechaInicio, fechaFin, precio))
            ],
          );
        });
  }

  void peticionResponder(String respuesta, fechaInicio, fechaFin, precio) {
    var provider = PeticionProvider();
    provider.peticionRespuesta(widget.idPeticion, respuesta,
        fechaInicio.toString(), fechaFin.toString(), precio.toString());
    Navigator.of(context).pop();
  }
}

_navegarPerfilUsuario(BuildContext context, int rut) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) {
    return PeticionMostrarPage(
      idPeticion: rut,
    );
  });
  Navigator.push(context, route);
}
