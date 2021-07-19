import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/especie_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';

class RazasAgregarPage extends StatefulWidget {
  RazasAgregarPage({Key key}) : super(key: key);

  @override
  _RazasAgregarPageState createState() => _RazasAgregarPageState();
}

class _RazasAgregarPageState extends State<RazasAgregarPage> {
  var _especies = <DropdownMenuItem>[];
  var _valorSeleccionado3;
  var especie = '';
// Controllers //
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _cargarEspecies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar Raza'),
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
                        controller: nombreCtrl,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            labelText: 'Nombre',
                            hintText: 'Nombre de la raza',
                            suffixIcon: Icon(MdiIcons.tag)),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Debe agregar un nombre';
                          }
                          return null;
                        },
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
                            hintText: 'Descripcion de la raza',
                            suffixIcon: Icon(MdiIcons.noteText)),
                        validator: (valor) {
                          if (valor == null || valor.isEmpty) {
                            return 'Debe agregar una descripcion';
                          }
                          return null;
                        },
                      ),
                    ),
                    Divider(),
                    Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: DropdownButtonFormField(
                          value: _valorSeleccionado3,
                          items: _especies,
                          hint: Text('Especie'),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          onChanged: (value) {
                            setState(() {
                              especie = value.toString();
                              _valorSeleccionado3 = value;
                            });
                          },
                          validator: (valor) {
                            if (valor == null) {
                              return 'Seleccione una raza';
                            }
                            return null;
                          },
                        )),
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
                        child: Text('Agregar Raza'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _razaAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _razaAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new RazasProvider();
      provider.razaAgregar(nombreCtrl.text, descripcionCtrl.text,
          especie); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarEspecies() async {
    var provider = new EspecieProvider();
    var especies = await provider.especieListar();
    especies.forEach((especie) {
      setState(() {
        _especies.add(DropdownMenuItem(
            child: Text(especie['nombre']), value: especie['id']));
      });
    });
  }
}
