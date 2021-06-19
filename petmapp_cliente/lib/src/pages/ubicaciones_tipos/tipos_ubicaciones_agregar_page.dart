import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';

class TipoUbicacionAgregarPage extends StatefulWidget {
  final int id;
  TipoUbicacionAgregarPage({this.id});

  @override
  _TipoUbicacionAgregarPageState createState() =>
      _TipoUbicacionAgregarPageState();
}

class _TipoUbicacionAgregarPageState extends State<TipoUbicacionAgregarPage> {
// Controllers //
  TextEditingController tipoUbicacionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Tipos de Ubicaciones'),
        ),
        body: Column(
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
                          hintText: 'tipo de la ubicacion',
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
                      onPressed: () => _hogarAgregar(context),
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
        ));
  }

  void _hogarAgregar(BuildContext context) {
    var provider = new TipoUbicacionProvider();
    provider.tipoAgregar(tipoUbicacionCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
