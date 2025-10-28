import 'package:finmene/models/user.dart';
import 'package:finmene/providers/auth/firabase_auth_provider.dart';
import 'package:finmene/providers/user/user_provider.dart';
import 'package:finmene/screens/auth/auth_screen.dart';
import 'package:finmene/screens/auth/sign_up_screen.dart';
import 'package:finmene/screens/financial-record/add_update_record.dart';
import 'package:finmene/screens/main_screen.dart';
import 'package:finmene/screens/splash/splash_screen.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.splashRoute:
      return _pageBuilder((_) => SplashScreen(), settings: settings);
    case RoutesName.mainRoute:
      return _pageBuilder((context) {
        if (context.read<FirebaseAuth>().currentUser != null) {
          final user = context.read<FirebaseAuth>().currentUser;
          final localUser = UserLocal(
            uuid: user!.uid,
            email: user.email ?? '',
            name: user.displayName == null 
                ? user.email!.split('@').first
                : user.displayName!,
          );
          context.read<UserProvider>().initUser(localUser);
          return MainScreen();
        } else {
          return ChangeNotifierProvider(
            create: (context) => FirabaseAuthProvider(context.read()),
            builder: (_, __) => UserAuthScreen(),
          );
        }
      }, settings: settings);
    case RoutesName.authRoute:
      return _pageBuilder((_) {
        return ChangeNotifierProvider(
          create: (context) => FirabaseAuthProvider(context.read()),
          builder: (_, __) => UserAuthScreen(),
        );
      }, settings: settings);
    case RoutesName.authSignUp:
      return _pageBuilder((_) {
        return ChangeNotifierProvider(
          create: (context) => FirabaseAuthProvider(context.read()),
          builder: (_, __) => SignUpScreen(),
        );
      }, settings: settings);
    case RoutesName.addUpdateRecord:
      return _pageBuilder(
        (_) {
          return ChangeNotifierProvider(
            create: (context) => FirabaseAuthProvider(context.read()),
            builder: (_, __) => AddUpdateRecord(),
          );
        },
        settings: settings,
        transitionsBuilder: slideFromBottomTransition()
      );
    default:
      return _pageBuilder((_) => SplashScreen(), settings: settings);
  }
}

RouteTransitionsBuilder slideFromBottomTransition() {
  return (BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  };
}

PageRouteBuilder<dynamic> _pageBuilder(
  Widget Function(BuildContext) page, {
  required RouteSettings settings,
  RouteTransitionsBuilder? transitionsBuilder,
}) {
  return PageRouteBuilder(
    settings: settings,
    transitionsBuilder:
        transitionsBuilder ??
        (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, _, __) => page(context),
  );
}
