import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/Models/mascotaModel.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeticionEditarPage extends StatefulWidget {
  final int idPeticion;
  PeticionEditarPage({this.idPeticion});
  @override
  _PeticionEditarPageState createState() => _PeticionEditarPageState();
}

class _PeticionEditarPageState extends State<PeticionEditarPage> {
// Controllers //
  TextEditingController fechaInicioCtrl = new TextEditingController();
  TextEditingController fechaFinCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SharedPreferences sharedPreferences;
  String email = '';
  String rut = '';
  List<MascotaModel> listaMascotas = [];
  List<MascotaModel> mascotasSeleccionadas = [];

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar peticiones'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
          centerTitle: true,
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
                  fechaInicioCtrl.text =
                      snapshot.data['fecha_inicio'].toString();
                  fechaFinCtrl.text = snapshot.data['fecha_fin'].toString();
                  descripcionCtrl.text =
                      snapshot.data['descripcion'].toString();
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descripcionCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Descripción',
                                    hintText: 'Descripción de la petición',
                                    suffixIcon: Icon(MdiIcons.tag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar una descripción';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: fechaInicioCtrl,
                                decoration: InputDecoration(
                                    labelText: 'Fecha Inicio',
                                    hintText: 'Fecha Inicio',
                                    suffixIcon: Icon(Icons.flag)),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: fechaFinCtrl,
                                decoration: InputDecoration(
                                    labelText: 'Fecha Fin',
                                    hintText: 'Fecha Fin',
                                    suffixIcon: Icon(Icons.flag)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: listaMascotas.length,
                          itemBuilder: (context, index) {
                            return mascotaItem(
                                listaMascotas[index].id,
                                listaMascotas[index].name,
                                listaMascotas[index].isSelected,
                                index);
                          },
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
                                child: Text('Editar  peticion'),
                                onPressed: () => _peticionEditar(context),
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
                  );
                }
              }),
        ));
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
    });
    var provider = MascotaProvider();
    var mascotas = await provider.mascotaListar();
    for (var mascota in mascotas) {
      if (mascota['usuario_rut'].toString() == rut) {
        listaMascotas
            .add(MascotaModel(mascota['id'], mascota['nombre'], false));
      }
    }
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PeticionProvider();
    return await provider.getpeticion(widget.idPeticion);
  }

  void _peticionEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new PeticionProvider();
      provider.peticionEditar(
        widget.idPeticion,
        descripcionCtrl.text,
        fechaInicioCtrl.text,
        fechaFinCtrl.text,
      );
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  // LISTA MULTI-SELECTION
  void cargarMascotas() async {
    var provider = MascotaProvider();
    var mascotas = await provider.mascotaListar();
    for (var mascota in mascotas) {
      if (mascota['usuario_rut'] == rut) {
        listaMascotas
            .add(MascotaModel(mascota['id'], mascota['nombre'], false));
      }
    }
  }

  Widget mascotaItem(int id, String name, bool isSelected, index) {
    return ListTile(
      title: Text(name),
      subtitle: Text(id.toString()),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: Colors.green)
          : Icon(Icons.check_circle, color: Colors.grey),
      onTap: () {
        setState(() {
          listaMascotas[index].isSelected = !listaMascotas[index].isSelected;
          if (listaMascotas[index].isSelected == true) {
            mascotasSeleccionadas.add(MascotaModel(id, name, true));
          } else if (listaMascotas[index].isSelected == false) {
            mascotasSeleccionadas.removeWhere(
                (element) => element.name == listaMascotas[index].name);
          }
        });
      },
    );
  }
}
