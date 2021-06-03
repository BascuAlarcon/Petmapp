import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_editar_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MascotaListarPage extends StatefulWidget {
  MascotaListarPage({Key key}) : super(key: key);

  @override
  _MascotaListarPageState createState() => _MascotaListarPageState();
}

class _MascotaListarPageState extends State<MascotaListarPage> {
  var rut;
  var id;
  SharedPreferences sharedPreferences;

  getSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    rut = sharedPreferences.getStringList('usuario')[0];
    rut = int.parse(rut);
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

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
            List<dynamic> safeCards = snapshot.data;
            return Column(
              children: [
                // LISTA MASCOTAS //
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refresh(),
                    child: ListView.builder(
                      itemCount: safeCards.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data[index]['usuario_rut'] == rut) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: ListTile(
                              leading: Icon(MdiIcons.soccer),
                              title: Text(snapshot.data[index]['nombre']),
                              subtitle:
                                  Text(snapshot.data[index]['id'].toString()),
                              onTap: () => _navegarMascotas(
                                  context, snapshot.data[index]['id']),
                            ),
                            actions: [
                              IconSlideAction(
                                caption: 'Editar',
                                color: Colors.yellow,
                                icon: MdiIcons.pencil,
                                onTap: () => _navegarMascotasEditar(
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
                        } else {
                          return Column();
                        }
                      },
                    ),
                  ),
                ),

                // LISTA MascotaS //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => _navegarMascotasAgregar(context),
                          child: Text('Agregar Mascotas'))),
                )
                // BOTON AGREGAR //
              ],
            );
          }
        },
      ),
    );
  }

  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = new PetmappProvider();
    return await provider.mascotaListar();
  }

  void _navegarMascotasAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => MascotasAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarMascotasEditar(BuildContext context, int idMascota) {
    var route = new MaterialPageRoute(
        builder: (context) => MascotaEditarPage(
            /* idMascota: idMascota, */
            ));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _MascotasBorrar(int id) async {
    var provider = new PetmappProvider();
    await provider.mascotaBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar la Mascota ${data[index]['nombre']}?'),
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
                    _MascotasBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _navegarMascotas(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return MascotaListarPage(
          /* idMascota: id, */
          );
    });
    Navigator.push(context, route);
  }
}
