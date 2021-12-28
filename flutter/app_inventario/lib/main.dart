import 'package:app_inventario/pages/home/home_screen.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'api/categoria.dart';
import 'api/gastos.dart';
import 'api/ubicacion.dart';
import 'api/estanteria.dart';
import 'api/producto.dart';
import 'api/detalle_producto.dart';
import 'api/usuario.dart';
import 'api/login.dart';
import 'api/venta.dart';
import 'api/reportes.dart';
import '/pages/login/login_screen.dart';
import 'package:flutter/material.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
} */

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalStorage storage = LocalStorage('usertoken');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoriaProvider()),
        ChangeNotifierProvider(create: (context) => GastosProvider()),
        ChangeNotifierProvider(create: (context) => UbicacionProvider()),
        ChangeNotifierProvider(create: (context) => EstanteriaProvider()),
        ChangeNotifierProvider(create: (context) => ProductoProvider()),
        ChangeNotifierProvider(create: (context) => DetalleProductoProvider()),
        ChangeNotifierProvider(create: (context) => UsuarioProvider()),
        ChangeNotifierProvider(create: (context) => MeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => VentaProvider()),
        ChangeNotifierProvider(create: (context) => ReportesProvider()),
      ],
      child: MaterialApp(
        title: 'Tienda Kairos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder(
          future: storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            print(storage.getItem('token'));

            if (storage.getItem('token') == null) {
              return LoginScreen();
            }
            return HomeScreen();
          },
        ),
      ),
    );
    /*return MaterialApp(
      title: 'Email And Password Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: ListViewCategorias(),
    ); */
  }
}
