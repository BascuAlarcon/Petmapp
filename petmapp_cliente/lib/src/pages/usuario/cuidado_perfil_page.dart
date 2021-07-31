import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class PerfilCuidadoPage extends StatefulWidget {
  final int rutUsuario;
  PerfilCuidadoPage({this.rutUsuario});
  @override
  _PerfilCuidadoPageState createState() => _PerfilCuidadoPageState();
}

class _PerfilCuidadoPageState extends State<PerfilCuidadoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil '),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
        ),
        body: Column(
          children: [_mostrarDatosUsuario()],
        ));
  }

  Widget _mostrarDatosUsuario() {
    return Expanded(
      child: Container(
          child: FutureBuilder(
              future: _fetchDatosUsuario(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('loading...');
                } else {
                  return Card(
                      child: ListView(
                    children: [
                      Container(
                          width: 200,
                          height: 200,
                          child: CircleAvatar(
                              child: ClipOval(
                                  child: snapshot.data['foto'] != 'xD'
                                      ? Image(
                                          image: FileImage(
                                              File(snapshot.data['foto'])))
                                      : Image(
                                          image: NetworkImage(
                                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))))),
                      ListTile(
                        title: Text(snapshot.data['rut'].toString()),
                        subtitle: Text(
                            'Mostrar número de notas, promedio notas, datos, etc...'),
                      )
                    ],
                  ));
                }
              })),
    );
  }

  Widget _mostrarDatosMascota() {}

  Future<LinkedHashMap<String, dynamic>> _fetchDatosUsuario() async {
    var provider = UsuarioProvider();
    return await provider.mostrarUsuario(widget.rutUsuario);
  }
}
