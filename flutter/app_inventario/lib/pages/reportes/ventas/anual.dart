import 'package:app_inventario/api/reportes.dart';
import 'package:app_inventario/models/producto.dart';
import 'package:app_inventario/pages/reportes/information.dart';
import 'package:app_inventario/pages/reportes/listview.dart';
import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../utils.dart';
import '../../../constants.dart';
import 'package:animate_do/animate_do.dart';

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
  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
      });
    });
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
        child: _isLoading
            ? ListView.separated(
                itemCount: 1,
                itemBuilder: (context, index) => const NewsCardSkelton(),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: defaultPadding),
              )
            : SlideInRight(
                duration: const Duration(seconds: 1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                              var fechaInicio = values[index].toString() +
                                  '/' +
                                  '1' +
                                  '/' +
                                  '1';
                              var fechaFinal =
                                  (int.parse(values[index]) + 1).toString() +
                                      '/' +
                                      '1' +
                                      '/' +
                                      '1';
                              productoT.getVentaProducto(
                                  fechaInicio, fechaFinal.toString());
                              productoT.getTotales(
                                  fechaInicio, fechaFinal.toString());
                              index = 0;
                              //Navigator.pop(context);
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                        ),
                        SizedBox(
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
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                const Padding(
                                  padding: EdgeInsets.only(top: 0.0),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text(
                                      'Saldo : Q.${productoT.totales['ganancia']}',
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.blue),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: const Icon(
                                                  Icons
                                                      .arrow_circle_up_outlined,
                                                  color: Colors.green,
                                                  size: 24,
                                                ),
                                                onPressed: () {}),
                                            Text(
                                              'Q.${productoT.totales['total_venta']}',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.green),
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
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: Colors.red),
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                              color:
                                                                  Colors.blue,
                                                              size: 24,
                                                            ),
                                                            onPressed: () {}),
                                                        Text(
                                                          'Q.' +
                                                              '${(productoT.todosVentaProducto[position].ganancia == null) ? productoT.todosVentaProducto[position].ganancia = '0' : productoT.todosVentaProducto[position].ganancia}',
                                                          style:
                                                              const TextStyle(
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
                                                      productoT
                                                              .todosVentaProducto[
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
          backgroundColor: Colors.white,
          itemExtent: 64,
          diameterRatio: 0.7,
          looping: true,
          onSelectedItemChanged: (index) => setState(() => this.index = index),
          // selectionOverlay: Container(),
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.indigo.withOpacity(0.12),
          ),
          children: Utils.modelBuilder<String>(
            values,
            (index, value) {
              final isSelected = this.index == index;
              final color = isSelected ? ColorF : ColorF;

              return Center(
                child: Text(
                  value,
                  style: TextStyle(
                      color: color,
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold),
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
        style: ElevatedButton.styleFrom(
            minimumSize: Size(50, 42), primary: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.date_range, size: 40, color: ColorF),
          ],
        ),
        onPressed: onClicked,
      );
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Skeleton(height: 60, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 100, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
        const SizedBox(height: 10),
        const Skeleton(height: 40, width: 315),
      ],
    );
  }
}
