import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:petmapp_cliente/src/pages/mascotas/mascota_listar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_agregar_page.dart';
import 'package:petmapp_cliente/src/pages/especies/especie_editar_page.dart';
import 'package:petmapp_cliente/src/providers/especie_provider.dart';
import 'package:petmapp_cliente/src/providers/petmapp_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EspecieListarPage extends StatefulWidget {
  EspecieListarPage({Key key}) : super(key: key);

  @override
  _EspecieListarPageState createState() => _EspecieListarPageState();
}

class _EspecieListarPageState extends State<EspecieListarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PetmApp'),
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
                // LISTA Especies //
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
                              leading: Icon(MdiIcons.soccer),
                              title: Text(snapshot.data[index]['nombre']),
                              onTap: () {}),
                        );
                      },
                    ),
                  ),
                ),

                // LISTA Especies//
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
    var provider = new EspecieProvider();
    return await provider.especieListar();
  }
}
