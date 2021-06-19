import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';

class TipoNegocioAgregarPage extends StatefulWidget {
  final int id;
  TipoNegocioAgregarPage({this.id});

  @override
  _TipoNegocioAgregarPageState createState() => _TipoNegocioAgregarPageState();
}

class _TipoNegocioAgregarPageState extends State<TipoNegocioAgregarPage> {
// Controllers //
  TextEditingController tipoNegocioCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Tipos de Negocios'),
        ),
        body: Column(
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
                          hintText: 'tipo del hogar',
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
    var provider = new TipoProvider();
    provider.tipoAgregar(tipoNegocioCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
