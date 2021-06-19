import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/peticiones/peticion_mostrar_page.dart';
import 'package:petmapp_cliente/src/pages/servicios/servicios_listar_page.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CuidadoPage extends StatefulWidget {
  @override
  _CuidadoPageState createState() => _CuidadoPageState();
}

class _CuidadoPageState extends State<CuidadoPage> {
  String rut = '';
  String email = '';
  String token = '';
  String estado = '';
  String name = '';
  String perfil = '';
  int id;
  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Servicio de Cuidado'),
        ),
        body: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: FutureBuilder(
            future: _fetch(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading...');
              } else {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(
                                'Usuario: ${snapshot.data['usuario_rut']}'),
                            subtitle: Text(
                              'VER PERFIL DEL USUARIO',
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Icon(MdiIcons.account),
                            tileColor: Colors.blue,
                            onTap: () {}),
                        Divider(color: Colors.black),
                        Expanded(
                          child: ListTile(
                            title: Text(
                                'Fecha de la petición: ${snapshot.data['fecha_inicio']}'),
                            subtitle: Text(
                                'Precio del servicio: ${snapshot.data['precio_total']}'),
                          ),
                        ),
                        buttonServicios(context, snapshot.data['id']),
                        buttonEvaluaciones() // VALIDAR QUE SEA POST snapshot.data['fecha_fin]
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ));
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = UsuarioProvider();
    var peticiones = await provider.getPeticiones(token);
    for (var peticion in peticiones) {
      if (peticion['estado'] == 2) {
        // AGREGAR OTRA VALIDACION: QUE PETICION['FECHA_INICIO'] == HOY //
        id = peticion['id'];
      }
    }
    var provi = PeticionProvider();
    return await provi.getpeticion(id);
  }

  // TRAER DATOS DE SHARED PREFERENCES //
  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
      email = sharedPreferencess.getStringList('usuario')[1];
      name = sharedPreferencess.getStringList('usuario')[2];
      perfil = sharedPreferencess.getStringList('usuario')[3];
      token = sharedPreferencess.getStringList('usuario')[4];
      estado = sharedPreferencess.getStringList('usuario')[5];
    });
  }

  buttonServicios(BuildContext context, id) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Servicios Adicionales'),
                onPressed: () => _navegarServicios(context, id))));
  }

  buttonEvaluaciones() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
                child: Text('Evaluar el servicio!'),
                onPressed: () => _navegarEvaluacion(context, id))));
  }
}

_navegarServicios(BuildContext context, int id) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) {
    return ServicioListarPage(
      idPeticion: id,
    );
  });
  Navigator.push(context, route);
}

_navegarEvaluacion(BuildContext context, int id) {
  MaterialPageRoute route = MaterialPageRoute(builder: (context) {
    return ServicioListarPage(
      idPeticion: id,
    );
  });
  Navigator.push(context, route);
}
