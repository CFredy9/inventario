import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '/models/venta.dart';

class VentaInformation extends StatefulWidget {
  final VentaModel venta;
  VentaInformation(this.venta);
  @override
  _VentaInformationState createState() => _VentaInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _VentaInformationState extends State<VentaInformation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información de Venta'),
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
                    "Producto : ${widget.venta.detalleproducto['producto']['nombre']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Precio Costo: ${widget.venta.detalleproducto['precio_costo']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Precio Venta: ${widget.venta.detalleproducto['precio_venta']}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Fardos : ${widget.venta.fardos}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Total Costo: ${widget.venta.total_costo}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Total Venta: ${widget.venta.total_venta}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Ganancia: ${widget.venta.ganancia}",
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
