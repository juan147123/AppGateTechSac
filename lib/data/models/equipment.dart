// To parse this JSON data, do
//
//     final equipment = equipmentFromJson(jsonString);

import 'dart:convert';

import 'package:app_quick_reports/data/models/company.dart';

List<Equipment> equipmentFromJson(String str) =>
    List<Equipment>.from(json.decode(str).map((x) => Equipment.fromJson(x)));

String equipmentToJson(List<Equipment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Equipment {
  Equipment({
    required this.id,
    required this.description,
    required this.code,
    required this.isDeleted,
    required this.estado,
    required this.companyId,
    required this.equipmentTypeId,
  });

  final String id;
  final String description;
  final String code;
  final String isDeleted;
  final String estado;
  final Company? companyId;
  final EquipmentTypeId? equipmentTypeId;

  factory Equipment.fromJson(Map<String, dynamic> json) => Equipment(
        id: json["id"],
        description: json["description"],
        code: json["code"],
        isDeleted: json["isDeleted"],
        estado: json["estado"],
        companyId: json["companyId"] != null
            ? Company.fromJson(json["companyId"])
            : null,
        equipmentTypeId: json["equipmentTypeId"] != null
            ? EquipmentTypeId.fromJson(json["equipmentTypeId"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "code": code,
        "isDeleted": isDeleted,
        "estado": estado,
        "companyId": companyId?.toJson(),
        "equipmentTypeId": equipmentTypeId?.toJson(),
      };
}

class EquipmentTypeId {
  EquipmentTypeId({
    required this.idequipmentType,
    required this.nameequipmentType,
    required this.isDeletedequipmentType,
  });

  final String idequipmentType;
  final String nameequipmentType;
  final String isDeletedequipmentType;

  factory EquipmentTypeId.fromJson(Map<String, dynamic> json) =>
      EquipmentTypeId(
        idequipmentType: json["idequipmentType"],
        nameequipmentType: json["nameequipmentType"],
        isDeletedequipmentType: json["isDeletedequipmentType"],
      );

  Map<String, dynamic> toJson() => {
        "idequipmentType": idequipmentType,
        "nameequipmentType": nameequipmentType,
        "isDeletedequipmentType": isDeletedequipmentType,
      };
}
