import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:app_inventario/pages/usuarios/reset.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class VerificacionCodigo extends StatefulWidget {
  String? correo;
  VerificacionCodigo(this.correo);
  @override
  _VerificacionCodigoState createState() => _VerificacionCodigoState();
}

class _VerificacionCodigoState extends State<VerificacionCodigo> {
  LocalStorage codigoT = LocalStorage('usercodigo');
  // form key
  final _formKey = GlobalKey<FormState>();
  TextEditingController codigoController = TextEditingController();
  //final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final codigoField = TextFormField(
        autofocus: false,
        controller: codigoController,
        keyboardType: TextInputType.number,
        cursorColor: ColorF,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Codigo no puede estar vacio");
          }
          if (!regex.hasMatch(value)) {
            return ("Ingrese un código valido (6 caracteres)");
          }
          return null;
        },
        onSaved: (value) {
          codigoController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Código",
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
            verificarCodigo(codigoController.text);
            //auth.sendPasswordResetEmail(email: emailController.text);
            //Navigator.of(context).pop();
          },
          child: const Text(
            'Verificar Código',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      /*appBar: AppBar(
        title: const Text('Ingrese código de verificación'),
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
              SizedBox(height: size.height * 0.08),
              const Text(
                'INGRESE CÓDIGO DE VERIFICACIÓN',
                style: TextStyle(
                    fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: size.height * 0.08),
              const Text(
                'Código',
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
                    child: codigoField),
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

  void verificarCodigo(String codigo) {
    if (codigo.isNotEmpty) {
      //Provider.of<MeProvider>(context, listen: false).verificarCodigo(codigo);
      print(codigoT.getItem('codigo'));
      if (codigo == codigoT.getItem('codigo')) {
        Navigator.pushAndRemoveUntil(
            (context),
            MaterialPageRoute(
                builder: (context) => ResetPassword(widget.correo)),
            (route) => false);
        Fluttertoast.showToast(
            msg: "Código correcto",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Código incorrecto",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
