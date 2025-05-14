class ModeloTipoProducto {
  int? pkTipoProducto;
  String nombre;
  double color;

  ModeloTipoProducto({
    this.pkTipoProducto,
    required this.nombre,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'pkTipoProducto': pkTipoProducto,
      'nombre': pkTipoProducto,
      'color': pkTipoProducto,
    };
  }

  Map<String, dynamic> toMapLite() {
    return {'nombre': pkTipoProducto, 'color': pkTipoProducto};
  }

  static ModeloTipoProducto fromMap(Map<String, dynamic> map) {
    return ModeloTipoProducto(
      pkTipoProducto: map['pkTipoProducto'],
      nombre: map['nombre'],
      color: map['color'],
    );
  }
}
