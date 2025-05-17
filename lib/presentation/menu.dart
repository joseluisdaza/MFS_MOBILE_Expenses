import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sistema_sqlite/presentation/producto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/presentation/usuario.dart';
import 'package:sistema_sqlite/providers/usuario_provider.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarios = ref.watch(usuarioProvider);

    return Scaffold(
      backgroundColor: Colors.blueGrey.shade100,
      appBar: AppBar(
        title: Text('Menú principal'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(child: Text('Control de gastos')),
      drawer: Drawer(
        child: Container(
          color: Colors.blueGrey.shade100,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.blueGrey.shade900],
                  ),
                ),
                // Get the first usuario from the provider
                accountName: Text(
                  usuarios.isNotEmpty
                      ? usuarios.first.nombre
                      : 'Actualiza el nombre',
                ),
                accountEmail: Text(
                  usuarios.isNotEmpty
                      ? usuarios.first.email
                      : 'Actualiza el correo',
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage:
                      (usuarios.isNotEmpty &&
                              usuarios.first.icon != null &&
                              usuarios.first.icon!.isNotEmpty)
                          // Use FileImage for file paths, AssetImage for bundled assets
                          ? (usuarios.first.icon!.startsWith('/') ||
                                  usuarios.first.icon!.startsWith('file')
                              ? FileImage(File(usuarios.first.icon!))
                              : AssetImage(usuarios.first.icon!)
                                  as ImageProvider)
                          : null,
                  child:
                      (usuarios.isNotEmpty &&
                              usuarios.first.icon != null &&
                              usuarios.first.icon!.isNotEmpty)
                          ? null
                          : Text('SP', style: TextStyle(fontSize: 35)),
                ),
              ),

              Divider(height: 10, color: Colors.teal.shade700),

              ListTile(
                focusColor: Colors.amber,
                leading: Icon(Icons.production_quantity_limits_outlined),
                title: Text('Producto', style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Producto()),
                  );
                },
              ),

              ListTile(
                focusColor: Colors.amber,
                leading: Icon(Icons.settings_accessibility),
                title: Text('Usuario', style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Usuario()),
                  );
                },
              ),

              // ListTile(
              //   focusColor: Colors.amber,
              //   leading: Icon(Icons.sim_card_alert_sharp),
              //   title: Text('Compras', style: TextStyle(fontSize: 20)),
              // ),

              // ListTile(
              //   focusColor: Colors.amber,
              //   leading: Icon(Icons.paypal),
              //   title: Text('Ventas', style: TextStyle(fontSize: 20)),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
