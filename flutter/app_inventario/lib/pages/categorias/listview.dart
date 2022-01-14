import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import '../../api/categoria.dart';

//import 'package:crud_firebase/ui/product_information.dart';
import '../../models/categoria.dart';

class ListViewCategorias extends StatefulWidget {
  @override
  _ListViewCategoriasState createState() => _ListViewCategoriasState();
}

class _ListViewCategoriasState extends State<ListViewCategorias> {
  List<CategoriaModel> items = <CategoriaModel>[];
  //final categoriaT = Provider.of<CategoriaProvider>;
  CategoriaProvider categoriaT = CategoriaProvider();
  @override
  void initState() {
    super.initState();
    items = <CategoriaModel>[];
    //categoriaT = null;
    //categoriaT = categoriaT.getCategoria();
    //final items2 = Provider.of<CategoriaProvider>(context);
  }

  @override
  void dispose() {
    super.dispose();
    //categoriaAddedSubscription!.cancel();
    //categoriaChangedSubscription!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    categoriaT = Provider.of<CategoriaProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Categorias'),
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
              itemCount: categoriaT.todos.length,
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
                                    '${categoriaT.todos[position].nombre}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                    ),
                                  ),
                                  onTap: () => _navigateToCategoria(
                                      context, categoriaT.todos[position])),
                            ),
                            //onPressed: () => _deleteProduct(context, items[position],position)),
                            IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blueAccent,
                                ),
                                onPressed: () => _navigateToCategoria(
                                    context, categoriaT.todos[position])),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => _showDialog(context,
                                  categoriaT.todos[position], position),
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
          onPressed: () => _createNewCategoria(context),
        ),
      ),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context, CategoriaModel cate, position) {
    print(cate.id);
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
                cate,
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

  void _navigateToCategoria(
      BuildContext context, CategoriaModel categoria) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationCategoria(categoria)),
    );
  }

  void _createNewCategoria(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationCategoria(CategoriaModel())),
    );
  }

  void _delete(
      BuildContext context, CategoriaModel categoria, int position) async {
    categoriaT.deleteTodo(categoria);
    setState(() {
      Navigator.of(context).pop();
    });
  }
}