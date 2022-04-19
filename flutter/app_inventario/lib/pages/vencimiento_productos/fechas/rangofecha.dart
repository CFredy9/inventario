import 'package:app_inventario/api/vencimiento.dart';
import 'package:app_inventario/models/detalle_producto.dart';
import 'package:app_inventario/constants.dart';
import 'package:app_inventario/pages/vencimiento_productos/information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class rangoFecha extends StatefulWidget {
  int rango;
  rangoFecha(this.rango);
  @override
  _rangoFechaState createState() => _rangoFechaState();
}

class _rangoFechaState extends State<rangoFecha> {
  List<DetalleProductoModel> items = <DetalleProductoModel>[];
  VencimientoProvider vencimientoProducto = VencimientoProvider();
  bool bandera = false;
  TabController? tabController;
  DateTime dateTime = DateTime.now();
  String valorFecha = "";
  int posFecha = DateTime.now().month;
  int rangoDia = 0;
  int rangoMes = 0;

  @override
  void initState() {
    super.initState();
    items = <DetalleProductoModel>[];
    rangoMes = 0;
    print("Valor rango" + widget.rango.toString());
    if (widget.rango == 30) {
      rangoDia = 0;
      rangoMes = 1;
    } else {
      rangoDia = widget.rango;
      rangoMes = 0;
    }
    //int dia = DateTime.now().day;
    //dateTime = dateTime.subtract(Duration(days: (dia - 1)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    vencimientoProducto = Provider.of<VencimientoProvider>(context);
    if (bandera == false) {
      String fechaInicio = DateFormat('yyyy/MM/dd').format(dateTime).toString();
      var fechaFinal = dateTime.year.toString() +
          '/' +
          (dateTime.month + rangoMes).toString() +
          '/' +
          (dateTime.day + rangoDia).toString();
      vencimientoProducto.getVencimientoProducto(
          fechaInicio, fechaFinal.toString());
      bandera = true;
    }
    return Center(
        child: Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Expanded(
            child: SlideInUp(
              duration: const Duration(seconds: 1),
              child: ListView.builder(
                  itemCount:
                      vencimientoProducto.todosVencimientoProducto.length,
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
                                              '${vencimientoProducto.todosVencimientoProducto[position].producto['nombre']}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    icon: const Icon(
                                                      Icons.date_range_outlined,
                                                      color: Colors.blue,
                                                      size: 24,
                                                    ),
                                                    onPressed: () {}),
                                                Text(
                                                  '${vencimientoProducto.todosVencimientoProducto[position].Vencimiento}',
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
                                          _navigateToVencimientoProductoInformation(
                                              context,
                                              vencimientoProducto
                                                      .todosVencimientoProducto[
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
          ),
        ],
      ),
    ));
  }

  void _navigateToVencimientoProductoInformation(
    BuildContext context,
    DetalleProductoModel detalleproducto,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              VencimientoProductoInformation(detalleproducto)),
    );
  }
}
