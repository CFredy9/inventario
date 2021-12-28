import 'package:app_inventario/pages/reportes/information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../../api/reportes.dart';

class ListViewVentaProductos extends StatefulWidget {
  @override
  _ListViewVentaProductosState createState() => _ListViewVentaProductosState();
}

class _ListViewVentaProductosState extends State<ListViewVentaProductos> {
  List<ProductoModel> items = <ProductoModel>[];
  ReportesProvider productoT = ReportesProvider();
  bool bandera = false;
  @override
  void initState() {
    super.initState();
    items = <ProductoModel>[];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ReportesProvider>(context);
    if (bandera == false || productoT.todosVentaProducto.isEmpty) {
      productoT.getVentaProducto();
      productoT.getTotales();
      bandera = true;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('VENTAS DE PRODUCTOS'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // passing this to our root
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
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
                                  style: TextStyle(
                                      fontSize: 22.0, color: Colors.blue),
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
        ),
      ),
    );
  }

  /*void _navigateToProducto(BuildContext context, ProductoModel producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationProducto(producto)),
    );
  } */

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
