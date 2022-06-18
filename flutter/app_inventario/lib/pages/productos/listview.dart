import 'package:app_inventario/widgets/search.dart';
import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import 'information.dart';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../../api/producto.dart';
import 'package:animate_do/animate_do.dart';

class ListViewProductos extends StatefulWidget {
  final CategoriaModel filterCategoria;
  ListViewProductos(this.filterCategoria);
  @override
  _ListViewProductosState createState() => _ListViewProductosState();
}

class _ListViewProductosState extends State<ListViewProductos> {
  List<ProductoModel> items = <ProductoModel>[];
  ProductoProvider productoT = ProductoProvider();
  String searchB = '';
  String orderB = '';
  int orderBNumber = 2;
  bool bandera = false;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
    items = <ProductoModel>[];
    bandera = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productoT = Provider.of<ProductoProvider>(context);

    final Buscador = Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: "Buscar",
          //icon: SvgPicture.asset("assets/icons/search.svg"),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (widget.filterCategoria.Id != null) {
            productoT.searchProducto(
                widget.filterCategoria.Id.toString(), value, '');
            searchB = value;
          } else {
            productoT.searchProducto('', value, '');
            searchB = value;
          }
        },
      ),
    );

    print('Prueba para ver que lleva');
    print(widget.filterCategoria.Id);
    if (widget.filterCategoria.Id != null && bandera == false) {
      bP = false;
      productoT.getProducto(widget.filterCategoria.Id.toString());
      bandera = true;
    } else if (widget.filterCategoria.Id == null && bandera == false) {
      productoT.getProducto('');
      bandera = true;
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorF,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: SlideInLeft(
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                AppBar(
                  elevation: 0,
                  title: const Text('PRODUCTOS'),
                  centerTitle: true,
                  backgroundColor: ColorF,
                  /*: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.deepPurple],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ),*/
                  leading: IconButton(
                    icon: const Icon(Icons.home, color: Colors.white),
                    onPressed: () {
                      // passing this to our root
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        //child: SearchBar()),
                        child: Buscador),
                    IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          if (orderBNumber == 1) {
                            orderB = 'nombre';
                            orderBNumber = 2;
                          } else if (orderBNumber == 2) {
                            orderB = '-nombre';
                            orderBNumber = 1;
                          }

                          if (widget.filterCategoria.Id != null) {
                            productoT.searchProducto(
                                widget.filterCategoria.Id.toString(),
                                searchB,
                                orderB);
                          } else {
                            productoT.searchProducto('', searchB, orderB);
                          }
                        }),
                    /*IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          if (widget.filterCategoria.Id != null) {
                            productoT.searchProducto(
                                widget.filterCategoria.Id.toString(),
                                searchB,
                                '-nombre');
                          } else {
                            productoT.searchProducto('', searchB, '-nombre');
                          }
                        }),*/
                  ],
                ),
              ],
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
            child: _isLoading
                ? /*ListView.builder(
                    itemCount: 10,
                    padding: const EdgeInsets.only(top: 10.0),
                    itemBuilder: (context, index) => const NewsCardSkelton(),
                    
                  )*/
                //Expanded(
                //child:
                ListView.separated(
                    itemCount: 10,
                    itemBuilder: (context, index) => const NewsCardSkelton(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: defaultPadding),
                  )
                //)
                //const Text("Cargando Datos")
                : SlideInRight(
                    duration: const Duration(seconds: 1),
                    child: ListView.builder(
                        itemCount: productoT.todosProducto.length,
                        padding: EdgeInsets.only(top: 3.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              /*Divider(
                          height: 1.0,
                        ),*/
                              Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    )),
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
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${productoT.todosProducto[position].Nombre}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                          icon: const Icon(
                                                            Icons.inventory,
                                                            color: ColorF,
                                                            size: 16,
                                                          ),
                                                          onPressed: () {}),
                                                      Text(
                                                        '${(productoT.todosProducto[position].ExistenciasT == null) ? productoT.todosProducto[position].existenciasT = 0 : productoT.todosProducto[position].existenciasT}',
                                                        style: TextStyle(
                                                          color: ColorF,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () =>
                                                _navigateToProductoInformation(
                                                    context,
                                                    productoT.todosProducto[
                                                        position])),
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: ColorF,
          onPressed: () => (rol == "Administrador")
              ? _createNewProducto(context)
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
      MaterialPageRoute(
          builder: (context) =>
              ProductoInformation(producto, widget.filterCategoria)),
    );
  }

  void _createNewProducto(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationProducto(ProductoModel(), widget.filterCategoria)),
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

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Skeleton(height: 40, width: size.width * 0.85),
        //const SizedBox(width: defaultPadding),
      ],
    );
  }
}
