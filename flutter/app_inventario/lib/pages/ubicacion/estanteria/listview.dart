import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'registro.dart';
import '../listview.dart';
import '../../../models/estanteria.dart';
import '../../../models/ubicacion.dart';
import '../../../api/estanteria.dart';

class ListViewEstanteria extends StatefulWidget {
  final UbicacionModel _ubicacionModel;
  ListViewEstanteria(this._ubicacionModel);
  @override
  _ListViewEstanteriaState createState() => _ListViewEstanteriaState();
}

class _ListViewEstanteriaState extends State<ListViewEstanteria> {
  List<EstanteriaModel> items = <EstanteriaModel>[];
  var items2;
  EstanteriaProvider estanteriaT = EstanteriaProvider();
  String? valores;
  bool bandera = false;
  @override
  void initState() {
    super.initState();
    items = <EstanteriaModel>[];
    print(items);
    //estanteriaT.getEstanteria(widget._ubicacionModel.Id.toString());
    //valores = widget._ubicacionModel.Id;
    estanteriaT = EstanteriaProvider();
    //returnId();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    estanteriaT = Provider.of<EstanteriaProvider>(context);
    if (bandera == false || estanteriaT.todosEstanteria.isEmpty) {
      estanteriaT.getEstanteria(widget._ubicacionModel.Id.toString());
      bandera = true;
    }
    //items2 = Provider.of<EstanteriaProvider>(context).getEstanteria(widget._ubicacionModel.Id.toString());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Estanteria'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // passing this to our root
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListViewUbicacion()));
            },
          ),
        ),
        body: Center(
          child: ListView.builder(
              itemCount: estanteriaT.todosEstanteria.length,
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
                                    '${estanteriaT.todosEstanteria[position].estanteria}',
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
                                  onTap: () => _navigateToEstanteria(
                                      context,
                                      estanteriaT.todosEstanteria[position],
                                      widget._ubicacionModel)),
                            ),
                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToEstanteria(
                                    context,
                                    estanteriaT.todosEstanteria[position],
                                    widget._ubicacionModel)),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(
                                  context,
                                  estanteriaT.todosEstanteria[position],
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
          onPressed: () => _createNewCategoria(context, widget._ubicacionModel),
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, EstanteriaModel estan, position) {
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
                estan,
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

  void _navigateToEstanteria(BuildContext context, EstanteriaModel estanteria,
      UbicacionModel ubicacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationEstanteria(estanteria, ubicacion)),
    );
  }

  void _createNewCategoria(
      BuildContext context, UbicacionModel ubicacion) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              RegistrationEstanteria(EstanteriaModel(), ubicacion)),
    );
  }

  void _delete(
      BuildContext context, EstanteriaModel estanteria, int position) async {
    estanteriaT.delete(estanteria);
    setState(() {
      Navigator.of(context).pop();
    });
  }
}
