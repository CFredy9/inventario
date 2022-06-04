import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
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
        cursorColor: ColorF,
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
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.mail,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //Boton
    final ButtonReset = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Restablecer Contraseña'),
      ),*/
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  SizedBox(height: size.height * 0.18),
                  IconButton(
                    icon: Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                    onPressed: () {
                      // passing this to our root
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.08),
              const Text(
                'RESTABLECER CONTRASEÑA',
                style: TextStyle(
                    fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.08),
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
              SizedBox(height: 20),
              SizedBox(
                child: ButtonReset,
                width: size.width * 0.75,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  void enviarCorreo(String correo) {
    if (correo.isNotEmpty) {
      Provider.of<MeProvider>(context, listen: false).enviarCorreo(correo);
      Fluttertoast.showToast(
          msg: "Correo enviado",
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => VerificacionCodigo(correo)),
          (route) => false);
    }
  }
}
