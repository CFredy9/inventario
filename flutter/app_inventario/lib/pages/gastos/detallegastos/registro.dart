import 'package:app_inventario/api/detalle_gastos.dart';
import 'package:app_inventario/api/gastos.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
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
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = RegExp('^[0-9]+');
          if (value!.isEmpty) {
            return ("Cantidad no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una cantidad válida");
          }
          return null;
        },
        onSaved: (value) {
          cantidadController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.attach_money_outlined,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Cantidad",
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
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
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
                  'DETALLE DE GASTO',
                  style: TextStyle(
                      fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: size.height * 0.08),
                const Text(
                  'Cantidad',
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
                      child: cantidadField),
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

  Future<void> onAdd() async {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
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
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
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
