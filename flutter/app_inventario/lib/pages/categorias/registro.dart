//import 'package:firebase_database/firebase_database.dart';
import 'package:app_inventario/constants.dart';
import 'package:app_inventario/widgets/background.dart';
import 'package:app_inventario/widgets/category.dart';
import 'package:provider/provider.dart';
import '../../utils.dart';
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
                'CATEGORIA',
                style: TextStyle(
                    fontSize: 18, color: ColorF, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              ButtonWidget(
                onClicked: () => Utils.showSheet(
                  context,
                  child: Picker(),
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: PrimaryLightColor,
                      borderRadius: BorderRadius.circular(29),
                    ),
                    child: nameField),
                width: size.width * 0.75,
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

  Widget Picker() => Container(
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
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      CategoryCard(
                        title: "Aceite",
                        image: "assets/aceite.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Arroz",
                        image: "assets/arroz.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Atoles",
                        image: "assets/atole.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Azúcar",
                        image: "assets/azucar.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Jabón",
                        image: "assets/barra-de-jabon.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Caja",
                        image: "assets/caja.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Cereal",
                        image: "assets/cereal.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Chocolate",
                        image: "assets/chocolate.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Chocolate 2",
                        image: "assets/chocolate2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Desechable",
                        image: "assets/desechable.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Detergente",
                        image: "assets/detergente.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Detergente 2",
                        image: "assets/detergente2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Fideo",
                        image: "assets/fideo.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Frijol",
                        image: "assets/frijol.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Frijol 2",
                        image: "assets/frijol2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Frutas",
                        image: "assets/frutas.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Galleta",
                        image: "assets/galletas2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Galleta 2",
                        image: "assets/galletas2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Gaseosa",
                        image: "assets/gaseosa.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Gaseosa 2",
                        image: "assets/gaseosa2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Golosinas",
                        image: "assets/golosinas.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Huevos",
                        image: "assets/huevos.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Jabón",
                        image: "assets/jabon.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Jugo",
                        image: "assets/jugo.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Leche",
                        image: "assets/leche.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Leche2",
                        image: "assets/leche2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Limpieza",
                        image: "assets/limpieza.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Maíz",
                        image: "assets/maiz.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Miel",
                        image: "assets/miel.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Pañal",
                        image: "assets/panal.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Pan de Molde",
                        image: "assets/pan-de-molde.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Papel",
                        image: "assets/papel-higienico.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Papel 2",
                        image: "assets/papel-higienico2.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Random",
                        image: "assets/random.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Shampoo",
                        image: "assets/shampoo.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Verduras",
                        image: "assets/verdura.png",
                        press: () {},
                      ),
                      CategoryCard(
                        title: "Verduras 2",
                        image: "assets/verdura2.png",
                        press: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class ButtonWidget extends StatelessWidget {
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IconButton(
        icon: const Icon(
          Icons.cloud_upload_outlined,
          size: 40,
          color: ColorF,
        ),
        onPressed: onClicked,
      );
}
