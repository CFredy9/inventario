import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/pages/login/login_screen.dart';
import 'package:app_inventario/pages/usuarios/reset.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
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
        keyboardType: TextInputType.name,
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
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Código",
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingrese código de verificación'),
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
                    codigoField,
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
        Fluttertoast.showToast(msg: "Codigo correcto ");
      } else {
        Fluttertoast.showToast(msg: "Codigo incorrecto ");
      }
    }
  }
}
