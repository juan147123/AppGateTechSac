// To parse this JSON data, do
//
//     final technicalReview = technicalReviewFromJson(jsonString);

import 'dart:convert';

List<TechnicalReview> technicalReviewFromJson(String str) =>
    List<TechnicalReview>.from(
        json.decode(str).map((x) => TechnicalReview.fromJson(x)));

String technicalReviewToJson(List<TechnicalReview> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TechnicalReview {
  TechnicalReview({
    required this.idTR,
    required this.title,
    required this.content,
    required this.conclusions,
    required this.status,
    required this.isDeleted,
    required this.inspectionDate,
    required this.filePath,
    this.equipmentId,
    this.technicalUserId,
    this.supervisorUserId,
  });

  final String idTR;
  final String title;
  final String content;
  final String conclusions;
  final String status;
  final String isDeleted;
  final DateTime inspectionDate;
  final String filePath;
  final String? equipmentId;
  final String? technicalUserId;
  final String? supervisorUserId;

  factory TechnicalReview.fromJson(Map<String, dynamic> json) =>
      TechnicalReview(
        idTR: json["idTR"],
        title: json["title"],
        content: json["content"],
        conclusions: json["conclusions"],
        status: json["status"],
        isDeleted: json["isDeleted"],
        inspectionDate: DateTime.parse(json["inspectionDate"]),
        filePath: json["filePath"],
        equipmentId: json["equipmentId"],
        technicalUserId: json["technicalUserId"],
        supervisorUserId: json["supervisorUserId"],
      );

  Map<String, dynamic> toJson() => {
        "idTR": idTR,
        "title": title,
        "content": content,
        "conclusions": conclusions,
        "status": status,
        "isDeleted": isDeleted,
        "inspectionDate": inspectionDate.toIso8601String(),
        "filePath": filePath,
        "equipmentId": equipmentId,
        "technicalUserId": technicalUserId,
        "supervisorUserId": supervisorUserId,
      };
}
