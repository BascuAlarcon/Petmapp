import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';

class TipoUbicacionEditarPage extends StatefulWidget {
  final int id;
  TipoUbicacionEditarPage({this.id});

  @override
  _TipoUbicacionEditarPageState createState() =>
      _TipoUbicacionEditarPageState();
}

class _TipoUbicacionEditarPageState extends State<TipoUbicacionEditarPage> {
// Controllers //
  TextEditingController tipoUbicacionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tipos de Ubicaciones'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoUbicacionCtrl.text =
                    snapshot.data['tipo_ubicacion'].toString();
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoUbicacionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'tipo',
                                  hintText: 'tipo de ubicacion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Agregar Tipo'),
                              onPressed: () => _hogarEditar(context),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Cancelar'),
                              onPressed: () => _navegarCancelar(context),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            }));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = TipoUbicacionProvider();
    return await provider.getTipo(widget.id);
  }

  void _hogarEditar(BuildContext context) {
    var provider = new TipoUbicacionProvider();
    provider.tipoEditar(widget.id, tipoUbicacionCtrl.text);
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
