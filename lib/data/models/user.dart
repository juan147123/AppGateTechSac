// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isDeleted,
    required this.rol,
    required this.ndocument,
    required this.imagePath,
    required this.estado,
    this.documentTypeId,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String isDeleted;
  final String rol;
  final String ndocument;
  final String imagePath;
  final String estado;
  final DocumentTypeId? documentTypeId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["Name"],
        email: json["email"],
        password: json["password"],
        isDeleted: json["isDeleted"],
        rol: json["rol"],
        ndocument: json["ndocument"],
        imagePath: json["imagePath"],
        estado: json["estado"],
        documentTypeId: json["documentTypeId"] == null
            ? null
            : DocumentTypeId.fromJson(json["documentTypeId"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": name,
        "email": email,
        "password": password,
        "isDeleted": isDeleted,
        "rol": rol,
        "ndocument": ndocument,
        "imagePath": imagePath,
        "estado": estado,
        "documentTypeId": documentTypeId?.toJson(),
      };
}

class DocumentTypeId {
  DocumentTypeId({
    required this.idDocumentType,
    required this.name,
    required this.isDeleteddocumentType,
  });

  final String idDocumentType;
  final String name;
  final String isDeleteddocumentType;

  factory DocumentTypeId.fromJson(Map<String, dynamic> json) => DocumentTypeId(
        idDocumentType: json["id_documentType"],
        name: json["name"],
        isDeleteddocumentType: json["isDeleteddocumentType"],
      );

  Map<String, dynamic> toJson() => {
        "id_documentType": idDocumentType,
        "name": name,
        "isDeleteddocumentType": isDeleteddocumentType,
      };
}
