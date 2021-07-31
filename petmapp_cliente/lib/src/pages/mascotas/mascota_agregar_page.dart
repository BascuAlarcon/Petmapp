import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petmapp_cliente/src/providers/especie_provider.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class MascotasAgregarPage extends StatefulWidget {
  MascotasAgregarPage({Key key}) : super(key: key);

  @override
  _MascotasAgregarPageState createState() => _MascotasAgregarPageState();
}

class _MascotasAgregarPageState extends State<MascotasAgregarPage> {
// Validaciones //
  final _formKey = GlobalKey<FormState>();
  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();
// Controllers //
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController sexoCtrl = new TextEditingController();
  TextEditingController estirilizacionCtrl = new TextEditingController();
  TextEditingController fechaNacimientoCtrl = new TextEditingController();
  TextEditingController condicionMedicaCtrl = new TextEditingController();
  TextEditingController microchipCtrl = new TextEditingController();
  TextEditingController alimentosCtrl = new TextEditingController();
  TextEditingController personalidadCtrl = new TextEditingController();
  TextEditingController razaCtrl = new TextEditingController();
  TextEditingController usuarioCtrl = new TextEditingController();
  bool _validate = false;
  var raza = '';
  var especie = '';
  var rut = '';
  var sexo = '';
  var _razas = <DropdownMenuItem>[];
  var _perros = <DropdownMenuItem>[];
  var _gatos = <DropdownMenuItem>[];
  var _sexo = <DropdownMenuItem>[];
  var _especies = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var _valorSeleccionado2;
  var _valorSeleccionado3;
  var _esterilizcion = <DropdownMenuItem>[];
  var _condicion = <DropdownMenuItem>[];
  var esterilizacion = '';
  var condicion = '';
  var microchip = '';
  var _microchip = <DropdownMenuItem>[];
  var _valorEsterilizacion;
  var _valorCondicion;
  var _valorMicrochip;
  var _valorSeleccionadoPerros;
  var _valorSeleccionadoGatos;
  DateTime _fechaNacimiento;

  @override
  void initState() {
    _fechaNacimiento = DateTime.now();
    super.initState();
    _cargarEspecies();
    _cargarSexo();
    _cargarRazas(1);
    _cargarEsterilizacion();
    _cargarCondicion();
    _cargarMicrochip();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1.0),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agregar Mascota'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
      ),
      body: // Form(
          // key: _formKey,
          /* child: */ Stack(children: <Widget>[
        Column(
          children: [
            Expanded(
              child: ListView(
                children: <Widget>[
                  Stack(children: <Widget>[
                    FadeInImage(
                        image: _imagefile == null
                            ? NetworkImage(
                                'https://cdn.dribbble.com/users/1030477/screenshots/4704756/dog_allied.gif')
                            : FileImage(File(_imagefile.path)),
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover),
                    //           size: 25.0,
                    //         ),
                    IconButton(
                      icon: new Icon(
                        Icons.add_a_photo_rounded,
                        color: Colors.white,
                      ),
                      highlightColor: Colors.pink,
                      onPressed: () {
                        tomarFoto(ImageSource.camera);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: IconButton(
                        icon: new Icon(
                          Icons.folder_special_outlined,
                          color: Colors.white,
                        ),
                        highlightColor: Colors.pink,
                        onPressed: () {
                          tomarFoto(ImageSource.gallery);
                        },
                      ),
                    ),
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
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
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
                          child: DropdownButtonFormField(
                            value: _valorEsterilizacion,
                            items: _esterilizcion,
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un sexo';
                                }
                                return null;
                              }, */
                            hint: Text('¿La mascota está esterilizada?'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onChanged: (value) {
                              setState(() {
                                esterilizacion = value.toString();
                                _valorEsterilizacion = value;
                              });
                            },
                          ),
                        ),
                        // Padding(
                        //     padding: const EdgeInsets.all(17.0),
                        //     child: Row(
                        //       children: [
                        //         Expanded(
                        //             child: Text(DateFormat('dd-MM-yyyy')
                        //                 .format(_fechaNacimiento))),
                        //         FlatButton(
                        //             onPressed: () {
                        //               showDatePicker(
                        //                       context: context,
                        //                       initialDate: DateTime.now(),
                        //                       firstDate: DateTime(1900),
                        //                       lastDate: DateTime.now())
                        //                   .then((fecha) => setState(() {
                        //                         _fechaNacimiento = fecha;
                        //                       }));
                        //               fechaNacimientoCtrl.text = Text(
                        //                       DateFormat('dd-MM-yyyy')
                        //                           .format(_fechaNacimiento))
                        //                   .toString();
                        //             },
                        //             child: Icon(Icons.date_range))
                        //       ],
                        //     )),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: TextFormField(
                            controller: fechaNacimientoCtrl,
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: fechaNacimientoCtrl == null
                                          ? DateTime.now()
                                          : _fechaNacimiento,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime.now())
                                  .then((value) => setState(() {
                                        if (value != null) {
                                          _fechaNacimiento = value;
                                          fechaNacimientoCtrl.text =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(value)
                                                  .toString();
                                        }
                                      }));
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              labelText: 'Fecha de nacimiento',
                              hintText: 'Fecha de nacimiento',
                              suffixIcon: Icon(Icons.date_range),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: DropdownButtonFormField(
                            value: _valorCondicion,
                            items: _condicion,
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un sexo';
                                }
                                return null;
                              }, */
                            hint: Text('¿La mascota tiene alguna enfermedad?'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onChanged: (value) {
                              setState(() {
                                condicion = value.toString();
                                _valorCondicion = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: DropdownButtonFormField(
                            value: _valorMicrochip,
                            items: _microchip,
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un sexo';
                                }
                                return null;
                              }, */
                            hint: Text('¿La mascota cuenta con microchip?'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onChanged: (value) {
                              setState(() {
                                microchip = value.toString();
                                _valorMicrochip = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: TextFormField(
                            controller: alimentosCtrl,
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              labelText: 'Alimentos',
                              hintText: 'Alimentos que consume la mascota',
                              suffixIcon: Icon(Icons.pets),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: TextFormField(
                            controller: personalidadCtrl,
                            /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              labelText: 'Personalidad',
                              hintText: '¿Cómo se comporta su mascota?',
                              suffixIcon: Icon(Icons.pets),
                              errorText:
                                  _validate ? 'Value Can\'t Be Empty' : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(17.0),
                          child: DropdownButtonFormField(
                            value: _valorSeleccionado2,
                            items: _sexo,
                            hint: Text('Sexo'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                            onChanged: (value) {
                              setState(() {
                                sexo = value.toString();
                                _valorSeleccionado2 = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: DropdownButtonFormField(
                              value: _valorSeleccionado3,
                              items: _especies,
                              hint: Text('Especie'),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                              onChanged: (value) {
                                if (value == 1) {
                                  _cargarPerros(value);
                                }
                                if (value == 2) {
                                  _cargarGatos(value);
                                }

                                setState(() {
                                  especie = value.toString();
                                  _valorSeleccionado3 = value;
                                });
                              },
                            )),
                        especie == '1'
                            ? Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: DropdownButtonFormField(
                                  value: _valorSeleccionadoPerros,
                                  items: _perros,
                                  hint: Text('Razas'),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onChanged: (value) {
                                    setState(() {
                                      raza = value.toString();
                                      _valorSeleccionadoPerros = value;
                                    });
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(17.0),
                                child: DropdownButtonFormField(
                                  value: _valorSeleccionadoGatos,
                                  items: _gatos,
                                  hint: Text('Razas'),
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onChanged: (value) {
                                    // print(value.toString());
                                    setState(() {
                                      raza = value.toString();
                                      _valorSeleccionadoGatos = value;
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
                      child: Text('Aceptar'),
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white12))),
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
        // Positioned(
        //   right: 10.0,
        //   top: 260.0, // or whatever
        //   child: Container(
        //     child: InkWell(
        //       onTap: () => {},
        //       borderRadius: BorderRadius.circular(50.0),
        //       child: Container(
        //         width: 45.0,
        //         height: 45.0,
        //         decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           border: Border.all(color: Color.fromRGBO(180, 196, 247, 1.0)),
        //           color: Color.fromRGBO(120, 139, 255, 1.0),
        //         ),
        //         child: Icon(
        //           Icons.add_a_photo_rounded,
        //           color: Colors.white,
        //           size: 25.0,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ]),
    );
  }

  void tomarFoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedFile;
      _imagefile == null ? null : foto = _imagefile.path;
    });
  }

  void _mascotaAgregar(BuildContext context) async {
    // if (_formKey.currentState.validate()) {
    if (nombreCtrl.text.trim() != "" ||
        sexo != "" ||
        raza != "" ||
        especie != "") {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var provider = new MascotaProvider();
      rut = sharedPreferences.getStringList('usuario')[0];
      provider.mascotaAgregar(
          rut,
          nombreCtrl.text.trim(),
          esterilizacion,
          fechaNacimientoCtrl.text.trim(),
          condicion,
          microchip,
          alimentosCtrl.text.trim(),
          personalidadCtrl.text.trim(),
          sexo,
          raza,
          foto);
      Navigator.pop(context);
    }
    //}
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarSexo() async {
    _sexo.add(DropdownMenuItem(child: Text("Macho"), value: 0));
    _sexo.add(DropdownMenuItem(child: Text("Hembra"), value: 1));
  }

  _cargarEsterilizacion() async {
    _esterilizcion.add(DropdownMenuItem(child: Text("Sí"), value: 0));
    _esterilizcion.add(DropdownMenuItem(child: Text("No"), value: 1));
  }

  _cargarCondicion() async {
    _condicion.add(DropdownMenuItem(child: Text("Sano"), value: 0));
    _condicion.add(DropdownMenuItem(child: Text("Con Enfermedad"), value: 1));
  }

  _cargarMicrochip() async {
    _microchip.add(DropdownMenuItem(child: Text("Sí"), value: 0));
    _microchip.add(DropdownMenuItem(child: Text("No"), value: 1));
  }
/*   Future<LinkedHashMap<String, dynamic>> _fetch(id) async {
    var provider = new EspecieProvider();
    return await provider.razasListar(id);
  }
  void _cargarRazas(value) async {
    FutureBuilder(
      future: _fetch(value),
      builder: (context, snapshot) {
        _mostrarRazas(snapshot.data['razas']);
        return Text('');
      },
    );
  }
  void _mostrarRazas(List<dynamic> razas) {
    print('Mostrar Razas');
    razas.forEach((raza) {
      setState(() {
        _razas.add(DropdownMenuItem(
          child: Text(raza['nombre']),
          value: raza['id'],
        ));
      });
    });
  } */

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

  _cargarRazas(id) async {
    _razas.clear();
    var provider = RazasProvider();
    var razas = await provider.getRazas();
    razas.forEach((raza) {
      if (raza['especie_id'] == id) {
        setState(() {
          _razas.add(
              DropdownMenuItem(child: Text(raza['nombre']), value: raza['id']));
          print(_razas);
          print(_razas.first);
        });
      }
    });
  }

  _cargarPerros(id) async {
    _perros.clear();
    var provider = RazasProvider();
    var razas = await provider.getRazas();
    razas.forEach((raza) {
      if (raza['especie_id'] == id) {
        setState(() {
          _perros.add(
              DropdownMenuItem(child: Text(raza['nombre']), value: raza['id']));
        });
      }
    });
  }

  _cargarGatos(id) async {
    _gatos.clear();
    var provider = RazasProvider();
    var razas = await provider.getRazas();
    razas.forEach((raza) {
      if (raza['especie_id'] == id) {
        setState(() {
          _gatos.add(
              DropdownMenuItem(child: Text(raza['nombre']), value: raza['id']));
        });
      }
    });
  }
}
