class ModeloProducto {
  int? pkProducto;
  String nombreProducto;
  double costoProducto;
  int pkTipoProducto = 0;

  ModeloProducto({
    this.pkProducto,
    required this.nombreProducto,
    required this.costoProducto,
    required this.pkTipoProducto,
  });

  Map<String, dynamic> toMap() {
    return {
      'pkProducto': pkProducto,
      'nombreProducto': nombreProducto,
      'CostoProducto': costoProducto,
      'pkTipoProducto': pkTipoProducto,
    };
  }

  Map<String, dynamic> toMapLite() {
    return {
      'nombreProducto': nombreProducto,
      'CostoProducto': costoProducto,
      'pkTipoProducto': pkTipoProducto,
    };
  }

  static ModeloProducto fromMap(Map<String, dynamic> map) {
    return ModeloProducto(
      pkProducto: map['pkProducto'],
      nombreProducto: map['nombreProducto'],
      costoProducto: map['CostoProducto'],
      pkTipoProducto: map['pkTipoProducto'],
    );
  }
}
