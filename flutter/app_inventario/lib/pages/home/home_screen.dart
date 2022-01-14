//import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_inventario/api/usuario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../usuarios/listview.dart';
import '../usuarios/perfil.dart';
import '../categorias/listview.dart';
import '../gastos/listview.dart';
import '../../api/login.dart';
import '../productos/listview.dart';
import '../ubicacion/listview.dart';
import '../login/login_screen.dart';
import '../venta/listview.dart';
import '../reportes/listview.dart';
import '../reportes/balance/listview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool bandera = false;

class _HomeScreenState extends State<HomeScreen> {
  MeProvider usuarioT = MeProvider();
  //bool bandera = false;
  //final User? user = FirebaseAuth.instance.currentUser;
  //UserModel loggedInUser = UserModel();
  //LoginProvider loginT = LoginProvider();
  @override
  void initState() {
    super.initState();
    bandera = false;
    /*FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    }); */
  }

  Drawer _getDrawer(BuildContext context) {
    var header = DrawerHeader(
      child: ListTile(
          title: Text("Perfil"),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PerfilScreen(usuarioT.Me)));
          }),
    );
    var info = const AboutListTile(
        child: Text("Información App"),
        applicationIcon: Icon(Icons.favorite),
        applicationVersion: "v1.0.0",
        applicationName: "Inventarios",
        icon: Icon(Icons.info));
    ListTile _getItem(Icon icon, String description, Widget route) {
      return ListTile(
        leading: icon,
        title: Text(description),
        onTap: () {
          setState(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => route));
          });
        },
      );
    }

    ListView listView = ListView(
      children: <Widget>[
        //ListTile(
        //  leading: Icon(Icons.settings),
        //  title: Text("Configuracin"),
        //),
        header,
        _getItem(const Icon(Icons.home), "Página Principal", HomeScreen()),
        _getItem(
            const Icon(Icons.account_circle), "Usuarios", ListViewUsuarios()),
        _getItem(
            const Icon(Icons.category), "Categorias", ListViewCategorias()),
        _getItem(const Icon(Icons.money), "Gastos", ListViewGastos()),
        _getItem(const Icon(Icons.money), "Ventas", ListViewVenta()),
        _getItem(const Icon(Icons.production_quantity_limits), "Productos",
            ListViewProductos()),
        /*_getItem(
            const Icon(Icons.add_location), "Ubicación", ListViewUbicacion()),*/
        _getItem(const Icon(Icons.receipt_long_outlined), "Reportes",
            ListViewVentaProductos()),
        _getItem(const Icon(Icons.receipt_long_outlined), "Balance",
            ListViewBalance()),
        info,
      ],
    );
    return Drawer(
      child: listView,
    );
  }

  @override
  Widget build(BuildContext context) {
    usuarioT = Provider.of<MeProvider>(context);
    if (bandera == false && usuarioT.Me != null) {
      print('Entra');
      usuarioT.getMe();
      bandera = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
      ),
      drawer: _getDrawer(context),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 150,
                child: Image.asset("assets/logo.png", fit: BoxFit.contain),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              /*Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),
              Text("${loggedInUser.email}",
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  )),*/
              SizedBox(
                height: 15,
              ),
              ActionChip(
                  label: Text("Logout"),
                  onPressed: () {
                    logout(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    bool logout =
        await Provider.of<LoginProvider>(context, listen: false).logOut();
    //await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
