import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/models/modeloUsuario.dart';
import 'package:sistema_sqlite/providers/usuario_provider.dart';

class Usuario extends ConsumerWidget {
  const Usuario({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarios = ref.watch(usuarioProvider);
    final nombreController = TextEditingController();
    final apellidoController = TextEditingController();
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final modo = ValueNotifier('grabar');
    final emailActivo = ValueNotifier<String?>(null);

    void limpiarCampos() {
      nombreController.clear();
      apellidoController.clear();
      emailController.clear();
      emailActivo.value = null;
      modo.value = 'grabar';
    }

    Future<void> grabarUsuario() async {
      final nombre = nombreController.text;
      final apellido = apellidoController.text;
      final email = emailController.text;
      final ok = await ref
          .read(usuarioProvider.notifier)
          .grabarUsuario(nombre, apellido, email);
      if (ok) {
        limpiarCampos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario grabado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error, el email ya existe')),
        );
      }
    }

    Future<void> modificarUsuario() async {
      final nombre = nombreController.text;
      final apellido = apellidoController.text;
      final email = emailController.text;
      await ref
          .read(usuarioProvider.notifier)
          .modificarUsuario(emailActivo.value!, nombre, apellido, email);
      limpiarCampos();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Se actualizó con éxito')));
    }

    // Future<void> estaSeguroDeEliminar(ModeloUsuario usuario) async {
    //   await showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: const Text('Confirma la eliminación de:'),
    //         content: Text(
    //           usuario.email,
    //           style: const TextStyle(fontSize: 20),
    //           textAlign: TextAlign.center,
    //         ),
    //         actions: [
    //           TextButton(
    //             onPressed: () async {
    //               await ref.read(usuarioProvider.notifier).eliminarUsuario(usuario.email);
    //               Navigator.pop(context);
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 const SnackBar(content: Text('Usuario eliminado')),
    //               );
    //             },
    //             child: const Text('Confirmo'),
    //           ),
    //           TextButton(
    //             onPressed: () {
    //               Navigator.pop(context);
    //             },
    //             child: const Text('Cancelar'),
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    void editarCampos(ModeloUsuario usuario) {
      nombreController.text = usuario.nombre;
      apellidoController.text = usuario.apellido;
      emailController.text = usuario.email;
      emailActivo.value = usuario.email;
      modo.value = 'modificar';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el apellido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<String>(
                valueListenable: modo,
                builder: (context, value, _) {
                  return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (value == 'grabar') {
                          grabarUsuario();
                        } else {
                          modificarUsuario();
                        }
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: Text((value == 'grabar') ? 'Aceptar' : 'Modificar'),
                  );
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child:
                    usuarios.isEmpty
                        ? const Center(child: Text('No hay usuarios'))
                        : ListView.builder(
                          itemCount: usuarios.length,
                          itemBuilder: (context, index) {
                            final usuario = usuarios[index];
                            return Card(
                              child: ListTile(
                                title: Text(
                                  '${usuario.nombre} ${usuario.apellido}',
                                ),
                                subtitle: Text(usuario.email),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green.shade900,
                                      ),
                                      onPressed: () => editarCampos(usuario),
                                    ),
                                    // IconButton(
                                    //   icon: Icon(Icons.delete, color: Colors.red.shade900),
                                    //   onPressed: () => estaSeguroDeEliminar(usuario),
                                    // ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
