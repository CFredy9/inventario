import 'package:app_inventario/api/venta.dart';
import 'package:app_inventario/pages/home/home_screen.dart';
import 'package:app_inventario/pages/venta/information.dart';
import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../../models/venta.dart';
import '../../../models/producto.dart';
import '../../constants.dart';
import 'package:animate_do/animate_do.dart';

class ListViewVenta extends StatefulWidget {
  @override
  _ListViewVentaState createState() => _ListViewVentaState();
}

class _ListViewVentaState extends State<ListViewVenta> {
  List<VentaModel> items = <VentaModel>[];
  var items2;
  VentaProvider ventaT = VentaProvider();
  String? valores;
  bool bandera = false;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    items = <VentaModel>[];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ventaT = Provider.of<VentaProvider>(context);
    if (bandera == false || ventaT.todosVenta.isEmpty) {
      ventaT.getVenta();
      bandera = true;
    }
    //items2 = Provider.of<EstanteriaProvider>(context).getEstanteria(widget._ubicacionModel.Id.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorF,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: SlideInLeft(
            duration: const Duration(seconds: 1),
            child: AppBar(
              elevation: 0,
              title: const Text('Ventas'),
              centerTitle: true,
              backgroundColor: ColorF,
              /*flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.deepPurple],
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
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Center(
            child: _isLoading
                ? ListView.separated(
                    itemCount: 10,
                    itemBuilder: (context, index) => const NewsCardSkelton(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: defaultPadding),
                  )
                : SlideInRight(
                    duration: const Duration(seconds: 1),
                    child: ListView.builder(
                        itemCount: ventaT.todosVenta.length,
                        padding: EdgeInsets.only(top: 3.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              /*Divider(
                          height: 1.0,
                        ),*/
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
                                              child: Text(
                                                '${ventaT.todosVenta[position].detalleproducto['producto']['nombre']}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 21.0,
                                                ),
                                              ),
                                            ),
                                            /*subtitle: Text(
                                        'Q.${ventaT.todosVenta[position].total}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 21.0,
                                        ),
                                      ),*/
                                            onTap: () => _navigateToVenta(
                                                context,
                                                ventaT.todosVenta[position])),
                                      ),
                                      Text(
                                        'Q.${ventaT.todosVenta[position].ganancia} ',
                                        style: TextStyle(
                                          color: ColorF,
                                          fontSize: 21.0,
                                        ),
                                      ),
                                      //onPressed: () => _deleteProduct(context, items[position],position)),
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
        ),
      ),
    );
  }

  void _navigateToVenta(BuildContext context, VentaModel venta) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VentaInformation(venta)),
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Skeleton(height: 40, width: 300),
        //const SizedBox(width: defaultPadding),
      ],
    );
  }
}
