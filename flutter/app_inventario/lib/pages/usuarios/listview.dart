import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import './registro.dart';
import './information.dart';
import '../../models/usuario.dart';
import '../login/login_screen.dart';
import '../home/home_screen.dart';
import '../../api/usuario.dart';
import '../../constants.dart';
import 'package:animate_do/animate_do.dart';

class ListViewUsuarios extends StatefulWidget {
  @override
  _ListViewUsuariosState createState() => _ListViewUsuariosState();
}

class _ListViewUsuariosState extends State<ListViewUsuarios> {
  List<UsuarioModel> items = <UsuarioModel>[];
  UsuarioProvider usuarioTT = UsuarioProvider();

  @override
  void initState() {
    super.initState();
    items = <UsuarioModel>[];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    usuarioTT = Provider.of<UsuarioProvider>(context);
    print(usuarioTT.todosUsuario.length);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: ColorF,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: SlideInDown(
            duration: const Duration(seconds: 1),
            child: AppBar(
              elevation: 0,
              title: Text('Lista de Usuarios'),
              centerTitle: true,
              backgroundColor: ColorF,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
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
            child: SlideInUp(
              duration: const Duration(seconds: 1),
              child: ListView.builder(
                  itemCount: usuarioTT.todosUsuario.length,
                  padding: EdgeInsets.only(top: 3.0),
                  itemBuilder: (context, position) {
                    return Column(
                      children: <Widget>[
                        /*Divider(
                          height: 1.0,
                        ),*/
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
                                          '${usuarioTT.todosUsuario[position].First_Name} '
                                          '${usuarioTT.todosUsuario[position].Last_Name}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                      ),
                                      subtitle: Center(
                                        child: Text(
                                          '${usuarioTT.todosUsuario[position].Rol}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 21.0,
                                          ),
                                        ),
                                      ),
                                      onTap: () => _navigateToUsertInformation(
                                          context,
                                          usuarioTT.todosUsuario[position])),
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
          onPressed: () => _createNewUser(context),
        ),
      ),
    );
  }

  void _navigateToUsertInformation(
      BuildContext context, UsuarioModel usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UsuarioInformation(usuario)),
    );
  }

  void _navigateToUser(BuildContext context, UsuarioModel usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen(usuario)),
    );
  }

  void _createNewUser(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RegistrationScreen(UsuarioModel())),
    );
  }
}
