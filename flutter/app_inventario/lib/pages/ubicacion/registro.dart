import 'package:app_inventario/api/ubicacion.dart';
import 'package:provider/provider.dart';

import 'listview.dart';
import '../../models/ubicacion.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationUbicacion extends StatefulWidget {
  final UbicacionModel ubicacionModel;
  RegistrationUbicacion(this.ubicacionModel);
  @override
  _RegistrationUbicacionState createState() => _RegistrationUbicacionState();
}

class _RegistrationUbicacionState extends State<RegistrationUbicacion> {
  String? valores;
  //String valores = "";
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*if (widget.ubicacionModel.Id != null) {
      List<String> palabra = widget.ubicacionModel.Ubicacion_Estanteria!.split('-');
      nameController = TextEditingController(text: palabra[1]);
      valores = palabra[0];
    } */
    if (widget.ubicacionModel.id != null) {
      nameController =
          TextEditingController(text: widget.ubicacionModel.almacen);
      //valores = widget.ubicacionModel.Almacen;
    }
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
          items: <String>['Tienda', 'Bodega1', 'Bodega2']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )); */
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
          hintText: "Ingrese ubicación",
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
            if (widget.ubicacionModel.Id != null) {
              onUpdate(widget.ubicacionModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.ubicacionModel.Id != null)
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
      UbicacionModel ubicacion = UbicacionModel(almacen: nameController.text);
      Provider.of<UbicacionProvider>(context, listen: false)
          .addUbicacion(ubicacion);
      Fluttertoast.showToast(msg: "Ubicacion creada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewUbicacion()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (nameController.text.isNotEmpty) {
      UbicacionModel ubicacion = UbicacionModel(almacen: nameController.text);
      Provider.of<UbicacionProvider>(context, listen: false)
          .updateUbicacion(ubicacion, id);
      Fluttertoast.showToast(msg: "Ubicacion actualizada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewUbicacion()),
          (route) => false);
    }
  }
}
