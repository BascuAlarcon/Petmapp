import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  TextEditingController nombreCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar Tipo de Alertas'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(children: <Widget>[ 
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: nombreCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                labelText: 'Nombre',
                                hintText: 'Nombre del tipo de alerta',
                                suffixIcon: Icon(MdiIcons.tagText)),
                            validator: (valor) {
                              if (valor == null || valor.isEmpty) {
                                return 'Debe agregar un nombre para el tipo';
                              }
                              return null;
                            },
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 180,
                      child: ElevatedButton(
                        child: Text('Volver'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(199, 199, 183, 1.0)),
                        ),
                        onPressed: () => _navegarCancelar(context),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 180,
                      child: ElevatedButton(
                        child: Text('Agregar'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _hogarAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _hogarAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new TipoAlertaProvider();
      provider.tipoAgregar(
            nombreCtrl.text); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
