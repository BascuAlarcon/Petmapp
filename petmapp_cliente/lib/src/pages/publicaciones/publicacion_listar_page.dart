import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_mostrar_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionListarPage extends StatefulWidget {
  PublicacionListarPage({Key key}) : super(key: key);

  @override
  _PublicacionListarPageState createState() => _PublicacionListarPageState();
}

class _PublicacionListarPageState extends State<PublicacionListarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String perfil = '';

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones disponibles'),
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
                // LISTA publicaciones //
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refresh(),
                    child: ListView.builder(
                      itemCount: safeCards.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data[index]['usuario_rut'].toString() ==
                            rut) {
                          return Column();
                        } else {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: ListTile(
                              leading: Icon(MdiIcons.soccer),
                              title: Text(snapshot.data[index]['descripcion']),
                              onTap: () => _navegarPublicacion(
                                  context, snapshot.data[index]['id']),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),

                // LISTA publicaciones //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () =>
                              _navegarpublicacionesAgregar(context),
                          child: Text('Agregar publicaciones'))),
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
    var provider = new PublicacionProvider();
    return await provider.publicacionListar();
  }

  void _navegarpublicacionesAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => PublicacionesAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _navegarpublicacionesEditar(BuildContext context, int idPublicacion) {
    var route = new MaterialPageRoute(
        builder: (context) => PublicacionEditarPage(
              idpublicacion: idPublicacion,
            ));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _publicacionesBorrar(int id) async {
    var provider = new PublicacionProvider();
    await provider.publicacionesBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar es publicacion?'),
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
                    _publicacionesBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _navegarPublicacion(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PublicacionMostrarPage(
        idPublicacion: id,
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
      perfil = sharedPreferencess.getStringList('usuario')[4];
    });
  }
}
