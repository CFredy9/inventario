import 'dart:async';
import 'package:app_inventario/api/producto.dart';
import 'package:provider/provider.dart';
import 'listview.dart';
import './information.dart';
import '../../models/producto.dart';
import '../../models/categoria.dart';
import '../../models/ubicacion.dart';
import '../../models/estanteria.dart';
import '../../api/categoria.dart';
import '../../models/detalle_producto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationProducto extends StatefulWidget {
  final ProductoModel __productoModel;
  RegistrationProducto(this.__productoModel);
  @override
  _RegistrationProductoState createState() => _RegistrationProductoState();
}

class _RegistrationProductoState extends State<RegistrationProducto> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController nombreController = TextEditingController();
  TextEditingController unidadesFardoController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  String? valoresCat;
  bool control = false;
  //DateTime selectedDate = DateTime.now();

  //List<CategoriaModel> items = <CategoriaModel>[];
  CategoriaProvider items = CategoriaProvider();

  /*void categoriaAdded(Event event) {
    setState(() {
      //items.add(CategoriaModel.fromSnapShot(event.snapshot));
    });
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //items = <CategoriaModel>[];

    //categoriaAddedSubscription =
    //   categoriaRef.onChildAdded.listen(categoriaAdded);
    if (widget.__productoModel.Id != null) {
      nombreController =
          TextEditingController(text: widget.__productoModel.Nombre);
      unidadesFardoController = TextEditingController(
          text: widget.__productoModel.UnidadesFardo.toString());
      valoresCat = widget.__productoModel.categoria['id'].toString();
    } else {
      print(widget.__productoModel.Id);
      //existenciasController = TextEditingController(text: contador.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    items = Provider.of<CategoriaProvider>(context);
    print(items.todos.length);
    //Campo nombre
    final nombreField = TextFormField(
        autofocus: false,
        controller: nombreController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Nombre no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una nombre valido (Minimo 3 caracteres) ");
          }
          return null;
        },
        onSaved: (value) {
          nombreController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.production_quantity_limits_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //Campo unidadesFardo
    final unidadesFardoField = TextFormField(
        autofocus: false,
        controller: unidadesFardoController,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Unidades Fardo no puede estar vacio");
          }

          return null;
        },
        onSaved: (value) {
          nombreController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.production_quantity_limits_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Unidades por Fardo",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //Campo Categoria
    final categoriaField = Container(
        padding: EdgeInsets.only(left: 0, right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField(
          decoration:
              InputDecoration(prefixIcon: Icon(Icons.amp_stories_outlined)),
          hint: Text("Seleccione una Categoría"),
          value: valoresCat,
          isExpanded: true,
          //underline: SizedBox(),
          onChanged: (valorNuevo) {
            setState(() {
              valoresCat = valorNuevo.toString();
            });
          },
          items: items.todos.map((map) {
            return DropdownMenuItem<String>(
              value: map.Id.toString(),
              child: Text(
                map.Nombre.toString(),
              ),
            );
          }).toList(),
        ));

    //crear button
    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (widget.__productoModel.Id != null) {
              onUpdate(widget.__productoModel.Id!);
            } else {
              onAdd();
            }
          },
          child: (widget.__productoModel.Id != null)
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
            if (widget.__productoModel.Id != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductoInformation(widget.__productoModel)));
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
                    nombreField,
                    SizedBox(height: 20),
                    unidadesFardoField,
                    SizedBox(height: 20),
                    categoriaField,
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

  /*_selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        vencimientoController.text = selected.day.toString() +
            '/' +
            selected.month.toString() +
            '/' +
            selected.year.toString();
      });
  } */

  void onAdd() {
    if (nombreController.text.isNotEmpty &&
        unidadesFardoController.text.isNotEmpty) {
      ProductoModel producto = ProductoModel(
          nombre: nombreController.text,
          unidadesFardo: int.parse(unidadesFardoController.text),
          categoria: valoresCat);
      Provider.of<ProductoProvider>(context, listen: false)
          .addProducto(producto);
      Fluttertoast.showToast(msg: "Producto creado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewProductos()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (nombreController.text.isNotEmpty &&
        unidadesFardoController.text.isNotEmpty) {
      ProductoModel producto = ProductoModel(
          nombre: nombreController.text,
          unidadesFardo: int.parse(unidadesFardoController.text),
          categoria: valoresCat);
      Provider.of<ProductoProvider>(context, listen: false)
          .updateProducto(producto, id);
      var ante =
          items.todos.singleWhere((cate) => cate.id == int.parse(valoresCat!));
      var categoria = items.todos[items.todos.indexOf(ante)].toJson();
      producto.categoria = categoria;
      Fluttertoast.showToast(msg: "Producto actualizado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(
              builder: (context) => ProductoInformation(producto)),
          (route) => false);
    }
  }
}
