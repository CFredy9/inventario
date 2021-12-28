import 'package:app_inventario/api/gastos.dart';
import 'package:provider/provider.dart';

import 'listview.dart';
import '../../models/gastos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationGasto extends StatefulWidget {
  final GastoModel gastoModel;
  RegistrationGasto(this.gastoModel);
  @override
  _RegistrationGastoState createState() => _RegistrationGastoState();
}

class _RegistrationGastoState extends State<RegistrationGasto> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController cantidadController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cantidadController =
        TextEditingController(text: widget.gastoModel.cantidad);
    descripcionController =
        TextEditingController(text: widget.gastoModel.descripcion);
  }

  @override
  Widget build(BuildContext context) {
    //Campo Cantidad
    final cantidadField = TextFormField(
        autofocus: false,
        controller: cantidadController,
        keyboardType: TextInputType.number,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Cantidad no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una cantidad valida");
          }
          return null;
        },
        onSaved: (value) {
          cantidadController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Cantidad",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo Descripcion
    final descripcionField = TextFormField(
        autofocus: false,
        controller: descripcionController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Descripcion no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una descripcion valida");
          }
          return null;
        },
        onSaved: (value) {
          cantidadController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Descripción",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
            if (widget.gastoModel.Id != null) {
              onUpdate(widget.gastoModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.gastoModel.Id != null)
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
            // passing this to our root
            Navigator.of(context).pop();
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
                    SizedBox(height: 45),
                    cantidadField,
                    SizedBox(height: 45),
                    descripcionField,
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

  void onAdd() {
    if (cantidadController.text.isNotEmpty &&
        descripcionController.text.isNotEmpty) {
      GastoModel gasto = GastoModel(
          cantidad: cantidadController.text,
          descripcion: descripcionController.text);
      Provider.of<GastosProvider>(context, listen: false).addGasto(gasto);
      Fluttertoast.showToast(msg: "Gasto creado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewGastos()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (cantidadController.text.isNotEmpty &&
        descripcionController.text.isNotEmpty) {
      GastoModel gasto = GastoModel(
          cantidad: cantidadController.text,
          descripcion: descripcionController.text);
      Provider.of<GastosProvider>(context, listen: false)
          .updateGasto(gasto, id);
      Fluttertoast.showToast(msg: "Gasto actualizado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewGastos()),
          (route) => false);
    }
  }
}
