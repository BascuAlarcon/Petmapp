import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:petmapp_cliente/src/providers/alertas_provider.dart';
import 'package:petmapp_cliente/src/providers/tipos_alerta_provider.dart';

class AlertaEditarPage extends StatefulWidget {
  final int idalerta;
  AlertaEditarPage({this.idalerta});

  @override
  _AlertaEditarPageState createState() => _AlertaEditarPageState();
}

class _AlertaEditarPageState extends State<AlertaEditarPage> {
  var _tipos = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var alerta = '';
// Controllers //
  TextEditingController tipoAlertaCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController descripcionCtrl = new TextEditingController();
  TextEditingController direccionCtrl = new TextEditingController();
  TextEditingController latitudCtrl = new TextEditingController();
  TextEditingController longitudCtrl = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _cargarTiposAlertas();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar alerta'),
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
                  tipoAlertaCtrl.text =
                      snapshot.data['tipo_alerta_id'].toString();
                  fotoCtrl.text = snapshot.data['foto'];
                  descripcionCtrl.text = snapshot.data['descripcion'];
                  direccionCtrl.text = snapshot.data['direccion'];
                  latitudCtrl.text = snapshot.data['latitud'];
                  longitudCtrl.text = snapshot.data['longitud'];
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            _crearAlerta(),
                            Divider(),
                            _crearCampoDescripcion(),
                            Divider(),
                            _crearCampoDireccion(),
                            Divider(),
                            _crearCampoLatitud(),
                            Divider(),
                            _crearCampoLongitud(),
                            Divider(),
                            _crearCampoFoto(),
                            Divider(),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            _botonAgregar(),
                            _botonCancelar(),
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }

  Widget _botonAgregar() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        child: Text('Guardar Cambios'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(120, 139, 255, 1.0)),
        ),
        onPressed: () => _alertaEditar(context),
      ),
    );
  }

  Widget _botonCancelar() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        child: Text('Cancelar'),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white12))),
          backgroundColor: MaterialStateProperty.all<Color>(
              Color.fromRGBO(199, 199, 183, 1.0)),
        ),
        onPressed: () => _navegarCancelar(context),
      ),
    );
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = AlertaProvider();
    return await provider.getAlerta(widget.idalerta);
  }

  void _alertaEditar(BuildContext context) {
    if (_formKey.currentState.validate()) {
      var provider = new AlertaProvider();
      provider.alertaEditar(
          widget.idalerta,
          tipoAlertaCtrl.text,
          fotoCtrl.text,
          descripcionCtrl.text,
          direccionCtrl.text,
          latitudCtrl.text,
          longitudCtrl.text); // usamos un controller //
      Navigator.pop(context);
    }
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  // DROPDOWN //
  Widget _crearAlerta() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        value: _valorSeleccionado,
        items: _tipos,
        hint: Text('Tipo de Alerta'),
        decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
        onChanged: (value) {
          setState(() {
            alerta = value.toString();
            _valorSeleccionado = value;
          });
        },
        validator: (valor) {
          if (valor == null) {
            return 'Seleccione un valor';
          }
          return null;
        },
      ),
    );
  }

  _cargarTiposAlertas() async {
    var provider = new TipoAlertaProvider();
    var tipos = await provider.tipoListar();
    tipos.forEach((tipo) {
      setState(() {
        _tipos.add(DropdownMenuItem(
            child: Text(tipo['nombre']), value: tipo['tipo_alerta']));
      });
    });
  }

  Widget _crearCampoDescripcion() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            controller: descripcionCtrl,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                labelText: 'Descripcion',
                hintText: 'Descripción de la alerta',
                suffixIcon: Icon(MdiIcons.tagText)),
            validator: (valor) {
              if (valor.isEmpty || valor == null) {
                return 'Indique una descripción';
              }
              if (valor.length < 10) {
                return 'La descripción debe contener al menos 10 cáracteres';
              }
              return null;
            }));
  }

  Widget _crearCampoLatitud() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: latitudCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'latitud',
              hintText: 'latitud',
              suffixIcon: Icon(MdiIcons.flag)),
          validator: (valor) {
            if (valor.isEmpty || valor == null) {
              return 'Indique una latitud';
            }
            return null;
          }),
    );
  }

  Widget _crearCampoLongitud() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: longitudCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'longitud',
              hintText: 'longitud',
              suffixIcon: Icon(MdiIcons.flag)),
          validator: (valor) {
            if (valor.isEmpty || valor == null) {
              return 'Indique una longitud';
            }
            return null;
          }),
    );
  }

  Widget _crearCampoDireccion() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
            controller: direccionCtrl,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              hintText: 'Direccion de la alerta',
              labelText: 'Direccion',
              suffixIcon: Icon(MdiIcons.mapMarker),
            ),
            validator: (valor) {
              if (valor.isEmpty || valor == null) {
                return 'Indique una direccion';
              }
              if (valor.length < 10) {
                return 'La dirección debe contener al menos 10 cáracteres';
              }
              return null;
            }));
  }

  Widget _crearCampoFoto() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
          controller: fotoCtrl,
          decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Foto',
              hintText: 'Ingrese una foto',
              suffixIcon: Icon(MdiIcons.camera)),
          validator: (valor) {
            if (valor.isEmpty || valor == null) {
              return 'Debe seleccionar una foto';
            }
            return null;
          }),
    );
  }
}
