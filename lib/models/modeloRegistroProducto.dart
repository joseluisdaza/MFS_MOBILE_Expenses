class ModeloRegistroProducto {
  int? pkRegistroProducto;
  double precio;
  int cantidad;

  ModeloRegistroProducto({
    this.pkRegistroProducto,
    required this.precio,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'pkRegistroProducto': pkRegistroProducto,
      'precio': precio,
      'cantidad': cantidad,
    };
  }

  Map<String, dynamic> toMapLite() {
    return {'precio': precio, 'cantidad': cantidad};
  }

  static ModeloRegistroProducto fromMap(Map<String, dynamic> map) {
    return ModeloRegistroProducto(
      pkRegistroProducto: map['pkRegistroProducto'],
      precio: map['precio'],
      cantidad: map['cantidad'],
    );
  }
}
