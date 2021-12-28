import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/models/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:provider/provider.dart';

import '../home/home_screen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  String? correo;
  ResetPassword(this.correo);
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

//final perfilReferencia = FirebaseDatabase.instance.reference().child('User');

class _ResetPasswordState extends State<ResetPassword> {
  //final User? perfil = FirebaseAuth.instance.currentUser;
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController(text: widget.correo);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Campo email
    final emailField = TextFormField(
        enabled: false,
        autofocus: false,
        controller: emailController,
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
          emailController.text = value!;
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

    //Campo Contrase
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Se requiere contraseña para iniciar sesión");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese una contraseña valida (Minimo 6 caracteres)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contraseña Nueva",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo de Confirmacion de Contrase
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordController.text != passwordController.text) {
            return "Las contraseñas no coinciden";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirmar Contraseña",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            onRecuperacionPassword(confirmPasswordController.text);
          },
          child: const Text(
            'Cambiar Contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Cambiar Contraseña"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
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

  void onRecuperacionPassword(String contrasenia) {
    if (contrasenia.isNotEmpty) {
      UsuarioModel usuario = UsuarioModel(
        email: widget.correo,
        password: contrasenia,
      );
      Provider.of<MeProvider>(context, listen: false)
          .recuperacionContra(usuario);
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false);
    }
  }

  updatePassword(String contrasenia) async {
    /*perfil!
        .updatePassword(contrasenia)
        .then((value) =>
            {Fluttertoast.showToast(msg: "Contraseña cambiada exitosamente")})
        .catchError((error) {
      Fluttertoast.showToast(msg: "Error al cambiar la contraseña"); 
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
        */
  }
}
