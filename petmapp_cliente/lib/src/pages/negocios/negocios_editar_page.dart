import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/negocios_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/ubicaciones_provider.dart';

class NegocioEditarPage extends StatefulWidget {
  final int id;
  NegocioEditarPage({this.id});

  @override
  _NegocioEditarPageState createState() => _NegocioEditarPageState();
}

class _NegocioEditarPageState extends State<NegocioEditarPage> {
// Controllers //
  TextEditingController tipoCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController localizacionCtrl = new TextEditingController();
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController horarioCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar ubicacions'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoCtrl.text = snapshot.data['tipo_id'].toString();
                fotoCtrl.text = snapshot.data['foto'];
                descripcionCtrl.text = snapshot.data['descripcion'];
                direccionCtrl.text = snapshot.data['direccion'];
                localizacionCtrl.text = snapshot.data['localizacion'];
                nombreCtrl.text = snapshot.data['nombre'];
                horarioCtrl.text = snapshot.data['horario'];
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Tipo Ubicacion',
                                  hintText: 'Tipo Ubicacion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: fotoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Foto',
                                  hintText: 'Foto',
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
                                  hintText: 'Descripcion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: direccionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Direccion',
                                  hintText: 'Direccion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: localizacionCtrl,
                              decoration: InputDecoration(
                                  labelText: 'localizacion',
                                  hintText: 'localizacion',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: nombreCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Nombre',
                                  hintText: 'Nombre',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: horarioCtrl,
                              decoration: InputDecoration(
                                  labelText: 'horario',
                                  hintText: 'horario',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
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
                              child: Text('Editar  ubicacion'),
                              onPressed: () => _negocioEditar(context),
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
    var provider = NegocioProvider();
    return await provider.getNegocio(widget.id);
  }

  void _negocioEditar(BuildContext context) {
    var provider = new NegocioProvider();
    provider.negocioEditar(
        widget.id,
        tipoCtrl.text,
        fotoCtrl.text,
        descripcionCtrl.text,
        direccionCtrl.text,
        localizacionCtrl.text,
        nombreCtrl.text,
        horarioCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
