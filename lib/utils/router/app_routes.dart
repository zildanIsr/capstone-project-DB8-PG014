import 'package:finmene/providers/auth/firabase_auth_provider.dart';
import 'package:finmene/screens/auth/auth_screen.dart';
import 'package:finmene/screens/main_screen.dart';
import 'package:finmene/screens/splash/splash_screen.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splashRoute:
      return _pageBuilder((_) => SplashScreen(), settings: settings);
    case RoutesName.mainRoute:
      return _pageBuilder((_) => MainScreen(), settings: settings);
    case RoutesName.authRoute:
      return _pageBuilder(
        (_) {
          return ChangeNotifierProvider(
            create: (context) => FirabaseAuthProvider(
              context.read()
            ),
            builder: (_, __) => UserAuthScreen(),
          );
        }, 
        settings: settings
      );
    default:
      return _pageBuilder((_) => SplashScreen(), settings: settings);
  }
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) => page(context),
  );
}
