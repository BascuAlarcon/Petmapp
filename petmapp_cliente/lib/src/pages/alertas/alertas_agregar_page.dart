import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertasAgregarPage extends StatefulWidget {
  final int idPublicacion;
  AlertasAgregarPage({this.idPublicacion});
  @override
  _AlertasAgregarPageState createState() => _AlertasAgregarPageState();
}

class _AlertasAgregarPageState extends State<AlertasAgregarPage> {
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
  TextEditingController habilitadoCtrl = new TextEditingController();
  TextEditingController ultimaActividadCtrl = new TextEditingController();
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
                          labelText: 'Tipo Alerta',
                          hintText: 'Tipo Alerta',
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: habilitadoCtrl,
                      decoration: InputDecoration(
                          labelText: 'Habilitado',
                          hintText: 'Habilitado',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: ultimaActividadCtrl,
                      decoration: InputDecoration(
                          labelText: 'Ultima actividad',
                          hintText: 'Ultima actividad',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
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
                      child: Text('Agregar alertas'),
                      onPressed: () => _alertasAgregar(context),
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

  void _alertasAgregar(BuildContext context) {
    var provider = new AlertaProvider();
    provider.alertaAgregar(
        rut,
        tipoAlertaCtrl.text,
        fotoCtrl.text,
        descripcionCtrl.text,
        direccionCtrl.text,
        localizacionCtrl.text,
        habilitadoCtrl.text,
        ultimaActividadCtrl.text); // usamos un controller //
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
