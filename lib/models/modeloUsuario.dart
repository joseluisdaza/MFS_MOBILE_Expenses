class ModeloUsuario {
  String email;
  String nombre;
  String apellido;
  String? icon;

  ModeloUsuario(this.nombre, this.apellido, this.email, this.icon);

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'icon': icon,
    };
  }

  Map<String, dynamic> toMapLite() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'icon': icon,
    };
  }

  static ModeloUsuario fromMap(Map<String, dynamic> map) {
    return ModeloUsuario(
      map['nombre'],
      map['apellido'],
      map['email'],
      map['icon'],
    );
  }
}
