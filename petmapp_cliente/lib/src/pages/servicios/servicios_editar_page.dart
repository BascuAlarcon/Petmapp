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
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar servicio'),
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
                            child: TextFormField(
                              controller: comentarioCtrl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  labelText: 'comentario',
                                  hintText: 'comentario del servicio',
                                  suffixIcon: Icon(Icons.flag)),
                              validator: (valor) {
                                if (valor.isEmpty || valor == null) {
                                  return 'Debe ingresar una descripcion';
                                }
                                return null;
                              },
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: montoCtrl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  labelText: 'monto',
                                  hintText: 'monto',
                                  suffixIcon: Icon(Icons.flag)),
                              validator: (valor) {
                                if (valor.isEmpty || valor == null) {
                                  return 'Debe ingresar el monto del servicio';
                                }
                                return null;
                              },
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: fechaCtrl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  labelText: 'fecha',
                                  hintText: 'fecha',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: fotoCtrl,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
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
                              child: Text('Guardar Cambios'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: Colors.white12))),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromRGBO(120, 139, 255, 1.0)),
                              ),
                              onPressed: () => _servicioEditar(context),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            height: 40,
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Volver'),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side:
                                            BorderSide(color: Colors.white12))),
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
            },
          ),
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = ServiciosProvider();
    return await provider.getServicio(widget.id);
  }

  void _servicioEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new ServiciosProvider();
      provider.serviciosEditar(comentarioCtrl.text, montoCtrl.text,
          fechaCtrl.text, fotoCtrl.text, widget.id.toString());
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
