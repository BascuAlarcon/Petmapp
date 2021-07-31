import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/comentarios_ubicaciones/coment_ubicaciones_listar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones/ubicaciones_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones/ubicaciones_editar_page.dart';
import 'package:petmapp_cliente/src/pages/ubicaciones/ubicaciones_mostrar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_ubicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UbicacionesListarPage extends StatefulWidget {
  UbicacionesListarPage({Key key}) : super(key: key);

  @override
  _UbicacionesListarPageState createState() => _UbicacionesListarPageState();
}

class _UbicacionesListarPageState extends State<UbicacionesListarPage> {
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
        title: Text('Ubicaciones existentes'),
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
                // LISTA ubicaciones //
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
                            leading: Icon(MdiIcons.homeMapMarker),
                            title: Text(snapshot.data[index]['descripcion']),
                            subtitle: Text(_nombres[snapshot.data[index]
                                ['tipo_ubicacion_id']]),
                            onTap: () => _navegarComentariosUbicacion(
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
                                : Text('')
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
                                : Text('')
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // LISTA ubicaciones //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegarubicacionesAgregar(context),
                        child: Text('Agregar Ubicaciones'),
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
    var provider = new UbicacionProvider();
    return await provider.ubicacionListar();
  }

  void _navegarubicacionesAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => UbicacionesAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _navegarUbicacionEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => UbicacionEditarPage(
              idubicacion: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _ubicacionesBorrar(int id) async {
    var provider = new UbicacionProvider();
    var comentariosProvider = new ComentarioUbicacionProvider();
    var comentarios = await comentariosProvider.comentarioUbicacionListar(id);
    for (var comentario in comentarios) {
      await comentariosProvider.comentarioBorrar(comentario['id']);
    }
    await provider.ubicacionBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar es ubicacion?'),
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
                    _ubicacionesBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _navegarComentariosUbicacion(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ComentarioUbicacionListarPage(
        id: id,
      );
    });
    Navigator.push(context, route);
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
    var provider = TipoUbicacionProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(tipo['id']);
        _nombres[tipo['id']] = tipo['nombre'];
      });
    });
  }
}
