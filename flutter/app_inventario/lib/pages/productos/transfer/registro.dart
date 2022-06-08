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

class TransferExistencias extends StatefulWidget {
  final DetalleProductoModel _detalleproductoModel;
  final ProductoModel __productModel;
  TransferExistencias(this._detalleproductoModel, this.__productModel);
  @override
  _TransferExistenciasState createState() => _TransferExistenciasState();
}

class _TransferExistenciasState extends State<TransferExistencias> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController existenciasTController = TextEditingController();
  TextEditingController existenciasBController = TextEditingController();
  int contadorT = 0;
  int contadorB = 0;
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
      existenciasTController = TextEditingController(
          text: widget._detalleproductoModel.ExistenciasT.toString());
      existenciasBController = TextEditingController(
          text: widget._detalleproductoModel.ExistenciasB.toString());
      contadorT = widget._detalleproductoModel.ExistenciasT!.toInt();
      contadorB = widget._detalleproductoModel.ExistenciasB!.toInt();
      //control = true;
    } else {
      existenciasTController =
          TextEditingController(text: contadorT.toString());
      existenciasBController =
          TextEditingController(text: contadorT.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //Campo Existencias
    final existenciasTField = Container(
      color: PrimaryLightColor,
      child: Expanded(
          child: TextFormField(
        controller: existenciasTController,
        enabled: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 39.0),
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),*/
        ),
      )),
    );

    final existenciasBField = Container(
      color: PrimaryLightColor,
      child: Expanded(
          child: TextFormField(
        controller: existenciasBController,
        enabled: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 39.0),
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),*/
        ),
      )),
    );

    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            onTransfer(widget._detalleproductoModel.Id!);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.loop,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {}),
              const Text(
                'Guardar',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
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
                                    widget.__productModel)));
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
                'Transferencia de Existencias',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Tienda',
                        style: TextStyle(fontSize: 14, color: ColorF),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: PrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: existenciasTField),
                        width: size.width * 0.35,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        child: IconButton(
                            icon: const Icon(
                              Icons.east,
                              color: ColorF,
                            ),
                            onPressed: () {
                              setState(() {
                                if (contadorT > 0) {
                                  contadorT--;
                                  contadorB++;
                                  existenciasTController =
                                      TextEditingController(
                                          text: contadorT.toString());
                                  existenciasBController =
                                      TextEditingController(
                                          text: contadorB.toString());
                                }
                              });
                            }),
                        width: size.width * 0.15,
                      ),
                      SizedBox(
                        child: IconButton(
                            icon: const Icon(
                              Icons.west,
                              color: ColorF,
                            ),
                            onPressed: () {
                              setState(() {
                                if (contadorB > 0) {
                                  contadorT++;
                                  contadorB--;
                                  existenciasTController =
                                      TextEditingController(
                                          text: contadorT.toString());
                                  existenciasBController =
                                      TextEditingController(
                                          text: contadorB.toString());
                                }
                              });
                            }),
                        width: size.width * 0.15,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Bodega',
                        style: TextStyle(fontSize: 14, color: ColorF),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              color: PrimaryLightColor,
                              borderRadius: BorderRadius.circular(29),
                            ),
                            child: existenciasBField),
                        width: size.width * 0.35,
                      ),
                    ],
                  ),
                ],
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

  Future<void> onTransfer(int id) async {
    /*var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();*/
    int existenciasT = int.parse(existenciasTController.text);
    int existenciasB = int.parse(existenciasBController.text);
    int existenciasTotal = existenciasT + existenciasB;

    if (existenciasTController.text.isNotEmpty &&
        existenciasBController.text.isNotEmpty) {
      DetalleProductoModel detalleproducto = DetalleProductoModel(
        producto: widget.__productModel.Id,
        precio_costo: widget._detalleproductoModel.Precio_Costo,
        precio_venta: widget._detalleproductoModel.Precio_Venta,
        existenciasT: existenciasT,
        existenciasB: existenciasB,
        existencias: existenciasTotal,
        vencimiento: widget._detalleproductoModel.Vencimiento,
        //almacen: valoresUbi,
        //estanteria: valoresEstan
      );
      bool istoken =
          await Provider.of<DetalleProductoProvider>(context, listen: false)
              .updateDetalleProducto(
                  detalleproducto, id, widget.__productModel.Id.toString());
      if (istoken) {
        Provider.of<ProductoProvider>(context, listen: false).getProducto('');
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! -
                widget._detalleproductoModel.Existencias!;
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! + existenciasTotal;

        Fluttertoast.showToast(
            msg: "Existencias actualizadas exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
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
