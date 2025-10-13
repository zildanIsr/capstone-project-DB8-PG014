import 'package:finmene/providers/app_info_provider.dart';
import 'package:finmene/utils/res/image_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) Navigator.pushReplacementNamed(context, RoutesName.authRoute);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.primary,
            child: Center(
              child: Image.asset(ImageRes.logoNoBg),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: appInformation(context))
        ],
      )
    );
  }

  Widget appInformation(BuildContext context) {
    AppInfoProvider appInfo = Provider.of<AppInfoProvider>(context);
    return Center(child: Text("v${appInfo.version}", style: Theme.of(context).textTheme.labelLarge,));
  }
}