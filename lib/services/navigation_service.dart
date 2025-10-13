import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> navigateToWithArgs(String routeName, arguments) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateToAndRemove(String routeName, arguments) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
        routeName, (Route<dynamic> route) => false,
        arguments: arguments);
  }

  getContext() {
    return navigatorKey.currentContext;
  }

  getCurrentState() {
    return navigatorKey.currentState;
  }

  goBack() {
    return navigatorKey.currentState!.pop();
  }
}