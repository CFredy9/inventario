//import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'listview.dart';
import '../../models/categoria.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/categoria.dart';

class RegistrationCategoria extends StatefulWidget {
  final CategoriaModel categoriaModel;
  RegistrationCategoria(this.categoriaModel);
  @override
  _RegistrationCategoriaState createState() => _RegistrationCategoriaState();
}

//final categoriaReference = FirebaseDatabase.instance.reference().child('Categoria');

class _RegistrationCategoriaState extends State<RegistrationCategoria> {
  //final _auth = FirebaseAuth.instance;
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
    nameController = TextEditingController(text: widget.categoriaModel.Nombre);
  }

  @override
  Widget build(BuildContext context) {
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
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
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
            if (widget.categoriaModel.Id != null) {
              //update(widget.categoriaModel.Id.toString());
              onUpdate(widget.categoriaModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.categoriaModel.Id != null)
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
    final String textVal = nameController.text;

    if (nameController.text.isNotEmpty) {
      CategoriaModel categoria = CategoriaModel(nombre: nameController.text);
      Provider.of<CategoriaProvider>(context, listen: false)
          .addCategoria(categoria);
      Fluttertoast.showToast(msg: "Categoria creada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewCategorias()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (nameController.text.isNotEmpty) {
      final CategoriaModel categoria =
          CategoriaModel(nombre: nameController.text);
      Provider.of<CategoriaProvider>(context, listen: false)
          .updateCategoria(categoria, id);
      Fluttertoast.showToast(msg: "Categoria actualizada exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewCategorias()),
          (route) => false);
    }
  }

  create() async {
    CategoriaModel cateModel = CategoriaModel();
    cateModel.nombre = nameController.text;
    /*await categoriaReference.push().set({
      'nombre': cateModel.nombre,
      'id': cateModel.Id,
    }).then((value) => null);*/
    Fluttertoast.showToast(msg: "Categoria creada exitosamente :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ListViewCategorias()),
        (route) => false);
  }

  update(String Id) async {
    CategoriaModel cateModel = CategoriaModel();
    cateModel.nombre = nameController.text;
    /*await categoriaReference.reference().child(Id).update({
      'nombre': cateModel.nombre,
    }).then((value) => null);*/
    Fluttertoast.showToast(msg: "Cambios guardados ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ListViewCategorias()),
        (route) => false);
  }
}
