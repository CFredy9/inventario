import 'package:app_inventario/api/detalle_gastos.dart';
import 'package:app_inventario/api/gastos.dart';
import 'package:provider/provider.dart';

import '../information.dart';
import '../../../models/detalle_gastos.dart';
import '../../../models/gastos.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationDetalleGasto extends StatefulWidget {
  final DetalleGastoModel detallegastoModel;
  final GastoModel __gastoModel;
  RegistrationDetalleGasto(this.detallegastoModel, this.__gastoModel);
  @override
  _RegistrationDetalleGastoState createState() =>
      _RegistrationDetalleGastoState();
}

class _RegistrationDetalleGastoState extends State<RegistrationDetalleGasto> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController cantidadController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cantidadController =
        TextEditingController(text: widget.detallegastoModel.cantidad);
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

    //crear button
    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if (widget.detallegastoModel.Id != null) {
              onUpdate(widget.detallegastoModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.detallegastoModel.Id != null)
              ? const Text(
                  'Actualizar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Añadir',
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
    if (cantidadController.text.isNotEmpty) {
      DetalleGastoModel detallegasto = DetalleGastoModel(
          descripcion: widget.__gastoModel.Id,
          cantidad: cantidadController.text);
      bool istoken =
          await Provider.of<DetalleGastosProvider>(context, listen: false)
              .addDetalleGasto(detallegasto, widget.__gastoModel.Id.toString());
      if (istoken) {
        /*double suma = double.parse(widget.__gastoModel.total!) +
            double.parse(cantidadController.text);
        String valor = suma.toStringAsFixed(2);
        widget.__gastoModel.total = valor;*/
        Fluttertoast.showToast(msg: "Gasto creado exitosamente :) ");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => GastoInformation(widget.__gastoModel)),
            (route) => false);
      }
    }
  }

  Future<void> onUpdate(int id) async {
    if (cantidadController.text.isNotEmpty) {
      DetalleGastoModel detallegasto = DetalleGastoModel(
          descripcion: widget.__gastoModel.Id,
          cantidad: cantidadController.text);
      bool istoken =
          await Provider.of<DetalleGastosProvider>(context, listen: false)
              .updateDetalleGasto(
                  detallegasto, id, widget.__gastoModel.Id.toString());
      if (istoken) {
        //Provider.of<GastosProvider>(context, listen: false).getGasto();
        Fluttertoast.showToast(msg: "Gasto actualizado exitosamente :) ");
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => GastoInformation(widget.__gastoModel)),
            (route) => false);
      }
    }
  }
}
