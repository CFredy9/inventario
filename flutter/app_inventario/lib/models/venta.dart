import 'ubicacion.dart';

class VentaModel {
  int? id;
  var detalleproducto;
  int? fardos;
  String? total_costo;
  String? total_venta;
  String? ganancia;

  VentaModel(
      {this.id,
      this.detalleproducto,
      this.fardos,
      this.total_costo,
      this.total_venta,
      this.ganancia});

  factory VentaModel.fromJson(Map<String, dynamic> json) {
    return VentaModel(
        id: json['id'],
        detalleproducto: json['detalleproducto'],
        fardos: json['fardos'],
        total_costo: json['total_costo'],
        total_venta: json['total_venta'],
        ganancia: json['ganancia']);
  }

  int? get Id => id;
  int? get Fardos => fardos;
  String? get Total_Costo => total_costo;
  String? get Total_Venta => total_venta;
  String? get Ganancia => ganancia;
  //UbicacionModel? get Almacen => almacen;

  dynamic toJson() => {
        'id': id,
        'detalleproducto': detalleproducto,
        'fardos': fardos,
        'total_costo': total_costo,
        'total_venta': total_venta,
        'ganancia': ganancia,
      };
}
