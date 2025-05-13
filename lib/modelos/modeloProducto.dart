class ModeloProducto {
  int? pkProducto;
  String nombreProducto;
  double costoProducto;

  ModeloProducto({
    this.pkProducto,
    required this.nombreProducto,
    required this.costoProducto,
  });

  Map<String, dynamic> toMap() {
    return {
      'pkProducto': pkProducto,
      'nombreProducto': nombreProducto,
      'CostoProducto': costoProducto,
    };
  }

  Map<String, dynamic> toMap1() {
    return {'nombreProducto': nombreProducto, 'CostoProducto': costoProducto};
  }

  static ModeloProducto fromMap(Map<String, dynamic> map) {
    return ModeloProducto(
      pkProducto: map['pkProducto'],
      nombreProducto: map['nombreProducto'],
      costoProducto: map['CostoProducto'],
    );
  }
}
