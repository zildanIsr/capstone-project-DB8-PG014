import 'dart:convert';

import 'package:finmene/models/entities/report.dart';
import 'package:finmene/utils/enums/category_enum.dart';

class ReportModel extends Report {
  const ReportModel({
    required super.trxDate,
    required super.ammount,
    required super.category,
    required super.description,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      trxDate: DateTime.parse(json['trxDate'] as String),
      ammount: json['ammount'] as num,
      category: CategoryType.values.firstWhere(
        (e) => e.toString() == 'CategoryType.${json['category']}',
      ),
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trxDate': trxDate.toIso8601String(),
      'ammount': ammount,
      'category': category.toString().split('.').last,
      'description': description,
    };
  }

  Report toEntity() {
    return Report(
      trxDate: trxDate,
      ammount: ammount,
      category: category,
      description: description,
    );
  }

  static String encode(List<Report> reports) => json.encode(
        reports
            .map<Map<String, dynamic>>((report) => ReportModel(
                  trxDate: report.trxDate,
                  ammount: report.ammount,
                  category: report.category,
                  description: report.description,
                ).toJson())
            .toList(),
      );

  static List<Report> decode(String reportsJson) =>
      (json.decode(reportsJson) as List<dynamic>)
          .map<Report>((item) =>
              ReportModel.fromJson(item as Map<String, dynamic>).toEntity())
          .toList();
}
