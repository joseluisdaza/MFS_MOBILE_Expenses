class ModeloProducto {
  int? pkProducto;
  String nombreProducto;
  double costoProducto;
  int pkTipoProducto = -1;
  String? icon;

  ModeloProducto({
    this.pkProducto,
    required this.nombreProducto,
    required this.costoProducto,
    this.pkTipoProducto = -1,
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'pkProducto': pkProducto,
      'nombreProducto': nombreProducto,
      'costoProducto': costoProducto,
      'pkTipoProducto': pkTipoProducto,
      'icon': icon,
    };
  }

  Map<String, dynamic> toMapLite() {
    return {
      'nombreProducto': nombreProducto,
      'costoProducto': costoProducto,
      'pkTipoProducto': pkTipoProducto,
      'icon': icon,
    };
  }

  static ModeloProducto fromMap(Map<String, dynamic> map) {
    return ModeloProducto(
      pkProducto: map['pkProducto'],
      nombreProducto: map['nombreProducto'],
      costoProducto: map['costoProducto'],
      pkTipoProducto: map['pkTipoProducto'],
      icon: map['icon'],
    );
  }
}
