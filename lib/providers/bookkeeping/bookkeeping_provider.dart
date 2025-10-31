import 'package:finmene/models/data/report_model.dart';
import 'package:finmene/models/entities/report.dart';
import 'package:finmene/providers/state/common_state.dart';
import 'package:finmene/services/shared_pref_service.dart';
import 'package:finmene/utils/constans/shared_pref_key.dart';
import 'package:finmene/utils/enums/category_enum.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:flutter/material.dart';

class BookkeepingProvider extends ChangeNotifier {
  double _incomeTotal = 0;
  double _expenseTotal = 0;

  double get incomeTotal => _incomeTotal;
  double get expenseTotal => _expenseTotal;

  num? get lastIncomeTrx {
    final sorted = List<Report>.from(_reports)
      ..sort((a, b) => b.trxDate.compareTo(a.trxDate));
    final matches = sorted.where((trx) => trx.category == CategoryType.income);
    if (matches.isEmpty) return null;
    return matches.first.ammount;
  }

  num? get lastExpenseTrx {
    final sorted = List<Report>.from(_reports)
      ..sort((a, b) => b.trxDate.compareTo(a.trxDate));
    final matches = sorted.where((trx) => trx.category != CategoryType.income);
    if (matches.isEmpty) return null;
    return matches.first.ammount;
  }

  List<Report> _reports = [];
  List<Report> get reports {
    final sorted = List<Report>.from(_reports);
    sorted.sort((a, b) => b.trxDate.compareTo(a.trxDate));
    return sorted;
  }

  CommonState<List<Report>> _reportsState = CommonState(data: [], state: StatusState.initial);
  CommonState<List<Report>> get reportsState => _reportsState;

  final SharedPrefService _sharedPrefService;

  BookkeepingProvider(SharedPrefService sharedPref)
    : _sharedPrefService = sharedPref;

  Future<void> countIncome() async {
    final monthTxs = reports.where(
        (tx) =>
            tx.category == CategoryType.income,
      );

    final incomeTotal = monthTxs.fold<double>(
        0.0,
        (sum, tx) => sum + tx.ammount.toDouble(),
      );

    _incomeTotal = incomeTotal;
  }

  Future<void> countExpense() async {
    final monthTxs = reports.where(
        (tx) =>
            tx.category != CategoryType.income,
      );

    final expenseTotal = monthTxs.fold<double>(
        0.0,
        (sum, tx) => sum + tx.ammount.toDouble(),
      );

    _expenseTotal = expenseTotal;
  }

  Future<void> loadReports() async {
    _reportsState = _reportsState.copyWith(state: StatusState.loading);
    notifyListeners();

    try {
      await _sharedPrefService.getString(SharedPrefKey.reportsList).then((val) {
        if (val.isNotEmpty) {
          _reports = ReportModel.decode(val);
          _reportsState = _reportsState.copyWith(
            data: _reports,
            state: StatusState.loaded,
          );
        } else {
          _reportsState = _reportsState.copyWith(
            data: _reports,
            state: StatusState.loaded,
          );
        }
      });
      countIncome();
      countExpense();
    } catch (e) {
      _reportsState = _reportsState.copyWith(
        state: StatusState.error,
        message: "Failed to load reports: ${e.toString()}",
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> addNewReport(Report report) async {
    _reportsState = _reportsState.copyWith(state: StatusState.loading);
    notifyListeners();

    try {
      _reports.add(report);
      String value = ReportModel.encode(reports);
      await _sharedPrefService.addString(SharedPrefKey.reportsList, value);
      countIncome();
      countExpense();
      _reportsState = _reportsState.copyWith(
        data: _reports,
        state: StatusState.success,
      ); 
    } catch (e) {
      _reportsState = _reportsState.copyWith(
        state: StatusState.error,
        message: "Failed to add new report: ${e.toString()}",
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> editReport(Report report, int index) async {
    _reportsState = _reportsState.copyWith(state: StatusState.loading);
    notifyListeners();
    try {
      _reports[index] = report;
      String value = ReportModel.encode(reports);
      await _sharedPrefService.addString(SharedPrefKey.reportsList, value);
      countIncome();
      countExpense();
      _reportsState = _reportsState.copyWith(
        data: _reports,
        state: StatusState.success,
      );
    } catch (e) {
      _reportsState = _reportsState.copyWith(
        state: StatusState.error,
        message: "Failed to edit report: ${e.toString()}",
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteReport(int index) async {
    _reportsState = _reportsState.copyWith(state: StatusState.loading);
    notifyListeners();
    try {
      _reports.removeAt(index);
      String value = ReportModel.encode(reports);
      await _sharedPrefService.addString(SharedPrefKey.reportsList, value);

      countIncome();
      countExpense();
      _reportsState = _reportsState.copyWith(
        data: _reports,
        state: StatusState.success,
      );
    } catch (e) {
      _reportsState = _reportsState.copyWith(
        state: StatusState.error,
        message: "Failed to edit report: ${e.toString()}",
      );
    } finally {
      notifyListeners();
    }
  }
}
