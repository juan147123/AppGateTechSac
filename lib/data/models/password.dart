// To parse this JSON data, do
//
//     final updatePasswordResponse = updatePasswordResponseFromJson(jsonString);

import 'dart:convert';

UpdatePasswordResponse updatePasswordResponseFromJson(String str) =>
    UpdatePasswordResponse.fromJson(json.decode(str));

String updatePasswordResponseToJson(UpdatePasswordResponse data) =>
    json.encode(data.toJson());

class UpdatePasswordResponse {
  UpdatePasswordResponse({
    required this.respuesta,
  });

  final String respuesta;

  factory UpdatePasswordResponse.fromJson(Map<String, dynamic> json) =>
      UpdatePasswordResponse(
        respuesta: json["respuesta"],
      );

  Map<String, dynamic> toJson() => {
        "respuesta": respuesta,
      };
}
