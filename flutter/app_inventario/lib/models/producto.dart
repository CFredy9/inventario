class ProductoModel {
  int? id;
  String? nombre;
  int? unidadesFardo;
  int? existenciasT;
  int? fardos;
  String? total_costo;
  String? total_venta;
  String? ganancia;
  var categoria;

  ProductoModel(
      {this.id,
      this.nombre,
      this.unidadesFardo,
      this.existenciasT,
      this.fardos,
      this.total_costo,
      this.total_venta,
      this.ganancia,
      this.categoria});

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    return ProductoModel(
        id: json['id'],
        nombre: json['nombre'],
        unidadesFardo: json['unidadesFardo'],
        existenciasT: json['existenciasT'],
        fardos: json['fardos'],
        total_costo: json['total_costo'],
        total_venta: json['total_venta'],
        ganancia: json['ganancia'],
        categoria: json['categoria']);
  }

  int? get Id => id;
  String? get Nombre => nombre;
  int? get UnidadesFardo => unidadesFardo;
  int? get ExistenciasT => existenciasT;
  int? get Fardos => fardos;
  String? get Total_Costo => total_costo;
  String? get Total_Venta => total_venta;
  String? get Ganancia => ganancia;

  dynamic toJson() => {
        'id': id,
        'nombre': nombre,
        'unidadesFardo': unidadesFardo,
        'existenciasT': existenciasT,
        'fardos': fardos,
        'total_costo': total_costo,
        'total_venta': total_venta,
        'ganancia': ganancia,
        'categoria': categoria
      };
}
