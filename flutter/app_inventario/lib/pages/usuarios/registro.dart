import 'package:app_inventario/api/usuario.dart';
import 'package:provider/provider.dart';

import '/models/usuario.dart';
import '/pages/usuarios/information.dart';
import './listview.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationScreen extends StatefulWidget {
  final UsuarioModel usuarioModel;
  RegistrationScreen(this.usuarioModel);
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // string for displaying the error Message
  String? errorMessage;
  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController rolController = TextEditingController();
  bool bandera = true;
  List Roles = ['Administrador', 'Empleado'];
  String? valores;
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
    if (widget.usuarioModel.Id != null) {
      bandera = false;
    }
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
    //Campo apellido
    final lastnameField = TextFormField(
        autofocus: false,
        controller: lastnameController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Apellido no puede estar vacio");
          }
          return null;
        },
        onSaved: (value) {
          lastnameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Apellido",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo telefono
    final phoneField = TextFormField(
        autofocus: false,
        controller: phoneController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Telefono no puede estar vacio");
          }
          return null;
        },
        onSaved: (value) {
          phoneController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Telefono",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo Rol
    final rolField = Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButton(
          hint: Text("Seleccione el Rol"),
          value: valores,
          isExpanded: true,
          underline: SizedBox(),
          onChanged: (valorNuevo) {
            setState(() {
              valores = valorNuevo.toString();
            });
          },
          items: <String>['Administrador', 'Empleado']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
    //Campo Email
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
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
          nameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Correo Electrónico",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //Campo Contraseña
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
          hintText: "Contraseña",
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
            print(widget.usuarioModel.id);
            if (widget.usuarioModel.id != null) {
              onUpdate(widget.usuarioModel.id!);
            } else {
              onAdd();
            }
          },
          child: (widget.usuarioModel.Id != null)
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
            if (widget.usuarioModel.Id != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UsuarioInformation(widget.usuarioModel)));
            } else {
              // passing this to our root
              Navigator.of(context).pop();
            }
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
                    SizedBox(
                        height: 120,
                        child: Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        )),
                    SizedBox(height: 45),
                    nameField,
                    SizedBox(height: 20),
                    lastnameField,
                    SizedBox(height: 20),
                    phoneField,
                    SizedBox(height: 20),
                    Visibility(visible: bandera, child: rolField),
                    Visibility(visible: bandera, child: SizedBox(height: 20)),
                    Visibility(visible: bandera, child: emailField),
                    Visibility(visible: bandera, child: SizedBox(height: 20)),
                    Visibility(visible: bandera, child: passwordField),
                    Visibility(visible: bandera, child: SizedBox(height: 20)),
                    Visibility(visible: bandera, child: confirmPasswordField),
                    Visibility(visible: bandera, child: SizedBox(height: 20)),
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

  void onAdd() {
    if (nameController.text.isNotEmpty &&
        lastnameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      UsuarioModel usuario = UsuarioModel(
        first_name: nameController.text,
        last_name: lastnameController.text,
        email: emailController.text,
        username: emailController.text,
        phone: phoneController.text,
        rol: valores,
        password: confirmPasswordController.text,
      );
      Provider.of<UsuarioProvider>(context, listen: false).addUsuario(usuario);
      Fluttertoast.showToast(msg: "Usuario creado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => ListViewUsuarios()),
          (route) => false);
    }
  }

  void onUpdate(int id) {
    if (nameController.text.isNotEmpty) {
      UsuarioModel usuario = UsuarioModel(
        first_name: nameController.text,
        last_name: lastnameController.text,
        //email: emailController.text,
        //username: emailController.text,
        phone: phoneController.text,
        //rol: valores,
        //password: confirmPasswordController.text,
      );
      widget.usuarioModel.first_name = nameController.text;
      widget.usuarioModel.last_name = lastnameController.text;
      widget.usuarioModel.phone = phoneController.text;
      Provider.of<UsuarioProvider>(context, listen: false)
          .updateUsuario(widget.usuarioModel, id);
      Fluttertoast.showToast(msg: "Usuario actualizado exitosamente :) ");
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(
              builder: (context) => UsuarioInformation(widget.usuarioModel)),
          (route) => false);
    }
  }

  /*void Registrar(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {create()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  create() async {
    final User? usuario = _auth.currentUser;
    UsuarioModel userModel = UsuarioModel();
    userModel.nombre = nameEditingController.text;
    userModel.apellido = lastnameEditingController.text;
    userModel.telefono = phoneEditingController.text;
    userModel.email = usuario!.email;
    userModel.rol = valores;
    userModel.id = usuario.uid;
    userModel.contrasenia = confirmPasswordEditingController.text;
    await usuarioReference.child(usuario.uid).set({
      'nombre': userModel.nombre,
      'apellido': userModel.apellido,
      'telefono': userModel.telefono,
      'email': userModel.email,
      'contrasenia': userModel.contrasenia,
      'rol': userModel.rol,
      'id': userModel.id,
    }).then((value) => null);
    Fluttertoast.showToast(msg: "Cuenta creada exitosamente :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ListViewUsuarios()),
        (route) => false);
  }

  update(String Id) async {
    UsuarioModel usuarioModel = UsuarioModel();

    widget.usuarioModel.nombre = nameEditingController.text;
    widget.usuarioModel.apellido = lastnameEditingController.text;
    widget.usuarioModel.telefono = phoneEditingController.text;
    print('QUE TRAE ' + Id);
    await usuarioReference.reference().child(Id).update({
      'nombre': widget.usuarioModel.nombre,
      'apellido': widget.usuarioModel.apellido,
      'telefono': widget.usuarioModel.telefono,
    }).then((value) => null);
    Fluttertoast.showToast(msg: "Cambios guardados ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
            builder: (context) => UsuarioInformation(widget.usuarioModel)),
        (route) => false);
  }*/
}
