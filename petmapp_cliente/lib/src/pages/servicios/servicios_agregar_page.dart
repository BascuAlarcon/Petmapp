import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/servicios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiciosAgregarPage extends StatefulWidget {
  final int idPeticion;
  ServiciosAgregarPage({this.idPeticion});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Publicacion'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: comentarioCtrl,
                      decoration: InputDecoration(
                          labelText: 'comentario',
                          hintText: 'comentario del servicio',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: montoCtrl,
                      decoration: InputDecoration(
                          labelText: 'monto',
                          hintText: 'monto',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fechaCtrl,
                      decoration: InputDecoration(
                          labelText: 'fecha',
                          hintText: 'fecha',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fotoCtrl,
                      decoration: InputDecoration(
                          labelText: 'foto',
                          hintText: 'foto',
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
                      child: Text('Agregar servicio'),
                      onPressed: () => _servicioAgregar(context),
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

  void _servicioAgregar(BuildContext context) {
    var provider = new ServiciosProvider();
    provider.serviciosAgregar(comentarioCtrl.text, montoCtrl.text,
        fechaCtrl.text, fotoCtrl.text, widget.idPeticion.toString());
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
      name = sharedPreferencess.getStringList('usuario')[2];
    });
  }
}
