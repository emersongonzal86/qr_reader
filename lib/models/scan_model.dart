import 'dart:convert';

ScanModel scanModelFromMap(String str) => ScanModel.fromMap(json.decode(str));

String scanModelToMap(ScanModel data) => json.encode(data.toMap());

class ScanModel {
  int id;
  String tipo;
  String valor;

  ScanModel({
    required this.id,
    required this.tipo,
    required this.valor,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };
}
