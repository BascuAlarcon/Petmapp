import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_editar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_editar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_agregar_page.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentarioAlertaListarPage extends StatefulWidget {
  ComentarioAlertaListarPage({Key key}) : super(key: key);

  @override
  _ComentarioAlertaListarPageState createState() =>
      _ComentarioAlertaListarPageState();
}

class _ComentarioAlertaListarPageState
    extends State<ComentarioAlertaListarPage> {
  SharedPreferences sharedPreferences;
  String token = '';

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
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
                // LISTA tipos alerta //
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
                                snapshot.data[index]['alerta_id'].toString()),
                            onTap: () {},
                          ),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegarcomentariosEditar(
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

                // LISTA comentariosalerta //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              _navegarcomentariosalertaAgregar(context),
                          child: Text('Agregar'))),
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
    var provider = new TipoProvider();
    return await provider.tipoListar();
  }

  void _navegarcomentariosalertaAgregar(BuildContext context) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentariosAlertaAgregarPage());
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
    var provider = new TipoProvider();
    await provider.tipoBorrar(id);
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
      token = sharedPreferencess.getStringList('usuario')[4];
    });
  }
}
