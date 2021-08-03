// import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/place_service_v1.dart';
import 'package:petmapp_cliente/src/pages/address_search.dart';
import 'package:petmapp_cliente/src/pages/place_service_v1.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UbicacionesAgregarPage extends StatefulWidget {
  final int idPublicacion;
  UbicacionesAgregarPage({this.idPublicacion});
  @override
  _UbicacionesAgregarPageState createState() => _UbicacionesAgregarPageState();
}

class _UbicacionesAgregarPageState extends State<UbicacionesAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  String ubicacion = '';
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

  final _formKey = GlobalKey<FormState>();
// Controllers //
  TextEditingController TituloCtrl = new TextEditingController();
  TextEditingController tipoAlertaCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController localizacionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar una ubicación'),
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
                        controller: TituloCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Título',
                            hintText: 'Título',
                            suffixIcon: Icon(MdiIcons.tagText)),
                        validator: (valor) {
                          if (valor.isEmpty || valor == null) {
                            return 'Debe ingresar un titulo';
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
                        onTap: _busquedaDireccion,
                        controller: _destinationController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
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
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(4.0),
                    height: 45,
                    width: 180,
                    child: ElevatedButton(
                      child: Text('Cancelar'),
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
                      child: Text('Agregar Ubicación'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white12))),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(120, 139, 255, 1.0)),
                      ),
                      onPressed: () => _ubicacionAgregar(context),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }

  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();

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

  void _ubicacionAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new UbicacionProvider();
      provider.ubicacionAgregar(
        TituloCtrl.text,
        ubicacion,
        foto,
        descripcionCtrl.text,
        _destinationController.text,
        _latitude,
        _longitud,
      ); // usamos un controller //
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
        hint: Text('Tipo de la ubicacion'),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        onChanged: (value) {
          setState(() {
            print(value);
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
        _tipos.add(
            DropdownMenuItem(child: Text(tipo['nombre']), value: tipo['id']));
      });
    });
  }
}
