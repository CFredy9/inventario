class DetalleProductoModel {
  int? id;
  var producto;
  String? precio_costo; //Por el momento en String
  String? precio_venta; //Por el momento en String
  int? existencias;
  String? vencimiento;
  var almacen;
  //var estanteria;

  DetalleProductoModel({
    this.id,
    this.producto,
    this.precio_costo,
    this.precio_venta,
    this.existencias,
    this.vencimiento,
    this.almacen,
  });

  factory DetalleProductoModel.fromJson(Map<String, dynamic> json) {
    return DetalleProductoModel(
      id: json['id'],
      producto: json['producto'],
      precio_costo: json['precio_costo'],
      precio_venta: json['precio_venta'],
      existencias: json['existencias'],
      vencimiento: json['vencimiento'],
      almacen: json['almacen'],
      //estanteria: json['estanteria']
    );
  }

  int? get Id => id;
  String? get Precio_Costo => precio_costo;
  String? get Precio_Venta => precio_venta;
  int? get Existencias => existencias;
  String? get Vencimiento => vencimiento;

  dynamic toJson() => {
        'id': id,
        'producto': producto,
        'precio_costo': precio_costo,
        'precio_venta': precio_venta,
        'existencias': existencias,
        'vencimiento': vencimiento,
        'almacen': almacen,
        //'estanteria': estanteria
      };
}
