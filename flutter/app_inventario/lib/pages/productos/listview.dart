import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import 'information.dart';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../../api/producto.dart';

class ListViewProductos extends StatefulWidget {
  @override
  _ListViewProductosState createState() => _ListViewProductosState();
}

class _ListViewProductosState extends State<ListViewProductos> {
  List<ProductoModel> items = <ProductoModel>[];
  ProductoProvider productoT = ProductoProvider();
  @override
  void initState() {
    super.initState();
    items = <ProductoModel>[];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ProductoProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('PRODUCTOS'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
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
              itemCount: productoT.todosProducto.length,
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
                                    '${productoT.todosProducto[position].Nombre}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Existencias: ' +
                                        '${(productoT.todosProducto[position].ExistenciasT == null) ? productoT.todosProducto[position].existenciasT = 0 : productoT.todosProducto[position].existenciasT}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToProductoInformation(
                                      context,
                                      productoT.todosProducto[position])),
                            ),
                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            /*IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToProducto(
                                    context, items[position])),*/
                            /*IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(context, position),
                            ),*/
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
          onPressed: () => _createNewProducto(context),
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  /*void _showDialog(context, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Esta seguro de querer eliminar el producto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () => _delete(
                context,
                items[position],
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
  } */

  /*void _navigateToProducto(BuildContext context, ProductoModel producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationProducto(producto)),
    );
  } */

  void _navigateToProductoInformation(
    BuildContext context,
    ProductoModel producto,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductoInformation(producto)),
    );
  }

  void _createNewProducto(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationProducto(ProductoModel())),
    );
  }

  /*void _delete(
      BuildContext context, ProductoModel producto, int position) async {
    final _auth = FirebaseAuth.instance;
    //await _auth.currentUser.delete(id)
    await productoReferencia.child(producto.id.toString()).remove().then((_) {
      setState(() {
        items.removeAt(position);
        Navigator.of(context).pop();
      });
    });
  } */
}
