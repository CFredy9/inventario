import 'dart:async';
import 'package:app_inventario/api/producto.dart';
import 'package:app_inventario/api/venta.dart';
import 'package:app_inventario/models/venta.dart';
import 'package:provider/provider.dart';
import '../information.dart';
import '../../../models/producto.dart';
import '../../../models/categoria.dart';
import '../../../models/ubicacion.dart';
import '../../../models/estanteria.dart';
import '../../../models/detalle_producto.dart';
import '../../../api/detalle_producto.dart';
import '../../../api/ubicacion.dart';
import '../../../api/estanteria.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationVenta extends StatefulWidget {
  final DetalleProductoModel _detalleproductoModel;
  final ProductoModel __productModel;
  RegistrationVenta(this._detalleproductoModel, this.__productModel);
  @override
  _RegistrationVentaState createState() => _RegistrationVentaState();
}

class _RegistrationVentaState extends State<RegistrationVenta> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController existenciasController = TextEditingController();
  int contador = 0;
  bool control = false;

  List<CategoriaModel> items = <CategoriaModel>[];
  //List<UbicacionModel> items2 = <UbicacionModel>[];
  //List<EstanteriaModel> items3 = <EstanteriaModel>[];

  UbicacionProvider items2 = UbicacionProvider();
  EstanteriaProvider items3 = EstanteriaProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*if (widget.productoModel.Precio_Costo == null) {
      precio_c = "0";
      widget.productoModel.Precio_Costo = "0";
    }*/
    items = <CategoriaModel>[];
    //items2 = <UbicacionModel>[];
    //items3 = <EstanteriaModel>[];

    if (widget._detalleproductoModel.Id != null) {
      existenciasController = TextEditingController(text: contador.toString());
      //contador = widget._detalleproductoModel.Existencias!.toInt();

      //control = true;
    } else {
      print(widget._detalleproductoModel.Id);
      existenciasController = TextEditingController(text: contador.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    items2 = Provider.of<UbicacionProvider>(context);
    items3 = Provider.of<EstanteriaProvider>(context);

    //Campo Existencias
    final existenciasField = Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (contador > 0) {
                      contador--;
                      existenciasController =
                          TextEditingController(text: contador.toString());
                    }
                  });
                },
                child: Icon(Icons.remove, color: Colors.black),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    primary: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    )),
              ),
            ),
            Expanded(
                child: TextFormField(
              controller: existenciasController,
              enabled: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 39.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            )),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (contador <
                        widget._detalleproductoModel.existencias!.toInt())
                      contador++;
                    existenciasController =
                        TextEditingController(text: contador.toString());
                  });
                },
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    primary: Colors.white,
                    side: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    )),
              ),
            ),
          ],
        ));

    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            onAdd();
          },
          child: (widget._detalleproductoModel.Id != null)
              ? const Text(
                  'Actualizar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Registrar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            if (widget._detalleproductoModel.Id != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductoInformation(widget.__productModel)));
            } else {
              // passing this to our root
              Navigator.of(context).pop();
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 20),
                    //nombreField,
                    SizedBox(height: 20),
                    existenciasField,
                    SizedBox(height: 20),
                    registrarButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onAdd() async {
    double total_costo = double.parse(existenciasController.text) *
        double.parse(widget._detalleproductoModel.precio_costo!);

    double total_venta = double.parse(existenciasController.text) *
        double.parse(widget._detalleproductoModel.precio_venta!);

    double ganancia = total_venta - total_costo;

    if (existenciasController.text.isNotEmpty) {
      VentaModel venta = VentaModel(
          detalleproducto: widget._detalleproductoModel.Id,
          fardos: int.parse(existenciasController.text),
          total_costo: total_costo.toString(),
          total_venta: total_venta.toString(),
          ganancia: ganancia.toString());
      bool istoken = await Provider.of<VentaProvider>(context, listen: false)
          .addVenta(venta);
      if (istoken) {
        Provider.of<DetalleProductoProvider>(context, listen: false)
            .getdetalleProducto(widget.__productModel.Id.toString());
        Provider.of<ProductoProvider>(context, listen: false).getProducto();
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! -
                int.parse(existenciasController.text);
        Fluttertoast.showToast(msg: "Venta creada exitosamente :) ");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) =>
                    ProductoInformation(widget.__productModel)),
            (route) => false);
      }
    }
  }
}
