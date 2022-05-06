import 'package:app_inventario/pages/credito/detallecredito/registro.dart';
import 'package:app_inventario/pages/credito/abonocredito/registro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../constants.dart';
import './listview.dart';
import '/models/credito.dart';
import '/models/detalle_credito.dart';
import '/models/abono_credito.dart';
import '../../api/detalle_credito.dart';
import '../../api/abono_credito.dart';
import '../../api/credito.dart';
//import './detallegastos/registro.dart';
import 'package:animate_do/animate_do.dart';
import 'package:unicorndial/unicorndial.dart';

class CreditoInformation extends StatefulWidget {
  final CreditoModel credito;
  CreditoInformation(this.credito);
  @override
  _CreditoInformationState createState() => _CreditoInformationState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _CreditoInformationState extends State<CreditoInformation> {
  DetalleCreditoProvider detallecreditoT = DetalleCreditoProvider();
  AbonoCreditoProvider abonocreditoT = AbonoCreditoProvider();
  CreditoProvider creditoT = CreditoProvider();
  bool bandera = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    detallecreditoT = Provider.of<DetalleCreditoProvider>(context);
    abonocreditoT = Provider.of<AbonoCreditoProvider>(context);
    //creditoT = Provider.of<CreditoProvider>(context);
    if (bandera == false) {
      detallecreditoT.getDetalleCredito(widget.credito.Id.toString());
      abonocreditoT.getAbonoCredito(widget.credito.Id.toString());
      //creditoT.getCredito();
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
              title: Text('${widget.credito.nombreCredito}'),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListViewCredito()));
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
                                  'Total: Q.${widget.credito.total}',
                                  style: TextStyle(
                                      fontSize: 22.0, color: Colors.blue),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 60,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.monetization_on,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                          onPressed: () {}),
                                      const Text(
                                        'Crédito',
                                        style: TextStyle(
                                            fontSize: 18.0, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 60,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 0.0),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(
                                            Icons.monetization_on,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                          onPressed: () {}),
                                      const Text(
                                        'Abonos',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: ListView.builder(
                              itemCount:
                                  detallecreditoT.todosDetalleCredito.length,
                              padding: EdgeInsets.only(top: 1.0),
                              itemBuilder: (context, position) {
                                return Column(
                                  children: <Widget>[
                                    /*Divider(
                                height: 1.0,
                              ),*/
                                    Container(
                                      padding: new EdgeInsets.all(1.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  '${detallecreditoT.todosDetalleCredito[position].cantidad}',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _navigateUpdateDetalleCredito(
                                                        context,
                                                        detallecreditoT
                                                                .todosDetalleCredito[
                                                            position]),
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
                        //Divider(),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: ListView.builder(
                              itemCount: abonocreditoT.todosAbonoCredito.length,
                              padding: EdgeInsets.only(top: 1.0),
                              itemBuilder: (context, position) {
                                return Column(
                                  children: <Widget>[
                                    /*Divider(
                                height: 1.0,
                              ),*/
                                    Container(
                                      padding: new EdgeInsets.all(1.0),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: ListTile(
                                                title: Text(
                                                  '${abonocreditoT.todosAbonoCredito[position].cantidad}',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18.0,
                                                  ),
                                                ),
                                                onTap: () =>
                                                    _navigateUpdateAbonoCredito(
                                                        context,
                                                        abonocreditoT
                                                                .todosAbonoCredito[
                                                            position]),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: UnicornDialer(
          parentButtonBackground: ColorF,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.add),
          childButtons: _getProfileMenu(),
        )
        /*FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: ColorF,
        onPressed: () => _createNewGasto(context),
      ),*/
        );
  }

  void _createNewGasto(BuildContext context) async {
    /*await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationDetalleGasto(DetalleGastoModel(), widget.credito)),
    );*/
  }

  void _navigateUpdateDetalleCredito(
      BuildContext context, DetalleCreditoModel detallecredito) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationDetalleCredito(detallecredito, widget.credito)),
    );
  }

  void _navigateUpdateAbonoCredito(
      BuildContext context, AbonoCreditoModel abonocredito) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationAbonoCredito(abonocredito, widget.credito)),
    );
  }

  List<UnicornButton> _getProfileMenu() {
    List<UnicornButton> children = [];

    // Add Children here
    children.add(UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.red,
      mini: true,
      child: Icon(Icons.monetization_on),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationDetalleCredito(
                  DetalleCreditoModel(), widget.credito)),
        );
      },
    )));
    children.add(UnicornButton(
        currentButton: FloatingActionButton(
      backgroundColor: Colors.green,
      mini: true,
      child: Icon(Icons.monetization_on),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => RegistrationAbonoCredito(
                  AbonoCreditoModel(), widget.credito)),
        );
      },
    )));

    return children;
  }
}
