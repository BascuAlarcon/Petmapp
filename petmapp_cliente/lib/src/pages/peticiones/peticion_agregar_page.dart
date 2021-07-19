import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/Models/mascotaModel.dart';
import 'package:petmapp_cliente/src/providers/mascotas_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PeticionesAgregarPage extends StatefulWidget {
  final int idPublicacion;
  PeticionesAgregarPage({this.idPublicacion});
  @override
  _PeticionesAgregarPageState createState() => _PeticionesAgregarPageState();
}

class _PeticionesAgregarPageState extends State<PeticionesAgregarPage> {
  SharedPreferences sharedPreferences;
  String email = '';
  String rut = '';

  List<MascotaModel> listaMascotas = [];
  List<MascotaModel> mascotasSeleccionadas = [];

  bool _validate = false;
  DateTime _fechaInicio;

  @override
  void initState() {
    super.initState();
    cargarMascotas();
    cargarDatosUsuario();
  }

// Controllers //
  TextEditingController fechaInicioCtrl = new TextEditingController();
  TextEditingController fechaFinCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController precioTotalCtrl = new TextEditingController();
  TextEditingController boletaCtrl = new TextEditingController();
  TextEditingController estadoCtrl = new TextEditingController();
  TextEditingController idPublicacionCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Agregar una petición'),
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: descripcionCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
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
                padding: const EdgeInsets.all(17.0),
                child: TextFormField(
                  controller: fechaInicioCtrl,
                  onTap: () {
                    showDatePicker(
                            context: context,
                            initialDate: fechaInicioCtrl == null
                                ? DateTime.now()
                                : _fechaInicio,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now())
                        .then((value) => setState(() {
                              _fechaInicio = value;
                              fechaInicioCtrl.text = DateFormat('yyyy-MM-dd')
                                  .format(value)
                                  .toString();
                            }));
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Fecha de inicio del cuidado',
                    hintText: 'Fecha de inicio',
                    suffixIcon: Icon(Icons.date_range),
                    errorText: _validate ? 'Value Can\'t Be Empty' : null,
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: fechaFinCtrl,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Fecha Fin',
                      hintText: 'Fecha Fin',
                      suffixIcon: Icon(MdiIcons.calendarRange)),
                  validator: (valor) {
                    if (valor.isEmpty || valor == null) {
                      return 'Debe ingresar una localizacion';
                    }
                    return null;
                  },
                ),
              ),
              Divider(),
              ElevatedButton(
                  child: Text('Mostrar Mascotas'),
                  onPressed: () {
                    setState(() {});
                  }),
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
                        child: Text('Agregar petición'),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(color: Colors.white12))),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromRGBO(120, 139, 255, 1.0)),
                        ),
                        onPressed: () => _peticionAgregar(context),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  void _peticionAgregar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new PeticionProvider();
      provider.peticionAgregar(
          descripcionCtrl.text,
          fechaInicioCtrl.text,
          fechaFinCtrl.text,
          mascotasSeleccionadas,
          rut,
          widget.idPublicacion.toString());

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
