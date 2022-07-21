// To parse this JSON data, do
//
//     final userCredentials = userCredentialsFromJson(jsonString);

import 'dart:convert';

UserCredentials userCredentialsFromJson(String str) =>
    UserCredentials.fromJson(json.decode(str));

String userCredentialsToJson(UserCredentials data) =>
    json.encode(data.toJson());

class UserCredentials {
  UserCredentials({
    required this.token,
    required this.rol,
    required this.id,
    required this.companyid,
  });

  final String token;
  final String rol;
  final String id;
  final String companyid;

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      UserCredentials(
        token: json["token"],
        rol: json["rol"],
        id: json["id"],
        companyid: json["companyid"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "rol": rol,
        "id": id,
        "companyid": companyid,
      };
}
