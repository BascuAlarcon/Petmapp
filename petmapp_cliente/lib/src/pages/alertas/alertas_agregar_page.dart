import 'dart:io';
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertasAgregarPage extends StatefulWidget {
  final int idPublicacion;
  AlertasAgregarPage({this.idPublicacion});
  @override
  _AlertasAgregarPageState createState() => _AlertasAgregarPageState();
}

class _AlertasAgregarPageState extends State<AlertasAgregarPage> {
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarTiposAlertas();
  }

  // VARIABLES //
  String email, name, rut, alerta = '';
  var _tipos = <DropdownMenuItem>[];
  var _valorSeleccionado;
  SharedPreferences sharedPreferences;
  final _formKey = GlobalKey<FormState>();
  // Controllers //
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController latitudCtrl = new TextEditingController();
  TextEditingController longitudCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar una alerta'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  // CAMPOS FORMULARIO //
                  children: [
                    _crearAlerta(),
                    Divider(),
                    _crearCampoDescripcion(),
                    Divider(),
                    _crearCampoDireccion(),
                    Divider(),
                    _crearCampoLatitud(),
                    Divider(),
                    _crearCampoLongitud(),
                    Divider(),
                    _crearCampoFoto(),
                    Divider(),
                    _mostrarImagen()
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _botonCancelar(),
                    _botonAgregar(),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  // WIDGETS //
  // BOTONES //
  Widget _botonAgregar() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(4.0),
      height: 45,
      width: 180,
      child: ElevatedButton(
        child: Text('Agregar Alerta'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(120, 139, 255, 1.0)),
        ),
        onPressed: () => _alertasAgregar(context),
      ),
    );
  }

  Widget _botonCancelar() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(4.0),
      height: 45,
      width: 180,
      child: ElevatedButton(
        child: Text('Cancelar'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(199, 199, 183, 1.0)),
        ),
        onPressed: () => _navegarCancelar(context),
      ),
    );
  }

  // DROPDOWN //
  Widget _crearAlerta() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        value: _valorSeleccionado,
        items: _tipos,
        hint: Text('Tipo de Alerta'),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        onChanged: (value) {
          setState(() {
            alerta = value.toString();
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

  _cargarTiposAlertas() async {
    var provider = new TipoAlertaProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(
            DropdownMenuItem(child: Text(tipo['nombre']), value: tipo['id']));
      });
    });
  }

  Widget _crearCampoDescripcion() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            controller: descripcionCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                labelText: 'Descripcion',
                hintText: 'Descripción de la alerta',
                suffixIcon: Icon(MdiIcons.tagText)),
            validator: (valor) {
              if (valor.isEmpty || valor == null) {
                return 'Indique una descripción';
              }
              if (valor.length < 10) {
                return 'La descripción debe contener al menos 10 cáracteres';
              }
              return null;
            }));
  }

  Widget _crearCampoLatitud() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: latitudCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'latitud',
              hintText: 'latitud',
              suffixIcon: Icon(MdiIcons.flag)),
          validator: (valor) {
            if (valor.isEmpty || valor == null) {
              return 'Indique una latitud';
            }
            return null;
          }),
    );
  }

  Widget _crearCampoLongitud() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: longitudCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'longitud',
              hintText: 'longitud',
              suffixIcon: Icon(MdiIcons.flag)),
          validator: (valor) {
            if (valor.isEmpty || valor == null) {
              return 'Indique una longitud';
            }
            return null;
          }),
    );
  }

  Widget _crearCampoDireccion() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            controller: direccionCtrl,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: 'Direccion de la alerta',
              labelText: 'Direccion',
              suffixIcon: Icon(MdiIcons.mapMarker),
            ),
            validator: (valor) {
              if (valor.isEmpty || valor == null) {
                return 'Indique una direccion';
              }
              if (valor.length < 10) {
                return 'La dirección debe contener al menos 10 cáracteres';
              }
              return null;
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
      foto = _imagefile.path;
    });
  }

  // NAVEGADORES //
  void _alertasAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new AlertaProvider();
      provider.alertaAgregar(
          rut,
          alerta,
          foto,
          descripcionCtrl.text,
          direccionCtrl.text,
          latitudCtrl.text,
          longitudCtrl.text); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  //  SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
    });
  }
}
