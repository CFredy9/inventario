import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '/pages/home/home_screen.dart';
import 'dart:async';
import 'registro.dart';
import '../../api/categoria.dart';
import 'package:animate_do/animate_do.dart';

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
  String? SearchC = '';
  String orderC = '';
  int orderCNumber = 2;
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

    final Buscador = Container(
      height: 40,
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(29.5),
      ),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: "Buscar",
          //icon: SvgPicture.asset("assets/icons/search.svg"),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          categoriaT.searchCategoria(value, 'nombre');
          SearchC = value;
        },
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorF,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(125.0),
          child: SlideInDown(
            duration: const Duration(seconds: 1),
            child: Column(
              children: [
                AppBar(
                  elevation: 0,
                  title: Text('Lista de Categorias'),
                  centerTitle: true,
                  backgroundColor: ColorF,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      categoriaT.getCategoria();
                      // passing this to our root
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.65,
                        //child: SearchBar()),
                        child: Buscador),
                    IconButton(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: () {
                          if (orderCNumber == 1) {
                            orderC = 'nombre';
                            orderCNumber = 2;
                          } else if (orderCNumber == 2) {
                            orderC = '-nombre';
                            orderCNumber = 1;
                          }

                          categoriaT.searchCategoria(SearchC, orderC);
                        }),
                  ],
                ),
              ],
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
            child: SlideInUp(
              duration: const Duration(seconds: 1),
              child: ListView.builder(
                  itemCount: categoriaT.todos.length,
                  padding: EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(50),
                              )),
                          padding: new EdgeInsets.all(3.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: ListTile(
                                      title: Center(
                                        child: Text(
                                          '${categoriaT.todos[position].nombre}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                      ),
                                      onTap: () => _navigateToCategoria(
                                          context, categoriaT.todos[position])),
                                ),
                                //onPressed: () => _deleteProduct(context, items[position],position)),
                                IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: ColorF,
                                    ),
                                    onPressed: () => _navigateToCategoria(
                                        context, categoriaT.todos[position])),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: ColorF,
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
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: ColorF,
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
