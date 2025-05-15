import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/data/db_helper.dart';
import 'package:sistema_sqlite/models/modeloProducto.dart';

class ProductoNotifier extends StateNotifier<List<ModeloProducto>> {
  final DatabaseHelper dbHelper;
  ProductoNotifier(this.dbHelper) : super([]) {
    cargarProductos();
  }

  Future<void> cargarProductos() async {
    final productos = await dbHelper.getProductos();
    state = productos;
  }

  Future<bool> grabarProducto(
    String nombre,
    double costo, [
    String? icon,
  ]) async {
    final existe = await dbHelper.existeNombreProducto(nombre);
    if (!existe) {
      final nuevoProducto = ModeloProducto(
        nombreProducto: nombre,
        costoProducto: costo,
        icon: icon,
      );
      await dbHelper.insertaProducto(nuevoProducto);
      await cargarProductos();
      return true;
    }
    return false;
  }

  Future<void> modificarProducto(
    int pk,
    String nombre,
    double costo, [
    String? icon,
  ]) async {
    final producto = ModeloProducto(
      pkProducto: pk,
      nombreProducto: nombre,
      costoProducto: costo,
      icon: icon,
    );
    await dbHelper.actualizarProducto(producto, pk);
    await cargarProductos();
  }

  Future<void> eliminarProducto(ModeloProducto producto) async {
    await dbHelper.eliminarProducto(producto);
    await cargarProductos();
  }
}

final productoProvider =
    StateNotifierProvider<ProductoNotifier, List<ModeloProducto>>(
      (ref) => ProductoNotifier(DatabaseHelper()),
    );
