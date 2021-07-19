import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_ubicaciones/coment_ubicaciones_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_ubicaciones/coment_ubicaciones_editar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_ubicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioUbicacionListarPage extends StatefulWidget {
  final int id;
  ComentarioUbicacionListarPage({this.id});

  @override
  _ComentarioUbicacionListarPageState createState() =>
      _ComentarioUbicacionListarPageState();
}

class _ComentarioUbicacionListarPageState
    extends State<ComentarioUbicacionListarPage> {
  SharedPreferences sharedPreferences;
  String token, rut = '';
  String nombre;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Comentarios Ubicación'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder(
                future: _fetchUbicacion(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data'));
                  } else {
                    return Card(
                        child: Column(
                      children: [
                        Image(
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                          height: 200,
                        ),
                        ListTile(
                          title: Text(snapshot.data['descripcion']),
                          subtitle: Text(snapshot.data['direccion']),
                        )
                      ],
                    ));
                  }
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _fetch(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('No data'));
                  } else {
                    List<dynamic> safeCards = snapshot.data;
                    return Column(
                      children: [
                        // LISTA COMENTARIOS//
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () => _refresh(),
                            child: ListView.separated(
                              itemCount: safeCards.length,
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                              itemBuilder: (context, index) {
                                _mostrarNombre(
                                    snapshot.data[index]['usuario_rut']);
                                return Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  child: ListTile(
                                    leading: Icon(MdiIcons.tag),
                                    subtitle: Text(nombre),
                                    title: Text(snapshot.data[index]
                                            ['descripcion']
                                        .toString()),
                                    onTap: () {},
                                  ),
                                  actions: [
                                    rut ==
                                            snapshot.data[index]['usuario_rut']
                                                .toString()
                                        ? IconSlideAction(
                                            caption: 'Editar',
                                            color: Colors.yellow,
                                            icon: MdiIcons.pencil,
                                            onTap: () =>
                                                _navegarcomentariosEditar(
                                                    context,
                                                    snapshot.data[index]['id']),
                                          )
                                        : Text(''),
                                  ],
                                  secondaryActions: [
                                    rut ==
                                            snapshot.data[index]['usuario_rut']
                                                .toString()
                                        ? IconSlideAction(
                                            caption: 'Borrar',
                                            color: Colors.red,
                                            icon: MdiIcons.trashCan,
                                            onTap: () => _mostrarConfirmacion(
                                                context, snapshot.data, index),
                                          )
                                        : Text(''),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),

                        // LISTA comentariosnegocio //
                        // BOTON AGREGAR //
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    _navegarComentariosAgregar(context),
                                child: Text('Agregar Comentario'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
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
            ),
          ],
        ));
  }

  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = new ComentarioUbicacionProvider();
    return await provider.comentarioUbicacionListar(widget.id);
  }

  Future<LinkedHashMap<String, dynamic>> _fetchUbicacion() async {
    var provider = new UbicacionProvider();
    return await provider.getUbicacion(widget.id);
  }

  void _navegarComentariosAgregar(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosUbicacionAgregarPage(id: widget.id));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _navegarcomentariosEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosUbicacionEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _comentariosBorrar(int id) async {
    var provider = new ComentarioUbicacionProvider();
    await provider.comentarioBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar su comentario?'),
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
                    _comentariosBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      /* listaDatos = sharedPreferencess.getStringList("usuario");
      print(listaDatos); */
      rut = sharedPreferencess.getStringList('usuario')[0];
      token = sharedPreferencess.getStringList('usuario')[4];
    });
  }

  _mostrarNombre(int rutUsuario) async {
    var provider = UsuarioProvider();
    var usuarios = await provider.getUsuarios();
    for (var usuario in usuarios) {
      if (usuario['rut'] == rutUsuario) {
        nombre = usuario['name'];
      }
    }
  }
}
