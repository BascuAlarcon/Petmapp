import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiciosAgregarPage extends StatefulWidget {
  final int idPeticion;
  final int boleta;
  ServiciosAgregarPage({this.idPeticion, this.boleta});
  @override
  _ServiciosAgregarPageState createState() => _ServiciosAgregarPageState();
}

class _ServiciosAgregarPageState extends State<ServiciosAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  bool _validate = false;
  DateTime _fecha = DateTime.now();
  DateTime _inicio, _fin;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    traerFechasPeticion();
  }

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
          title: Text('Agregar un servicio'),
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
                      child: TextFormField(
                        controller: comentarioCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'comentario',
                            hintText: 'comentario del servicio',
                            suffixIcon: Icon(MdiIcons.messageText)),
                        validator: (valor) {
                          if (valor.isEmpty || valor == null) {
                            return 'Debe indicar una descripción del servicio';
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
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'monto',
                            hintText: 'monto',
                            suffixIcon: Icon(MdiIcons.currencyUsd)),
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
                      padding: const EdgeInsets.all(17.0),
                      child: TextFormField(
                        controller: fechaCtrl,
                        onTap: () {
                          _mostrarFechaInicio(context);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          labelText: 'Fecha de inicio del cuidado',
                          hintText: 'Fecha de inicio',
                          suffixIcon: Icon(Icons.date_range),
                          errorText: _validate ? 'Value Can\'t Be Empty' : null,
                        ),
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
                        child: Text('Agregar Servicio'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _servicioAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Future _mostrarFechaInicio(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: _inicio,
            firstDate: _inicio,
            lastDate: _fin)
        .then((value) => setState(() {
              if (value != null) {
                _fecha = value;
                fechaCtrl.text =
                    DateFormat('yyyy-MM-dd').format(value).toString();
              }
            }));
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

  void _servicioAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      int montoTotal;
      montoTotal = (widget.boleta + int.tryParse(montoCtrl.text));
      var provider = new ServiciosProvider();
      provider.serviciosAgregar(
          comentarioCtrl.text,
          montoCtrl.text,
          montoTotal.toString(),
          fechaCtrl.text,
          foto,
          widget.idPeticion.toString());
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
      name = sharedPreferencess.getStringList('usuario')[2];
    });
  }

  void traerFechasPeticion() async {
    var provider = PeticionProvider();
    var peticiones = await provider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['id'] == widget.idPeticion) {
        _inicio = DateTime.parse(peticion['fecha_inicio']);
        _fin = DateTime.parse(peticion['fecha_fin']);
      }
    }
  }
}
