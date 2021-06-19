import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_editar_page.dart';
import 'package:petmapp_cliente/src/pages/alertas/alertas_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/comentarios_alertas/coment_alertas_listar_page.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertaListarPage extends StatefulWidget {
  AlertaListarPage({Key key}) : super(key: key);

  @override
  _AlertaListarPageState createState() => _AlertaListarPageState();
}

class _AlertaListarPageState extends State<AlertaListarPage> {
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
        title: Text('Alertas Existentes'),
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
                            title: Text(snapshot.data[index]['descripcion']),
                            subtitle: Text(
                                'tipo de alerta ${snapshot.data[index]['tipo_alerta_id'].toString()}'),
                            onTap: () => _navegarComentariosAlerta(
                                context, snapshot.data[index]['id']),
                          ),
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
                          child: Text('Agregar alertas'))),
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
      perfil = sharedPreferencess.getStringList('usuario')[4];
    });
  }
}
