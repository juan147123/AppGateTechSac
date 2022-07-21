// To parse this JSON data, do
//
//     final company = companyFromJson(jsonString);

import 'dart:convert';

List<Company> companyFromJson(String str) =>
    List<Company>.from(json.decode(str).map((x) => Company.fromJson(x)));

String companyToJson(List<Company> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Company {
  Company({
    required this.idcompany,
    required this.name,
  });

  final String idcompany;
  final String name;

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        idcompany: json["idcompany"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "idcompany": idcompany,
        "name": name,
      };
}

// To parse this JSON data, do
//
//     final companyEmployee = companyEmployeeFromJson(jsonString);

List<CompanyEmployee> companyEmployeeFromJson(String str) =>
    List<CompanyEmployee>.from(
        json.decode(str).map((x) => CompanyEmployee.fromJson(x)));

String companyEmployeeToJson(List<CompanyEmployee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CompanyEmployee {
  CompanyEmployee({
    required this.idEmpl,
    required this.name,
    required this.documentTypeId,
    required this.document,
    required this.email,
    required this.phone,
    required this.rol,
    required this.estado,
    required this.isDeletedEmp,
  });

  final String idEmpl;
  final String name;
  final DocumentType? documentTypeId;
  final String document;
  final String email;
  final String phone;
  final String rol;
  final String estado;
  final String isDeletedEmp;

  factory CompanyEmployee.fromJson(Map<String, dynamic> json) =>
      CompanyEmployee(
        idEmpl: json["id_empl"],
        name: json["name"],
        documentTypeId: json["documentTypeId"] != null
            ? DocumentType.fromJson(json["documentTypeId"])
            : null,
        document: json["document"],
        email: json["email"],
        phone: json["phone"],
        rol: json["rol"],
        estado: json["estado"],
        isDeletedEmp: json["isDeleted_emp"],
      );

  Map<String, dynamic> toJson() => {
        "id_empl": idEmpl,
        "name": name,
        "documentTypeId": documentTypeId?.toJson(),
        "document": document,
        "email": email,
        "phone": phone,
        "rol": rol,
        "estado": estado,
        "isDeleted_emp": isDeletedEmp,
      };
}

class DocumentType {
  DocumentType({
    required this.documentType,
    required this.nameDocumentType,
    required this.idDeleteddocumentType,
  });

  final String documentType;
  final String nameDocumentType;
  final String idDeleteddocumentType;

  factory DocumentType.fromJson(Map<String, dynamic> json) => DocumentType(
        documentType: json["documentType"],
        nameDocumentType: json["name_documentType"],
        idDeleteddocumentType: json["idDeleteddocumentType"],
      );

  Map<String, dynamic> toJson() => {
        "documentType": documentType,
        "name_documentType": nameDocumentType,
        "idDeleteddocumentType": idDeleteddocumentType,
      };
}
