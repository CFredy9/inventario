import 'dart:async';
import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/constants.dart';
import 'package:provider/provider.dart';

import '/models/usuario.dart';
import '../home/home_screen.dart';
//import 'package:inventarios/pages/login/login_screen.dart';
import './listview.dart';
import 'cambio_password.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:animate_do/animate_do.dart';

class PerfilScreen extends StatefulWidget {
  final UsuarioModel usuarioModel;
  PerfilScreen(this.usuarioModel);
  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  MeProvider usuarioT = MeProvider();
  bool bandera = false;

  // string for displaying the error Message
  String? errorMessage;
  UsuarioModel me = UsuarioModel();
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  /*Query query = usuarioReferencia
      .orderByChild('id')
      .equalTo('RdhIhWIxJ6bGHsq0QdnoCuVueoi1');
  bool bandera = true;
  List Roles = ['Administrador', 'Empleado'];
  String? valores;
  List<UsuarioModel> items = <UsuarioModel>[];
  StreamSubscription<Event>? PerfilAddedSubscription;*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController =
        TextEditingController(text: widget.usuarioModel.First_Name);
    lastnameController =
        TextEditingController(text: widget.usuarioModel.Last_Name);
    phoneController = TextEditingController(text: widget.usuarioModel.Phone);
    emailController = TextEditingController(text: widget.usuarioModel.Email);
  }

  @override
  void dispose() {
    super.dispose();
    //PerfilAddedSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    //Campo nombre
    final nameField = TextFormField(
        autofocus: false,
        controller: nameController,
        keyboardType: TextInputType.name,
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Nombre no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese un nombre válido \n (Minimo 3 caracteres)");
          }
          return null;
        },
        onSaved: (value) {
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //Campo apellido
    final lastnameField = TextFormField(
        autofocus: false,
        controller: lastnameController,
        keyboardType: TextInputType.name,
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Apellido no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese un apellido válido \n (Minimo 3 caracteres)");
          }
          return null;
        },
        onSaved: (value) {
          lastnameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Apellido",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //Campo telefono
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneController,
        keyboardType: TextInputType.phone,
        cursorColor: ColorF,
        /*validator: (value) {
          if (value!.isEmpty) {
            return ("Telefono no puede estar vacio");
          }
          return null;
        },*/
        onSaved: (value) {
          phoneController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.phone,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Telefono",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //Campo Email
    final emailField = TextFormField(
        autofocus: false,
        enabled: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        cursorColor: ColorF,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Ingrese su Correo Electrónico");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Ingrese un Correo Electrónico valido");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Correo Electrónico",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            onUpdate(widget.usuarioModel.Id!);
          },
          child: const Text(
            'Guardar Cambios',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SlideInDown(
          duration: const Duration(seconds: 1),
          child: AppBar(
            backgroundColor: ColorF,
            title: const Text("Perfil"),
            centerTitle: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // passing this to our root
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Center(
          child: SlideInUp(
            duration: const Duration(seconds: 1),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //SizedBox(height: 5),
                        const Center(
                          child: Text(
                            'Nombre',
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorF,
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: PrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: nameField),
                          width: size.width * 1,
                        ),
                        SizedBox(height: 5),
                        const Center(
                          child: Text(
                            'Apellido',
                            style: TextStyle(fontSize: 14, color: ColorF),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: PrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: lastnameField),
                          width: size.width * 1,
                        ),
                        SizedBox(height: 5),
                        const Center(
                          child: Text(
                            'Teléfono',
                            style: TextStyle(fontSize: 14, color: ColorF),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: PrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: phoneField),
                          width: size.width * 1,
                        ),
                        SizedBox(height: 5),
                        const Center(
                          child: Text(
                            'Correo Electrónico',
                            style: TextStyle(fontSize: 14, color: ColorF),
                          ),
                        ),
                        SizedBox(
                          child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              width: size.width * 0.8,
                              decoration: BoxDecoration(
                                color: PrimaryLightColor,
                                borderRadius: BorderRadius.circular(29),
                              ),
                              child: emailField),
                          width: size.width * 1,
                        ),
                        SizedBox(height: 20),
                        signUpButton,
                        SizedBox(height: 15),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Cambiar Contraseña? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CambioPassword()));
                                },
                                child: const Text(
                                  "Presiona Aquí",
                                  style: TextStyle(
                                      color: ColorF,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                              )
                            ])
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onUpdate(int id) {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    if (nameController.text.isNotEmpty) {
      print("VALOR:" + nameController.text);
      UsuarioModel usuario = UsuarioModel(
        first_name: nameController.text,
        last_name: lastnameController.text,
        //email: emailController.text,
        //username: emailController.text,
        phone: phoneController.text,
        //rol: valores,
        //password: confirmPasswordController.text,
      );
      Provider.of<MeProvider>(context, listen: false).updateMe(usuario, id);
      Fluttertoast.showToast(msg: "Cambios Guardados ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    }
  }

  update(String Id) async {
    UsuarioModel userModel = UsuarioModel();
    /*userModel.nombre = nameEditingController.text;
    userModel.apellido = lastnameEditingController.text;
    userModel.telefono = phoneEditingController.text;
    await perfilReferencia.reference().child(Id).update({
      'nombre': userModel.nombre,
      'apellido': userModel.apellido,
      'telefono': userModel.telefono,
    }).then((value) => null);*/
    Fluttertoast.showToast(msg: "Cambios guardados ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }
}
