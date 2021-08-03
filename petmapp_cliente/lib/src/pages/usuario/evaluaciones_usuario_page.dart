import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';

class EvaluacionesUsuarioPage extends StatefulWidget {
  final int rut;
  EvaluacionesUsuarioPage({this.rut});

  @override
  _EvaluacionesUsuarioPageState createState() =>
      _EvaluacionesUsuarioPageState();
}

class _EvaluacionesUsuarioPageState extends State<EvaluacionesUsuarioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Evaluaciones del usuario'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [_evaluacionPeticiones(), _evaluacionPubliaciones()],
        ));
  }

  Widget _evaluacionPeticiones() {
    return Expanded(
      child: FutureBuilder(
        future: _fetchPeticion(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          } else {
            List<dynamic> safeCards = snapshot.data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Evaluaciones a peticiones'),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshPeticion(),
                    child: ListView.builder(
                      itemCount: safeCards.length,
                      itemBuilder: (context, index) {
                        return snapshot.data[index]['usuario_rut'] == widget.rut
                            ? Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: ListTile(
                                  leading: Icon(MdiIcons.calendarTextOutline),
                                  title: Text('Nota: ' +
                                      snapshot.data[index]['nota'].toString()),
                                  subtitle:
                                      Text(snapshot.data[index]['comentario']),
                                  onTap: () {},
                                ),
                              )
                            : Column();
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

  Widget _evaluacionPubliaciones() {
    return Expanded(
      child: FutureBuilder(
        future: _fetchPublicacion(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('Loading...');
          } else {
            List<dynamic> safeCards = snapshot.data;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Evaluaciones a publicaciones'),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshPublicacion(),
                    child: ListView.builder(
                      itemCount: safeCards.length,
                      itemBuilder: (context, index) {
                        return snapshot.data[index]['usuario_rut'] == widget.rut
                            ? Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                child: ListTile(
                                  leading: Icon(MdiIcons.calendarTextOutline),
                                  title: Text('Nota: ' +
                                      snapshot.data[index]['nota'].toString()),
                                  subtitle:
                                      Text(snapshot.data[index]['comentario']),
                                  onTap: () {},
                                ),
                              )
                            : Column();
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

  Future<Null> _refreshPeticion() async {
    await _fetchPeticion();
    setState(() {});
  }

  Future<Null> _refreshPublicacion() async {
    await _fetchPublicacion();
    setState(() {});
  }

  Future<List<dynamic>> _fetchPublicacion() async {
    var provider = PublicacionProvider();
    return await provider.publicacionListar();
  }

  Future<List<dynamic>> _fetchPeticion() async {
    var provider = PeticionProvider();
    return await provider.peticionListar();
  }
}
