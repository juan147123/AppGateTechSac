// To parse this JSON data, do
//
//     final empresa = empresaFromJson(jsonString);

import 'dart:convert';

List<Empresa> empresaFromJson(String str) =>
    List<Empresa>.from(json.decode(str).map((x) => Empresa.fromJson(x)));

String empresaToJson(List<Empresa> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Empresa {
  Empresa({
    required this.id,
    required this.name,
    required this.description,
    required this.isDeleted,
    required this.ruc,
    required this.headquarter,
    required this.estado,
    required this.companyUser,
  });

  final String id;
  final String name;
  final String description;
  final String isDeleted;
  final String ruc;
  final String headquarter;
  final String estado;
  final CompanyUser companyUser;

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        isDeleted: json["isDeleted"],
        ruc: json["ruc"],
        headquarter: json["headquarter"],
        estado: json["estado"],
        companyUser: CompanyUser.fromJson(json["CompanyUser"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "isDeleted": isDeleted,
        "ruc": ruc,
        "headquarter": headquarter,
        "estado": estado,
        "CompanyUser": companyUser.toJson(),
      };
}

class CompanyUser {
  CompanyUser({
    required this.idU,
    required this.nameU,
    required this.emailU,
    required this.uisDeleted,
    required this.rolTu,
    required this.documentU,
    required this.ndocumentU,
    required this.passU,
  });

  final String idU;
  final String nameU;
  final String emailU;
  final String uisDeleted;
  final String rolTu;
  final String documentU;
  final String ndocumentU;
  final String passU;

  factory CompanyUser.fromJson(Map<String, dynamic> json) => CompanyUser(
        idU: json["idU"],
        nameU: json["NameU"],
        emailU: json["emailU"],
        uisDeleted: json["UisDeleted"],
        rolTu: json["rolTu"],
        documentU: json["documentU"],
        ndocumentU: json["ndocumentU"],
        passU: json["passU"],
      );

  Map<String, dynamic> toJson() => {
        "idU": idU,
        "NameU": nameU,
        "emailU": emailU,
        "UisDeleted": uisDeleted,
        "rolTu": rolTu,
        "documentU": documentU,
        "ndocumentU": ndocumentU,
        "passU": passU,
      };
}
