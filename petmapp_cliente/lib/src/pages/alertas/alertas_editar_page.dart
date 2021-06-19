import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';

class AlertaEditarPage extends StatefulWidget {
  final int idalerta;
  AlertaEditarPage({this.idalerta});

  @override
  _AlertaEditarPageState createState() => _AlertaEditarPageState();
}

class _AlertaEditarPageState extends State<AlertaEditarPage> {
// Controllers //
  TextEditingController tipoAlertaCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController habilitadoCtrl = new TextEditingController();
  TextEditingController ultimaActividadCtrl = new TextEditingController();
  TextEditingController localizacionCtrl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Editar alertas'),
        ),
        body: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No hay data'),
                );
              } else {
                tipoAlertaCtrl.text =
                    snapshot.data['tipo_alerta_id'].toString();
                fotoCtrl.text = snapshot.data['foto'];
                descripcionCtrl.text = snapshot.data['descripcion'];
                direccionCtrl.text = snapshot.data['direccion'];
                localizacionCtrl.text = snapshot.data['localizacion'];
                habilitadoCtrl.text = snapshot.data['habilitado'].toString();
                ultimaActividadCtrl.text = snapshot.data['ultima_actividad'];
                return Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: tipoAlertaCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Tipo Alerta',
                                  hintText: 'Tipo Alerta',
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
                              controller: habilitadoCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Habilitado',
                                  hintText: 'Habilitado',
                                  suffixIcon: Icon(Icons.flag)),
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: ultimaActividadCtrl,
                              decoration: InputDecoration(
                                  labelText: 'Ultima actividad',
                                  hintText: 'Ultima actividad',
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
                              child: Text('Editar  alerta'),
                              onPressed: () => _alertaEditar(context),
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
    var provider = AlertaProvider();
    return await provider.getAlerta(widget.idalerta);
  }

  void _alertaEditar(BuildContext context) {
    var provider = new AlertaProvider();
    provider.alertaEditar(
        widget.idalerta,
        tipoAlertaCtrl.text,
        fotoCtrl.text,
        descripcionCtrl.text,
        direccionCtrl.text,
        localizacionCtrl.text,
        habilitadoCtrl.text,
        ultimaActividadCtrl.text); // usamos un controller //
    Navigator.pop(context);
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }
}
