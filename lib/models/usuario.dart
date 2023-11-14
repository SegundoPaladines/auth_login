class Usuario {
  int? id;
  String usuario;
  String contrasena;
  List<double>? rostroCaracteristicas;
  String? huellaDigital;

  Usuario({
    this.id,
    required this.usuario,
    required this.contrasena,
    this.rostroCaracteristicas,
    this.huellaDigital,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'contrasena': contrasena,
      'rostroCaracteristicas': rostroCaracteristicas,
      'huellaDigital': huellaDigital,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      usuario: map['usuario'],
      contrasena: map['contrasena'],
      rostroCaracteristicas: map['rostroCaracteristicas'] != null
          ? List<double>.from(map['rostroCaracteristicas'])
          : null,
      huellaDigital: map['huellaDigital'],
    );
  }
}