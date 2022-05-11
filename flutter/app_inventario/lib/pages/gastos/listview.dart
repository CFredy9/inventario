import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import 'information.dart';
//import 'package:crud_firebase/ui/product_information.dart';
import '../../models/gastos.dart';
import '../../api/gastos.dart';
import 'package:animate_do/animate_do.dart';

class ListViewGastos extends StatefulWidget {
  @override
  _ListViewGastosState createState() => _ListViewGastosState();
}

class _ListViewGastosState extends State<ListViewGastos> {
  List<GastoModel> items = <GastoModel>[];
  GastosProvider gastoT = GastosProvider();
  @override
  void initState() {
    super.initState();
    items = <GastoModel>[];
    print(items);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    gastoT = Provider.of<GastosProvider>(context);
    print(gastoT.todosGasto.length);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorF,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: SlideInDown(
            duration: const Duration(seconds: 1),
            child: AppBar(
              elevation: 0,
              title: const Text('GASTOS'),
              centerTitle: true,
              backgroundColor: ColorF,
              /*flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.green],
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
            child: SlideInUp(
              duration: const Duration(seconds: 1),
              child: ListView.builder(
                  itemCount: gastoT.todosGasto.length,
                  padding: EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
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
                                          '${gastoT.todosGasto[position].descripcion}',
                                          style: const TextStyle(
                                            color: ColorF,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                      ),
                                      onTap: () => _navigateToGastoInformation(
                                          context,
                                          gastoT.todosGasto[position])),
                                ),
                                //onPressed: () => _deleteProduct(context, items[position],position)),
                                IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: ColorF,
                                    ),
                                    onPressed: () => (rol == "Administrador")
                                        ? _navigateToGasto(context,
                                            gastoT.todosGasto[position])
                                        : Fluttertoast.showToast(
                                            msg:
                                                "No tiene los permisos requeridos\n para realizar esta acción",
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0)),
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
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, GastoModel gasto, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Esta seguro de querer eliminar este gasto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () => _delete(
                context,
                gasto,
                position,
              ),
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToGasto(BuildContext context, GastoModel gasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationGasto(gasto)),
    );
  }

  void _navigateToGastoInformation(
      BuildContext context, GastoModel gasto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GastoInformation(gasto)),
    );
  }

  void _createNewGasto(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationGasto(GastoModel())),
    );
  }

  void _delete(BuildContext context, GastoModel gasto, int position) async {
    gastoT.delete(gasto);
    setState(() {
      Navigator.of(context).pop();
    });
  }
}
