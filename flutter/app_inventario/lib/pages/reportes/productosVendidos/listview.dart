import 'package:app_inventario/widgets/skeleton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_database/firebase_database.dart';
import '../../../constants.dart';
import '../../../utils.dart';
import './listview.dart';
import '/models/credito.dart';
import '/models/detalle_credito.dart';
import '/models/abono_credito.dart';
import '../../../api/reportes.dart';
import '../../home/home_screen.dart';
//import './detallegastos/registro.dart';
import 'package:animate_do/animate_do.dart';
import 'package:unicorndial/unicorndial.dart';

class ListViewProductosVendidos extends StatefulWidget {
  @override
  _ListViewProductosVendidosState createState() =>
      _ListViewProductosVendidosState();
}

//final usuarioReferencia = FirebaseDatabase.instance.reference().child('Gasto');

class _ListViewProductosVendidosState extends State<ListViewProductosVendidos> {
  ReportesProvider productosT = ReportesProvider();
  bool bandera = false;
  DateTime dateTime = DateTime.now();
  String valorFecha = "";
  int posFecha = DateTime.now().month;
  late bool _isLoading;
  @override
  void initState() {
    super.initState();
    _isLoading = true;
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isLoading = false;
      });
    });

    int dia = DateTime.now().day;
    dateTime = dateTime.subtract(Duration(days: (dia - 1)));
    print(posFecha);
    nombreMes();
  }

  @override
  Widget build(BuildContext context) {
    productosT = Provider.of<ReportesProvider>(context);
    //creditoT = Provider.of<CreditoProvider>(context);
    if (bandera == false) {
      String fechaInicio = DateFormat('yyyy/MM/dd').format(dateTime).toString();
      var fechaFinal = dateTime.year.toString() +
          '/' +
          (dateTime.month + 1).toString() +
          '/' +
          dateTime.day.toString();
      productosT.getProductoVendidoFardos(fechaInicio, fechaFinal);
      productosT.getProductoVendidoGanancia(fechaInicio, fechaFinal);
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
            title: Text('PRODUCTOS VENDIDOS'),
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
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonWidget(
                            onClicked: () => Utils.showSheet(
                              context,
                              child: buildDatePicker(),
                              onClicked: () {
                                final value =
                                    DateFormat('yyyy/MM/dd').format(dateTime);
                                //Utils.showSnackBar(context, 'Selected "$value"');

                                var fechaFinal;
                                setState(() {
                                  posFecha = dateTime.month;
                                  nombreMes();
                                  print(dateTime.month);
                                  if (dateTime.month == 12) {
                                    fechaFinal =
                                        (dateTime.year + 1).toString() +
                                            '/' +
                                            '1' +
                                            '/' +
                                            dateTime.day.toString();
                                  } else {
                                    fechaFinal = dateTime.year.toString() +
                                        '/' +
                                        (dateTime.month + 1).toString() +
                                        '/' +
                                        dateTime.day.toString();
                                  }
                                });

                                print(value);

                                productosT.getProductoVendidoFardos(
                                    value, fechaFinal.toString());
                                productosT.getProductoVendidoGanancia(
                                    value, fechaFinal.toString());

                                Navigator.of(context, rootNavigator: true)
                                    .pop('dialog');
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Text('${valorFecha}',
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: ColorF,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              )),
                          height: 70,
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Text(
                                    'Productos Más Vendidos',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            itemCount: productosT
                                .todosProductosVendidosCantidad.length,
                            padding: EdgeInsets.only(top: 1.0),
                            itemBuilder: (context, position) {
                              return Column(
                                children: <Widget>[
                                  /*Divider(
                                    height: 1.0,
                                  ),*/
                                  Container(
                                    padding: new EdgeInsets.all(1.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${productosT.todosProductosVendidosCantidad[position].Nombre}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            icon: const Icon(
                                                              Icons.inventory,
                                                              color: ColorF,
                                                              size: 16,
                                                            ),
                                                            onPressed: () {}),
                                                        Text(
                                                          '${(productosT.todosProductosVendidosCantidad[position].Fardos == null) ? productosT.todosProductosVendidosCantidad[position].fardos = 0 : productosT.todosProductosVendidosCantidad[position].Fardos}',
                                                          style: TextStyle(
                                                            color: ColorF,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                      Center(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              )),
                          height: 70,
                          padding: const EdgeInsets.all(5.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: Column(
                                children: const <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                  ),
                                  Text(
                                    'Productos con Mayor Ganancia',
                                    style: TextStyle(
                                        fontSize: 20.0, color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 200,
                        child: ListView.builder(
                            itemCount: productosT
                                .todosProductosVendidosGanancia.length,
                            padding: EdgeInsets.only(top: 1.0),
                            itemBuilder: (context, position) {
                              return Column(
                                children: <Widget>[
                                  /*Divider(
                                    height: 1.0,
                                  ),*/
                                  Container(
                                    padding: new EdgeInsets.all(1.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: ListTile(
                                              title: Center(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${productosT.todosProductosVendidosGanancia[position].Nombre}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .monetization_on_outlined,
                                                              color: ColorF,
                                                              size: 20,
                                                            ),
                                                            onPressed: () {}),
                                                        Text(
                                                          '${(productosT.todosProductosVendidosGanancia[position].Ganancia == null) ? productosT.todosProductosVendidosGanancia[position].ganancia = "0" : productosT.todosProductosVendidosGanancia[position].Ganancia}',
                                                          style: TextStyle(
                                                            color: ColorF,
                                                            fontSize: 16.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void nombreMes() {
    List mes = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    valorFecha = mes[posFecha - 1] + ' ' + dateTime.year.toString();
  }

  Widget buildDatePicker() => SizedBox(
        height: 180,
        child: CupertinoTheme(
          data: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(
              dateTimePickerTextStyle: TextStyle(
                  fontSize: 18,
                  color: ColorF,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
          ),
          child: CupertinoDatePicker(
            backgroundColor: Colors.white,
            minimumYear: 2015,
            maximumYear: DateTime.now().year,
            initialDateTime: dateTime,
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (dateTime) =>
                setState(() => this.dateTime = dateTime),
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
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: Size(50, 42), primary: Colors.white),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 40,
              color: ColorF,
            ),
          ],
        ),
        onPressed: onClicked,
      );
}

class NewsCardSkelton extends StatelessWidget {
  const NewsCardSkelton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Skeleton(height: 60, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 100, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: size.width * 0.9),
        const SizedBox(height: 10),
        Skeleton(height: 40, width: 315),
      ],
    );
  }
}
