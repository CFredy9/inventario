import 'package:app_inventario/api/reportes.dart';
import 'package:app_inventario/models/producto.dart';
import 'package:app_inventario/pages/reportes/information.dart';
import 'package:app_inventario/pages/reportes/listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';

class ReporteAnual extends StatefulWidget {
  @override
  _ReporteAnualState createState() => _ReporteAnualState();
}

class _ReporteAnualState extends State<ReporteAnual> {
  List<ProductoModel> items = <ProductoModel>[];
  ReportesProvider productoT = ReportesProvider();
  bool bandera = false;
  TabController? tabController;
  DateTime dateTime = DateTime.now();
  String valorFecha = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    items = <ProductoModel>[];
    valorFecha = dateTime.year.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ReportesProvider>(context);
    if (bandera == false) {
      var fechaInicio = dateTime.year.toString() + '/' + '1' + '/' + '1';
      var fechaFinal = (dateTime.year + 1).toString() + '/' + '1' + '/' + '1';
      productoT.getVentaProducto(fechaInicio, fechaFinal.toString());
      productoT.getTotales(fechaInicio, fechaFinal.toString());
      bandera = true;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(height: 24),
                ButtonWidget(
                  onClicked: () => Utils.showSheet(
                    context,
                    child: buildCustomPicker(),
                    onClicked: () {
                      final value = values[index];
                      //Utils.showSnackBar(context, 'Selected "$value"');
                      setState(() {
                        print(index);
                        valorFecha = values[index];
                      });
                      var fechaInicio =
                          values[index].toString() + '/' + '1' + '/' + '1';
                      var fechaFinal =
                          (int.parse(values[index]) + 1).toString() +
                              '/' +
                              '1' +
                              '/' +
                              '1';
                      productoT.getVentaProducto(
                          fechaInicio, fechaFinal.toString());
                      productoT.getTotales(fechaInicio, fechaFinal.toString());
                      index = 0;
                      //Navigator.pop(context);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text('${valorFecha}', style: TextStyle(fontSize: 20)),
              ],
            ),
            Center(
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Text(
                              'Saldo : Q.${productoT.totales['ganancia']}',
                              style:
                                  TextStyle(fontSize: 22.0, color: Colors.blue),
                            ),
                            Column(
                              children: [
                                Text(
                                  'Ventas : Q.${productoT.totales['total_venta']}',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.green),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                ),
                                Text(
                                  'Costos : Q.${productoT.totales['total_costo']}',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: productoT.todosVentaProducto.length,
                  padding: EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        Divider(
                          height: 1.0,
                        ),
                        Container(
                          padding: new EdgeInsets.all(3.0),
                          child: Card(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                      title: Text(
                                        '${productoT.todosVentaProducto[position].Nombre}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Ganancia: Q.' +
                                            '${(productoT.todosVentaProducto[position].ganancia == null) ? productoT.todosVentaProducto[position].ganancia = '0' : productoT.todosVentaProducto[position].ganancia}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      onTap: () =>
                                          _navigateToVentaProductoInformation(
                                              context,
                                              productoT.todosVentaProducto[
                                                  position])),
                                ),
                              ],
                            ),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  static List<String> values = [
    '2020',
    '2021',
    '2022',
  ];

  Widget buildCustomPicker() => SizedBox(
        height: 200,
        child: CupertinoPicker(
          itemExtent: 64,
          diameterRatio: 0.7,
          looping: true,
          onSelectedItemChanged: (index) => setState(() => this.index = index),
          // selectionOverlay: Container(),
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.blue.withOpacity(0.12),
          ),
          children: Utils.modelBuilder<String>(
            values,
            (index, value) {
              final isSelected = this.index == index;
              final color = isSelected ? Colors.blueAccent : Colors.black;

              return Center(
                child: Text(
                  value,
                  style: TextStyle(color: color, fontSize: 24),
                ),
              );
            },
          ),
        ),
      );

  void _navigateToVentaProductoInformation(
    BuildContext context,
    ProductoModel producto,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VentaProductoInformation(producto)),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(50, 42)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, size: 35),
          ],
        ),
        onPressed: onClicked,
      );
}
