// To parse this JSON data, do
//
//     final detailsTr = detailsTrFromJson(jsonString);

import 'dart:convert';

List<DetailsTR> detailsTrFromJson(String str) =>
    List<DetailsTR>.from(json.decode(str).map((x) => DetailsTR.fromJson(x)));

String detailsTrToJson(List<DetailsTR> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DetailsTR {
  DetailsTR({
    required this.id,
    this.title,
    this.content,
    this.conclusions,
    this.status,
    this.inspectionDate,
    this.target,
    this.equipmentId,
    this.technicalUserId,
    this.supervisorUserId,
  });

  final String id;
  final String? title;
  final String? content;
  final String? conclusions;
  final String? status;
  final DateTime? inspectionDate;
  final String? target;
  final String? equipmentId;
  final String? technicalUserId;
  final String? supervisorUserId;

  factory DetailsTR.fromJson(Map<String, dynamic> json) => DetailsTR(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        conclusions: json["conclusions"],
        status: json["status"],
        inspectionDate: json["inspectionDate"] != null
            ? DateTime.parse(json["inspectionDate"])
            : null,
        target: json["target"],
        equipmentId: json["equipmentId"],
        technicalUserId: json["technicalUserId"],
        supervisorUserId: json["supervisorUserId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "conclusions": conclusions,
        "status": status,
        "inspectionDate": inspectionDate?.toIso8601String(),
        "target": target,
        "equipmentId": equipmentId,
        "technicalUserId": technicalUserId,
        "supervisorUserId": supervisorUserId,
      };
}
