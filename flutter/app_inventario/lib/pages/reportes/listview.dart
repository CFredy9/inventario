import 'package:app_inventario/pages/reportes/information.dart';
import '../../utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../../api/reportes.dart';
import './ventas/mensual.dart';
import './ventas/anual.dart';
import 'package:animate_do/animate_do.dart';

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
          backgroundColor: ColorF,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110.0),
            child: SlideInDown(
              duration: Duration(seconds: 2),
              child: AppBar(
                elevation: 0,
                title: const Text('VENTAS DE PRODUCTOS'),
                centerTitle: true,
                backgroundColor: ColorF,
                /*flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                    ),
                  ),
                ),*/
                leading: IconButton(
                  icon: const Icon(Icons.home, color: Colors.white),
                  onPressed: () {
                    // passing this to our root
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
                bottom: TabBar(
                  padding: const EdgeInsets.only(top: 15.0),
                  //isScrollable: true,
                  indicatorColor: Colors.white,
                  indicator: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  ),
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
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 25.0, bottom: 10.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: TabBarView(
                controller: tabController,
                children: [
                  ReporteMensual(),
                  ReporteAnual(),
                ],
              ),
            ),
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
