import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';

class AlertaMostrarPage extends StatefulWidget {
  final int idPeticion;
  AlertaMostrarPage({this.idPeticion});

  @override
  _AlertaMostrarPageState createState() => _AlertaMostrarPageState();
}

class _AlertaMostrarPageState extends State<AlertaMostrarPage> {
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
                            title: Text(
                                'Usuario: ${snapshot.data['usuario_rut']}'),
                            subtitle: Text(
                              'VER PERFIL DEL USUARIO',
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Icon(MdiIcons.account),
                            tileColor: Colors.blue,
                            onTap: () {}),
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
                                  onPressed: () {},
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
    var provider = AlertaProvider();
    return await provider.getAlerta(widget.idPeticion);
  }

  _navegarPerfilUsuario(BuildContext context, int rut) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return AlertaMostrarPage(
        idPeticion: rut,
      );
    });
    Navigator.push(context, route);
  }
}
