import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/usuario.dart';
import '/pages/usuarios/listview.dart';
import '/pages/usuarios/registro.dart';
import '../../api/usuario.dart';

class UsuarioInformation extends StatefulWidget {
  final UsuarioModel usuario;
  UsuarioInformation(this.usuario);
  @override
  _UsuarioInformationState createState() => _UsuarioInformationState();
}

class _UsuarioInformationState extends State<UsuarioInformation> {
  UsuarioProvider usuarioT = UsuarioProvider();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    usuarioT = Provider.of<UsuarioProvider>(context);

    //crear button
    final editar = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 3,
          onPressed: () {
            _navigateToUser(context, widget.usuario);
          },
          child: const Text(
            'Editar',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    //crear button
    final eliminar = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width / 3,
          onPressed: () {
            _showDialog(context);
          },
          child: const Text(
            'Eliminar',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Información Usuario'),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // passing this to our root
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListViewUsuarios()));
          },
        ),
      ),
      body: Center(
        child: Container(
          height: 400,
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              Card(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Text(
                        "Nombre : ${widget.usuario.First_Name}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Divider(),
                      Text(
                        "Apellido : ${widget.usuario.Last_Name}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Divider(),
                      Text(
                        "Telefono : ${widget.usuario.Phone}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Divider(),
                      Text(
                        "Email : ${widget.usuario.Email}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                      Divider(),
                      Text(
                        "Rol : ${widget.usuario.Rol}",
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  editar,
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                  ),
                  eliminar,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToUser(BuildContext context, UsuarioModel usuario) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen(usuario)),
    );
  }

  //nuevo para que pregunte antes de eliminar un registro
  void _showDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Esta seguro de querer eliminar el usuario?'),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () => _delete(
                context,
                widget.usuario,
              ),
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _delete(BuildContext context, UsuarioModel usuario) async {
    usuarioT.delete(usuario);
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ListViewUsuarios()),
      );
    });
  }
}
