import 'dart:async';
//import 'package:firebase_database/firebase_database.dart';
import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/models/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
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
        cursorColor: ColorF,
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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nombre",
          border: InputBorder.none,
        ));

    //Campo Contrase
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        cursorColor: ColorF,
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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Contraseña Nueva",
          border: InputBorder.none,
        ));
    //Campo de Confirmacion de Contrase
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordController,
        obscureText: true,
        cursorColor: ColorF,
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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.vpn_key,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirmar Contraseña",
          border: InputBorder.none,
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
            onRecuperacionPassword(confirmPasswordController.text);
          },
          child: const Text(
            'Cambiar Contraseña',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
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
      ),*/

      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: size.height * 0.10),
                  IconButton(
                    icon: Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                    onPressed: () {
                      // passing this to our root
                      //Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                          (context),
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (route) => false);
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.06),
              const Text(
                'CAMBIAR CONTRASEÑA',
                style: TextStyle(
                    fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.06),
              const Text(
                'Email',
                style: TextStyle(fontSize: 14, color: ColorF),
                textAlign: TextAlign.left,
              ),
              //SizedBox(height: 5),
              SizedBox(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: emailField),
                width: size.width * 0.75,
              ),
              const Text(
                'Contraseña Nueva',
                style: TextStyle(fontSize: 14, color: ColorF),
                textAlign: TextAlign.left,
              ),
              //SizedBox(height: 5),
              SizedBox(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: passwordField),
                width: size.width * 0.75,
              ),
              const Text(
                'Confirmar Contraseña Nueva',
                style: TextStyle(fontSize: 14, color: ColorF),
                textAlign: TextAlign.left,
              ),
              //SizedBox(height: 5),
              SizedBox(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: confirmPasswordField),
                width: size.width * 0.75,
              ),
              SizedBox(height: 20),
              SizedBox(
                child: signUpButton,
                width: size.width * 0.75,
              ),
              SizedBox(height: 15),
            ],
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
      Fluttertoast.showToast(
          msg: "Contraseña actualizada exitosamente",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
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
