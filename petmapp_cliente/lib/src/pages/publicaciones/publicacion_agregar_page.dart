import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PublicacionesAgregarPage extends StatefulWidget {
  PublicacionesAgregarPage({Key key}) : super(key: key);
  @override
  _PublicacionesAgregarPageState createState() =>
      _PublicacionesAgregarPageState();
}

class _PublicacionesAgregarPageState extends State<PublicacionesAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  var _hogares = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var _hogar = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarHogares();
  }

// Controllers //
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController tarifaCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar una publicación'),
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
                        controller: descripcionCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
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
                                borderRadius: BorderRadius.circular(20.0)),
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
                    Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: DropdownButtonFormField(
                        value: _valorSeleccionado,
                        items: _hogares,
                        hint: Text('Hogar'),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                        onChanged: (value) {
                          setState(() {
                            _hogar = value.toString();
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
                    ),
                    _hogares.length == 0
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Debe al menos ingresar un hogar para usar este servicio :)',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Text(':)')
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
                        child: Text('Agregar Publicación'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _publicacionAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _publicacionAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new PublicacionProvider();
      provider.publicacionAgregar("", descripcionCtrl.text, tarifaCtrl.text,
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

  _cargarHogares() async {
    var provider = new HogarProvider();
    var hogares = await provider.hogarListar();
    hogares.forEach((hogar) {
      if (hogar['usuario_rut'].toString() == rut.toString()) {
        setState(() {
          _hogares.add(DropdownMenuItem(
              child: Text(hogar['direccion']), value: hogar['id']));
        });
      }
    });
  }
}
