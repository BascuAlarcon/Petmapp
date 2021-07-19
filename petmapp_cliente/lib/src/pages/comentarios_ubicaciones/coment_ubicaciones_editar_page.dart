import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  TextEditingController descripcionCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar comentario'),
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
                  descripcionCtrl.text = snapshot.data['descripcion'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descripcionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Comentario',
                                    hintText: 'Agrege su comentario',
                                    suffixIcon: Icon(MdiIcons.messageText)),
                                validator: (valor) {
                                  if (valor == null || valor.isEmpty) {
                                    return 'Debe agregar su comentario';
                                  }
                                  if (valor.length < 10) {
                                    return 'Comentario muy corto';
                                  }
                                  return null;
                                },
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
                                child: Text('Guardar comentario'),
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
                                onPressed: () => _comentarioEditar(context),
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
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(199, 199, 183, 1.0)),
                                ),
                                onPressed: () => _navegarCancelar(context),
                              ),
                            ),
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
    var provider = ComentarioUbicacionProvider();
    return await provider.getComentario(widget.id);
  }

  void _comentarioEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new ComentarioUbicacionProvider();
      provider.comentarioEditar(
        widget.id,
        descripcionCtrl.text,
      );
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
