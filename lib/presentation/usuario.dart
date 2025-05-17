import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
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
    final imagePath = ValueNotifier<String?>(null);

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
          .grabarUsuario(nombre, apellido, email, imagePath.value);
      if (ok) {
        limpiarCampos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario grabado correctamente')),
        );
      }
    }

    Future<void> modificarUsuario() async {
      final nombre = nombreController.text;
      final apellido = apellidoController.text;
      final email = emailController.text;
      await ref
          .read(usuarioProvider.notifier)
          .modificarUsuario(
            emailActivo.value!,
            nombre,
            apellido,
            email,
            imagePath.value,
          );
      limpiarCampos();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Se actualizó con éxito')));
    }

    void editarCampos(ModeloUsuario usuario) {
      nombreController.text = usuario.nombre;
      apellidoController.text = usuario.apellido;
      emailController.text = usuario.email;
      emailActivo.value = usuario.email;
      imagePath.value = usuario.icon;
      modo.value = 'modificar';
    }

    Future<void> pickImage(ImageSource source) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = path.basename(pickedFile.path);
        final savedImage = await File(
          pickedFile.path,
        ).copy('${appDir.path}/$fileName');
        imagePath.value = savedImage.path;
      }
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
              ValueListenableBuilder<String?>(
                valueListenable: imagePath,
                builder: (context, value, _) {
                  return Column(
                    children: [
                      value != null
                          ? Image.file(File(value), width: 100, height: 100)
                          : const Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: () => pickImage(ImageSource.camera),
                          ),
                          IconButton(
                            icon: const Icon(Icons.photo),
                            onPressed: () => pickImage(ImageSource.gallery),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),

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
