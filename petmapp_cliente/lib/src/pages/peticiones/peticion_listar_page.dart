import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/peticiones_publicaciones_listar.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisPeticionesPage extends StatefulWidget {
  MisPeticionesPage({Key key}) : super(key: key);

  @override
  _MisPeticionesPageState createState() => _MisPeticionesPageState();
}

class _MisPeticionesPageState extends State<MisPeticionesPage> {
  SharedPreferences sharedPreferences;
  String token = '';
  int rutUsuario;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        title: Text('Mis Peticiones'),
        centerTitle: true,
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
                        _buscarUsuario(snapshot.data[index]['publicacion_id']);
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            leading: Icon(MdiIcons.accountClock),
                            title: Text('Petición para el: ' +
                                snapshot.data[index]['fecha_inicio']),
                            onTap: () => _navegarPeticiones(context,
                                snapshot.data[index]['publicacion_id']),
                          ),
                          actions: [
                            IconSlideAction(
                              caption: 'Editar',
                              color: Colors.yellow,
                              icon: MdiIcons.pencil,
                              onTap: () => _navegarpeticionEditar(
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
    return await provider.getPeticiones(token);
  }

  void _navegarpeticionEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => PeticionEditarPage(
              idPeticion: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _peticionBorrar(int id) async {
    var provider = new PeticionProvider();
    await provider.peticionesBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar esta petición?'),
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
                    _peticionBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  // CAMBIAR -> NAVEGAR A LA PUBLICACIÓN DE LA PETICIÓN
  _navegarPeticiones(
    BuildContext context,
    int idPublicacion,
  ) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PublicacionMostrarPage(
          idPublicacion: idPublicacion, rutUsuario: rutUsuario);
    });
    Navigator.push(context, route);
  }

  _buscarUsuario(idPublicacion) async {
    var provider = PublicacionProvider();
    var publicaciones = await provider.publicacionListar();
    for (var publicacion in publicaciones) {
      if (publicacion['id'] == idPublicacion) {
        rutUsuario = publicacion['usuario_rut'];
      }
    }
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      token = sharedPreferencess.getStringList('usuario')[4];
    });
  }
}
