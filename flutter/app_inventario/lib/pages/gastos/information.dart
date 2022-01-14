import 'package:app_inventario/pages/gastos/listview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
import '/models/gastos.dart';
import '/models/detalle_gastos.dart';
import '../../api/detalle_gastos.dart';
import './detallegastos/registro.dart';

class GastoInformation extends StatefulWidget {
  final GastoModel gasto;
  GastoInformation(this.gasto);
  @override
  _GastoInformationState createState() => _GastoInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _GastoInformationState extends State<GastoInformation> {
  DetalleGastosProvider detallegastoT = DetalleGastosProvider();
  bool bandera = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    detallegastoT = Provider.of<DetalleGastosProvider>(context);
    if (bandera == false) {
      detallegastoT.getDetalleGasto(widget.gasto.Id.toString());
      detallegastoT.getTotales(widget.gasto.Id.toString());
      bandera = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gasto.descripcion}'),
        //backgroundColor: Colors.blueAccent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
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
                MaterialPageRoute(builder: (context) => ListViewGastos()));
          },
        ),
      ),
      body: Center(
        child: Container(
          //height: 250,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Center(
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(top: 10.0),
                          ),
                          Text(
                            'Total: Q.${detallegastoT.total['total']}',
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                      itemCount: detallegastoT.todosDetalleGasto.length,
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
                                          '${detallegastoT.todosDetalleGasto[position].cantidad}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                        onTap: () => _navigateUpdateGasto(
                                            context,
                                            detallegastoT
                                                .todosDetalleGasto[position]),
                                      ),
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
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () => _createNewGasto(context),
      ),
    );
  }

  void _createNewGasto(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationDetalleGasto(DetalleGastoModel(), widget.gasto)),
    );
  }

  void _navigateUpdateGasto(
      BuildContext context, DetalleGastoModel detallegasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationDetalleGasto(detallegasto, widget.gasto)),
    );
  }
}
