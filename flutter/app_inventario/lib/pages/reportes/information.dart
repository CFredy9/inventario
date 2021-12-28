import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '/models/producto.dart';

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
      appBar: AppBar(
        title: Text('Reportes'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          height: 450,
          padding: const EdgeInsets.all(25.0),
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Text(
                    "Producto : ${widget.ventaproducto.nombre}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Fardos : ${widget.ventaproducto.existenciasT}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Total Costo: Q.${widget.ventaproducto.total_costo}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Total Venta: Q.${widget.ventaproducto.total_venta}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Ganancia: Q.${widget.ventaproducto.ganancia}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
