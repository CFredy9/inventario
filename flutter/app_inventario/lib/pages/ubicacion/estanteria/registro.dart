import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
import 'package:app_inventario/api/estanteria.dart';
import 'package:provider/provider.dart';

import 'listview.dart';
import '../../../models/ubicacion.dart';
import '../../../models/estanteria.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationEstanteria extends StatefulWidget {
  final EstanteriaModel estanteriaModel;
  final UbicacionModel __ubicacionModel;
  RegistrationEstanteria(this.estanteriaModel, this.__ubicacionModel);
  @override
  _RegistrationEstanteriaState createState() => _RegistrationEstanteriaState();
}

//final estanteriaReference =
//    FirebaseDatabase.instance.reference().child('Estanteria');
//final ubicacionRefer = FirebaseDatabase.instance.reference().child('Ubicacion');

class _RegistrationEstanteriaState extends State<RegistrationEstanteria> {
  String? valores;
  //List<UbicacionModel> items = <UbicacionModel>[];
  UbicacionModel? variable = UbicacionModel();
  //StreamSubscription<Event>? ubicacionAddedSubscription;
  /*void ubicacionAdded(Event event) {
    setState(() {
      items.add(UbicacionModel.fromSnapShot(event.snapshot));
    });
  } */
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController ubicacionController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*items = <UbicacionModel>[];
    ubicacionAddedSubscription = ubicacionRefer
        .child(widget.__ubicacionModel.Id.toString())
        .onChildAdded
        .listen(ubicacionAdded); */
    if (widget.estanteriaModel.Id != null) {
      nameController =
          TextEditingController(text: widget.estanteriaModel.estanteria);
      //valores = widget.ubicacionModel.Almacen;
    }
    ubicacionController =
        TextEditingController(text: widget.__ubicacionModel.almacen);
    //valores = widget.__ubicacionModel.Id;
  }

  @override
  Widget build(BuildContext context) {
    //Campo Ubicacion
    /*final ubicacionField = Container(
        padding: EdgeInsets.only(left: 0, right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonFormField(
          enableFeedback: false,
          decoration:
              InputDecoration(prefixIcon: Icon(Icons.add_location_outlined)),
          hint: Text("Seleccione Ubicaci
n"),
          value: valores,
          isExpanded: true,
          //underline: SizedBox(),
          onChanged: (valorNuevo) {
            setState(() {
              valores = valorNuevo.toString();
            });
          },
          items: items.map((map) {
            return DropdownMenuItem<String>(
              value: map.Id.toString(),
              child: Text(
                map.Almacen.toString(),
              ),
            );
          }).toList(),
        )); */
    //Campo ubicacion
    final ubicacionField = TextFormField(
        enabled: false,
        autofocus: false,
        controller: ubicacionController,
        keyboardType: TextInputType.name,
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.add_location_alt_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Ingrese ubicación",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo nombre
    final nameField = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Nombre no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese un nombre valido (Minimo 3 caracteres)");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.add_location_alt_outlined),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Ingrese ubicación estanteria",
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
            if (widget.estanteriaModel.Id != null) {
              //update(widget.estanteriaModel.Id.toString(),widget.__ubicacionModel);
              onUpdate(widget.estanteriaModel.id!);
            } else {
              //create(widget.__ubicacionModel);
              onAdd();
            }
          },
          child: (widget.estanteriaModel.Id != null)
              ? Text(
                  'Actualizar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )
              : Text(
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
                    ubicacionField,
                    SizedBox(height: 45),
                    nameField,
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
    if (nameController.text.isNotEmpty) {
      EstanteriaModel estanteria = EstanteriaModel(
          estanteria: nameController.text, almacen: widget.__ubicacionModel.id);
      Provider.of<EstanteriaProvider>(context, listen: false)
          .addEstanteria(estanteria);
      Fluttertoast.showToast(msg: "Estanteria creada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(
              builder: (context) =>
                  ListViewEstanteria(widget.__ubicacionModel)),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (nameController.text.isNotEmpty) {
      EstanteriaModel estanteria = EstanteriaModel(
          estanteria: nameController.text, almacen: widget.__ubicacionModel.id);
      Provider.of<EstanteriaProvider>(context, listen: false)
          .updateEstanteria(estanteria, id);
      Fluttertoast.showToast(msg: "Ubicacion actualizada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(
              builder: (context) =>
                  ListViewEstanteria(widget.__ubicacionModel)),
          (route) => false);
    }
  }
}
