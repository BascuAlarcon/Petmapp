import 'dart:collection'; 
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';

class PublicacionEditarPage extends StatefulWidget {
  final int idpublicacion;
  PublicacionEditarPage({this.idpublicacion});

  @override
  _PublicacionEditarPageState createState() => _PublicacionEditarPageState();
}

class _PublicacionEditarPageState extends State<PublicacionEditarPage> {
// Controllers //
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController tarifaCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar publicaciones'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                descripcionCtrl.text = snapshot.data['descripcion'].toString();
                tarifaCtrl.text = snapshot.data['tarifa'].toString();
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: descripcionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Descripcion',
                                  hintText: 'Descripcion de la publicacion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tarifaCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Tarifa',
                                  hintText: 'Tarifa',
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
                              child: Text('Editar  publicacion'),
                              onPressed: () => _publicacionEditar(context),
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
    var provider = PublicacionProvider();
    return await provider.getpublicacion(widget.idpublicacion);
  }

  void _publicacionEditar(BuildContext context) {
    var provider = new PublicacionProvider();
    provider.publicacionEditar(
      widget.idpublicacion,
      descripcionCtrl.text,
      tarifaCtrl.text,
    ); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
