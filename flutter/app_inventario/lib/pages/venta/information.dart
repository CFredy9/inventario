import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../constants.dart';
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
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          title: Text('Información de Venta'),
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
          child: Container(
            height: 390,
            //padding: const EdgeInsets.all(25.0),
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
                        "Producto : ${widget.venta.detalleproducto['producto']['nombre']}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Precio Costo: ${widget.venta.detalleproducto['precio_costo']}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Precio Venta: ${widget.venta.detalleproducto['precio_venta']}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Fardos : ${widget.venta.fardos}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Total Costo: ${widget.venta.total_costo}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Total Venta: ${widget.venta.total_venta}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Ganancia: ${widget.venta.ganancia}",
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
    );
  }
}
