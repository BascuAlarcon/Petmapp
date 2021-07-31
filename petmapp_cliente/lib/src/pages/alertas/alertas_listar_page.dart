import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_editar_page.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_listar_page.dart';
import 'package:petmapp_cliente/src/providers/comentarios_alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertaListarPage extends StatefulWidget {
  AlertaListarPage({Key key}) : super(key: key);

  @override
  _AlertaListarPageState createState() => _AlertaListarPageState();
}

class _AlertaListarPageState extends State<AlertaListarPage> {
  SharedPreferences sharedPreferences;
  DateTime _ultimaActividad;
  int diasPasados;
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
    comprobarEstadoAlertas();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas Existentes'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
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
                // LISTA alertas //
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
                            leading: Icon(MdiIcons.soccer),
                            title: Text(snapshot.data[index]['foto']),
                            subtitle: Text(_nombres[snapshot.data[index]
                                ['tipo_alerta_id']]),
                            onTap: () => _navegarComentariosAlerta(
                                context, snapshot.data[index]['id']),
                          ),
                          actions: [
                            rut ==
                                    snapshot.data[index]['usuario_rut']
                                        .toString()
                                ? IconSlideAction(
                                    caption: 'Editar',
                                    color: Colors.yellow,
                                    icon: MdiIcons.pencil,
                                    onTap: () => _navegarAlertasEditar(
                                        context, snapshot.data[index]['id']),
                                  )
                                : Text(''),
                          ],
                          secondaryActions: [
                            rut ==
                                    snapshot.data[index]['usuario_rut']
                                        .toString()
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

                // LISTA alertas //
                // BOTON AGREGAR //
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 40,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _navegaralertasAgregar(context),
                        child: Text('Agregar Alerta'),
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
    var provider = new AlertaProvider();
    return await provider.alertaListar();
  }

  void _navegaralertasAgregar(BuildContext context) {
    var route =
        new MaterialPageRoute(builder: (context) => AlertasAgregarPage());
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  _navegarComentariosAlerta(BuildContext context, int id) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) {
      return ComentarioAlertaListarPage(
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

  void _navegarAlertasEditar(BuildContext context, int id) {
    var route = new MaterialPageRoute(
        builder: (context) => AlertaEditarPage(
              idalerta: id,
            ));
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  void _alertasBorrar(int id) async {
    var provider = new AlertaProvider();
    var comentariosProvider = new ComentarioAlertaProvider();
    var comentarios = await comentariosProvider.comentarioAlertaListar(id);
    for (var comentario in comentarios) {
      await comentariosProvider.comentarioBorrar(comentario['id']);
    }
    await provider.alertaBorrar(id);
  }

  _mostrarConfirmacion(BuildContext context, dynamic data, int index) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar es alerta?'),
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
                    _alertasBorrar(data[index]['id']);
                    data.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _cargarTipo() async {
    var provider = TipoAlertaProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(tipo['id']);
        _nombres[tipo['id']] = tipo['nombre'];
      });
    });
  }

  // ACÁ SE COMPRUEBA QUE LA ALERTA CULIA TENGA MENOS DE 1 SEMANA VIVA

  void comprobarEstadoAlertas() async {
    var provider = AlertaProvider();
    var alertas = await provider.alertaListar();
    for (var alerta in alertas) {
      diasPasados = calcularDias(alerta['ultima_actividad']);
      if (diasPasados > 7) {
        await provider.alertaBorrar(alerta['id']);
      }
    }
  }

  int calcularDias(ultimaActividad) {
    int daysBetween(DateTime ultimaActividad, DateTime hoy) {
      ultimaActividad = DateTime(
          ultimaActividad.year, ultimaActividad.month, ultimaActividad.day);
      hoy = DateTime(hoy.year, hoy.month, hoy.day);
      return (hoy.difference(ultimaActividad).inHours / 24).round();
    }

    _ultimaActividad = DateTime.parse(ultimaActividad);
    return daysBetween(_ultimaActividad, DateTime.now());
  }
}
