class Usuario {
  final int id;
  final String correo;
  final int rut;
  final int promedio;

  const Usuario({this.id, this.correo, this.rut, this.promedio});

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      id: json['id'],
      correo: json['email'],
      rut: json['rut'],
      promedio: json['promedio_evaluaciones']);
}
