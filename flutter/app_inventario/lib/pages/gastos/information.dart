import 'package:app_inventario/pages/gastos/listview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../constants.dart';
import '/models/gastos.dart';
import '/models/detalle_gastos.dart';
import '../../api/detalle_gastos.dart';
import './detallegastos/registro.dart';
import 'package:animate_do/animate_do.dart';

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
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SlideInLeft(
          duration: const Duration(seconds: 1),
          child: AppBar(
            elevation: 0,
            title: Text('${widget.gasto.descripcion}'),
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
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // passing this to our root
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListViewGastos()));
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
          child: SlideInRight(
            duration: const Duration(seconds: 1),
            child: Container(
              //height: 250,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(50),
                          )),
                      height: 80,
                      padding: const EdgeInsets.all(5.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0),
                              ),
                              Text(
                                'Total: Q.${detallegastoT.total['total']}',
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.blue),
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
                                Container(
                                  height: 60,
                                  padding: new EdgeInsets.all(0.0),
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
                                                '${detallegastoT.todosDetalleGasto[position].cantidad}',
                                                style: const TextStyle(
                                                  color: ColorF,
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                            ),
                                            onTap: () => (rol == "Administrador")
                                                ? _navigateUpdateGasto(
                                                    context,
                                                    detallegastoT
                                                            .todosDetalleGasto[
                                                        position])
                                                : Fluttertoast.showToast(
                                                    msg:
                                                        "No tiene los permisos requeridos\n para realizar esta acción",
                                                    backgroundColor: Colors.red,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0),
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorF,
        onPressed: () => (rol == "Administrador")
            ? _createNewGasto(context)
            : Fluttertoast.showToast(
                msg:
                    "No tiene los permisos requeridos\n para realizar esta acción",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0),
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
