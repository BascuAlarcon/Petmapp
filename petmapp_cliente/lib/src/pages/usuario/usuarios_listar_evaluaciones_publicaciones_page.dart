import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';

class UsuarioEvaluacionPublicacionListarPage extends StatefulWidget {
  final int rut;
  UsuarioEvaluacionPublicacionListarPage({this.rut});

  @override
  _UsuarioEvaluacionPublicacionListarPageState createState() =>
      _UsuarioEvaluacionPublicacionListarPageState();
}

class _UsuarioEvaluacionPublicacionListarPageState
    extends State<UsuarioEvaluacionPublicacionListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluaciones'),
        leading: Container(
            child: ElevatedButton(
                child: Icon(MdiIcons.arrowBottomLeft),
                onPressed: () => Navigator.pop(context))),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No data'));
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
                          if (snapshot.data[index]['usuario_rut'] ==
                              widget.rut) {
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: ListTile(
                                  leading: Icon(MdiIcons.soccer),
                                  title: Text(
                                      snapshot.data[index]['comentario'] == null
                                          ? 'Aún no finaliza el servicio'
                                          : snapshot.data[index]['comentario']),
                                  subtitle: Text(
                                      snapshot.data[index]['nota'] == null
                                          ? ''
                                          : 'Nota del servicio: ' +
                                              snapshot.data[index]['nota']
                                                  .toString()),
                                  onTap: () {}),
                            );
                          } else {
                            return Column();
                          }
                        }),
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
    var provider = new PublicacionProvider();
    return await provider.publicacionListar();
  }
}
