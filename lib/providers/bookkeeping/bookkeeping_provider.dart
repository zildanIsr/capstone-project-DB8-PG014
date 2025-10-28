import 'package:finmene/models/data/report_model.dart';
import 'package:finmene/models/entities/report.dart';
import 'package:finmene/providers/state/common_state.dart';
import 'package:finmene/services/shared_pref_service.dart';
import 'package:finmene/utils/constans/shared_pref_key.dart';
import 'package:finmene/utils/enums/status_state_enum.dart';
import 'package:flutter/material.dart';

class BookkeepingProvider extends ChangeNotifier {
  List<Report> _reports = [];
  List<Report> get reports => _reports;

  CommonState<List<Report>> _reportsState = CommonState(data: [], state: StatusState.initial);
  CommonState<List<Report>> get reportsState => _reportsState;

  final SharedPrefService _sharedPrefService;

  BookkeepingProvider(SharedPrefService sharedPref)
    : _sharedPrefService = sharedPref;

  Future<void> loadReports() async {
    _reportsState = _reportsState.copyWith(state: StatusState.loading);
    notifyListeners();

    try {
      await _sharedPrefService.getString(SharedPrefKey.themeKey).then((val) {
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
      await _sharedPrefService.addString(SharedPrefKey.themeKey, value);
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
      await _sharedPrefService.addString(SharedPrefKey.themeKey, value);
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
      await _sharedPrefService.addString(SharedPrefKey.themeKey, value);
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
