import 'dart:collection'; 
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';

class PeticionEditarPage extends StatefulWidget {
  final int idpeticion;
  PeticionEditarPage({this.idpeticion});

  @override
  _PeticionEditarPageState createState() => _PeticionEditarPageState();
}

class _PeticionEditarPageState extends State<PeticionEditarPage> {
// Controllers //
  TextEditingController fechaInicioCtrl = new TextEditingController();
  TextEditingController fechaFinCtrl = new TextEditingController();
  TextEditingController precioTotalCtrl = new TextEditingController();
  TextEditingController boletaCtrl = new TextEditingController();
  TextEditingController estadoCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar peticiones'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                fechaInicioCtrl.text = snapshot.data['fecha_inicio'].toString();
                fechaFinCtrl.text = snapshot.data['fecha_fin'].toString();
                precioTotalCtrl.text = snapshot.data['precio_total'].toString();
                estadoCtrl.text = snapshot.data['estado'].toString();
                boletaCtrl.text = snapshot.data['boleta'].toString();
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fechaInicioCtrl,
                      decoration: InputDecoration(
                          labelText: 'Descripcion',
                          hintText: 'Descripcion de la peticiones',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: fechaFinCtrl,
                      decoration: InputDecoration(
                          labelText: 'Tarifa',
                          hintText: 'Tarifa',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: precioTotalCtrl,
                      decoration: InputDecoration(
                          labelText: 'Tarifa',
                          hintText: 'Tarifa',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: estadoCtrl,
                      decoration: InputDecoration(
                          labelText: 'Tarifa',
                          hintText: 'Tarifa',
                          suffixIcon: Icon(Icons.flag)),
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: boletaCtrl,
                      decoration: InputDecoration(
                          labelText: 'Tarifa',
                          hintText: 'Tarifa',
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
            }));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = PeticionProvider();
    return await provider.getpeticion(widget.idpeticion);
  }

  void _peticionEditar(BuildContext context) {
    var provider = new PeticionProvider();
    provider.peticionEditar(
      widget.idpeticion,
      fechaInicioCtrl.text, fechaFinCtrl.text, precioTotalCtrl.text, boletaCtrl.text, estadoCtrl.text
    ); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
