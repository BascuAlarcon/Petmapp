import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/address_search.dart';
import 'package:petmapp_cliente/src/pages/place_service_v1.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

class NegociosAgregarPage extends StatefulWidget {
  final int idPublicacion;
  NegociosAgregarPage({this.idPublicacion});
  @override
  _NegociosAgregarPageState createState() => _NegociosAgregarPageState();
}

class _NegociosAgregarPageState extends State<NegociosAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String negocio = '';
  var _tipos = <DropdownMenuItem>[];
  var _valorSeleccionado;

  //Cosas que agregué ahora
  final _destinationController = TextEditingController();
  String _latitude = '';
  String _longitud = '';

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  _busquedaDireccion() async {
    final sessionToken = Uuid().v4();
    final Suggestion result = await showSearch(
        context: context, delegate: AddressSearch(sessionToken));
    if (result != null) {
      final placeDetails = await PlaceApiProvider(sessionToken)
          .getPlaceDetailFromId(result.placeId);
      setState(() {
        _latitude = placeDetails.latitud;
        _longitud = placeDetails.longitud;
        _destinationController.text = result.description;
      });
    }
  }
  /////////////////////////

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarTipos();
  }

// Controllers //
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController horarioCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar un negocio'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _mostrarImagen(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: nombreCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Nombre',
                            hintText: 'Nombre del negocio',
                            suffixIcon: Icon(MdiIcons.store)),
                        validator: (valor) {
                          if (valor.isEmpty || valor == null) {
                            return 'Debe ingresar el nombre del negocio';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    _crearCampoTipo(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: descripcionCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
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
                        onTap: _busquedaDireccion,
                        controller: _destinationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Direccion',
                            hintText: 'Direccion del negocio',
                            suffixIcon: Icon(MdiIcons.mapMarker)),
                        // validator: (valor) {
                        //   if (valor.isEmpty || valor == null) {
                        //     return 'Debe ingresar la dirección del negocio';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    Divider(),
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
                        child: Text('Agregar Negocio'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _negociosAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();

  //Se agrandó esto 1
  Widget _mostrarImagen() {
    return Stack(
      children: [
        FadeInImage(
            image: _imagefile == null
                ? NetworkImage(
                    'https://cdn.dribbble.com/users/1030477/screenshots/4704756/dog_allied.gif')
                : FileImage(File(_imagefile.path)),
            placeholder: AssetImage('assets/jar-loading.gif'),
            fit: BoxFit.cover),
        IconButton(
          icon: new Icon(
            Icons.add_a_photo_rounded,
            color: Colors.white,
          ),
          highlightColor: Colors.pink,
          onPressed: () {
            tomarFoto(ImageSource.camera);
          },
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: IconButton(
            icon: new Icon(
              Icons.folder_special_outlined,
              color: Colors.white,
            ),
            highlightColor: Colors.pink,
            onPressed: () {
              tomarFoto(ImageSource.gallery);
            },
          ),
        ),
      ],
    );
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

  void _negociosAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new NegocioProvider();
      provider.negocioAgregar(
          negocio,
          foto,
          descripcionCtrl.text,
          _destinationController.text,
          _latitude,
          _longitud,
          nombreCtrl.text); // usamos un controller //
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
        _tipos.add(
            DropdownMenuItem(child: Text(tipo['nombre']), value: tipo['id']));
      });
    });
  }
}
