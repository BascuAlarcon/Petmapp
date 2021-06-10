import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_editar_page.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
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
        backgroundColor: Color.fromRGBO(84, 101, 255, 1.0),
        title: Text('Tus Mascotas'),
        leading: Container(
            color: Color.fromRGBO(84, 101, 255, 1.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromRGBO(84, 101, 255, 1.0), // background
                    onPrimary: Colors.white,
                    elevation: 0 // foreground
                    ),
                child: Icon(MdiIcons.arrowLeft),
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
                          return InkWell(
                              onTap: () => _navegarMascotas(
                                  context, snapshot.data[index]['id']),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  margin: EdgeInsets.all(15),
                                  elevation: 10,
                                  // Dentro de esta propiedad usamos ClipRRect
                                  child: ClipRRect(
                                    // Los bordes del contenido del card se cortan usando BorderRadius
                                    borderRadius: BorderRadius.circular(30),
                                    // EL widget hijo que será recortado segun la propiedad anterior
                                    child: Column(
                                      children: <Widget>[
                                        // Usamos el widget Image para mostrar una imagen
                                        Image(
                                          // Como queremos traer una imagen desde un url usamos NetworkImage
                                          image: NetworkImage(
                                              'https://cdn.dribbble.com/users/2402074/screenshots/14168530/media/3c81d79d3b8415f6b309eb953e69f0bd.png?compress=1&resize=400x300'),
                                        ),
                                        // Usamos Container para el contenedor de la descripción
                                        Container(
                                          padding: EdgeInsets.all(13),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: new EdgeInsets.only(
                                                    left: 140.0),
                                                child: Text(
                                                    snapshot.data[index]
                                                        ['nombre'],
                                                    style: TextStyle(
                                                        fontSize: 18.0)),
                                              ),
                                              Container(
                                                padding: new EdgeInsets.only(
                                                    left: 30.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.edit_rounded,
                                                        color: Colors.cyan,
                                                      ),
                                                      tooltip: 'Editar',
                                                      onPressed: () =>
                                                          _navegarMascotasEditar(
                                                              context,
                                                              snapshot.data[
                                                                  index]['id']),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors
                                                              .orangeAccent),
                                                      tooltip: 'Eliminar',
                                                      onPressed: () =>
                                                          _mostrarConfirmacion(
                                                              context,
                                                              snapshot.data,
                                                              index),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )));
                          // return Slidable(
                          //   actionPane: SlidableDrawerActionPane(),
                          //   actionExtentRatio: 0.25,
                          //   child: ListTile(
                          //     leading: Icon(MdiIcons.soccer),
                          //     title: Text(snapshot.data[index]['nombre']),
                          //     subtitle:
                          //         Text(snapshot.data[index]['id'].toString()),
                          //     onTap: () => _navegarMascotas(
                          //         context, snapshot.data[index]['id']),
                          //   ),
                          //   actions: [
                          //     IconSlideAction(
                          //       caption: 'Editar',
                          //       color: Colors.yellow,
                          //       icon: MdiIcons.pencil,
                          //       onTap: () => _navegarMascotasEditar(
                          //           context, snapshot.data[index]['id']),
                          //     )
                          //   ],
                          //   secondaryActions: [
                          //     IconSlideAction(
                          //       caption: 'Borrar',
                          //       color: Colors.red,
                          //       icon: MdiIcons.trashCan,
                          //       onTap: () => _mostrarConfirmacion(
                          //           context, snapshot.data, index),
                          //     ),
                          //   ],
                          // );
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
                        child: Text('Agregar Mascotas'),
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
    var provider = new MascotaProvider();
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
    var provider = new MascotaProvider();
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
