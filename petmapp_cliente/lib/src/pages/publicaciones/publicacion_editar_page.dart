import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  TextEditingController tituloCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar Publicación'),
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
                  descripcionCtrl.text =
                      snapshot.data['descripcion'].toString();
                  tarifaCtrl.text = snapshot.data['tarifa'].toString();
                  tituloCtrl.text = snapshot.data['titulo'].toString();
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                    controller: tituloCtrl,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        labelText: 'Titulo',
                                        hintText: 'Titulo de la publicacion',
                                        suffixIcon: Icon(MdiIcons.tagText)),
                                    validator: (valor) {
                                      if (valor.isEmpty || valor == null) {
                                        return 'Indique un Titulo';
                                      }
                                      if (valor.length < 5) {
                                        return 'El Titulo debe contener al menos 5 cáracteres';
                                      }
                                      return null;
                                    })),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descripcionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Descripcion',
                                    hintText: 'Descripcion de la publicacion',
                                    suffixIcon: Icon(MdiIcons.tagText)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Ingrese una descripción de la publicación';
                                  }
                                  if (valor.length < 10) {
                                    return 'Descripción demasiado corta';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: tarifaCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Tarifa',
                                    hintText: 'Tarifa',
                                    suffixIcon: Icon(MdiIcons.currencyUsd)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Ingrese la tarfia diaria';
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
                                onPressed: () => _publicacionEditar(context),
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
    var provider = PublicacionProvider();
    return await provider.getpublicacion(widget.idpublicacion);
  }

  void _publicacionEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new PublicacionProvider();
      provider.publicacionEditar(
        tituloCtrl.text,
        widget.idpublicacion,
        descripcionCtrl.text,
        tarifaCtrl.text,
      ); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
