import 'dart:async';
import 'package:app_inventario/api/producto.dart';
import 'package:app_inventario/api/venta.dart';
import 'package:app_inventario/models/venta.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../information.dart';
import '../../../models/producto.dart';
import '../../../models/categoria.dart';
import '../../../models/detalle_producto.dart';
import '../../../api/detalle_producto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationVenta extends StatefulWidget {
  final DetalleProductoModel _detalleproductoModel;
  final ProductoModel __productModel;
  final CategoriaModel cateFilterRV;
  RegistrationVenta(
      this._detalleproductoModel, this.__productModel, this.cateFilterRV);
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
    //Campo Existencias
    final existenciasField = Container(
        color: PrimaryLightColor,
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
                  primary: PrimaryLightColor,
                  /*side: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    )*/
                ),
              ),
            ),
            Expanded(
                child: TextFormField(
              controller: existenciasController,
              enabled: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 39.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (contador <
                        widget._detalleproductoModel.existenciasT!.toInt())
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
                  primary: PrimaryLightColor,
                  /*side: BorderSide(
                      width: 1.0,
                      color: Colors.grey,
                    )*/
                ),
              ),
            ),
          ],
        ));

    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            print("Aqui entra?");
            onAdd();
          },
          child: (widget._detalleproductoModel.Id != null)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {}),
                    const Text(
                      'Vender',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
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
      ),*/
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: size.height * 0.20),
                  IconButton(
                    icon: Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                    onPressed: () {
                      if (widget._detalleproductoModel.Id != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductoInformation(
                                    widget.__productModel,
                                    widget.cateFilterRV)));
                      } else {
                        // passing this to our root
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.07),
              const Text(
                'VENTA',
                style: TextStyle(
                    fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.07),
              const Text(
                'Existencias',
                style: TextStyle(fontSize: 14, color: ColorF),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: existenciasField),
                width: size.width * 0.75,
              ),
              SizedBox(height: 10),
              SizedBox(
                child: registrarButton,
                width: size.width * 0.75,
              ),
            ],
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
    String inString = ganancia.toStringAsFixed(2); // '2.35'
    ganancia = double.parse(inString);

    if (int.parse(existenciasController.text) != 0) {
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
        Provider.of<ProductoProvider>(context, listen: false).getProducto('');
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! -
                int.parse(existenciasController.text);
        Fluttertoast.showToast(
            msg: "Venta creada exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => ProductoInformation(
                    widget.__productModel, widget.cateFilterRV)),
            (route) => false);
      }
    } else {
      print("Valor 0");
      Fluttertoast.showToast(msg: "Ingrese un cantidad mayor a 0 ");
    }
  }
}
