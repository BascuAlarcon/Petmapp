import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';

class ServiciosEditarPage extends StatefulWidget {
  final int id;
  ServiciosEditarPage({this.id});
  @override
  _ServiciosEditarPageState createState() => _ServiciosEditarPageState();
}

class _ServiciosEditarPageState extends State<ServiciosEditarPage> {
  @override

// Controllers //
  TextEditingController comentarioCtrl = new TextEditingController();
  TextEditingController montoCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController fechaCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Publicacion'),
        ),
        body: FutureBuilder(
          future: _fetch(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('No hay data'),
              );
            } else {
              comentarioCtrl.text = snapshot.data['comentario'];
              montoCtrl.text = snapshot.data['monto'].toString();
              fechaCtrl.text = snapshot.data['fecha'];
              fotoCtrl.text = snapshot.data['foto'];
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: comentarioCtrl,
                            decoration: InputDecoration(
                                labelText: 'comentario',
                                hintText: 'comentario del servicio',
                                suffixIcon: Icon(Icons.flag)),
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: montoCtrl,
                            decoration: InputDecoration(
                                labelText: 'monto',
                                hintText: 'monto',
                                suffixIcon: Icon(Icons.flag)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: fechaCtrl,
                            decoration: InputDecoration(
                                labelText: 'fecha',
                                hintText: 'fecha',
                                suffixIcon: Icon(Icons.flag)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: fotoCtrl,
                            decoration: InputDecoration(
                                labelText: 'foto',
                                hintText: 'foto',
                                suffixIcon: Icon(Icons.flag)),
                          ),
                        ),
                        Divider(),
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
                            child: Text('Editar servicio'),
                            onPressed: () => _servicioAgregar(context),
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
          },
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = ServiciosProvider();
    return await provider.getServicio(widget.id);
  }

  void _servicioAgregar(BuildContext context) {
    var provider = new ServiciosProvider();
    provider.serviciosEditar(comentarioCtrl.text, montoCtrl.text,
        fechaCtrl.text, fotoCtrl.text, widget.id.toString());
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
