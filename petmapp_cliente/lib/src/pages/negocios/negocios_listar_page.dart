import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_negocios/coment_negocios_listar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios/negocios_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios/negocios_editar_page.dart';
import 'package:petmapp_cliente/src/pages/negocios_tipos/tipos_editar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NegociosListarPage extends StatefulWidget {
  NegociosListarPage({Key key}) : super(key: key);

  @override
  _NegociosListarPageState createState() => _NegociosListarPageState();
}

class _NegociosListarPageState extends State<NegociosListarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String perfil = '';
  var _tipos = []..length = 500;
  var _nombres = []..length = 500;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarTipo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Negocios Existentes'),
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
                // LISTA negocios //
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
                            leading: Icon(MdiIcons.store),
                            title: Text(snapshot.data[index]['descripcion']),
                            subtitle:
                                Text(_nombres[snapshot.data[index]['tipo_id']]),
                            onTap: () => _navegarComentariosNegocio(
                                context, snapshot.data[index]['id']),
                          ),
                          actions: [
                            perfil == '1'
                                ? IconSlideAction(
                                    caption: 'Editar',
                                    color: Colors.yellow,
                                    icon: MdiIcons.pencil,
                                    onTap: () => _navegarUbicacionEditar(
                                        context, snapshot.data[index]['id']),
                                  )
                                : Text(''),
                          ],
                          secondaryActions: [
                            perfil == '1'
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

                // LISTA negocios //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegarnegociosAgregar(context),
                        child: Text('Agregar Negocio'),
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
    var provider = new NegocioProvider();
    return await provider.negocioListar();
  }

  void _navegarnegociosAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => NegociosAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarUbicacionEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => NegocioEditarPage(
              id: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  _navegarComentariosNegocio(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => ComentarioNegocioListarPage(id: id));
    Navigator.push(context, route);
  }

  void _negociosBorrar(int id) async {
    var provider = new NegocioProvider();
    var comentariosProvider = new ComentarioNegocioProvider();
    var comentarios = await comentariosProvider.comentarioNegocioListar(id);
    for (var comentario in comentarios) {
      await comentariosProvider.comentarioBorrar(comentario['id']);
    }
    await provider.negocioBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar el negocio?'),
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
                    _negociosBorrar(data[index]['id']);
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
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
      perfil = sharedPreferencess.getStringList('usuario')[3];
    });
  }

  _cargarTipo() async {
    var provider = TipoProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(tipo['id']);
        _nombres[tipo['id']] = tipo['nombre'];
      });
    });
  }
}
