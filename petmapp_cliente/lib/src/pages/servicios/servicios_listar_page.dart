import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/servicios/servicios_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/servicios/servicios_editar_page.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';

class ServicioListarPage extends StatefulWidget {
  final int idPeticion;
  ServicioListarPage({this.idPeticion});

  @override
  _ServicioListarPageState createState() => _ServicioListarPageState();
}

class _ServicioListarPageState extends State<ServicioListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Servicios Adicionles'),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text('No data')); /* CircularProgressIndicator() */
          } else {
            List<dynamic> safeCards = snapshot.data;
            return Column(
              children: [
                // LISTA publicaciones //
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
                                'servicio: ${snapshot.data[index]['comentario']}'),
                            subtitle: Text(
                                'Monto: ${snapshot.data[index]['monto'].toString()}clp'),
                            onTap: () {},
                          ),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegarServiciosEditar(
                                  context, snapshot.data[index]['id']),
                            )
                          ],
                          secondaryActions: [
                            IconSlideAction(
                              caption: 'Borrar',
                              color: Colors.red,
                              icon: MdiIcons.trashCan,
                              onTap: () => _mostrarConfirmacion(
                                  context, snapshot.data, index),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                _agregarServicios(widget.idPeticion)
              ],
            );
          }
        },
      ),
    );
  }

  /* _navegarPerfil(BuildContext context, int rut) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PerfilPublicacionPage(rut);
    });
    Navigator.push(context, route);
  } */

  _agregarServicios(id) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => _navegarServiciosAgregar(context, id),
                child: Text('Agregar Servicios'))));
  }

  _navegarServiciosAgregar(BuildContext context, int idPeticion) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ServiciosAgregarPage(
        idPeticion: idPeticion,
      );
    });
    Navigator.push(context, route);
  }

  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = ServiciosProvider();
    return await provider.serviciosListar(widget.idPeticion);
  }

  void _navegarServiciosEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => ServiciosEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _servicioBorrar(int id) async {
    var provider = new ServiciosProvider();
    await provider.serviciosBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar el servicio ${data[index]['id']}?'),
            actions: [
              MaterialButton(
                  child: Text('Cancelar',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                child: Text('Borrar'),
                onPressed: () {
                  setState(() {
                    _servicioBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
