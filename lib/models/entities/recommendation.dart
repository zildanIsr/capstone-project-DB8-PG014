import 'dart:convert';

import 'package:equatable/equatable.dart';

BudgetRecommendation budgetRecommendationFromMap(String str) => BudgetRecommendation.fromMap(json.decode(str));

String budgetRecommendationToMap(BudgetRecommendation data) => json.encode(data.toMap());

class BudgetRecommendation extends Equatable {
    final double safetyBuffer;
    final double nextMonthBudgetWeekly;
    final double nextMonthBudgetMonthly;
    final String nextMonthBudgetWeeklyFormatted;
    final String nextMonthBudgetMonthlyFormatted;
    final List<String> recommendations;

    const BudgetRecommendation({
        required this.safetyBuffer,
        required this.nextMonthBudgetWeekly,
        required this.nextMonthBudgetMonthly,
        required this.nextMonthBudgetWeeklyFormatted,
        required this.nextMonthBudgetMonthlyFormatted,
        required this.recommendations,
    });

    static BudgetRecommendation empty() => BudgetRecommendation(
        safetyBuffer: 0.0,
        nextMonthBudgetWeekly: 0.0,
        nextMonthBudgetMonthly: 0.0,
        nextMonthBudgetWeeklyFormatted: "",
        nextMonthBudgetMonthlyFormatted: "",
        recommendations: [],
    );

    BudgetRecommendation copyWith({
        double? safetyBuffer,
        double? nextMonthBudgetWeekly,
        double? nextMonthBudgetMonthly,
        String? nextMonthBudgetWeeklyFormatted,
        String? nextMonthBudgetMonthlyFormatted,
        List<String>? recommendations,
    }) => 
        BudgetRecommendation(
            safetyBuffer: safetyBuffer ?? this.safetyBuffer,
            nextMonthBudgetWeekly: nextMonthBudgetWeekly ?? this.nextMonthBudgetWeekly,
            nextMonthBudgetMonthly: nextMonthBudgetMonthly ?? this.nextMonthBudgetMonthly,
            nextMonthBudgetWeeklyFormatted: nextMonthBudgetWeeklyFormatted ?? this.nextMonthBudgetWeeklyFormatted,
            nextMonthBudgetMonthlyFormatted: nextMonthBudgetMonthlyFormatted ?? this.nextMonthBudgetMonthlyFormatted,
            recommendations: recommendations ?? this.recommendations,
        );

    factory BudgetRecommendation.fromMap(Map<String, dynamic> json) => BudgetRecommendation(
        safetyBuffer: json["safety_buffer"]?.toDouble(),
        nextMonthBudgetWeekly: json["next_month_budget_weekly"]?.toDouble(),
        nextMonthBudgetMonthly: json["next_month_budget_monthly"]?.toDouble(),
        nextMonthBudgetWeeklyFormatted: json["next_month_budget_weekly_formatted"],
        nextMonthBudgetMonthlyFormatted: json["next_month_budget_monthly_formatted"],
        recommendations: List<String>.from(json["recommendations"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "safety_buffer": safetyBuffer,
        "next_month_budget_weekly": nextMonthBudgetWeekly,
        "next_month_budget_monthly": nextMonthBudgetMonthly,
        "next_month_budget_weekly_formatted": nextMonthBudgetWeeklyFormatted,
        "next_month_budget_monthly_formatted": nextMonthBudgetMonthlyFormatted,
        "recommendations": List<dynamic>.from(recommendations.map((x) => x)),
    };
    
      @override
      List<Object?> get props => [
        safetyBuffer,
        nextMonthBudgetWeekly,
        nextMonthBudgetMonthly,
        nextMonthBudgetWeeklyFormatted,
        nextMonthBudgetMonthlyFormatted,
        recommendations,
      ];
}
