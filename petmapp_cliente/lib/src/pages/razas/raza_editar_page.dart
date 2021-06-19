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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Razas'),
        ),
        body: FutureBuilder(
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
                            child: TextField(
                              controller: nombreCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  hintText: 'Nombre de la raza',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: descripcionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Descripcion',
                                  hintText: 'Descripcion de la raza',
                                  suffixIcon: Icon(Icons.flag)),
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
                              child: Text('Editar  Raza'),
                              onPressed: () => _razaEditar(context),
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
    var provider = RazasProvider();
    return await provider.getRaza(widget.idRaza);
  }

  void _razaEditar(BuildContext context) {
    var provider = new RazasProvider();
    provider.razaEditar(widget.idRaza, nombreCtrl.text, descripcionCtrl.text);
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
