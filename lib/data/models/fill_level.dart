// To parse this JSON data, do
//
//     final fillLevel = fillLevelFromJson(jsonString);

import 'dart:convert';

import 'package:app_quick_reports/data/models/company.dart';
import 'package:app_quick_reports/data/models/technical_review.dart';

List<FillLevelTR> fillLevelFromJson(String str) => List<FillLevelTR>.from(
    json.decode(str).map((x) => FillLevelTR.fromJson(x)));

String fillLevelToJson(List<FillLevelTR> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FillLevelTR {
  FillLevelTR({
    required this.id,
    required this.diameter,
    required this.totalNumberLifters,
    required this.exposedLifter,
    required this.height,
    required this.fillingLevel,
    required this.description,
    required this.flisDelete,
    this.technicalReviewId,
    this.companyId,
  });

  final String id;
  final String diameter;
  final String totalNumberLifters;
  final String exposedLifter;
  final String height;
  final String fillingLevel;
  final String description;
  final String flisDelete;
  final TechnicalReview? technicalReviewId;
  final Company? companyId;

  factory FillLevelTR.fromJson(Map<String, dynamic> json) => FillLevelTR(
        id: json["id"],
        diameter: json["diameter"],
        totalNumberLifters: json["totalNumberLifters"],
        exposedLifter: json["exposedLifter"],
        height: json["height"],
        fillingLevel: json["fillingLevel"],
        description: json["description"],
        flisDelete: json["flisDelete"],
        technicalReviewId: json["technicalReviewId"] != null
            ? TechnicalReview.fromJson(json["technicalReviewId"])
            : null,
        companyId: json["companyId"] != null
            ? Company.fromJson(json["companyId"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "diameter": diameter,
        "totalNumberLifters": totalNumberLifters,
        "exposedLifter": exposedLifter,
        "height": height,
        "fillingLevel": fillingLevel,
        "description": description,
        "flisDelete": flisDelete,
        "technicalReviewId": technicalReviewId?.toJson(),
        "companyId": companyId?.toJson(),
      };
}
