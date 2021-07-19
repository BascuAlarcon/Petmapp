import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/comentarios_ubicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComentariosUbicacionAgregarPage extends StatefulWidget {
  final int id;
  ComentariosUbicacionAgregarPage({this.id});
  @override
  _ComentariosUbicacionAgregarPageState createState() =>
      _ComentariosUbicacionAgregarPageState();
}

class _ComentariosUbicacionAgregarPageState
    extends State<ComentariosUbicacionAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String name = '';
  String rut = '';
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

// Controllers //
  TextEditingController descripcionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar un comentario'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: descripcionCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Comentario',
                            hintText: 'Agrege su comentario',
                            suffixIcon: Icon(MdiIcons.messageText)),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Debe agregar su comentario';
                          }
                          if (valor.length < 10) {
                            return 'Comentario muy corto';
                          }
                          return null;
                        },
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
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _comentarioAgregar(context),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      height: 40,
                      width: double.infinity,
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
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _comentarioAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new ComentarioUbicacionProvider();
      provider.comentarioAgregar(
          descripcionCtrl.text, widget.id.toString(), rut);
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
}
