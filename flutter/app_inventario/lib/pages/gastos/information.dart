import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart';
import '/models/gastos.dart';

class GastoInformation extends StatefulWidget {
  final GastoModel gasto;
  GastoInformation(this.gasto);
  @override
  _GastoInformationState createState() => _GastoInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _GastoInformationState extends State<GastoInformation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información Gasto'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Container(
          height: 250,
          padding: const EdgeInsets.all(25.0),
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Text(
                    "Cantidad : ${widget.gasto.cantidad}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Descripcion : ${widget.gasto.descripcion}",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                  ),
                  Divider(),
                  Text(
                    "Fecha : ${widget.gasto.fecha}",
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
