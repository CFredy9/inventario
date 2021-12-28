import 'dart:async';
import 'dart:ffi';

import 'package:app_inventario/pages/productos/venta/registro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../models/detalle_producto.dart';
import '../../api/producto.dart';
import '../../api/detalle_producto.dart';
import 'registro.dart';
import 'listview.dart';
import 'detalle/registro.dart';

class ProductoInformation extends StatefulWidget {
  final ProductoModel producto;
  //final CategoriaModel __cateModel;
  //final UbicacionModel __ubiModel;
  //final EstanteriaModel __estanteriaModel;
  ProductoInformation(this.producto);
  @override
  _ProductoInformationState createState() => _ProductoInformationState();
}

//final productoReferencia =
//    FirebaseDatabase.instance.reference().child('Producto');
//final cateReferencia = FirebaseDatabase.instance.reference().child('Categoria');
//final ubiReferencia = FirebaseDatabase.instance.reference().child('Ubicacion');

class _ProductoInformationState extends State<ProductoInformation> {
  int? existenciasT = 0;
  CategoriaModel categoria = CategoriaModel();
  ProductoModel productos = ProductoModel();
  DetalleProductoModel detalle = DetalleProductoModel();
  //List<DetalleProductoModel> itemsDetalle = <DetalleProductoModel>[];

  ProductoProvider productoT = ProductoProvider();
  DetalleProductoProvider itemsDetalle = DetalleProductoProvider();

  bool bandera = false;

  /*void detalleproductoAdded(Event event) {
    setState(() {
      items.add(DetalleProductoModel.fromSnapShot(event.snapshot));
    });
    existenciasT = 0;
    for (var i = 0; i < items.length; i++) {
      existenciasT = items[i].Existencias! + existenciasT!;
    }
  } */

  @override
  void initState() {
    super.initState();
    print(bandera);
    print(widget.producto.Id.toString());
    bandera = false;

    //callStreamUbicacion();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ProductoProvider>(context);
    itemsDetalle = Provider.of<DetalleProductoProvider>(context);
    if (bandera == false) {
      itemsDetalle.getdetalleProducto(widget.producto.Id.toString());
      bandera = true;
    }
    //crear button
    final editar = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 3,
          onPressed: () {
            _navigateToProducto(context, widget.producto);
            print(widget.producto.Id);
          },
          child: const Text(
            'Editar',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //crear button
    final eliminar = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 3,
          onPressed: () {
            _showDialog(context);
          },
          child: const Text(
            'Eliminar',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //crear button
    final addDetalle = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.greenAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 2,
          onPressed: () {
            _navigateToDetalleProducto(context, detalle, widget.producto);
          },
          child: const Text(
            'Añadir Detalle',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Información de Producto'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListViewProductos()));
          },
        ),
      ),
      body: Center(
        child: Container(
          //height: 700,
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Text(
                        "Nombre : ${widget.producto.Nombre}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Divider(),
                      Text(
                        "Unidades Fardo : ${widget.producto.UnidadesFardo}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(),
                      Text(
                        "Total Existencias : ${widget.producto.ExistenciasT}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(),
                      Text(
                        "Categoria : ${widget.producto.categoria['nombre']}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Divider(),
                      addDetalle,
                      /*Text(
                            "Almacen : ${ubicacion.Almacen}",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Divider(),
                          Text(
                            "Estanteria : ${estanteria.Ubicacion_Estanteria}",
                            style: TextStyle(fontSize: 18.0),
                          ),*/
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  editar,
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  eliminar,
                ],
              ),
              Expanded(
                child: Center(
                  child: ListView.builder(
                      itemCount: itemsDetalle.todosdetalleProducto.length,
                      padding: EdgeInsets.only(top: 3.0),
                      itemBuilder: (context, position) {
                        //callStreamUbicacionEstan();
                        return Column(
                          children: <Widget>[
                            Divider(
                              height: 1.0,
                            ),
                            Container(
                              padding: EdgeInsets.all(3.0),
                              child: Card(
                                child: Column(
                                  children: <Widget>[
                                    const Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                    ),
                                    Text(
                                      "EXISTENCIAS : ${itemsDetalle.todosdetalleProducto[position].Existencias}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    Text(
                                      "Precio Costo : ${itemsDetalle.todosdetalleProducto[position].Precio_Costo}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    Text(
                                      "Precio Venta : ${itemsDetalle.todosdetalleProducto[position].Precio_Venta}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    Text(
                                      "Vencimiento : ${itemsDetalle.todosdetalleProducto[position].Vencimiento}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    Text(
                                      "Almacén : ${itemsDetalle.todosdetalleProducto[position].almacen['almacen']}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    Text(
                                      "Estanteria : ${itemsDetalle.todosdetalleProducto[position].estanteria['estanteria']}",
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    Divider(),
                                    //onPressed: () => _deleteProduct(context, items[position],position)),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () =>
                                            _navigateToDetalleProducto(
                                                context,
                                                itemsDetalle
                                                        .todosdetalleProducto[
                                                    position],
                                                widget.producto)),
                                    IconButton(
                                        icon: const Icon(
                                          Icons.add_shopping_cart_sharp,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () => _navigateToVenta(
                                            context,
                                            itemsDetalle
                                                .todosdetalleProducto[position],
                                            widget.producto)),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProducto(BuildContext context, ProductoModel producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationProducto(producto)),
    );
  }

  void _navigateToDetalleProducto(BuildContext context,
      DetalleProductoModel detalle, ProductoModel producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationDetalleProducto(detalle, producto)),
    );
  }

  void _navigateToVenta(BuildContext context, DetalleProductoModel detalle,
      ProductoModel producto) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationVenta(detalle, producto)),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Esta seguro de querer eliminar el producto?'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => _delete(
                context,
                widget.producto,
              ),
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete(BuildContext context, ProductoModel producto) async {
    productoT.delete(producto);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListViewProductos()),
      );
    });
    /*await productoReferencia.child(producto.id.toString()).remove().then((_) {
      setState(() {
        //items.removeAt(position);
        //Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListViewProductos()),
        );
      });
    });*/
  }
}
