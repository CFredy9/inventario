import 'dart:async';
import 'package:app_inventario/api/producto.dart';
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

class RegistrationDetalleProducto extends StatefulWidget {
  final DetalleProductoModel _detalleproductoModel;
  final ProductoModel __productModel;
  RegistrationDetalleProducto(this._detalleproductoModel, this.__productModel);
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
  TextEditingController existenciasController = TextEditingController();
  TextEditingController vencimientoController = TextEditingController();
  String? valoresCat;
  String? valoresUbi;
  String? valoresEstan;
  String? nombreAlmacen;
  String? nombreEstanteria;
  int contador = 0;
  bool control = false;
  DateTime selectedDate = DateTime.now();

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
      precioCostoController = TextEditingController(
          text: widget._detalleproductoModel.Precio_Costo.toString());
      precioVentaController = TextEditingController(
          text: widget._detalleproductoModel.Precio_Venta.toString());
      vencimientoController = TextEditingController(
          text: widget._detalleproductoModel.Vencimiento.toString());
      existenciasController = TextEditingController(
          text: widget._detalleproductoModel.Existencias.toString());
      contador = widget._detalleproductoModel.Existencias!.toInt();
      valoresUbi = widget._detalleproductoModel.almacen['id'].toString();

      //control = true;

      valoresEstan = widget._detalleproductoModel.estanteria['id'].toString();
    } else {
      print(widget._detalleproductoModel.Id);
      existenciasController = TextEditingController(text: contador.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    items2 = Provider.of<UbicacionProvider>(context);
    items3 = Provider.of<EstanteriaProvider>(context);

    //Campo Precio Costo
    final precioCostoField = TextFormField(
        autofocus: false,
        controller: precioCostoController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Precio Costo no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una precio costo valido");
          }
          return null;
        },
        onSaved: (value) {
          precioCostoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.monetization_on_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Precio Costo",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo Precio Costo
    final precioVentaField = TextFormField(
        autofocus: false,
        controller: precioVentaController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Precio Venta no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una precio venta valido");
          }
          return null;
        },
        onSaved: (value) {
          precioVentaController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.monetization_on_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Precio Venta",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //Campo Ubicacion
    final ubicacionField = Container(
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
              control = true;
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
              }
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
        ));

    //Campo Estanteria
    final estanteriaField = Container(
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
        ));
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

    final vencimientoField = Container(
        child: TextFormField(
            //enabled: false,
            autofocus: false,
            controller: vencimientoController,
            keyboardType: TextInputType.none,
            onSaved: (value) {
              vencimientoController.text = value!;
            },
            onTap: () => _selectDate(context),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.date_range),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Fecha Vencimiento",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            )));

    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
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
                    precioCostoField,
                    SizedBox(height: 20),
                    precioVentaField,
                    SizedBox(height: 20),
                    vencimientoField,
                    SizedBox(height: 20),
                    ubicacionField,
                    SizedBox(height: 20),
                    estanteriaField,
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        vencimientoController.text = selected.year.toString() +
            '/' +
            selected.month.toString() +
            '/' +
            selected.day.toString();
      });
  }

  Future<void> onAdd() async {
    if (vencimientoController.text != "null" &&
        vencimientoController.text != "") {
      //detalleModel.vencimiento = vencimientoController.text;
    } else {
      //detalleModel.vencimiento = "Sin especificar";
    }
    if (precioCostoController.text.isNotEmpty &&
        precioVentaController.text.isNotEmpty &&
        existenciasController.text.isNotEmpty &&
        vencimientoController.text.isNotEmpty) {
      DetalleProductoModel detalleproducto = DetalleProductoModel(
          producto: widget.__productModel.Id,
          precio_costo: precioCostoController.text,
          precio_venta: precioVentaController.text,
          existencias: int.parse(existenciasController.text),
          vencimiento: vencimientoController.text,
          almacen: valoresUbi,
          estanteria: valoresEstan);
      bool istoken =
          await Provider.of<DetalleProductoProvider>(context, listen: false)
              .addDetalleProducto(
                  detalleproducto, widget.__productModel.Id.toString());
      if (istoken) {
        Provider.of<ProductoProvider>(context, listen: false).getProducto();
        widget.__productModel.existenciasT =
            widget.__productModel.existenciasT! +
                int.parse(existenciasController.text);
        Fluttertoast.showToast(
            msg: "Detalle de Producto creado exitosamente :) ");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) =>
                    ProductoInformation(widget.__productModel)),
            (route) => false);
      }
    }
  }

  Future<void> onUpdate(int id) async {
    if (precioCostoController.text.isNotEmpty &&
        precioVentaController.text.isNotEmpty &&
        existenciasController.text.isNotEmpty &&
        vencimientoController.text.isNotEmpty) {
      DetalleProductoModel detalleproducto = DetalleProductoModel(
          producto: widget.__productModel.Id,
          precio_costo: precioCostoController.text,
          precio_venta: precioVentaController.text,
          existencias: int.parse(existenciasController.text),
          vencimiento: vencimientoController.text,
          almacen: valoresUbi,
          estanteria: valoresEstan);
      bool istoken =
          await Provider.of<DetalleProductoProvider>(context, listen: false)
              .updateDetalleProducto(
                  detalleproducto, id, widget.__productModel.Id.toString());
      if (istoken) {
        Provider.of<ProductoProvider>(context, listen: false).getProducto();
        widget.__productModel.existenciasT =
            int.parse(existenciasController.text);
        Fluttertoast.showToast(
            msg: "Detalle de Producto actualizado exitosamente :) ");
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
