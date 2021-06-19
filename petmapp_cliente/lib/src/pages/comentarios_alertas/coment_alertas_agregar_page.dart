import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/comentarios_alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentariosAlertaAgregarPage extends StatefulWidget {
  final int id;
  ComentariosAlertaAgregarPage({this.id});
  @override
  _ComentariosAlertaAgregarPageState createState() =>
      _ComentariosAlertaAgregarPageState();
}

class _ComentariosAlertaAgregarPageState
    extends State<ComentariosAlertaAgregarPage> {
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
  TextEditingController fechaEmisionCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Comentario'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fechaEmisionCtrl,
                      decoration: InputDecoration(
                          labelText: 'Fecha Emision',
                          hintText: 'Fecha Emision',
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
                      child: Text('Agregar comentario'),
                      onPressed: () => _comentarioAgregar(context),
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

  void _comentarioAgregar(BuildContext context) {
    var provider = new ComentarioAlertaProvider();
    provider.comentarioAgregar(descripcionCtrl.text, fechaEmisionCtrl.text,
        fotoCtrl.text, widget.id.toString(), rut);
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
