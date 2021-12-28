class UsuarioModel {
  int? id;
  String? email;
  String? username;
  String? first_name;
  String? last_name;
  String? phone;
  String? rol;
  String? password;

  UsuarioModel(
      {this.id,
      this.email,
      this.username,
      this.first_name,
      this.last_name,
      this.phone,
      this.rol,
      this.password});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      phone: json['phone'],
      rol: json['rol'],
      password: json['password'],
    );
  }

  int? get Id => id;
  String? get Email => email;
  String? get First_Name => first_name;
  String? get Last_Name => last_name;
  String? get Phone => phone;
  String? get Rol => rol;

  //UbicacionModel? get Almacen => almacen;

  dynamic toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'first_name': first_name,
        'last_name': last_name,
        'phone': phone,
        'rol': rol,
        'password': password
      };
}
