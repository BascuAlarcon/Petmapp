import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/peticiones_publicaciones_listar.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisPublicacionesPage extends StatefulWidget {
  final int idPublicacion, estado;
  MisPublicacionesPage({this.estado, this.idPublicacion});

  @override
  _MisPublicacionesPageState createState() => _MisPublicacionesPageState();
}

class _MisPublicacionesPageState extends State<MisPublicacionesPage> {
  SharedPreferences sharedPreferences;
  String token = '';
  bool _mostrar = true;
  var lista = 0;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Publicaciones'),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          var snapshotData = snapshot.data;
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
                        _comprobarPeticionPublicacion(snapshotData[index]);
                        return /* _mostrar == true
                            ? */
                            Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                            leading: Icon(MdiIcons.tag),
                            title: Text(snapshot.data[index]['descripcion']),
                            onTap: () => _navegarPeticiones(
                                context, snapshot.data[index]['id']),
                          ),
                          actions: [_accionEditar(snapshot.data[index])],
                          secondaryActions: [
                            _accionEliminar(snapshot.data[index], index)
                          ],
                        );
                        /* : Column(); */
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

  var publicaciones = [0, 1, 2, 3];
  Future<List<dynamic>> _fetch() async {
    var provider = new UsuarioProvider();
    var publicaciones = await provider.publicacionListar(token);
    var contador = 0;
    for (var publicacion in publicaciones) {
      publicaciones[contador] = publicacion;
    }
    print(publicaciones);
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
      token = sharedPreferencess.getStringList('usuario')[4];
    });
  }

  _comprobarPeticionPublicacion(publicacion) async {
    var peticionProvider = PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    _mostrar = true;
    for (var peticion in peticiones) {
      if (publicacion['id'] == peticion['publicacion_id']) {
        if (peticion['estado'] == 3 || peticion['estado'] == 4) {
          _mostrar = false;
        }
      }
    }
  }

  _accionEditar(data) {
    if ((widget.estado == 1 ||
            widget.estado == 3 ||
            widget.estado == 4 ||
            widget.estado == null) ||
        widget.idPublicacion != data['id']) {
      return IconSlideAction(
        caption: 'Editar',
        color: Colors.yellow,
        icon: MdiIcons.pencil,
        onTap: () => _navegarpublicacionesEditar(context, data['id']),
      );
    } else {
      return Text('No permitido');
    }
  }

  _accionEliminar(data, index) {
    if ((widget.estado == 1 || widget.estado == 3 || widget.estado == 4) ||
        widget.idPublicacion != data['id']) {
      return IconSlideAction(
        caption: 'Borrar',
        color: Colors.red,
        icon: MdiIcons.trashCan,
        onTap: () => _mostrarConfirmacion(context, data, index),
      );
    } else {
      return Text('No permitido');
    }
  }
}
