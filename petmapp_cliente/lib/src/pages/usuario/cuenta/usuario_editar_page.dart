import 'dart:collection';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petmapp_cliente/src/providers/usuarios_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_otp/flutter_otp.dart';

class UsuarioEditarPage extends StatefulWidget {
  final int rut;
  UsuarioEditarPage(this.rut);

  @override
  _UsuarioEditarPageState createState() => _UsuarioEditarPageState();
}

class _UsuarioEditarPageState extends State<UsuarioEditarPage> {
  // Controllers //
  TextEditingController emailCtrl = new TextEditingController();
  TextEditingController nameCtrl = new TextEditingController();
  TextEditingController sexoCtrl = new TextEditingController();
  TextEditingController fechaNacimientoCtrl = new TextEditingController();
  TextEditingController fotoCtrl = new TextEditingController();
  TextEditingController numeroTelefonicoCtrl = new TextEditingController();
  TextEditingController codigoCtrl = new TextEditingController();
  var _sexo = <DropdownMenuItem>[];
  var _valorSeleccionado;
  var sexo = '';
  PickedFile _imagefile;
  String foto;
  final ImagePicker _picker = ImagePicker();
  int caso = 0;
  bool existenciaFoto = false;
  bool _validate = false;
  DateTime _fechaNacimiento = DateTime.now();

  // OTP //
  FlutterOtp otp = FlutterOtp();

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
    _cargarSexo();
  }

  String rut = '';
  final _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Editar datos'),
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
                  emailCtrl.text = snapshot.data['email'];
                  nameCtrl.text = snapshot.data['name'];
                  _valorSeleccionado = snapshot.data['sexo'];
                  fechaNacimientoCtrl.text = snapshot.data['fecha_nacimiento'];
                  snapshot.data['fecha_nacimiento'] == null
                      ? null
                      : _fechaNacimiento =
                          DateTime.parse(snapshot.data['fecha_nacimiento']);
                  snapshot.data['numero_telefonico'] != null
                      ? numeroTelefonicoCtrl.text =
                          snapshot.data['numero_telefonico'].toString()
                      : null;
                  snapshot.data['foto'] == null
                      ? existenciaFoto = null
                      : existenciaFoto = true;

                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: emailCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Email',
                                    hintText: 'Email',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar un email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: nameCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Nombre',
                                    hintText: 'Nombre',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar su nombre';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: DropdownButtonFormField(
                                value: _valorSeleccionado,
                                items: _sexo,
                                hint: Text('Sexo'),
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                onChanged: (value) {
                                  setState(() {
                                    sexo = value.toString();
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
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(17.0),
                              child: TextFormField(
                                controller: fechaNacimientoCtrl,
                                onTap: () {
                                  _mostrarFecha(context);
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  labelText: 'Fecha de nacimiento',
                                  hintText: 'Fecha de nacimiento',
                                  suffixIcon: Icon(Icons.date_range),
                                  errorText: _validate
                                      ? 'Value Can\'t Be Empty'
                                      : null,
                                ),
                              ),
                            ),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: numeroTelefonicoCtrl,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    labelText: 'Número telefonico',
                                    hintText: 'Número telefonico',
                                    suffixIcon: Icon(Icons.flag)),
                                validator: (valor) {
                                  if (valor.isEmpty || valor == null) {
                                    return 'Debe ingresar su número telefonico';
                                  }
                                  if (valor.length < 7) {
                                    return 'Ingrese un número telefonico valido';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Divider(),
                            _crearCampoFoto(),
                            _mostrarImagen(snapshot.data['foto'])
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: 180,
                              child: ElevatedButton(
                                child: Text('Volver'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white12))),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(199, 199, 183, 1.0)),
                                ),
                                onPressed: () => _navegarCancelar(context),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(4.0),
                              height: 45,
                              width: 180,
                              child: ElevatedButton(
                                  child: Text('Guardar Cambios'),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: BorderSide(
                                                color: Colors.white12))),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromRGBO(120, 139, 255, 1.0)),
                                  ),
                                  onPressed: () {
                                    _usuarioEditar(context);
                                  }),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ));
  }

  Future _mostrarFecha(BuildContext context) async {
    return await showDatePicker(
            context: context,
            initialDate: DateTime(2002),
            firstDate: DateTime(1900),
            lastDate: DateTime(2003))
        .then((value) => setState(() {
              if (value != null) {
                _fechaNacimiento = value;
                fechaNacimientoCtrl.text =
                    DateFormat('yyyy-MM-dd').format(value).toString();
              }
            }));
  }

  Widget _crearCampoFoto() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          onPressed: () => tomarFoto(ImageSource.gallery),
          child: Text('Seleccionar foto'),
        ));
  }

  Widget _mostrarImagen(foto) {
    return FadeInImage(
        width: 100,
        height: 300,
        image: caso == 0
            ? FileImage(File(foto))
            : FileImage(File(_imagefile.path)),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.cover);
  }

  void tomarFoto(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    setState(() {
      pickedFile == null ? null : _imagefile = pickedFile;
      _imagefile == null ? null : caso = 1;
      _imagefile == null ? null : foto = _imagefile.path;
    });
  }

  Future<LinkedHashMap<String, dynamic>> _fetch() async {
    var provider = UsuarioProvider();
    return await provider.mostrarUsuario(widget.rut);
  }

  Future<void> cargarDatosUsuario() async {
    SharedPreferences sharedPreferencess =
        await SharedPreferences.getInstance();
    setState(() {
      rut = sharedPreferencess.getStringList('usuario')[0];
    });
  }

  void _usuarioEditar(BuildContext context) {
    /* sendOtp();
    mostrarAlerta();
    bool isCorrectOTP = otp.resultChecker(int.tryParse(codigoCtrl.text));  */
    if (_formKey.currentState.validate()) {
      var provider = new UsuarioProvider();
      provider.perfilEditar(rut, emailCtrl.text, nameCtrl.text, sexo,
          fechaNacimientoCtrl.text, foto, numeroTelefonicoCtrl.text);
      Navigator.pop(context);
    }
  }

  void sendOtp() {
    String mensaje = 'Su codigo es: ';
    int min = 1000;
    int max = 9999;
    String codigo = '+56';
    otp.sendOtp(numeroTelefonicoCtrl.text, mensaje, min, max, codigo);
  }

  mostrarAlerta() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Código de validación', textAlign: TextAlign.center),
            children: [
              TextField(
                controller: codigoCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Ingrese el código",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.white12))),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromRGBO(120, 139, 255, 1.0)),
                    ),
                    onPressed: () {},
                    child: Text('Si, estoy seguro')),
              ),
            ],
          );
        });
  }

  void _navegarCancelar(BuildContext context) {
    Navigator.pop(context);
  }

  _cargarSexo() async {
    _sexo.add(DropdownMenuItem(child: Text("Masculino"), value: 0));
    _sexo.add(DropdownMenuItem(child: Text("Femenino"), value: 1));
  }
}
