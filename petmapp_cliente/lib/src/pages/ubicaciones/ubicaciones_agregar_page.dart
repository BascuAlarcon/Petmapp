import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

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
          title: Text('Agregar Alerta'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: tipoAlertaCtrl,
                      decoration: InputDecoration(
                          labelText: 'Tipo Ubicacion',
                          hintText: 'Tipo Ubicacion',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fotoCtrl,
                      decoration: InputDecoration(
                          labelText: 'Foto',
                          hintText: 'Foto',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descripcionCtrl,
                      decoration: InputDecoration(
                          labelText: 'Descripcion',
                          hintText: 'Descripcion',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: direccionCtrl,
                      decoration: InputDecoration(
                          labelText: 'Direccion',
                          hintText: 'Direccion',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: localizacionCtrl,
                      decoration: InputDecoration(
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
                      child: Text('Agregar ubicacions'),
                      onPressed: () => _ubicacionsAgregar(context),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Cancelar'),
                      onPressed: () => _navegarCancelar(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  void _ubicacionsAgregar(BuildContext context) {
    var provider = new UbicacionProvider();
    provider.ubicacionAgregar(
        tipoAlertaCtrl.text,
        fotoCtrl.text,
        descripcionCtrl.text,
        direccionCtrl.text,
        localizacionCtrl.text); // usamos un controller //
    Navigator.pop(context);
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
}
