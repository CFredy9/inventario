import 'package:app_inventario/api/detalle_credito.dart';
import 'package:app_inventario/api/gastos.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../information.dart';
import '../../../models/detalle_credito.dart';
import '../../../models/credito.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationDetalleCredito extends StatefulWidget {
  final DetalleCreditoModel detallecreditoModel;
  final CreditoModel __creditoModel;
  RegistrationDetalleCredito(this.detallecreditoModel, this.__creditoModel);
  @override
  _RegistrationDetalleCreditoState createState() =>
      _RegistrationDetalleCreditoState();
}

class _RegistrationDetalleCreditoState
    extends State<RegistrationDetalleCredito> {
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
        TextEditingController(text: widget.detallecreditoModel.cantidad);
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
            if (widget.detallecreditoModel.Id != null) {
              onUpdate(widget.detallecreditoModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.detallecreditoModel.Id != null)
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
                  'DETALLE DE CRÉDITO',
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
      DetalleCreditoModel detallecredito = DetalleCreditoModel(
          credito: widget.__creditoModel.Id, cantidad: cantidadController.text);
      bool istoken =
          await Provider.of<DetalleCreditoProvider>(context, listen: false)
              .addDetalleCredito(
                  detallecredito, widget.__creditoModel.Id.toString());
      if (istoken) {
        double suma = double.parse(widget.__creditoModel.total!) +
            double.parse(cantidadController.text);
        String valor = suma.toStringAsFixed(2);
        widget.__creditoModel.total = valor;
        Fluttertoast.showToast(
            msg: "Detalle de Crédito creado exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) =>
                    CreditoInformation(widget.__creditoModel)),
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
      DetalleCreditoModel detallegasto = DetalleCreditoModel(
          credito: widget.__creditoModel.Id, cantidad: cantidadController.text);
      bool istoken =
          await Provider.of<DetalleCreditoProvider>(context, listen: false)
              .updateDetalleCredito(
                  detallegasto, id, widget.__creditoModel.Id.toString());
      if (istoken) {
        //Provider.of<GastosProvider>(context, listen: false).getGasto();
        double actualizacion = double.parse(widget.__creditoModel.total!) -
            double.parse(widget.detallecreditoModel.cantidad!) +
            double.parse(cantidadController.text);
        String valor = actualizacion.toStringAsFixed(2);
        widget.__creditoModel.total = valor;
        Fluttertoast.showToast(
            msg: "Detalle de Crédito actualizado exitosamente",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) =>
                    CreditoInformation(widget.__creditoModel)),
            (route) => false);
      }
    }
  }
}
