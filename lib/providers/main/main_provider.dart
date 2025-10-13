import 'package:finmene/providers/commons/tab_navigator.dart';
import 'package:finmene/screens/home/dashboard_screen.dart';
import 'package:finmene/screens/home/profile_screen.dart';
import 'package:finmene/utils/widgets/persistens_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainProvider extends ChangeNotifier {
  List<int> _indexHistory = [0];
  final List<Widget> _screens = [
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: const DashboardScreen()
        ),
      ),
      child: const PersistentView(),
    ),
    ChangeNotifierProvider(
      create: (_) => TabNavigator(
        TabItem(
          child: ProfileScreen()
        ),
      ),
      child: const PersistentView(),
    ),
  ];

  List<Widget> get screens => _screens;

  List<int> get indexHistory => _indexHistory;

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void changeIndex(int index) {
    if (_currentIndex == index) return;
    _currentIndex = index;
    _indexHistory.add(index);
    notifyListeners();
  }

  void goBack() {
    if (_indexHistory.length == 1) return;
    _indexHistory.removeLast();
    _currentIndex = _indexHistory.last;
    notifyListeners();
  }

  void resetIndex() {
    _indexHistory = [0];
    _currentIndex = 0;
    notifyListeners();
  }
}