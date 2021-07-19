import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';

class UbicacionEditarPage extends StatefulWidget {
  final int idubicacion;
  UbicacionEditarPage({this.idubicacion});

  @override
  _UbicacionEditarPageState createState() => _UbicacionEditarPageState();
}

class _UbicacionEditarPageState extends State<UbicacionEditarPage> {
  String ubicacion = '';
  var _tipos = <DropdownMenuItem>[];
  var _valorSeleccionado;
// Controllers //
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController localizacionCtrl = new TextEditingController();
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
          title: Text('Editar Ubicación'),
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
                                    hintText: 'Descripcion',
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
                                    hintText: 'Direccion',
                                    suffixIcon: Icon(MdiIcons.mapMarker)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar la dirección';
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
                                    hintText: 'Localizacion',
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
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(120, 139, 255, 1.0)),
                                ),
                                onPressed: () => _ubicacionEditar(context),
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
    var provider = UbicacionProvider();
    return await provider.getUbicacion(widget.idubicacion);
  }

  void _ubicacionEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new UbicacionProvider();
      provider.ubicacionEditar(
          widget.idubicacion,
          ubicacion,
          fotoCtrl.text,
          descripcionCtrl.text,
          direccionCtrl.text,
          localizacionCtrl.text); // usamos un controller //
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
        hint: Text('Tipo de la ubicacion'),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        onChanged: (value) {
          setState(() {
            ubicacion = value.toString();
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
    var provider = new TipoUbicacionProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(DropdownMenuItem(
            child: Text(tipo['nombre']), value: tipo['tipo_ubicacion']));
      });
    });
  }
}
