import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
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
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fechaCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'fecha',
                            hintText: 'fecha',
                            suffixIcon: Icon(MdiIcons.calendar)),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: fotoCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'foto',
                            hintText: 'foto',
                            suffixIcon: Icon(MdiIcons.camera)),
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

  void _servicioAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var montoTotal = widget.boleta + int.tryParse(montoCtrl.text);
      var provider = new ServiciosProvider();
      provider.serviciosAgregar(
          comentarioCtrl.text,
          montoCtrl.text,
          montoTotal.toString(),
          fechaCtrl.text,
          fotoCtrl.text,
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
}
