import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MascotasAgregarPage extends StatefulWidget {
  MascotasAgregarPage({Key key}) : super(key: key);

  @override
  _MascotasAgregarPageState createState() => _MascotasAgregarPageState();
}

class _MascotasAgregarPageState extends State<MascotasAgregarPage> {
// Controllers //
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController sexoCtrl = new TextEditingController();
  TextEditingController razaCtrl = new TextEditingController();
  TextEditingController usuarioCtrl = new TextEditingController();

  var raza = '';
  var rut = '';
  var _razas = <DropdownMenuItem>[];
  var _valorSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarRazas();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agregar Mascotas'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nombreCtrl,
                      decoration: InputDecoration(
                          labelText: 'Nombre',
                          hintText: 'Nombre de la Mascota',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: sexoCtrl,
                      decoration: InputDecoration(
                          labelText: 'Sexo',
                          hintText: 'Sexo de la Mascota',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField(
                      value: _valorSeleccionado,
                      items: _razas,
                      hint: Text('Razas'),
                      onChanged: (value) {
                        setState(() {
                          raza = value.toString();
                          _valorSeleccionado = value;
                        });
                      },
                    ),
                  )
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
                      child: Text('Agregar Mascota'),
                      onPressed: () => _mascotaAgregar(context),
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

  void _mascotaAgregar(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var provider = new PetmappProvider();
    rut = sharedPreferences.getStringList('usuario')[0];
    provider.mascotaAgregar(
        rut, nombreCtrl.text.trim(), sexoCtrl.text.trim(), raza);
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarRazas() async {
    var provider = new PetmappProvider();
    var razas = await provider.getRazas();
    razas.forEach((raza) {
      setState(() {
        _razas.add(DropdownMenuItem(
          child: Text(raza['nombre']),
          value: raza['id'],
        ));
      });
    });
  }
}
