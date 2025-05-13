import 'package:flutter/material.dart';
import 'package:sistema_sqlite/paginas/producto.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      appBar: AppBar(
        title: Text('Menú principal'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Center(child: Text('Sistema')),
      drawer: Drawer(
        child: Container(
          color: Colors.tealAccent,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.teal.shade900],
                  ),
                ),
                accountName: Text('Personal system'),
                accountEmail: Text('ps@digi.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text('SP', style: TextStyle(fontSize: 35)),
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
                leading: Icon(Icons.sim_card_alert_sharp),
                title: Text('Compras', style: TextStyle(fontSize: 20)),
              ),
              ListTile(
                focusColor: Colors.amber,
                leading: Icon(Icons.paypal),
                title: Text('Ventas', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
