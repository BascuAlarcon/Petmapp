import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';

class TipoAlertaAgregarPage extends StatefulWidget {
  final int id;
  TipoAlertaAgregarPage({this.id});

  @override
  _TipoAlertaAgregarPageState createState() => _TipoAlertaAgregarPageState();
}

class _TipoAlertaAgregarPageState extends State<TipoAlertaAgregarPage> {
// Controllers //
  TextEditingController tipoAlertaCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Tipos de Alertas'),
        ),
        body: Column(
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
                          hintText: 'tipo de la alerta',
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
    var provider = new TipoAlertaProvider();
    provider.tipoAgregar(tipoAlertaCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
