import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/tipos_ubicacion_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarTipos();
  }

  final _formKey = GlobalKey<FormState>();
// Controllers //
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
                    _crearCampoTipo(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fotoCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
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
                        controller: direccionCtrl,
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: localizacionCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
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

  void _ubicacionAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new UbicacionProvider();
      provider.ubicacionAgregar(
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
