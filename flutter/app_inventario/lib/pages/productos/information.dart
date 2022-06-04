import 'dart:async';
//import 'dart:ffi';

import 'package:app_inventario/pages/productos/venta/registro.dart';
import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
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
import 'package:animate_do/animate_do.dart';

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
  int banderaRegistro = 0;
  bool visualizar = false;
  late bool _isLoading;

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
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
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
      color: ColorF,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          minWidth: MediaQuery.of(context).size.width / 2,
          onPressed: () {
            (rol == "Administrador")
                ? _navigateToDetalleProducto(
                    context, detalle, widget.producto, banderaRegistro)
                : Fluttertoast.showToast(
                    msg:
                        "No tiene los permisos requeridos\n para realizar esta acción",
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
          },
          child: const Text(
            'Añadir Compra',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SlideInLeft(
          duration: const Duration(seconds: 1),
          child: AppBar(
            elevation: 0,
            title: Text('Información de Producto'),
            centerTitle: true,
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
                        builder: (context) =>
                            ListViewProductos(CategoriaModel())));
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Center(
          child: _isLoading
              ? ListView.separated(
                  itemCount: 1,
                  itemBuilder: (context, index) => const NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                )
              : Container(
                  //height: 700,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Center(
                        child: SlideInRight(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                )),
                            height: 160,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          " ${widget.producto.Nombre}",
                                          style: const TextStyle(
                                              fontSize: 22.0,
                                              color: ColorF,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                icon: const Icon(
                                                  Icons.inventory,
                                                  color: ColorF,
                                                  size: 18,
                                                ),
                                                onPressed: () {}),
                                            Text(
                                              " ${widget.producto.ExistenciasT}",
                                              style: const TextStyle(
                                                  fontSize: 22.0,
                                                  color: ColorF,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                                padding:
                                                    EdgeInsets.only(top: 0),
                                                icon: const Icon(
                                                  Icons.category,
                                                  color: ColorF,
                                                  size: 18,
                                                ),
                                                onPressed: () {}),
                                            Text(
                                              "${widget.producto.categoria['nombre']}",
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                color: ColorF,
                                                //fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "U/Fardos: ${widget.producto.UnidadesFardo}   ",
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: ColorF,
                                            //fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            padding: EdgeInsets.only(top: 0),
                                            icon: const Icon(
                                              Icons.edit,
                                              color: ColorF,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              (rol == "Administrador")
                                                  ? _navigateToProducto(
                                                      context, widget.producto)
                                                  : Fluttertoast.showToast(
                                                      msg:
                                                          "No tiene los permisos requeridos\n para realizar esta acción",
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                            }),
                                        IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: ColorF,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              (rol == "Administrador")
                                                  ? _showDialog(context)
                                                  : Fluttertoast.showToast(
                                                      msg:
                                                          "No tiene los permisos requeridos\n para realizar esta acción",
                                                      backgroundColor:
                                                          Colors.red,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: SlideInLeft(
                          duration: const Duration(seconds: 1),
                          child: Column(
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 10),
                              ),
                              addDetalle,
                            ],
                          ),
                        ),
                      ),
                      //SizedBox(height: 20),
                      /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    editar,
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                    ),
                    eliminar,
                  ],
                ),*/
                      Expanded(
                        child: SlideInRight(
                          duration: const Duration(seconds: 1),
                          child: Center(
                            child: ListView.builder(
                                itemCount:
                                    itemsDetalle.todosdetalleProducto.length,
                                padding: EdgeInsets.only(top: 3.0),
                                itemBuilder: (context, position) {
                                  //callStreamUbicacionEstan();
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(3.0),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 15.0),
                                              ),
                                              Text(
                                                "Existencias: ${itemsDetalle.todosdetalleProducto[position].Existencias}",
                                                style: const TextStyle(
                                                  fontSize: 18.0,
                                                  color: ColorF,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "Tienda: ${itemsDetalle.todosdetalleProducto[position].ExistenciasT}",
                                                        style: const TextStyle(
                                                          fontSize: 18.0,
                                                          color: ColorF,
                                                        ),
                                                      ),
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons.add_circle,
                                                            color: ColorF,
                                                            size: 30,
                                                          ),
                                                          onPressed: () => (rol ==
                                                                  "Administrador")
                                                              ? _navigateToDetalleProducto(
                                                                  context,
                                                                  itemsDetalle
                                                                          .todosdetalleProducto[
                                                                      position],
                                                                  widget
                                                                      .producto,
                                                                  banderaRegistro =
                                                                      1)
                                                              : Fluttertoast.showToast(
                                                                  msg:
                                                                      "No tiene los permisos requeridos\n para realizar esta acción",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0)),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        "Bodega: ${itemsDetalle.todosdetalleProducto[position].ExistenciasB}",
                                                        style: const TextStyle(
                                                          fontSize: 18.0,
                                                          color: ColorF,
                                                        ),
                                                      ),
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons.add_circle,
                                                            color: ColorF,
                                                            size: 30,
                                                          ),
                                                          onPressed: () => (rol ==
                                                                  "Administrador")
                                                              ? _navigateToDetalleProducto(
                                                                  context,
                                                                  itemsDetalle
                                                                          .todosdetalleProducto[
                                                                      position],
                                                                  widget
                                                                      .producto,
                                                                  banderaRegistro =
                                                                      2)
                                                              : Fluttertoast.showToast(
                                                                  msg:
                                                                      "No tiene los permisos requeridos\n para realizar esta acción",
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .arrow_circle_down_sharp,
                                                            color: Colors.red,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {}),
                                                      Text(
                                                        "Costo: ${itemsDetalle.todosdetalleProducto[position].Precio_Costo}",
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons
                                                                .arrow_circle_up_outlined,
                                                            color: Colors.green,
                                                            size: 24,
                                                          ),
                                                          onPressed: () {}),
                                                      Text(
                                                        "Venta: ${itemsDetalle.todosdetalleProducto[position].Precio_Venta}",
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.green),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      icon: const Icon(
                                                        Icons.date_range,
                                                        color: ColorF,
                                                        size: 24,
                                                      ),
                                                      onPressed: () {}),
                                                  Text(
                                                    "${itemsDetalle.todosdetalleProducto[position].Vencimiento}",
                                                    style: const TextStyle(
                                                      fontSize: 18.0,
                                                      color: ColorF,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              /*Divider(),
                                        Text(
                                          "Almacén : ${itemsDetalle.todosdetalleProducto[position].almacen['almacen']}",
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        Divider(),
                                        Text(
                                          "Estanteria : ${itemsDetalle.todosdetalleProducto[position].estanteria['estanteria']}",
                                          style: TextStyle(fontSize: 18.0),
                                        ),*/
                                              //onPressed: () => _deleteProduct(context, items[position],position)),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: ColorF,
                                                      ),
                                                      onPressed: () => (rol ==
                                                              "Administrador")
                                                          ? _navigateToDetalleProducto(
                                                              context,
                                                              itemsDetalle
                                                                      .todosdetalleProducto[
                                                                  position],
                                                              widget.producto,
                                                              banderaRegistro =
                                                                  10)
                                                          : Fluttertoast.showToast(
                                                              msg:
                                                                  "No tiene los permisos requeridos\n para realizar esta acción",
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0)),
                                                  IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .add_shopping_cart_sharp,
                                                        color: ColorF,
                                                      ),
                                                      onPressed: () => (rol ==
                                                              "Administrador")
                                                          ? _navigateToVenta(
                                                              context,
                                                              itemsDetalle
                                                                      .todosdetalleProducto[
                                                                  position],
                                                              widget.producto)
                                                          : Fluttertoast.showToast(
                                                              msg:
                                                                  "No tiene los permisos requeridos\n para realizar esta acción",
                                                              backgroundColor:
                                                                  Colors.red,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0)),
                                                ],
                                              ),

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
                      ),
                    ],
                  ),
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
      DetalleProductoModel detalle, ProductoModel producto, int valor) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationDetalleProducto(detalle, producto, valor)),
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
        MaterialPageRoute(
            builder: (context) => ListViewProductos(CategoriaModel())),
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

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Skeleton(height: 120, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 50, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 150, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 150, width: 315),
      ],
    );
  }
}
