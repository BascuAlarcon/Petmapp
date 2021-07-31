import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:petmapp_cliente/src/pages/Models/search_widget.dart';
import 'package:petmapp_cliente/src/pages/Models/usuario.dart';
import 'package:petmapp_cliente/src/pages/Models/usuarioData.dart';
import 'package:petmapp_cliente/src/pages/usuario/perfil_usuario_page.dart';
import 'package:petmapp_cliente/src/pages/usuario/usuarios_listar_evaluaciones_publicaciones_page.dart';
import 'package:petmapp_cliente/src/providers/peticiones_provider.dart';
import 'package:petmapp_cliente/src/providers/publicaciones_provider.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';

class UsuarioListarPage extends StatefulWidget {
  UsuarioListarPage({Key key}) : super(key: key);

  @override
  _UsuarioListarPageState createState() => _UsuarioListarPageState();
}

class _UsuarioListarPageState extends State<UsuarioListarPage> {
  List<Usuario> usuarios;
  String query = '';
  @override
  void initState() {
    super.initState();
    init();
  }

  bool _isLoading = true;

  Future init() async {
    final usuarios = await UsuariosApi.getUsuarios(query);
    setState(() {
      this.usuarios = usuarios;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Usuarios'),
        backgroundColor: Color.fromRGBO(120, 139, 255, 1.0),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                crearBuscador(),
                Expanded(
                    child: ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return construirUsuario(usuario);
                  },
                )

                    /* FutureBuilder(
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
                                    trailing: Icon(MdiIcons.arrowRight),
                                    subtitle: snapshot.data[index]
                                                ['promedio_evaluaciones'] ==
                                            null
                                        ? Text('Sin evaluaciones :)')
                                        : Text('Promedio de notas: ' +
                                            snapshot.data[index]
                                                    ['promedio_evaluaciones']
                                                .toString()),
                                    onTap: () => _navegarUsuarioEvaluaciones(
                                        context, snapshot.data[index]['rut'])),
                                actions: [
                                  IconSlideAction(
                                      caption: 'Borrar',
                                      color: Colors.red,
                                      icon: MdiIcons.trashCan,
                                      onTap: () => _mostrarConfirmacion(
                                          context, snapshot.data[index]['rut']))
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ), */
                    ),
              ],
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

  _navegarUsuarioEvaluaciones(BuildContext context, rut) {
    var route = new MaterialPageRoute(
        builder: (context) => PerfilPublicacionPage(
            rut) /* UsuarioEvaluacionesListarPage(rut: rut) */);
    Navigator.push(context, route).then((value) {
      setState(() {});
    });
  }

  //    ELIMINAR UN USUARIO     //
  // MUCHO OJO CON NO DEJAR LA CAGA //
  void _usuarioBorrar(int rut) async {
    // ELIMINAR EL USUARIO //
    var userProvider = new UsuarioProvider();
    await userProvider.usuarioBorrar(rut);
    // ELIMINAR PUBLICACIONES DEL USUARIO //
    var publicacionProvider = new PublicacionProvider();
    var publicaciones = await publicacionProvider.publicacionListar();
    for (var publicacion in publicaciones) {
      if (publicacion['usuario_rut'] == rut) {
        await publicacionProvider.publicacionesBorrar(publicacion['id']);
      }
    }
    // ELIMINAR PETICIONES DEL USUARIO //
    var peticionProvider = new PeticionProvider();
    var peticiones = await peticionProvider.peticionListar();
    for (var peticion in peticiones) {
      if (peticion['usuario_rut'] == rut) {
        await peticionProvider.peticionesBorrar(peticion['id']);
      }
    }
    setState(() {
      init();
    });
    // ELIMINAR COMENTARIOS //
    // ELIMINAR ALERTAS //
    // NO ELIMINAR NADA MÁS EN CASO DE QUE VUELVA //
  }

  _mostrarConfirmacion(BuildContext context, int rut) {
    print(rut);
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmar Borrado'),
            content: Text('¿Desea borrar este usuario?'),
            actions: [
              MaterialButton(
                  child: Text('Cancelar',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      )),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              ElevatedButton(
                child: Text('Borrar'),
                onPressed: () {
                  setState(() {
                    _usuarioBorrar(rut);
                  });
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget crearBuscador() {
    return SearchWidget(
        text: query,
        hintText: 'Email del usuario o rut',
        onChanged: buscarUsuario);
  }

  Future buscarUsuario(String query) async {
    final usuarios = await UsuariosApi.getUsuarios(query);

    if (!mounted) return;

    setState(() {
      this.query = query;
      this.usuarios = usuarios;
    });
  }

  Widget construirUsuarioo(Usuario usuario) {
    return ListTile(
      title: Text(usuario.correo),
    );
  }

  Widget construirUsuario(Usuario usuario) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: Icon(MdiIcons.account),
        title: Text(usuario.correo),
        subtitle: Text('Promedio notas: ' + usuario.promedio.toString()),
        onTap: () {},
      ),
      secondaryActions: [
        IconSlideAction(
            caption: 'Borrar',
            color: Colors.red,
            icon: MdiIcons.trashCan,
            onTap: () => _mostrarConfirmacion(context, usuario.rut)),
      ],
    );
  }
}
