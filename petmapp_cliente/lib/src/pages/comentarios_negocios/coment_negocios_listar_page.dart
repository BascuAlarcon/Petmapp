import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_negocios/coment_negocios_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_negocios/coment_negocios_editar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioNegocioListarPage extends StatefulWidget {
  final int id;
  ComentarioNegocioListarPage({this.id});

  @override
  _ComentarioNegocioListarPageState createState() =>
      _ComentarioNegocioListarPageState();
}

class _ComentarioNegocioListarPageState
    extends State<ComentarioNegocioListarPage> {
  SharedPreferences sharedPreferences;
  String token, rut = '';
  String foto;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Comentarios Ubicación'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [_dataAlerta(), _dataComentarios()],
        ));
  }

  Widget _dataAlerta() {
    return Center(
      child: FutureBuilder(
        future: _fetchNegocio(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No data'));
          } else {
            foto = snapshot.data['foto'];
            return Card(
                child: Column(
              children: [
                foto != null
                    ? Image(
                        height: 300, width: 300, image: FileImage(File(foto)))
                    : Image(
                        image: NetworkImage(
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                        height: 200,
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1, right: 3),
                      child: Text(
                        snapshot.data['direccion'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Text(
                    snapshot.data['nombre'],
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Text(
                    snapshot.data['descripcion'],
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ));
          }
        },
      ),
    );
  }

  Widget _dataComentarios() {
    return Expanded(
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
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            leading: Icon(MdiIcons.messageReplyTextOutline),
                            subtitle:
                                Text(snapshot.data[index]['fecha_emision']),
                            title: Text(
                                snapshot.data[index]['descripcion'] != null
                                    ? snapshot.data[index]['descripcion']
                                    : Text('loading')),
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

                // LISTA comentariosnegocio //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegarComentariosAgregar(context),
                        child: Text('Agregar Comentario'),
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

  Future<LinkedHashMap<String, dynamic>> _fetchNegocio() async {
    var provider = new NegocioProvider();
    return await provider.getNegocio(widget.id);
  }

  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = new ComentarioNegocioProvider();
    return await provider.comentarioNegocioListar(widget.id);
  }

  void _navegarComentariosAgregar(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosNegocioAgregarPage(id: widget.id));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarcomentariosEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosNegocioEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _comentariosBorrar(int id) async {
    var provider = new ComentarioNegocioProvider();
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
