import 'package:app_inventario/api/gastos.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
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
  //TextEditingController cantidadController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    descripcionController =
        TextEditingController(text: widget.gastoModel.descripcion);
  }

  @override
  Widget build(BuildContext context) {
    //Campo Cantidad
    /*final cantidadField = TextFormField(
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
        ));*/

    //Campo Descripcion
    final descripcionField = TextFormField(
        autofocus: false,
        controller: descripcionController,
        keyboardType: TextInputType.multiline,
        cursorColor: ColorF,
        maxLines: 2,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Descripcion no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una descripcion válida");
          }
          return null;
        },
        onSaved: (value) {
          descripcionController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.description,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Descripción",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //crear button
    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
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
                    SizedBox(height: size.height * 0.15),
                    IconButton(
                      icon:
                          Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                      onPressed: () {
                        // passing this to our root
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.08),
                const Text(
                  'GASTO',
                  style: TextStyle(
                      fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.08),
                const Text(
                  'Descripción',
                  style: TextStyle(fontSize: 14, color: ColorF),
                  textAlign: TextAlign.left,
                ),
                //SizedBox(height: 5),
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
                      child: descripcionField),
                  width: size.width * 0.75,
                ),
                SizedBox(height: 20),
                SizedBox(
                  child: registrarButton,
                  width: size.width * 0.75,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onAdd() {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    if (descripcionController.text.isNotEmpty) {
      GastoModel gasto = GastoModel(descripcion: descripcionController.text);
      Provider.of<GastosProvider>(context, listen: false).addGasto(gasto);
      Fluttertoast.showToast(msg: "Gasto creado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewGastos()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    if (descripcionController.text.isNotEmpty) {
      GastoModel gasto = GastoModel(descripcion: descripcionController.text);
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
