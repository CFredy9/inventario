//import 'package:firebase_database/firebase_database.dart';
import 'package:app_inventario/constants.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:app_inventario/widgets/category.dart';
import 'package:app_inventario/widgets/select_images.dart';
import 'package:app_inventario/widgets/images_category.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
import 'listview.dart';
import '../../models/categoria.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../api/categoria.dart';
import 'package:scroll_indicator/scroll_indicator.dart';

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
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController = ScrollController();
    nameController = TextEditingController(text: widget.categoriaModel.Nombre);
    (widget.categoriaModel.Imagen != null)
        ? imagenubi = widget.categoriaModel.Imagen
        : imagenubi = "";
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
            return ("Categoría no puede estar vacio");
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
            Icons.category,
            color: ColorF,
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Categoria",
          border: InputBorder.none,
          /*border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),*/
        ));
    //crear button
    final registrarButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: ColorF,
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),*/
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: [
                    SizedBox(height: size.height * 0.18),
                    IconButton(
                      icon:
                          Icon(Icons.reply_all_sharp, color: ColorF, size: 30),
                      onPressed: () {
                        // passing this to our root
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.08),
                const Text(
                  'CATEGORIA',
                  style: TextStyle(
                      fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                ButtonWidget(
                  onClicked: () => Utils.showSheet(
                    context,
                    child: Home(),
                    onClicked: () {
                      //final value = DateFormat('yyyy/MM/dd').format(dateTime);
                      //Utils.showSnackBar(context, 'Selected "$value"');

                      var fechaFinal;
                      setState(() {});

                      //productoT.getVentaProducto(value, fechaFinal.toString());
                      //productoT.getTotales(value, fechaFinal.toString());

                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.08),
                const Text(
                  'Nombre de Categoria',
                  style: TextStyle(fontSize: 14, color: ColorF),
                  textAlign: TextAlign.left,
                ),
                //SizedBox(height: 5),
                SizedBox(
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: PrimaryLightColor,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: nameField),
                  width: size.width * 0.75,
                ),
                if (imagenubi != "")
                  SizedBox(
                    child: Image(
                      //image: AssetImage(imagenubi!),
                      image: NetworkImage(imagenubi!),
                      height: 80,
                    ),
                  ),
                SizedBox(height: 20),
                SizedBox(
                  child: registrarButton,
                  width: size.width * 0.75,
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onAdd() {
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    final String textVal = nameController.text;
    if (nameController.text.isNotEmpty) {
      CategoriaModel categoria =
          CategoriaModel(nombre: nameController.text, imagen: imagenubi);
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
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    if (nameController.text.isNotEmpty) {
      final CategoriaModel categoria =
          CategoriaModel(nombre: nameController.text, imagen: imagenubi);
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
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    CategoriaModel cateModel = CategoriaModel();
    cateModel.nombre = nameController.text;
    cateModel.imagen = imagenubi;
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
    var isvalid = _formKey.currentState!.validate();
    if (!isvalid) {
      return;
    }
    _formKey.currentState!.save();
    CategoriaModel cateModel = CategoriaModel();
    cateModel.nombre = nameController.text;
    cateModel.imagen = imagenubi;
    /*await categoriaReference.reference().child(Id).update({
      'nombre': cateModel.nombre,
    }).then((value) => null);*/
    Fluttertoast.showToast(msg: "Cambios guardados ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ListViewCategorias()),
        (route) => false);
  }

  int optionSelected = 0;

  void checkOption(int index) {
    setState(() {
      optionSelected = index;
      print(index);
    });
  }

  /*Widget Picker() => Container(
        //color: Colors.transparent,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: SizedBox(
          height: 550,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                /*Expanded(
                  child: IconButton(
                    icon: const Icon(
                      Icons.cloud_upload_outlined,
                      size: 40,
                      color: ColorF,
                    ),
                    onPressed: () {},
                  ),
                ),*/
                /*Text(
                  'Elija una opción...',
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: ColorF,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),*/
                Expanded(
                  child: GridView.count(
                    controller: scrollController,
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      for (int i = 0; i < images.length; i++)
                        CategoryCard(
                          title: images[i]['title'] as String,
                          image: images[i]['image'] as String,
                          press: () {
                            checkOption(i + 1);
                            imagenubi = images[i]['imagen'];
                          },
                          isSelect: i + 1 == optionSelected,
                        ),
                    ],
                  ),
                ),
                ScrollIndicator(
                  scrollController: scrollController,
                  width: 150,
                  height: 5,
                  indicatorWidth: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300]),
                  indicatorDecoration: BoxDecoration(
                      color: ColorF, borderRadius: BorderRadius.circular(10)),
                ),
              ],
            ),
          ),
        ),
      );*/
}

class ButtonWidget extends StatefulWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(
          Icons.cloud_upload_outlined,
          size: 40,
          color: ColorF,
        ),
        onPressed: widget.onClicked,
      );
}
