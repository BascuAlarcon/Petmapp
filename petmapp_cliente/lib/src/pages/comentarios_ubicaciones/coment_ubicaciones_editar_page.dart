import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/comentarios_ubicaciones_provider.dart';

class ComentariosUbicacionEditarPage extends StatefulWidget {
  final int id;
  ComentariosUbicacionEditarPage({this.id});

  @override
  _ComentariosUbicacionEditarPageState createState() =>
      _ComentariosUbicacionEditarPageState();
}

class _ComentariosUbicacionEditarPageState
    extends State<ComentariosUbicacionEditarPage> {
// Controllers //
  TextEditingController fechaEmisionCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar Ubicacions'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                fotoCtrl.text = snapshot.data['foto'];
                descripcionCtrl.text = snapshot.data['descripcion'];
                fechaEmisionCtrl.text = snapshot.data['fecha_emision'];
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fechaEmisionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Fecha emision',
                                  hintText: 'Fecha emision del comentario',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fotoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Foto',
                                  hintText: 'Foto asociada',
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
                                  hintText: 'Descripcion del comentario',
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
                              child: Text('Editar Ubicacion'),
                              onPressed: () => _comentarioEditar(context),
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
    var provider = ComentarioUbicacionProvider();
    return await provider.getComentario(widget.id);
  }

  void _comentarioEditar(BuildContext context) {
    var provider = new ComentarioUbicacionProvider();
    provider.comentarioEditar(
      widget.id,
      descripcionCtrl.text,
      fechaEmisionCtrl.text,
      fotoCtrl.text,
    ); 
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
