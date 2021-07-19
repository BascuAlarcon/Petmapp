import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';

class NegocioEditarPage extends StatefulWidget {
  final int id;
  NegocioEditarPage({this.id});

  @override
  _NegocioEditarPageState createState() => _NegocioEditarPageState();
}

class _NegocioEditarPageState extends State<NegocioEditarPage> {
  String negocio = '';
  var _tipos = <DropdownMenuItem>[];
  var _valorSeleccionado;
// Controllers //
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController localizacionCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController horarioCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _cargarTipos();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar negocio'),
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
                  fotoCtrl.text = snapshot.data['foto'];
                  descripcionCtrl.text = snapshot.data['descripcion'];
                  direccionCtrl.text = snapshot.data['direccion'];
                  localizacionCtrl.text = snapshot.data['localizacion'];
                  nombreCtrl.text = snapshot.data['nombre'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _crearCampoTipo(),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: fotoCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Foto',
                                    hintText: 'Foto',
                                    suffixIcon: Icon(MdiIcons.camera)),
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
                                    hintText: 'Descripcion del negocio',
                                    suffixIcon: Icon(MdiIcons.tagText)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una descripción';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: direccionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Direccion',
                                    hintText: 'Direccion del negocio',
                                    suffixIcon: Icon(MdiIcons.mapMarker)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar la dirección del negocio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: localizacionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Localizacion',
                                    hintText: 'Localizacion del negocio',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar las coordenadas';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nombreCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Nombre',
                                    hintText: 'Nombre del negocio',
                                    suffixIcon: Icon(MdiIcons.store)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar el nombre del negocio';
                                  }
                                  if (valor.length < 5) {
                                    return 'Debe ingresar el nombre del negocio';
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
                                onPressed: () => _negocioEditar(context),
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
    var provider = NegocioProvider();
    return await provider.getNegocio(widget.id);
  }

  void _negocioEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new NegocioProvider();
      provider.negocioEditar(
          widget.id,
          negocio,
          fotoCtrl.text,
          descripcionCtrl.text,
          direccionCtrl.text,
          localizacionCtrl.text,
          nombreCtrl.text); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _crearCampoTipo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        value: _valorSeleccionado,
        items: _tipos,
        hint: Text('Tipo de Negocio'),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        onChanged: (value) {
          setState(() {
            negocio = value.toString();
            _valorSeleccionado = value;
          });
        },
        validator: (valor) {
          if (valor == null) {
            return 'Seleccione un valor';
          }
          return null;
        },
      ),
    );
  }

  _cargarTipos() async {
    var provider = new TipoProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(DropdownMenuItem(
            child: Text(tipo['nombre']), value: tipo['tipo_negocio']));
      });
    });
  }
}
