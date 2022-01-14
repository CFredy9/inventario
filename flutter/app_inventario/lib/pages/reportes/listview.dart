import 'package:app_inventario/pages/reportes/information.dart';
import '../../utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../../api/reportes.dart';
import './ventas/mensual.dart';
import './ventas/anual.dart';

class ListViewVentaProductos extends StatefulWidget {
  @override
  _ListViewVentaProductosState createState() => _ListViewVentaProductosState();
}

class _ListViewVentaProductosState extends State<ListViewVentaProductos>
    with SingleTickerProviderStateMixin {
  List<ProductoModel> items = <ProductoModel>[];
  ReportesProvider productoT = ReportesProvider();
  bool bandera = false;
  bool bandera2 = false;
  TabController? tabController;
  DateTime dateTime = DateTime.now();
  String valorFecha = "";
  int posFecha = DateTime.now().month;
  int index = 0;
  @override
  void initState() {
    super.initState();
    items = <ProductoModel>[];
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /*localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'), // English
        //const Locale('de', 'DE'), // German
        // ... other locales the app supports
      ],*/
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text('VENTAS DE PRODUCTOS'),
            centerTitle: true,
            //backgroundColor: Colors.blueAccent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // passing this to our root
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
            bottom: TabBar(
              //isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              controller: tabController,
              tabs: const <Widget>[
                Tab(text: 'Mensual'),
                Tab(text: 'Anual'),
              ],
            ),
            //elevation: 20,
            //titleSpacing: 20,
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              ReporteMensual(),
              ReporteAnual(),
            ],
          )),
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
