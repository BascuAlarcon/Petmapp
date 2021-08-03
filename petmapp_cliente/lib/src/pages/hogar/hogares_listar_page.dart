import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/hogar/hogar_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/hogar/hogar_editar_page.dart';
import 'package:petmapp_cliente/src/pages/hogar/hogar_mostrar_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HogarListarPage extends StatefulWidget {
  final int idPeticion, estado, idHogar;
  HogarListarPage({this.estado, this.idPeticion, this.idHogar});

  @override
  _HogarListarPageState createState() => _HogarListarPageState();
}

class _HogarListarPageState extends State<HogarListarPage> {
  SharedPreferences sharedPreferences;
  String rut, token = '';

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Hogares'),
        centerTitle: true,
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
                // LISTA hogares //
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
                            leading: Icon(MdiIcons.home),
                            title: Text(snapshot.data[index]['descripcion']),
                            onTap: () => _navegarHogarMostrar(
                                    context, snapshot.data[index]['id'])(
                                // OJO ACA //
                                context,
                                snapshot.data[index]['id']),
                          ),
                          actions: [
                            snapshot.data[index]['id'] != widget.idHogar
                                ? IconSlideAction(
                                    caption: 'Editar',
                                    color: Colors.yellow,
                                    icon: MdiIcons.pencil,
                                    onTap: () => _navegarhogaresEditar(
                                        context, snapshot.data[index]['id']),
                                  )
                                : Text('Accion no permitida')
                          ],
                          secondaryActions: [
                            snapshot.data[index]['id'] != widget.idHogar
                                ? IconSlideAction(
                                    caption: 'Borrar',
                                    color: Colors.red,
                                    icon: MdiIcons.trashCan,
                                    onTap: () => _mostrarConfirmacion(
                                        context, snapshot.data, index),
                                  )
                                : Text('Accion no permitida')
                          ],
                        );
                      },
                    ),
                  ),
                ),

                // LISTA hogares //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegarhogaresAgregar(context),
                        child: Text('Agregar Hogar'),
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
    var provider = new UsuarioProvider();
    return await provider.hogarListar(token);
  }

  void _navegarhogaresAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => HogaresAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {
        print('refresh');
      });
    });
  }

  void _navegarhogaresEditar(BuildContext context, int idHogar) {
    var route = new MaterialPageRoute(
        builder: (context) => HogarEditarPage(
              idhogar: idHogar,
            ));
    Navigator.push(context, route).then((value) {
      setState(
          () {}); // cuando se devuelva el navigator con un pop, que resfresque //
    });
  }

  void _hogaresBorrar(int id) async {
    var provider = new HogarProvider();
    await provider.hogaresBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar es hogar?'),
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
                    _hogaresBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _navegarHogarMostrar(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return HogarMostrarPage(idHogar: id);
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
      token = sharedPreferencess.getStringList('usuario')[4];
    });
  }

  bool _mostrar;
}
