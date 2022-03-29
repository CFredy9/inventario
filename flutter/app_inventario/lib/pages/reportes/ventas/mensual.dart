import 'package:app_inventario/api/reportes.dart';
import 'package:app_inventario/models/producto.dart';
import 'package:app_inventario/constants.dart';
import 'package:app_inventario/pages/reportes/information.dart';
import 'package:app_inventario/pages/reportes/listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';

class ReporteMensual extends StatefulWidget {
  @override
  _ReporteMensualState createState() => _ReporteMensualState();
}

class _ReporteMensualState extends State<ReporteMensual> {
  List<ProductoModel> items = <ProductoModel>[];
  ReportesProvider productoT = ReportesProvider();
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
    if (bandera == false) {
      String fechaInicio = DateFormat('yyyy/MM/dd').format(dateTime).toString();
      var fechaFinal = dateTime.year.toString() +
          '/' +
          (dateTime.month + 1).toString() +
          '/' +
          dateTime.day.toString();
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
              mainAxisAlignment: MainAxisAlignment.center,
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

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Text('${valorFecha}',
                    style: const TextStyle(
                        fontSize: 20,
                        color: ColorF,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Center(
              child: Container(
                height: 115,
                padding: const EdgeInsets.all(0.0),
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
                              padding: EdgeInsets.only(top: 15.0),
                            ),
                            Text(
                              'Saldo: Q.${productoT.totales['ganancia']}',
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(
                                          Icons.arrow_circle_up_outlined,
                                          color: Colors.green,
                                          size: 24,
                                        ),
                                        onPressed: () {}),
                                    Text(
                                      'Q.${productoT.totales['total_venta']}',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.green),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        icon: const Icon(
                                          Icons.arrow_circle_down_sharp,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        onPressed: () {}),
                                    Text(
                                      'Q.${productoT.totales['total_costo']}',
                                      style: TextStyle(
                                          fontSize: 18.0, color: Colors.red),
                                    ),
                                  ],
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
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              )),
                          padding: new EdgeInsets.all(3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                      title: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${productoT.todosVentaProducto[position].Nombre}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_circle_up_outlined,
                                                      color: Colors.blue,
                                                      size: 24,
                                                    ),
                                                    onPressed: () {}),
                                                Text(
                                                  'Q.' +
                                                      '${(productoT.todosVentaProducto[position].ganancia == null) ? productoT.todosVentaProducto[position].ganancia = '0' : productoT.todosVentaProducto[position].ganancia}',
                                                  style: const TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
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
        child: CupertinoTheme(
          data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                  fontSize: 18,
                  color: ColorF,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            minimumYear: 2015,
            maximumYear: DateTime.now().year,
            initialDateTime: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.dateTime = dateTime),
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
        style: ElevatedButton.styleFrom(
            minimumSize: Size(50, 42), primary: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 40,
              color: ColorF,
            ),
          ],
        ),
        onPressed: onClicked,
      );
}
