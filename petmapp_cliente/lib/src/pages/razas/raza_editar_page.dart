import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';

class RazaEditarPage extends StatefulWidget {
  final int idRaza;
  RazaEditarPage({this.idRaza});

  @override
  _RazaEditarPageState createState() => _RazaEditarPageState();
}

class _RazaEditarPageState extends State<RazaEditarPage> {
// Controllers //
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar raza'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No hay data'),
                  );
                } else {
                  nombreCtrl.text = snapshot.data['nombre'];
                  descripcionCtrl.text = snapshot.data['descripcion'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nombreCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Nombre',
                                    hintText: 'Nombre de la raza',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor == null || valor.isEmpty) {
                                    return 'Debe agregar un nombre';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descripcionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Descripcion',
                                    hintText: 'Descripcion de la raza',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor == null || valor.isEmpty) {
                                    return 'Debe agregar una descripcion';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider()
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
                                child: Text('Guardar Cambios'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(120, 139, 255, 1.0)),
                                ),
                                onPressed: () => _razaEditar(context),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 40,
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text('Cancelar'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(199, 199, 183, 1.0)),
                                ),
                                onPressed: () => _navegarCancelar(context),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = RazasProvider();
    return await provider.getRaza(widget.idRaza);
  }

  void _razaEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new RazasProvider();
      provider.razaEditar(widget.idRaza, nombreCtrl.text, descripcionCtrl.text);
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
