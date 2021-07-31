import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';

class HogarEditarPage extends StatefulWidget {
  final int idhogar;
  HogarEditarPage({this.idhogar});

  @override
  _HogarEditarPageState createState() => _HogarEditarPageState();
}

class _HogarEditarPageState extends State<HogarEditarPage> {
  var _disponibilidad = <DropdownMenuItem>[];
  var _tipo = <DropdownMenuItem>[];
  var _valorTipo, _valorDisponibilidad;
  String tipo, disponibilidad = '';

// Controllers //
  TextEditingController tipoHogarCtrl = new TextEditingController();
  TextEditingController disponibilidadCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController longitudCtrl = new TextEditingController();
  TextEditingController latitudCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _cargarDisponibilidad();
    _cargarTipo();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar Hogar'),
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
                  direccionCtrl.text = snapshot.data['direccion'];
                  fotoCtrl.text = snapshot.data['foto'];
                  longitudCtrl.text = snapshot.data['longitud'];
                  latitudCtrl.text = snapshot.data['latitud'];
                  _valorTipo = snapshot.data['tipo_hogar'];
                  _valorDisponibilidad = snapshot.data['disponibilidad_patio'];
                  snapshot.data['foto'] == null ? caso = 2 : caso = 0;
                  //_imagefile.path = snapshot.data['foto'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButtonFormField(
                                    value: _valorTipo,
                                    items: _tipo,
                                    hint: Text('¿Qué tipo de hogar es?'),
                                    validator: (valor) {
                                      if (valor == null) {
                                        return 'Debe ingresar la clase de hogar';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                    onChanged: (value) {
                                      setState(() {
                                        tipo = value.toString();
                                        _valorTipo = value;
                                      });
                                    })),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonFormField(
                                  value: _valorDisponibilidad,
                                  items: _disponibilidad,
                                  hint: Text('¿Su hogar cuenta con patio?'),
                                  validator: (valor) {
                                    if (valor == null) {
                                      return 'Debe ingresar la disponibilidad de patio';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onChanged: (value) {
                                    setState(() {
                                      disponibilidad = value.toString();
                                      _valorDisponibilidad = value;
                                    });
                                  }),
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
                                    labelText: 'direccion',
                                    hintText: 'direccion del hogar',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una dirección';
                                  }
                                  if (valor.length < 5) {
                                    return 'Direccion muy corta';
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
                                    hintText: 'Descripcion del hogar',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una descripcion';
                                  }
                                  if (valor.length < 5) {
                                    return 'Descripcion muy corta';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: longitudCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'longitud',
                                    hintText: 'longitud del hogar',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una longitud';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: latitudCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'latitud',
                                    hintText: 'latitud del hogar',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una latitud';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            _crearCampoFoto(),
                            caso == 0
                                ? _mostrarImagen(snapshot.data['foto'])
                                : Text(''),
                            caso == 1 ? _mostrarImagen('example') : Text(''),
                            caso == 2 ? Text('') : Text('')
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
                                onPressed: () => _hogarEditar(context),
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

  Widget _crearCampoFoto() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => tomarFoto(ImageSource.gallery),
          child: Text('Seleccionar foto'),
        ));
  }

  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();
  int caso = 2;

  Widget _mostrarImagen(foto) {
    return FadeInImage(
        image: caso == 0
            ? FileImage(File(foto))
            : FileImage(File(_imagefile.path)),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover);
  }

  void tomarFoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      pickedFile == null ? null : _imagefile = pickedFile;
      _imagefile == null ? null : caso = 1;
      _imagefile == null ? null : foto = _imagefile.path;
    });
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = HogarProvider();
    return await provider.gethogar(widget.idhogar);
  }

  void _hogarEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new HogarProvider();
      provider.hogarEditar(
          widget.idhogar,
          tipo,
          disponibilidad,
          direccionCtrl.text,
          descripcionCtrl.text,
          foto,
          longitudCtrl.text,
          latitudCtrl.text); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarDisponibilidad() async {
    _disponibilidad.add(DropdownMenuItem(child: Text("Si"), value: 0));
    _disponibilidad.add(DropdownMenuItem(child: Text("No"), value: 1));
  }

  _cargarTipo() async {
    _tipo.add(DropdownMenuItem(child: Text("Casa"), value: 0));
    _tipo.add(DropdownMenuItem(child: Text("Departamento"), value: 1));
  }
}
