import 'package:finmene/models/entities/recommendation.dart';
import 'package:finmene/providers/bookkeeping/bookkeeping_provider.dart';
import 'package:finmene/providers/state/common_state.dart';
import 'package:finmene/services/ml_model_service.dart';
import 'package:finmene/utils/enums/category_enum.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:flutter/material.dart';

class MonthlyBudgetProvider extends ChangeNotifier {
  final MonthlyBudgetModel service;
  final BookkeepingProvider budgetProvider;

  MonthlyBudgetProvider({required this.service, required this.budgetProvider});

  CommonState<BudgetRecommendation?> state = CommonState(
    data: null,
    state: StatusState.initial,
  );

  Future<void> init() async {
    await service.load();
    notifyListeners();
  }

  List<double> _buildMonthlyTotals() {
    final txs = budgetProvider.reports;
    final monthlyTotals = List<double>.filled(12, 0.0);

    for (var month = 1; month <= 12; month++) {
      final monthTxs = txs.where(
        (tx) =>
            tx.trxDate.year == DateTime.now().year &&
            tx.trxDate.month == month &&
            tx.category != CategoryType.income,
      );

      final monthTotal = monthTxs.fold<double>(
        0.0,
        (sum, tx) => sum + tx.ammount.toDouble(),
      );

      // Simpan total di indeks sesuai bulan (0 untuk Januari, dst)
      monthlyTotals[month - 1] = monthTotal;
    }

    return monthlyTotals;
  }

  Map<String, double> _buildCategoryAverages() {
    final txs = budgetProvider.reports;
    final categorySums = <String, double>{};
    final categoryCounts = <String, int>{};

    for (var tx in txs) {
      categorySums[tx.category.name] =
          (categorySums[tx.category.name] ?? 0) + tx.ammount;
      categoryCounts[tx.category.name] =
          (categoryCounts[tx.category.name] ?? 0) + 1;
    }

    final categoryAverages = <String, double>{};
    categorySums.forEach((category, sum) {
      final count = categoryCounts[category] ?? 1;
      categoryAverages[category] = sum / count;
    });

    return categoryAverages;
  }

  Future<void> getMonthlyBudgetPayload() async {
    state = state.copyWith(state: StatusState.loading);
    notifyListeners();

    try {
      final monthlyTotals = _buildMonthlyTotals();
      final catAvg = _buildCategoryAverages();

      final payload = await service.buildPayload(
        monthlyTotals: monthlyTotals,
        catAvg: catAvg,
        kpi3m: null,
      );

      state = state.copyWith(
        data: BudgetRecommendation.fromMap(payload),
        state: StatusState.success,
      );
    } catch (e) {
      state = state.copyWith(
        data: null,
        state: StatusState.error,
        message: "Gagal melakukan prediksi",
      );
    } finally {
      notifyListeners();
    }
  }
}
