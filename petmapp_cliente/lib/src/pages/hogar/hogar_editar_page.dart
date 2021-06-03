import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/hogar_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';

class HogarEditarPage extends StatefulWidget {
  final int idhogar;
  HogarEditarPage({this.idhogar});

  @override
  _HogarEditarPageState createState() => _HogarEditarPageState();
}

class _HogarEditarPageState extends State<HogarEditarPage> {
// Controllers //
  TextEditingController tipoHogarCtrl = new TextEditingController();
  TextEditingController disponibilidadCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar hogares'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoHogarCtrl.text = snapshot.data['tipo_hogar'].toString();
                descripcionCtrl.text = snapshot.data['descripcion'];
                disponibilidadCtrl.text =
                    snapshot.data['disponibilidad_patio'].toString();
                direccionCtrl.text = snapshot.data['direccion'];
                fotoCtrl.text = snapshot.data['foto'];
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoHogarCtrl,
                              decoration: InputDecoration(
                                  labelText: 'tipo',
                                  hintText: 'tipo del hogar',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: disponibilidadCtrl,
                              decoration: InputDecoration(
                                  labelText: 'disponibilidad',
                                  hintText: 'disponibilidad Patio',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: direccionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'direccion',
                                  hintText: 'direccion del hogar',
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
                                  hintText: 'Descripcion del hogar',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fotoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'foto',
                                  hintText: 'foto de la hogar',
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
                              child: Text('Editar  hogar'),
                              onPressed: () => _hogarEditar(context),
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
    var provider = HogarProvider();
    return await provider.gethogar(widget.idhogar);
  }

  void _hogarEditar(BuildContext context) {
    var provider = new HogarProvider();
    provider.hogarEditar(
        widget.idhogar,
        tipoHogarCtrl.text,
        disponibilidadCtrl.text,
        direccionCtrl.text,
        descripcionCtrl.text,
        fotoCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
