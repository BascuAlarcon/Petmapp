import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_mostrar_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class PeticionListarPage extends StatefulWidget {
  final int idPublicacion;
  PeticionListarPage({this.idPublicacion});

  @override
  _PeticionListarPageState createState() => _PeticionListarPageState();
}

class _PeticionListarPageState extends State<PeticionListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PetmApp'),
        leading: Container(
            child: ElevatedButton(
                child: Icon(MdiIcons.arrowBottomLeft),
                onPressed: () => Navigator.pop(context))),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text('No data')); /* CircularProgressIndicator() */
          } else {
            // LISTA peticiones //
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'PETICIONES DE CUIDADO',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Expanded(
                        child: _mostrarPeticiones(snapshot.data['peticiones'])),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<LinkedHashMap<String, dynamic>> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = new UsuarioProvider();
    return await provider.peticionListar(widget.idPublicacion);
  }

  Widget _mostrarPeticiones(List<dynamic> peticiones) {
    if (peticiones.isEmpty) {
      return Center(
        child: Text('No hay peticiones'),
      );
    } else {
      return ListView.separated(
          itemCount: peticiones.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) {
            return peticiones[index]['estado'] == 3
                ? Text('')
                : ListTile(
                    title: Text(
                        'Fecha de inicio: ${peticiones[index]['fecha_inicio']}'),
                    subtitle: Text(
                        'Fecha en que termina: ${peticiones[index]['fecha_fin']}'),
                    /* subtitle: peticiones[index]['rut'].toString().length == 8
                        ? Text('Rut del usuario que realizo la peticion: ' +
                            peticiones[index]['usuario_rut']
                                .toString()
                                .replaceRange(7, 7, '-'))
                        : Text('Rut del usuario que realizo la peticion: ' +
                            peticiones[index]['usuario_rut']
                                .toString()
                                .replaceRange(7, 7, '-')), */
                    onTap: () => _navegarPeticion(
                        context,
                        peticiones[index]['id'],
                        peticiones[index]['usuario_rut']),
                  );
          });
    }
  }

  _navegarPeticion(BuildContext context, int idPeticion, int rutUsuario) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PeticionMostrarPage(
        idPeticion: idPeticion,
        rutUsuario: rutUsuario,
      );
    });
    Navigator.push(context, route);
  }
}
