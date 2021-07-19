import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_editar_page.dart';
import 'package:petmapp_cliente/src/providers/especie_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EspecieListarPage extends StatefulWidget {
  EspecieListarPage({Key key}) : super(key: key);

  @override
  _EspecieListarPageState createState() => _EspecieListarPageState();
}

class _EspecieListarPageState extends State<EspecieListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Especies'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
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
                // LISTA Especies //
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refresh(),
                    child: ListView.separated(
                      itemCount: safeCards.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                              leading: Icon(MdiIcons.paw),
                              title: Text(snapshot.data[index]['nombre']),
                              onTap: () {}),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegarEspecieEditar(
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
// BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegarEspecieAgregar(context),
                        child: Text('Agregar Especie'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                      )),
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
    var provider = new EspecieProvider();
    return await provider.especieListar();
  }

  void _navegarEspecieAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => EspeciesAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarEspecieEditar(BuildContext context, int idEspecie) {
    var route = new MaterialPageRoute(
        builder: (context) => EspecieEditarPage(
              idEspecie: idEspecie,
            ));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _especieBorrar(int id) async {
    var provider = new EspecieProvider();
    await provider.especieBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar la especie ${data[index]['nombre']}?'),
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
                    _especieBorrar(data[index]['id']);
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
