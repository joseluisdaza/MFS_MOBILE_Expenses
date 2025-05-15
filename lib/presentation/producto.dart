import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/models/modeloProducto.dart';
import 'package:sistema_sqlite/providers/producto_provider.dart';

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

    void limpiarCampos() {
      nombreController.clear();
      costoController.clear();
      pkActivo.value = -1;
      modo.value = 'grabar';
    }

    Future<void> grabarProducto() async {
      final nombre = nombreController.text;
      final costo = double.tryParse(costoController.text) ?? 0.0;
      final existe = await ref
          .read(productoProvider.notifier)
          .grabarProducto(nombre, costo);
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
          .modificarProducto(pkActivo.value, nombre, costo);
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
    }

    return Scaffold(
      appBar: AppBar(title: const Text('ABC Producto')),
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
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            item.nombreProducto,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            'costo: ${item.costoProducto}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              editarCampos(item);
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green.shade900,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              estaSeguroDeEliminar(item);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
