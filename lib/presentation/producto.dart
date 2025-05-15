import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/models/modeloProducto.dart';
import 'package:sistema_sqlite/providers/producto_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Producto extends ConsumerWidget {
  const Producto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(productoProvider);
    final nombreController = TextEditingController();
    final costoController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final modo = ValueNotifier('grabar');
    final pkActivo = ValueNotifier(-1);
    final imagePath = ValueNotifier<String?>(null);

    void limpiarCampos() {
      nombreController.clear();
      costoController.clear();
      pkActivo.value = -1;
      modo.value = 'grabar';
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

    Future<void> grabarProducto() async {
      final nombre = nombreController.text;
      final costo = double.tryParse(costoController.text) ?? 0.0;
      final existe = await ref
          .read(productoProvider.notifier)
          .grabarProducto(nombre, costo, imagePath.value);

      if (existe) {
        limpiarCampos();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto grabado correctamente')),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error, el nombre ya existe')));
      }
    }

    Future<void> modificarProducto() async {
      final nombre = nombreController.text;
      final costo = double.tryParse(costoController.text) ?? 0.0;

      await ref
          .read(productoProvider.notifier)
          .modificarProducto(pkActivo.value, nombre, costo, imagePath.value);
      limpiarCampos();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Se actualizó con éxito')));
    }

    Future<void> estaSeguroDeEliminar(ModeloProducto objProducto) async {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirma la eliminación de:'),
            content: Text(
              objProducto.nombreProducto,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await ref
                      .read(productoProvider.notifier)
                      .eliminarProducto(objProducto);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Producto eliminado')),
                  );
                },
                child: const Text('Confirmo'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      );
    }

    void editarCampos(ModeloProducto item) {
      nombreController.text = item.nombreProducto;
      costoController.text = item.costoProducto.toString();
      pkActivo.value = item.pkProducto!;
      modo.value = 'modificar';
      imagePath.value = item.icon;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
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
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: costoController,
                decoration: const InputDecoration(
                  labelText: 'Costo unitario',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa costo';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),

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

              ValueListenableBuilder<String>(
                valueListenable: modo,
                builder: (context, value, _) {
                  return ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (value == 'grabar') {
                          grabarProducto();
                        } else {
                          modificarProducto();
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
                    productos.isEmpty
                        ? const Center(child: Text('No hay registros'))
                        : ListView.builder(
                          itemCount: productos.length,
                          itemBuilder: (context, index) {
                            final item = productos[index];
                            return Card(
                              child: ListTile(
                                leading:
                                    item.icon != null
                                        ? Image.file(
                                          File(item.icon!),
                                          width: 50,
                                          height: 50,
                                        )
                                        : const Icon(Icons.image, size: 50),
                                title: Text(item.nombreProducto),
                                subtitle: Text('Costo: ${item.costoProducto}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.green.shade900,
                                      ),
                                      onPressed: () => editarCampos(item),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade900,
                                      ),
                                      onPressed:
                                          () => estaSeguroDeEliminar(item),
                                    ),
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
