import 'dart:async';
import 'package:app_inventario/api/producto.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../information.dart';
import '../../../models/producto.dart';
import '../../../models/categoria.dart';
//import '../../../models/ubicacion.dart';
//import '../../../models/estanteria.dart';
import '../../../models/detalle_producto.dart';
import '../../../api/detalle_producto.dart';
//import '../../../api/ubicacion.dart';
//import '../../../api/estanteria.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationDetalleProducto extends StatefulWidget {
  final DetalleProductoModel _detalleproductoModel;
  final ProductoModel __productModel;
  final CategoriaModel cateFilterRD;
  int valor;
  RegistrationDetalleProducto(this._detalleproductoModel, this.__productModel,
      this.cateFilterRD, this.valor);
  @override
  _RegistrationDetalleProductoState createState() =>
      _RegistrationDetalleProductoState();
}

class _RegistrationDetalleProductoState
    extends State<RegistrationDetalleProducto> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController precioCostoController = TextEditingController();
  TextEditingController precioVentaController = TextEditingController();
  TextEditingController existenciasTController = TextEditingController();
  TextEditingController existenciasBController = TextEditingController();
  TextEditingController vencimientoController = TextEditingController();
  String? valoresCat;
  String? valoresUbi;
  String? valoresEstan;
  String? nombreAlmacen;
  String? nombreEstanteria;
  int contador = 0;
  int contador2 = 0;
  bool control = false;
  DateTime selectedDate = DateTime.now();

  List<CategoriaModel> items = <CategoriaModel>[];
  //List<UbicacionModel> items2 = <UbicacionModel>[];
  //List<EstanteriaModel> items3 = <EstanteriaModel>[];

  //UbicacionProvider items2 = UbicacionProvider();
  //EstanteriaProvider items3 = EstanteriaProvider();

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
      precioCostoController = TextEditingController(
          text: widget._detalleproductoModel.Precio_Costo.toString());
      precioVentaController = TextEditingController(
          text: widget._detalleproductoModel.Precio_Venta.toString());
      vencimientoController = TextEditingController(
          text: widget._detalleproductoModel.Vencimiento.toString());
      if (widget.valor == 1) {
        existenciasTController = TextEditingController(text: '0');
        contador = 0;
      } else {
        existenciasTController = TextEditingController(
            text: widget._detalleproductoModel.ExistenciasT.toString());
        contador = widget._detalleproductoModel.ExistenciasT!.toInt();
      }
      if (widget.valor == 2) {
        existenciasBController = TextEditingController(text: '0');
        contador2 = 0;
      } else {
        existenciasBController = TextEditingController(
            text: widget._detalleproductoModel.ExistenciasB.toString());
        contador2 = widget._detalleproductoModel.ExistenciasB!.toInt();
      }

      //valoresUbi = widget._detalleproductoModel.almacen['id'].toString();

      //control = true;

      //valoresEstan = widget._detalleproductoModel.estanteria['id'].toString();
    } else {
      print(widget._detalleproductoModel.Id);
      existenciasTController = TextEditingController(text: contador.toString());
      existenciasBController =
          TextEditingController(text: contador2.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //items2 = Provider.of<UbicacionProvider>(context);
    //items3 = Provider.of<EstanteriaProvider>(context);

    //Campo Precio Costo
    final precioCostoField = TextFormField(
        autofocus: false,
        controller: precioCostoController,
        keyboardType: TextInputType.number,
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = RegExp('^[0-9]+');
          if (value!.isEmpty) {
            return ("Precio Costo no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una precio costo válido");
          }
          return null;
        },
        onSaved: (value) {
          precioCostoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.monetization_on_outlined,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Precio Costo",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //Campo Precio Costo
    final precioVentaField = TextFormField(
        autofocus: false,
        controller: precioVentaController,
        keyboardType: TextInputType.number,
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = RegExp('^[0-9]+');
          if (value!.isEmpty) {
            return ("Precio Venta no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese un precio venta válido");
          }
          if (double.parse(precioCostoController.text) >
              double.parse(precioVentaController.text)) {
            return "Precio Venta no puede ser \n menor a Precio Costo";
          }
          return null;
        },
        onSaved: (value) {
          precioVentaController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.monetization_on_outlined,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Precio Venta",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));

    //Campo Ubicacion
    /*final ubicacionField = Container(
        padding: EdgeInsets.only(left: 0, right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField(
          decoration:
              InputDecoration(prefixIcon: Icon(Icons.amp_stories_outlined)),
          hint: Text("Seleccione una Ubicación"),
          value: valoresUbi,
          isExpanded: true,
          //underline: SizedBox(),
          onChanged: (valorNuevo) {
            setState(() {
              valoresUbi = valorNuevo.toString();
              /*control = true;
              valoresUbi = valorNuevo.toString();
              items3.getEstanteria(valoresUbi);
              print("Antes");
              if (widget._detalleproductoModel.Id != null && control == false) {
                valoresEstan =
                    widget._detalleproductoModel.estanteria['id'].toString();
              } else {
                print('Entra');
                print(items3.todosEstanteria.length);
                if (items3.todosEstanteria.isNotEmpty) {
                  valoresEstan = items3.todosEstanteria[0].Id.toString();
                } 
              }*/
            });
          },
          items: items2.todosUbicacion.map((map) {
            return DropdownMenuItem<String>(
              value: map.Id.toString(),
              child: Text(
                map.Almacen.toString(),
              ),
            );
          }).toList(),
        ));*/

    //Campo Estanteria
    /*final estanteriaField = Container(
        padding: EdgeInsets.only(left: 0, right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField(
          decoration:
              InputDecoration(prefixIcon: Icon(Icons.amp_stories_outlined)),
          hint: Text("Seleccione una Estanteria"),
          value: (items3.todosEstanteria.isNotEmpty)
              ? valoresEstan = items3.todosEstanteria[0].Id.toString()
              : valoresEstan,
          isExpanded: true,
          //underline: SizedBox(),
          onChanged: (valorNuevo) {
            setState(() {
              valoresEstan = valorNuevo.toString();
            });
          },
          items: items3.todosEstanteria.map((map) {
            return DropdownMenuItem<String>(
              value: map.Id.toString(),
              child: Text(
                map.estanteria.toString(),
              ),
            );
          }).toList(),
        ));*/
    //Campo ExistenciasT
    final existenciasTField = Container(
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
                      existenciasTController =
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
              controller: existenciasTController,
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
                    contador++;
                    existenciasTController =
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

    //Campo ExistenciasB
    final existenciasBField = Container(
        color: PrimaryLightColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (contador2 > 0) {
                      contador2--;
                      existenciasBController =
                          TextEditingController(text: contador2.toString());
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
              controller: existenciasBController,
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
                    contador2++;
                    existenciasBController =
                        TextEditingController(text: contador2.toString());
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

    final vencimientoField = Container(
        child: TextFormField(
            //enabled: false,
            autofocus: false,
            controller: vencimientoController,
            keyboardType: TextInputType.none,
            cursorColor: ColorF,
            onSaved: (value) {
              vencimientoController.text = value!;
            },
            onTap: () => _selectDate(context),
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.date_range,
                color: ColorF,
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Fecha Vencimiento",
              border: InputBorder.none,
              /*border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),*/
            )));

    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (widget._detalleproductoModel.Id != null) {
              onUpdate(widget._detalleproductoModel.Id!);
            } else {
              onAdd();
            }
          },
          child: (widget._detalleproductoModel.Id != null)
              ? const Text(
                  'Actualizar Compra',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Registrar Compra',
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    if (widget.valor == 0 || widget.valor == 10)
                      SizedBox(height: size.height * 0.06),
                    if (widget.valor == 10 ||
                        widget.valor == 1 ||
                        widget.valor == 2)
                      SizedBox(height: size.height * 0.15),
                    IconButton(
                      icon:
                          Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                      onPressed: () {
                        if (widget._detalleproductoModel.Id != null) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductoInformation(
                                      widget.__productModel,
                                      widget.cateFilterRD)));
                        } else {
                          // passing this to our root
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                if (widget.valor == 1 || widget.valor == 2)
                  SizedBox(height: size.height * 0.10),
                const Text(
                  'DETALLE PRODUCTO',
                  style: TextStyle(
                      fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.02),
                if (widget.valor == 0 || widget.valor == 10)
                  const Text(
                    'Precio Costo',
                    style: TextStyle(fontSize: 14, color: ColorF),
                    textAlign: TextAlign.left,
                  ),
                //SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 10)
                  SizedBox(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: PrimaryLightColor,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: precioCostoField),
                    width: size.width * 0.75,
                  ),
                SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 10)
                  const Text(
                    'Precio Venta',
                    style: TextStyle(fontSize: 14, color: ColorF),
                    textAlign: TextAlign.left,
                  ),
                //SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 10)
                  SizedBox(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: PrimaryLightColor,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: precioVentaField),
                    width: size.width * 0.75,
                  ),
                if (widget.valor == 0 || widget.valor == 10)
                  const Text(
                    'Fecha de Vencimiento',
                    style: TextStyle(fontSize: 14, color: ColorF),
                    textAlign: TextAlign.left,
                  ),
                //SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 10)
                  SizedBox(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: PrimaryLightColor,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: vencimientoField),
                    width: size.width * 0.75,
                  ),
                if (widget.valor == 0 || widget.valor == 1)
                  const Text(
                    'Existencias Tienda',
                    style: TextStyle(fontSize: 14, color: ColorF),
                    textAlign: TextAlign.left,
                  ),
                //SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 1)
                  SizedBox(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: PrimaryLightColor,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: existenciasTField),
                    width: size.width * 0.75,
                  ),
                if (widget.valor == 0 || widget.valor == 2)
                  const Text(
                    'Existencias Bodega',
                    style: TextStyle(fontSize: 14, color: ColorF),
                    textAlign: TextAlign.left,
                  ),
                //SizedBox(height: 5),
                if (widget.valor == 0 || widget.valor == 2)
                  SizedBox(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        width: size.width * 0.8,
                        decoration: BoxDecoration(
                          color: PrimaryLightColor,
                          borderRadius: BorderRadius.circular(29),
                        ),
                        child: existenciasBField),
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
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      //initialDatePickerMode: DatePickerMode.year,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        vencimientoController.text = selected.year.toString() +
            '-' +
            selected.month.toString() +
            '-' +
            selected.day.toString();
      });
  }

  Future<void> onAdd() async {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    if (vencimientoController.text != "null" &&
        vencimientoController.text != "") {
      //detalleModel.vencimiento = vencimientoController.text;
    } else {
      //detalleModel.vencimiento = "Sin especificar";
    }
    int existenciasTotal = int.parse(existenciasTController.text) +
        int.parse(existenciasBController.text);
    if (precioCostoController.text.isNotEmpty &&
        precioVentaController.text.isNotEmpty &&
        existenciasTController.text.isNotEmpty) {
      DetalleProductoModel detalleproducto = DetalleProductoModel(
        producto: widget.__productModel.Id,
        precio_costo: precioCostoController.text,
        precio_venta: precioVentaController.text,
        existenciasT: int.parse(existenciasTController.text),
        existenciasB: int.parse(existenciasBController.text),
        existencias: existenciasTotal,
        vencimiento: vencimientoController.text,
        //almacen: valoresUbi,
        //estanteria: valoresEstan
      );
      bool istoken =
          await Provider.of<DetalleProductoProvider>(context, listen: false)
              .addDetalleProducto(
                  detalleproducto, widget.__productModel.Id.toString());
      if (istoken) {
        Provider.of<ProductoProvider>(context, listen: false).getProducto('');
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! + existenciasTotal;
        Fluttertoast.showToast(
            msg: "Detalle de Producto creado exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => ProductoInformation(
                    widget.__productModel, widget.cateFilterRD)),
            (route) => false);
      }
    }
  }

  Future<void> onUpdate(int id) async {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    int existenciasT = int.parse(existenciasTController.text);
    int existenciasB = int.parse(existenciasBController.text);
    int existenciasTotal = 0;
    if (widget.valor == 1) {
      existenciasTotal = int.parse(existenciasTController.text) +
          int.parse(existenciasBController.text) +
          widget._detalleproductoModel.ExistenciasT!;
      existenciasT = existenciasT + widget._detalleproductoModel.ExistenciasT!;
    } else if (widget.valor == 2) {
      existenciasTotal = int.parse(existenciasTController.text) +
          int.parse(existenciasBController.text) +
          widget._detalleproductoModel.ExistenciasB!;
      existenciasB = existenciasB + widget._detalleproductoModel.ExistenciasB!;
    } else {
      existenciasTotal = int.parse(existenciasTController.text) +
          int.parse(existenciasBController.text);
    }
    if (precioCostoController.text.isNotEmpty &&
        precioVentaController.text.isNotEmpty &&
        existenciasTController.text.isNotEmpty) {
      DetalleProductoModel detalleproducto = DetalleProductoModel(
        producto: widget.__productModel.Id,
        precio_costo: precioCostoController.text,
        precio_venta: precioVentaController.text,
        existenciasT: existenciasT,
        existenciasB: existenciasB,
        existencias: existenciasTotal,
        vencimiento: vencimientoController.text,
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
            msg: "Detalle de Producto actualizado exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => ProductoInformation(
                    widget.__productModel, widget.cateFilterRD)),
            (route) => false);
      }
    }
  }
}
