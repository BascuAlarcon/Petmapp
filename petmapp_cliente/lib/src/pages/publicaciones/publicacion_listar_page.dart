import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_editar_page.dart';
import 'package:petmapp_cliente/src/pages/publicaciones/publicacion_mostrar_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionListarPage extends StatefulWidget {
  final int idPublicacion;
  PublicacionListarPage({this.idPublicacion});

  @override
  _PublicacionListarPageState createState() => _PublicacionListarPageState();
}

class _PublicacionListarPageState extends State<PublicacionListarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String perfil = '';
  bool mostrar = true;
  int contador = 0;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lista de Publicaciones'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
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
                _mostrarPublicaciones(safeCards, snapshotData),
                _botonAgregar()
              ],
            );
          }
        },
      ),
    );
  }

  // TRAER DATA //
  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = new PublicacionProvider();
    return await provider.publicacionListar();
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

  // CONSTRUIR PAGE //
  Widget _mostrarPublicaciones(safeCards, snapshotData) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => _refresh(),
        child: ListView.builder(
          itemCount: safeCards.length,
          itemBuilder: (context, index) {
            _comprobarPeticionPublicacion(snapshotData[index]);
            if (mostrar == false) {
              return Column();
            } else {
              return widget.idPublicacion != snapshotData[index]['id']
                  ? Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      child: ListTile(
                        leading: Icon(MdiIcons.clipboardText),
                        title: Text(snapshotData[index]['descripcion']),
                        onTap: () => _navegarPublicacion(
                            context,
                            snapshotData[index]['id'],
                            snapshotData[index]['usuario_rut']),
                      ),
                    )
                  : Column();
            }
          },
        ),
      ),
    );
  }

  Widget _botonAgregar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          height: 40,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _navegarpublicacionesAgregar(context),
            child: Text('Agregar Publicación'),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white12))),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(120, 139, 255, 1.0)),
            ),
          )),
    );
  }

  // NAVEGADORES //
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

  _navegarPublicacion(BuildContext context, int id, int rut) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return PublicacionMostrarPage(
        idPublicacion: id,
        rutUsuario: rut,
      );
    });
    Navigator.push(context, route);
  }

  // SE COMPRUEBA QUE EL USUARIO NO TENGA UNA PETICION CON ESTADO 2 A LA PUBLICACION //
  _comprobarPeticionPublicacion(index) async {
    var peticionProvider = PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    mostrar = true;
    for (var peticion in peticiones) {
      if (index['id'] == peticion['publicacion_id']) {
        if (peticion['estado'] == 3 || peticion['estado'] == 4) {
          mostrar = false;
        }
      }
    }
  }
}
