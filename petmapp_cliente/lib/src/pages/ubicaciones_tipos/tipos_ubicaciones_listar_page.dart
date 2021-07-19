import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones_tipos/tipos_ubicaciones_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones_tipos/tipos_ubicaciones_editar_page.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipoUbicacionListarPage extends StatefulWidget {
  TipoUbicacionListarPage({Key key}) : super(key: key);

  @override
  _TipoUbicacionListarPageState createState() =>
      _TipoUbicacionListarPageState();
}

class _TipoUbicacionListarPageState extends State<TipoUbicacionListarPage> {
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
        centerTitle: true,
        title: Text('Tipo de ubicaciones'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
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
                            leading: Icon(MdiIcons.store),
                            title:
                                Text(snapshot.data[index]['nombre'].toString()),
                            onTap: () {},
                          ),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegartiposalertaEditar(
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

                // LISTA tiposalerta //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegartiposAgregar(context),
                        child: Text('Agregar Tipos de Ubicaciones'),
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
    var provider = new TipoUbicacionProvider();
    return await provider.tipoListar();
  }

  void _navegartiposAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => TipoUbicacionAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegartiposalertaEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => TipoUbicacionEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _tiposalertaBorrar(int id) async {
    var provider = new TipoUbicacionProvider();
    await provider.tipoBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar el tipo de ubicacion?'),
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
                    _tiposalertaBorrar(data[index]['id']);
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
