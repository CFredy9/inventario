import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../../constants.dart';
import './listview.dart';
import '/models/credito.dart';
import '/models/detalle_credito.dart';
import '/models/abono_credito.dart';
import '../../../api/capital.dart';
import '../../home/home_screen.dart';
//import './detallegastos/registro.dart';
import 'package:animate_do/animate_do.dart';
import 'package:unicorndial/unicorndial.dart';

class ListviewCapital extends StatefulWidget {
  @override
  _ListviewCapitalState createState() => _ListviewCapitalState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _ListviewCapitalState extends State<ListviewCapital> {
  CapitalProvider capitalT = CapitalProvider();
  bool bandera = false;
  late bool _isLoading;
  @override
  void initState() {
    _isLoading = true;
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    capitalT = Provider.of<CapitalProvider>(context);
    //creditoT = Provider.of<CreditoProvider>(context);
    if (bandera == false) {
      capitalT.getTotales();
      //creditoT.getCredito();
      bandera = true;
    }
    return Scaffold(
      backgroundColor: ColorF,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: SlideInLeft(
          duration: const Duration(seconds: 1),
          child: AppBar(
            elevation: 0,
            title: Text('CAPITAL'),
            backgroundColor: ColorF,
            /*flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.deepPurple],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),*/
            leading: IconButton(
              icon: Icon(Icons.home, color: Colors.white),
              onPressed: () {
                // passing this to our root
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
              },
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Center(
          child: _isLoading
              ? ListView.separated(
                  itemCount: 1,
                  itemBuilder: (context, index) => const NewsCardSkelton(),
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                )
              : SlideInRight(
                  duration: const Duration(seconds: 1),
                  child: Container(
                    //height: 250,
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                )),
                            height: 300,
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Capital',
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.blue),
                                            ),
                                            Text(
                                              'Q. ${capitalT.totales['capital']}',
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Total en Productos',
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.green),
                                            ),
                                            Text(
                                              'Q. ${capitalT.totales['total_costo']}',
                                              style: const TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 30,
                                ),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        const Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                        ),
                                        Column(
                                          children: [
                                            const Text(
                                              'Total en Créditos',
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.red),
                                            ),
                                            Text(
                                              'Q. ${capitalT.totales['total_credito']}',
                                              style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const <Widget>[
        Skeleton(height: 100, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 100, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 100, width: 315),
        SizedBox(height: 10),
        Skeleton(height: 100, width: 315),
      ],
    );
  }
}
