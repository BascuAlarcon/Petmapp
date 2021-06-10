import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';

class HogarMostrarPage extends StatefulWidget {
  final int idHogar;
  HogarMostrarPage({this.idHogar});

  @override
  _HogarMostrarPageState createState() => _HogarMostrarPageState();
}

class _HogarMostrarPageState extends State<HogarMostrarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Hogar número ${widget.idHogar}'),
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
                          subtitle: Text('${snapshot.data['direccion']}'),
                        ),
                        Divider(color: Colors.black),
                        ListTile(
                          title: Text('${snapshot.data['descripcion']}clp'),
                        ),
                        Expanded(child: Divider()),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Agregar peticion'),
                                    onPressed:
                                        () {} /* => _navegarAgregarPeticion(
                                        context, snapshot.data['id']) */
                                    )))
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
    var provider = HogarProvider();
    return await provider.gethogar(widget.idHogar);
  }
}
