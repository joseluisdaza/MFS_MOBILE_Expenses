import 'package:flutter/material.dart';
import 'package:sistema_sqlite/data/ab_helper.dart';
import 'package:sistema_sqlite/models/modeloProducto.dart';

class Producto extends StatefulWidget {
  const Producto({super.key});

  @override
  State<Producto> createState() => _ProductoState();
}

class _ProductoState extends State<Producto> {
  final _formKey = GlobalKey<FormState>();
  final _nombreProducto = TextEditingController();
  final _costoUnitario = TextEditingController();
  List<ModeloProducto> _productos = [];
  final _dbHelper = DatabaseHelper();
  String modo = 'grabar';
  int _pkActivo = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final productos = await _dbHelper.getProductos();

    setState(() {
      _productos = productos;
    });
  }

  Future<void> _grabarProducto() async {
    // vemos si existe el nombre
    final nombre = _nombreProducto.text;
    final costo = double.tryParse(_costoUnitario.text) ?? 0.0;
    bool existe = await _dbHelper.existeNombreProducto(nombre);

    if (!existe) {
      final nuevoProducto = ModeloProducto(
        nombreProducto: nombre,
        costoProducto: costo,
      );
      await _dbHelper.insertaProducto(nuevoProducto);
      _nombreProducto.clear();
      _costoUnitario.clear();
      _cargarProductos();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Procesando datos')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error, el nombre ya existe')));
    }
  }

  Future<void> _modificarProducto() async {
    final nombre = _nombreProducto.text;
    final costo = double.tryParse(_costoUnitario.text) ?? 0.0;
    final nuevoProducto = ModeloProducto(
      pkProducto: _pkActivo,
      nombreProducto: nombre,
      costoProducto: costo,
    );

    await _dbHelper.actualizarProducto(nuevoProducto, _pkActivo);
    _nombreProducto.clear();
    _costoUnitario.clear();
    _cargarProductos();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Se actualizo con exito')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ABC Producto')),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nombreProducto,
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              TextFormField(
                controller: _costoUnitario,
                decoration: InputDecoration(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (modo == 'grabar') {
                      _grabarProducto();
                    } else {
                      _modificarProducto();
                      _pkActivo = -1;
                      modo = 'grabar';
                      FocusScope.of(context).unfocus();
                    }
                  }
                },
                child: Text((modo == 'grabar') ? 'Aceptar' : 'Modificar'),
              ),
              SizedBox(height: 10),
              Expanded(
                child:
                    _productos.isEmpty
                        ? Center(child: Text('No hay registros'))
                        : ListView.builder(
                          itemCount: _productos.length,
                          itemBuilder: (context, index) {
                            final item = _productos[index];

                            return Card(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Expanded(child:
                                      Column(
                                        children: [
                                          Text(
                                            item.nombreProducto,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            'costo: ${item.costoProducto}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      //),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _editarCampos(item);
                                                _pkActivo = item.pkProducto!;
                                                print('_pkActivo = $_pkActivo');
                                                modo = 'modificar';
                                              });
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green.shade900,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _estaSeguroDeEliminar(item);
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

  Future<void> _estaSeguroDeEliminar(ModeloProducto objProducto) async {
    await showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          title: Text('Confirma la eliminación de:'),
          content: Text(
            objProducto.nombreProducto,
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _dbHelper.eliminarProducto(objProducto);
                Navigator.pop(context);
                _cargarProductos();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado')),
                );
              },
              child: Text('Confirmo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editarCampos(ModeloProducto item) async {
    _nombreProducto.text = item.nombreProducto;
    _costoUnitario.text = item.costoProducto.toString();
  }
}
