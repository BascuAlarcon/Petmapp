import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_listar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/publicacion_peticiones_listar_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisPublicacionesPage extends StatefulWidget {
  MisPublicacionesPage({Key key}) : super(key: key);

  @override
  _MisPublicacionesPageState createState() => _MisPublicacionesPageState();
}

class _MisPublicacionesPageState extends State<MisPublicacionesPage> {
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
        title: Text('Mis Publicaciones'),
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
                            title: Text(snapshot.data[index]['descripcion']),
                            onTap: () => _navegarPeticiones(
                                context, snapshot.data[index]['id']),
                          ),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegarpublicacionesEditar(
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
    var provider = new UsuarioProvider();
    return await provider.publicacionListar(token);
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

  _navegarPeticiones(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PeticionListarPage(idPublicacion: id);
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
      token = sharedPreferencess.getStringList('usuario')[3];
    });
  }
}
