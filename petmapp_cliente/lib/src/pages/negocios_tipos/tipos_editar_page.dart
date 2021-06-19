import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';

class TipoNegocioEditarPage extends StatefulWidget {
  final int id;
  TipoNegocioEditarPage({this.id});

  @override
  _TipoNegocioEditarPageState createState() => _TipoNegocioEditarPageState();
}

class _TipoNegocioEditarPageState extends State<TipoNegocioEditarPage> {
// Controllers //
  TextEditingController tipoNegocioCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tipos de Negocios'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoNegocioCtrl.text = snapshot.data['tipo_negocio'].toString();
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoNegocioCtrl,
                              decoration: InputDecoration(
                                  labelText: 'tipo',
                                  hintText: 'tipo de negocio',
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
    var provider = TipoProvider();
    return await provider.getTipo(widget.id);
  }

  void _hogarEditar(BuildContext context) {
    var provider = new TipoProvider();
    provider.tipoEditar(
        widget.id, tipoNegocioCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
