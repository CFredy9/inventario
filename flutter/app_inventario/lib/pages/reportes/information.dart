import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../constants.dart';
import '/models/producto.dart';
import 'package:animate_do/animate_do.dart';

class VentaProductoInformation extends StatefulWidget {
  final ProductoModel ventaproducto;
  VentaProductoInformation(this.ventaproducto);
  @override
  _VentaProductoInformationState createState() =>
      _VentaProductoInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _VentaProductoInformationState extends State<VentaProductoInformation> {
  @override
  void initState() {
    super.initState();
    if (widget.ventaproducto.ExistenciasT == null) {
      widget.ventaproducto.existenciasT = 0;
    }
    if (widget.ventaproducto.Total_Costo == null) {
      widget.ventaproducto.total_costo = '0';
    }
    if (widget.ventaproducto.Total_Venta == null) {
      widget.ventaproducto.total_venta = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SlideInLeft(
          duration: const Duration(seconds: 1),
          child: AppBar(
            elevation: 0,
            title: Text('Detalle'),
            backgroundColor: ColorF,
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
          child: SlideInRight(
            duration: const Duration(seconds: 1),
            child: Container(
              height: 300,
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 25.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: ColorF,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    )),
                padding: new EdgeInsets.all(3.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                        Text(
                          "Producto : ${widget.ventaproducto.nombre}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                        Text(
                          "Fardos : ${widget.ventaproducto.existenciasT}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                        Text(
                          "Total Costo: Q.${widget.ventaproducto.total_costo}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                        Text(
                          "Total Venta: Q.${widget.ventaproducto.total_venta}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                        Text(
                          "Ganancia: Q.${widget.ventaproducto.ganancia}",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 25.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
