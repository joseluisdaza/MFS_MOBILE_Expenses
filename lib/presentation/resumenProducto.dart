import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sistema_sqlite/models/modeloProducto.dart';
import 'package:sistema_sqlite/providers/producto_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ResumenProducto extends ConsumerWidget {
  const ResumenProducto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productos = ref.watch(productoProvider);

    if (productos.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resumen de Productos')),
        body: const Center(child: Text('No hay productos registrados')),
      );
    }

    // Last product added (assuming last in list is last added)
    final lastProducto = productos.last;

    // Product with highest price
    final maxProducto = productos.reduce(
      (a, b) => a.costoProducto > b.costoProducto ? a : b,
    );

    // Product with lowest price
    final minProducto = productos.reduce(
      (a, b) => a.costoProducto < b.costoProducto ? a : b,
    );

    // Prepare data for chart
    final barGroups =
        productos.asMap().entries.map((entry) {
          final idx = entry.key;
          final producto = entry.value;
          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: producto.costoProducto,
                color: Colors.blueAccent,
                width: 18,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Productos'),
        backgroundColor: Colors.blueGrey,
      ),
      backgroundColor: Colors.blueGrey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                title: const Text('Último producto agregado'),
                subtitle: Text(
                  '${lastProducto.nombreProducto} (\$${lastProducto.costoProducto})',
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Producto con mayor precio'),
                subtitle: Text(
                  '${maxProducto.nombreProducto} (\$${maxProducto.costoProducto})',
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Producto con menor precio'),
                subtitle: Text(
                  '${minProducto.nombreProducto} (\$${minProducto.costoProducto})',
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Precios de productos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY:
                      productos
                          .map((p) => p.costoProducto)
                          .reduce((a, b) => a > b ? a : b) +
                      10,
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          final idx = value.toInt();
                          if (idx >= 0 && idx < productos.length) {
                            return Text(
                              productos[idx].nombreProducto.length > 6
                                  ? productos[idx].nombreProducto.substring(
                                    0,
                                    6,
                                  )
                                  : productos[idx].nombreProducto,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
