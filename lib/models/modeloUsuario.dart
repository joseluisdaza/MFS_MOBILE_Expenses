class ModeloUsuario {
  String email;
  String nombre;
  String apellido;

  ModeloUsuario(this.nombre, this.apellido, this.email);

  Map<String, dynamic> toMap() {
    return {'nombre': nombre, 'apellido': apellido, 'email': email};
  }

  Map<String, dynamic> toMapLite() {
    return {'nombre': nombre, 'apellido': apellido, 'email': email};
  }

  static ModeloUsuario fromMap(Map<String, dynamic> map) {
    return ModeloUsuario(map['nombre'], map['apellido'], map['email']);
  }
}
