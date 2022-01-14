import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
//import './estanteria/listview.dart';
import '../../models/ubicacion.dart';
import '../../api/ubicacion.dart';

class ListViewUbicacion extends StatefulWidget {
  @override
  _ListViewUbicacionState createState() => _ListViewUbicacionState();
}

class _ListViewUbicacionState extends State<ListViewUbicacion> {
  List<UbicacionModel> items = <UbicacionModel>[];
  UbicacionProvider ubicacionT = UbicacionProvider();
  @override
  void initState() {
    super.initState();
    items = <UbicacionModel>[];
    print(items);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ubicacionT = Provider.of<UbicacionProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ubicaciones'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // passing this to our root
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: ubicacionT.todosUbicacion.length,
              padding: EdgeInsets.only(top: 3.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 1.0,
                    ),
                    Container(
                      padding: new EdgeInsets.all(3.0),
                      child: Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  '${ubicacionT.todosUbicacion[position].almacen}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 21.0,
                                  ),
                                ),
                                /*subtitle: Text(
                                    '${items[position].Almacen}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 21.0,
                                    ),
                                  ), */
                                /*onTap: () => _navigateToUbicacionEstanteria(
                                      context,
                                      ubicacionT.todosUbicacion[position])*/
                              ),
                            ),
                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToUbicacion(context,
                                    ubicacionT.todosUbicacion[position])),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(
                                  context,
                                  ubicacionT.todosUbicacion[position],
                                  position),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.blueAccent,
          onPressed: () => _createNewUbicacion(context),
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, UbicacionModel ubi, position) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Esta seguro de querer eliminar este usuario?'),
          actions: <Widget>[
            TextButton(
              child: Text('Si'),
              onPressed: () => _delete(
                context,
                ubi,
                position,
              ),
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToUbicacion(
      BuildContext context, UbicacionModel ubicacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationUbicacion(ubicacion)),
    );
  }

  /*void _navigateToUbicacionEstanteria(
      BuildContext context, UbicacionModel ubicacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListViewEstanteria(ubicacion)),
    );
  }*/

  void _createNewUbicacion(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationUbicacion(UbicacionModel())),
    );
  }

  void _delete(
      BuildContext context, UbicacionModel ubicacion, int position) async {
    ubicacionT.delete(ubicacion);
    setState(() {
      Navigator.of(context).pop();
    });
  }
}
