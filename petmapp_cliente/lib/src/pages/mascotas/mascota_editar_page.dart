import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/especie_provider.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/razas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MascotasEditarPage extends StatefulWidget {
  final int idMascota;
  MascotasEditarPage({this.idMascota});

  @override
  _MascotasEditarPageState createState() => _MascotasEditarPageState();
}

class _MascotasEditarPageState extends State<MascotasEditarPage> {
// Validaciones //
  final _formKey = GlobalKey<FormState>();
// Controllers //
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController fechaNacimientoCtrl = new TextEditingController();
  TextEditingController alimentosCtrl = new TextEditingController();
  TextEditingController personalidadCtrl = new TextEditingController();
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

  @override
  void initState() {
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
          title: Text('Editar mi Mascota'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
            key: _formKey,
            child: FutureBuilder(
              future: _fetch(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No hay data'),
                  );
                } else {
                  nombreCtrl.text = snapshot.data['nombre'];
                  fechaNacimientoCtrl.text = snapshot.data['fecha_nacimiento'];
                  alimentosCtrl.text = snapshot.data['alimentos'];
                  personalidadCtrl.text = snapshot.data['personalidad'];
                  _valorEsterilizacion = snapshot.data['estirilizacion'];
                  //_valorCondicion = snapshot.data['condicion_medica'];
                  _valorMicrochip = snapshot.data['microchip'];
                  _valorSeleccionado2 = snapshot.data['sexo'];
                  // _valorSeleccionado3 = snapshot.data['raza_id'];
                  return Stack(children: <Widget>[
                    Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: <Widget>[
                              Stack(children: <Widget>[
                                FadeInImage(
                                    image: NetworkImage(
                                        'https://cdn.dribbble.com/users/1030477/screenshots/4704756/dog_allied.gif'),
                                    placeholder:
                                        AssetImage('assets/jar-loading.gif'),
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
                                        /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          labelText: 'Nombre',
                                          hintText: 'Nombre de la Mascota',
                                          suffixIcon: Icon(Icons.pets),
                                          errorText: _validate
                                              ? 'Value Can\'t Be Empty'
                                              : null,
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
                                        hint: Text(
                                            '¿La mascota está esterilizada?'),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
                                        onChanged: (value) {
                                          setState(() {
                                            esterilizacion = value.toString();
                                            _valorEsterilizacion = value;
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child: TextFormField(
                                        controller: fechaNacimientoCtrl,
                                        /* validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingrese un nombre';
                                }
                                return null;
                              }, */
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          labelText: 'Fecha de nacimiento',
                                          hintText: 'Fecha de nacimiento',
                                          suffixIcon: Icon(Icons.pets),
                                          errorText: _validate
                                              ? 'Value Can\'t Be Empty'
                                              : null,
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
                                        hint: Text(
                                            '¿La mascota tiene alguna enfermedad?'),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
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
                                        hint: Text(
                                            '¿La mascota cuenta con microchip?'),
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
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
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          labelText: 'Alimentos',
                                          hintText:
                                              'Alimentos que consume la mascota',
                                          suffixIcon: Icon(Icons.pets),
                                          errorText: _validate
                                              ? 'Value Can\'t Be Empty'
                                              : null,
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
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          labelText: 'Personalidad',
                                          hintText:
                                              '¿Cómo se comporta su mascota?',
                                          suffixIcon: Icon(Icons.pets),
                                          errorText: _validate
                                              ? 'Value Can\'t Be Empty'
                                              : null,
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
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
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
                                                      BorderRadius.circular(
                                                          20.0))),
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
                                                          BorderRadius.circular(
                                                              20.0))),
                                              onChanged: (value) {
                                                setState(() {
                                                  raza = value.toString();
                                                  _valorSeleccionadoPerros =
                                                      value;
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
                                                          BorderRadius.circular(
                                                              20.0))),
                                              onChanged: (value) {
                                                // print(value.toString());
                                                setState(() {
                                                  raza = value.toString();
                                                  _valorSeleccionadoGatos =
                                                      value;
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
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.white12))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
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
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.white12))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(120, 139, 255, 1.0)),
                                  ),
                                  onPressed: () => _mascotaEditar(context),
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
                              border: Border.all(
                                  color: Color.fromRGBO(180, 196, 247, 1.0)),
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
                  ]);
                }
              },
            )));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = MascotaProvider();
    return await provider.getMascota(widget.idMascota);
  }

  void _mascotaEditar(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      if (nombreCtrl.text.trim() != "" ||
          sexo != "" ||
          raza != "" ||
          especie != "") {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        var provider = new MascotaProvider();
        rut = sharedPreferences.getStringList('usuario')[0];
        provider.mascotaEditar(
            nombreCtrl.text.trim(),
            esterilizacion,
            fechaNacimientoCtrl.text.trim(),
            condicion,
            microchip,
            alimentosCtrl.text.trim(),
            personalidadCtrl.text.trim(),
            sexo,
            raza);
        Navigator.pop(context);
      }
    }
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
