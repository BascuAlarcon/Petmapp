import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class UsuarioListarPage extends StatefulWidget {
  UsuarioListarPage({Key key}) : super(key: key);

  @override
  _UsuarioListarPageState createState() => _UsuarioListarPageState();
}

class _UsuarioListarPageState extends State<UsuarioListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        leading: Container(
            child: ElevatedButton(
                child: Icon(MdiIcons.arrowBottomLeft),
                onPressed: () => Navigator.pop(context))),
      ),
      body: FutureBuilder(
        future: _fetch(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Text('No data')); /* CircularProgressIndicator() */
          } else {
            List<dynamic> safeCards = snapshot.data;
            return Column(
              children: [
                // LISTA RAZAS //
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refresh(),
                    child: ListView.separated(
                      itemCount: safeCards.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: ListTile(
                              leading: Icon(MdiIcons.accountCircle),
                              title: Text(
                                snapshot.data[index]['email'],
                              ),
                              subtitle: snapshot.data[index]['perfil_id'] == 1
                                  ? Text(snapshot.data[index]['name'],
                                      style: TextStyle(color: Colors.redAccent))
                                  : Text(snapshot.data[index]['name']),
                              onTap: () {}),
                        );
                      },
                    ),
                  ),
                ),

                // LISTA USUARIOS //
              ],
            );
          }
        },
      ),
    );
  }

  Future<Null> _refresh() async {
    await _fetch();
    setState(() {});
  }

  Future<List<dynamic>> _fetch() async {
    var provider = new UsuarioProvider();
    return await provider.getUsuarios();
  }
}
