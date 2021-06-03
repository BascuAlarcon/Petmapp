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
  bool _validate = false;
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
      backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agregar Mascota'),
        backgroundColor: Color.fromRGBO(155, 177, 255, 1.0),
      ),
      body: Stack(children: <Widget>[
        Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(children: <Widget>[
                    FadeInImage(
                        image: NetworkImage(
                            'https://danbooru.donmai.us/data/sample/e5/2e/__samsung_sam_samsung_drawn_by_iwbitu_sa__sample-e52e8d8330554ccbada090d408606548.jpg'),
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    // Botón Agregar Foto
                  ]),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: TextFormField(
                            controller: nombreCtrl,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              labelText: 'Nombre',
                              hintText: 'Nombre de la Mascota',
                              suffixIcon: Icon(Icons.pets),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: TextField(
                            controller: sexoCtrl,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                labelText: 'Sexo',
                                hintText: 'Sexo de la Mascota',
                                suffixIcon: Icon(Icons.gesture_rounded)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: DropdownButtonFormField(
                            value: _valorSeleccionado,
                            items: _razas,
                            hint: Text('Razas'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
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
                  )
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
                      child: Text('Cancelar'),
                      style: ButtonStyle(
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
                      child: Text('Agregar Mascota'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(120, 139, 255, 1.0)),
                      ),
                      onPressed: () => _mascotaAgregar(context),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Positioned(
          right: 10.0,
          top: 260.0, // or whatever
          child: Container(
            child: InkWell(
              onTap: () => {},
              borderRadius: BorderRadius.circular(50.0),
              child: Container(
                width: 45.0,
                height: 45.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color.fromRGBO(180, 196, 247, 1.0)),
                  color: Color.fromRGBO(120, 139, 255, 1.0),
                ),
                child: Icon(
                  Icons.add_a_photo_rounded,
                  color: Colors.white,
                  size: 25.0,
                ),
              ),
            ),
          ),
        ),
      ]),
    );
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
