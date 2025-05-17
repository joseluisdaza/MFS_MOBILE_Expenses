import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/models/modeloUsuario.dart';
import 'package:sistema_sqlite/data/db_helper.dart'; // Adjust path as needed

class UsuarioNotifier extends StateNotifier<List<ModeloUsuario>> {
  final DatabaseHelper dbHelper;
  UsuarioNotifier(this.dbHelper) : super([]) {
    cargarUsuarios();
  }

  Future<void> cargarUsuarios() async {
    final usuarios = await dbHelper.getUsuarios();
    state = usuarios;
  }

  Future<bool> grabarUsuario(
    String nombre,
    String apellido,
    String email,
  ) async {
    // Check if email exists
    final existe = await dbHelper.existeUsuario(email);
    if (!existe) {
      final nuevoUsuario = ModeloUsuario(nombre, apellido, email);
      await dbHelper.insertaUsuario(nuevoUsuario);
      await cargarUsuarios();
      return true;
    }
    return false;
  }

  Future<void> modificarUsuario(
    String emailOriginal,
    String nombre,
    String apellido,
    String emailNuevo,
  ) async {
    final usuario = ModeloUsuario(nombre, apellido, emailNuevo);
    await dbHelper.actualizarUsuario(usuario);
    await cargarUsuarios();
  }

  // Future<void> eliminarUsuario(String email) async {
  //   await dbHelper.eliminarUsuario(email);
  //   await cargarUsuarios();
  // }
}

final usuarioProvider =
    StateNotifierProvider<UsuarioNotifier, List<ModeloUsuario>>(
      (ref) => UsuarioNotifier(DatabaseHelper()),
    );
