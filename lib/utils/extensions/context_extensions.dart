import 'package:flutter/material.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get size => mediaQuery.size;

  double get widht => size.width;
  double get height => size.height;

  // TabNavigator get tabNavigator => read<TabNavigator>();

  // void pop() => tabNavigator.pop();

  // void push(Widget page) => tabNavigator.push(TabItem(child: page));
}