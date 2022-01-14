import 'package:app_inventario/models/producto.dart';
import 'package:app_inventario/pages/reportes/information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';
import '../../../api/reportes.dart';
import '../../../api/gastos.dart';

class BalanceMensual extends StatefulWidget {
  @override
  _BalanceMensualState createState() => _BalanceMensualState();
}

class _BalanceMensualState extends State<BalanceMensual> {
  List<ProductoModel> items = <ProductoModel>[];
  ReportesProvider productoT = ReportesProvider();
  GastosProvider gastoT = GastosProvider();
  bool bandera = false;
  TabController? tabController;
  DateTime dateTime = DateTime.now();
  String valorFecha = "";
  int posFecha = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    items = <ProductoModel>[];

    int dia = DateTime.now().day;
    dateTime = dateTime.subtract(Duration(days: (dia - 1)));
    print(posFecha);
    nombreMes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ReportesProvider>(context);
    gastoT = Provider.of<GastosProvider>(context);
    if (bandera == false) {
      String fechaInicio = DateFormat('yyyy/MM/dd').format(dateTime).toString();
      var fechaFinal = dateTime.year.toString() +
          '/' +
          (dateTime.month + 1).toString() +
          '/' +
          dateTime.day.toString();
      productoT.getVentaProducto(fechaInicio, fechaFinal.toString());
      productoT.getTotales(fechaInicio, fechaFinal.toString());
      gastoT.getGastoBalance(fechaInicio, fechaFinal.toString());
      gastoT.getTotalBalance(fechaInicio, fechaFinal.toString());
      gastoT.getSaldoBalance(fechaInicio, fechaFinal.toString());
      bandera = true;
    }
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                ButtonWidget(
                  onClicked: () => Utils.showSheet(
                    context,
                    child: buildDatePicker(),
                    onClicked: () {
                      final value = DateFormat('yyyy/MM/dd').format(dateTime);
                      //Utils.showSnackBar(context, 'Selected "$value"');

                      var fechaFinal;
                      setState(() {
                        posFecha = dateTime.month;
                        nombreMes();
                        print(dateTime.month);
                        if (dateTime.month == 12) {
                          fechaFinal = (dateTime.year + 1).toString() +
                              '/' +
                              '1' +
                              '/' +
                              dateTime.day.toString();
                        } else {
                          fechaFinal = dateTime.year.toString() +
                              '/' +
                              (dateTime.month + 1).toString() +
                              '/' +
                              dateTime.day.toString();
                        }
                      });

                      print(value);

                      productoT.getVentaProducto(value, fechaFinal.toString());
                      productoT.getTotales(value, fechaFinal.toString());
                      gastoT.getGastoBalance(value, fechaFinal.toString());
                      gastoT.getTotalBalance(value, fechaFinal.toString());
                      gastoT.getSaldoBalance(value, fechaFinal.toString());

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
                height: 70,
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Text(
                          'Saldo: Q.${gastoT.saldo['total']}',
                          style: TextStyle(fontSize: 22.0, color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 50,
                  child: Card(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            'Ingreso: Q.${productoT.totales['ganancia']}',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: 50,
                  child: Card(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            'Gasto: Q.${gastoT.total['total']}',
                            style: TextStyle(fontSize: 18.0, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: ListView.builder(
                      itemCount: productoT.todosVentaProducto.length,
                      padding: EdgeInsets.only(top: 1.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            /*Divider(
                              height: 1.0,
                            ),*/
                            Container(
                              padding: new EdgeInsets.all(1.0),
                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          '${productoT.todosVentaProducto[position].Nombre}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${(productoT.todosVentaProducto[position].ganancia == null) ? productoT.todosVentaProducto[position].ganancia = '0' : productoT.todosVentaProducto[position].ganancia}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
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
                //Divider(),
                Container(
                  width: MediaQuery.of(context).size.width * 0.45,
                  height: MediaQuery.of(context).size.height * 0.55,
                  child: ListView.builder(
                      itemCount: gastoT.todosGasto.length,
                      padding: EdgeInsets.only(top: 1.0),
                      itemBuilder: (context, position) {
                        return Column(
                          children: <Widget>[
                            /*Divider(
                              height: 1.0,
                            ),*/
                            Container(
                              padding: new EdgeInsets.all(1.0),
                              child: Card(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                          '${gastoT.todosGasto[position].Descripcion}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        subtitle: Text(
                                          '${gastoT.todosGasto[position].total}',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
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
          ],
        ),
      ),
    );
  }

  void nombreMes() {
    List mes = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    valorFecha = mes[posFecha - 1] + ' ' + dateTime.year.toString();
  }

  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoDatePicker(
          minimumYear: 2015,
          maximumYear: DateTime.now().year,
          initialDateTime: dateTime,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (dateTime) =>
              setState(() => this.dateTime = dateTime),
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
