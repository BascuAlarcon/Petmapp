import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';

class TipoAlertaEditarPage extends StatefulWidget {
  final int id;
  TipoAlertaEditarPage({this.id});

  @override
  _TipoAlertaEditarPageState createState() => _TipoAlertaEditarPageState();
}

class _TipoAlertaEditarPageState extends State<TipoAlertaEditarPage> {
// Controllers //
  TextEditingController tipoAlertaCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tipos de Alertas'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoAlertaCtrl.text = snapshot.data['tipo_alerta'].toString();
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoAlertaCtrl,
                              decoration: InputDecoration(
                                  labelText: 'tipo',
                                  hintText: 'tipo de alerta',
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
    var provider = TipoAlertaProvider();
    return await provider.getTipo(widget.id);
  }

  void _hogarEditar(BuildContext context) {
    var provider = new TipoAlertaProvider();
    provider.tipoEditar(
        widget.id, tipoAlertaCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
