import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_editar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_editar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_agregar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioAlertaListarPage extends StatefulWidget {
  final int id;
  ComentarioAlertaListarPage({this.id});

  @override
  _ComentarioAlertaListarPageState createState() =>
      _ComentarioAlertaListarPageState();
}

class _ComentarioAlertaListarPageState
    extends State<ComentarioAlertaListarPage> {
  SharedPreferences sharedPreferences;
  String token, rut = '';
  var _fotosUsuario = [];
  var _usuarios = [];
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    /* _fetchUsuario(); */
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comentarios'),
        leading: Container(
            child: ElevatedButton(
                child: Icon(MdiIcons.arrowBottomLeft),
                onPressed: () => Navigator.pop(context))),
      ),
      body: FutureBuilder(
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
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            leading: Icon(MdiIcons.soccer),
                            title: Text(
                                snapshot.data[index]['descripcion'].toString()),
                            onTap: () {},
                          ),
                          actions: [
                            Container(
                                width: 50,
                                height: 50,
                                child: CircleAvatar(
                                    child: ClipOval(
                                        child:
                                            /* snapshot.data[index]['foto'] !=
                                                'xD'
                                            ? Image(
                                                image: FileImage(File(snapshot
                                                    .data[index]['foto'])))
                                            :  */
                                            Image(
                                                image: NetworkImage(
                                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))))),
                            rut ==
                                    snapshot.data[index]['usuario_rut']
                                        .toString()
                                ? IconSlideAction(
                                    caption: 'Editar',
                                    color: Colors.yellow,
                                    icon: MdiIcons.pencil,
                                    onTap: () => _navegarcomentariosEditar(
                                        context, snapshot.data[index]['id']),
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

                // LISTA comentariosalerta //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () => _navegarComentariosAgregar(
                                context,
                              ),
                          child: Text('Agregar un comentario'))),
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
    var provider = new ComentarioAlertaProvider();
    return await provider.comentarioAlertaListar(widget.id);
  }

  void _fetchUsuario() async {
    var provider = new ComentarioAlertaProvider();
    var comentarios = await provider.comentarioAlertaListar(widget.id);
    var usuarioProvider = new UsuarioProvider();
    var usuarios = await usuarioProvider.getUsuarios();
    // y si un usuario hace más de un comentario?
    for (var comentario in comentarios) {
      for (var usuario in usuarios) {
        if (comentario['usuario_rut'] == usuario['rut']) {
          // _usuarios.add(usuario['rut']);
          //_fotosUsuario.add(usuario['foto']);
        }
      }
    }
  }

  void _navegarComentariosAgregar(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosAlertaAgregarPage(id: widget.id));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _navegarcomentariosEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosAlertaEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _comentariosBorrar(int id) async {
    var provider = new ComentarioAlertaProvider();
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
}
