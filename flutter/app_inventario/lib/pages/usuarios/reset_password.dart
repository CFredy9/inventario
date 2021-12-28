import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import './verificacion_codigo.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class VerificarCorreo extends StatefulWidget {
  @override
  _VerificarCorreoState createState() => _VerificarCorreoState();
}

class _VerificarCorreoState extends State<VerificarCorreo> {
  // form key
  final _formKey = GlobalKey<FormState>();
  String? _email;
  TextEditingController emailController = TextEditingController();
  //final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Boton
    final ButtonReset = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            enviarCorreo(emailController.text);
            //auth.sendPasswordResetEmail(email: emailController.text);
            //Navigator.of(context).pop();
          },
          child: Text(
            'Enviar Correo',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 150,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    ButtonReset,
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

  void enviarCorreo(String correo) {
    if (correo.isNotEmpty) {
      Provider.of<MeProvider>(context, listen: false).enviarCorreo(correo);
      Fluttertoast.showToast(msg: "Correo enviado ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => VerificacionCodigo(correo)),
          (route) => false);
    }
  }
}
