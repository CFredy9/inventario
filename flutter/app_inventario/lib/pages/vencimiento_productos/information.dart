import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../constants.dart';
import '/models/detalle_producto.dart';

class VencimientoProductoInformation extends StatefulWidget {
  final DetalleProductoModel vencimientoproducto;
  VencimientoProductoInformation(this.vencimientoproducto);
  @override
  _VencimientoProductoInformationState createState() =>
      _VencimientoProductoInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _VencimientoProductoInformationState
    extends State<VencimientoProductoInformation> {
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
          title: Text('Detalle'),
          backgroundColor: ColorF,
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
            height: 200,
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
                        "Producto : ${widget.vencimientoproducto.producto['nombre']}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Fardos : ${widget.vencimientoproducto.Existencias}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25.0),
                      ),
                      Text(
                        "Vencimiento : ${widget.vencimientoproducto.Vencimiento}",
                        style: TextStyle(fontSize: 18.0),
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
