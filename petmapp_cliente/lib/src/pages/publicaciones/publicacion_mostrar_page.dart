import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';

class PublicacionMostrarPage extends StatefulWidget {
  final int idPublicacion;
  PublicacionMostrarPage({this.idPublicacion});

  @override
  _PublicacionMostrarPageState createState() => _PublicacionMostrarPageState();
}

class _PublicacionMostrarPageState extends State<PublicacionMostrarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Publicacion número ${widget.idPublicacion}'),
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
                              'Fecha publicación: ${snapshot.data['created_at']}'),
                        ),
                        Divider(color: Colors.black),
                        ListTile(
                          title: Text(
                              'Precio por día: ${snapshot.data['tarifa']}clp'),
                        ),
                        Expanded(child: Divider()),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 40,
                                width: double.infinity,
                                child: ElevatedButton(
                                    child: Text('Agregar peticion'),
                                    onPressed: () => _navegarAgregarPeticion(
                                        context, snapshot.data['id']))))
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  /* _navegarMascotas(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PublicacionMostrarPage(
        idPublicacion: id,
      );
    });
    Navigator.push(context, route);
  } */

  _navegarAgregarPeticion(BuildContext context, int idPublicacion) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PeticionesAgregarPage(idPublicacion: idPublicacion);
    });
    Navigator.push(context, route);
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PublicacionProvider();
    return await provider.getpublicacion(widget.idPublicacion);
  }
}
