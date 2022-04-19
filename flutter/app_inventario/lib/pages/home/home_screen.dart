//import 'package:firebase_auth/firebase_auth.dart';
import 'package:animations/animations.dart';
import 'package:app_inventario/api/categoria.dart';
import 'package:app_inventario/api/producto.dart';
import 'package:app_inventario/api/usuario.dart';
import 'package:app_inventario/models/categoria.dart';
import 'package:app_inventario/widgets/animations.dart';
import 'package:app_inventario/widgets/carga.dart';
import 'package:app_inventario/widgets/category.dart';
import 'package:app_inventario/widgets/select_images.dart';
import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
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
import '../vencimiento_productos/listview.dart';
import '../../widgets/paginaCarga.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/scheduler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool bandera = false;

class _HomeScreenState extends State<HomeScreen> {
  MeProvider usuarioT = MeProvider();
  List<CategoriaModel> items = <CategoriaModel>[];
  CategoriaProvider categoriaT = CategoriaProvider();
  late bool _isLoading;
  //bool bandera = false;
  //final User? user = FirebaseAuth.instance.currentUser;
  //UserModel loggedInUser = UserModel();
  //LoginProvider loginT = LoginProvider();
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
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
            ListViewProductos(CategoriaModel())),
        /*_getItem(
            const Icon(Icons.add_location), "Ubicación", ListViewUbicacion()),*/
        _getItem(const Icon(Icons.receipt_long_outlined), "Reportes",
            ListViewVentaProductos()),
        _getItem(const Icon(Icons.receipt_long_outlined), "Balance",
            ListViewBalance()),
        _getItem(const Icon(Icons.date_range_outlined), "Vencimiento",
            VencimientoProductos()),
        //_getItem(const Icon(Icons.date_range_outlined), "Carga", Animations()),
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
    categoriaT = Provider.of<CategoriaProvider>(context);
    return Scaffold(
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          title: const Text("Welcome"),
          centerTitle: true,
          /*flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.deepPurple],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),*/
          backgroundColor: ColorF,
        ),
      ),
      drawer: _getDrawer(context),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _isLoading
                    ? Expanded(
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 100,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: 12,
                            itemBuilder: (BuildContext ctx, position) {
                              return const NewsCardSkelton();
                            }
                            /*separatorBuilder: (context, index) =>
                              const SizedBox(height: defaultPadding),*/
                            ),
                      )
                    : Expanded(
                        child: SlideInLeft(
                          duration: Duration(seconds: 1),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 100,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: categoriaT.todos.length,
                              itemBuilder: (BuildContext ctx, position) {
                                return CategoryCard(
                                  title: '${categoriaT.todos[position].Nombre}',
                                  image: (categoriaT.todos[position].Imagen !=
                                              null &&
                                          categoriaT.todos[position].Imagen !=
                                              "")
                                      ? '${categoriaT.todos[position].Imagen}'
                                      : 'http://${apiUrl}:8000/media/images/random.png',
                                  press: () {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ListViewProductos(
                                                  categoriaT.todos[position])),
                                    );*/
                                    navigateToProduct(
                                        categoriaT.todos[position].Id
                                            .toString(),
                                        position);
                                  },
                                );
                              }),
                        ),
                      ),
                /*SizedBox(
                  height: 150,
                  child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                ),*/
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
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
      ),
    );
  }

  Future<void> navigateToProduct(String id, int position) async {
    bool istoken = await Provider.of<ProductoProvider>(context, listen: false)
        .getProducto(id);
    if (istoken) {
      //Provider.of<GastosProvider>(context, listen: false).getGasto();
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ListViewProductos(categoriaT.todos[position])),
      );
    }
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

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Skeleton(height: 100, width: 100),
      ],
    );
  }
}
