import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HogaresAgregarPage extends StatefulWidget {
  HogaresAgregarPage({Key key}) : super(key: key);
  @override
  _HogaresAgregarPageState createState() => _HogaresAgregarPageState();
}

class _HogaresAgregarPageState extends State<HogaresAgregarPage> {
  SharedPreferences sharedPreferences;
  String email, name, rut, tipo, disponibilidad = '';
  var _disponibilidad = <DropdownMenuItem>[];
  var _tipo = <DropdownMenuItem>[];
  var _valorTipo, _valorDisponibilidad;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarDisponibilidad();
    _cargarTipo();
  }

// Controllers //
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController longitudCtrl = new TextEditingController();
  TextEditingController latitudCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar un hogar'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
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
                                    borderRadius: BorderRadius.circular(20.0))),
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
                                  borderRadius: BorderRadius.circular(20.0))),
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
                                borderRadius: BorderRadius.circular(20.0)),
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
                                borderRadius: BorderRadius.circular(20.0)),
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
                                borderRadius: BorderRadius.circular(20.0)),
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
                                borderRadius: BorderRadius.circular(20.0)),
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
                    _mostrarImagen()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 180,
                      child: ElevatedButton(
                        child: Text('Volver'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(199, 199, 183, 1.0)),
                        ),
                        onPressed: () => _navegarCancelar(context),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(4.0),
                      height: 45,
                      width: 180,
                      child: ElevatedButton(
                        child: Text('Agregar Hogar'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _hogarAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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

  Widget _mostrarImagen() {
    return FadeInImage(
        width: 300,
        height: 300,
        image: _imagefile == null
            ? NetworkImage(
                'https://cdn.dribbble.com/users/1030477/screenshots/4704756/dog_allied.gif')
            : FileImage(File(_imagefile.path)),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover);
  }

  void tomarFoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedFile;
      _imagefile == null ? null : foto = _imagefile.path;
    });
  }

  void _hogarAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new HogarProvider();
      provider.hogarAgregar(
          tipo,
          disponibilidad,
          direccionCtrl.text,
          descripcionCtrl.text,
          foto,
          longitudCtrl.text,
          latitudCtrl.text,
          rut); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      /* listaDatos = sharedPreferencess.getStringList("usuario");
      print(listaDatos); */
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
    });
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
