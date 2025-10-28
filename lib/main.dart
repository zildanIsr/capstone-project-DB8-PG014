import 'package:finmene/firebase_options.dart';
import 'package:finmene/providers/app_info_provider.dart';
import 'package:finmene/providers/bookkeeping/bookkeeping_provider.dart';
import 'package:finmene/providers/main/main_provider.dart';
import 'package:finmene/providers/theme_provider.dart';
import 'package:finmene/providers/user/user_provider.dart';
import 'package:finmene/services/firebase_auth_service.dart';
import 'package:finmene/services/navigation_service.dart';
import 'package:finmene/services/shared_pref_service.dart';
import 'package:finmene/utils/router/app_routes.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => NavigationService()),
        Provider(create: (_) => SharedPrefService()),
        Provider(create: (_) => FirebaseAuth.instance),
        Provider(create: (ctx) => FirebaseAuthService(ctx.read())),
        ChangeNotifierProvider(create: (_) => MainProvider()),
        ChangeNotifierProvider(
          create: (_) => AppInfoProvider()..initAppInformation(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(
          create: (context) => BookkeepingProvider(context.read()),
        ),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final themeProvider = Provider.of<ThemeProvider>(context);
    final navigator = Provider.of<NavigationService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigator.navigatorKey,
      title: "Finmene App",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      onGenerateRoute: generateRoute,
      initialRoute: RoutesName.splashRoute,
    );
  }
}
