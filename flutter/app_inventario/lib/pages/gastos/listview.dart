import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import 'information.dart';
//import 'package:crud_firebase/ui/product_information.dart';
import '../../models/gastos.dart';
import '../../api/gastos.dart';

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
        appBar: AppBar(
          title: Text('GASTOS'),
          centerTitle: true,
          //backgroundColor: Colors.blueAccent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.green],
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
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: gastoT.todosGasto.length,
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
                                    '${gastoT.todosGasto[position].descripcion}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToGastoInformation(
                                      context, gastoT.todosGasto[position])),
                            ),
                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToGasto(
                                    context, gastoT.todosGasto[position])),
                          ],
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ],
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blueAccent,
          onPressed: () => _createNewGasto(context),
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
