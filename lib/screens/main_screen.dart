
import 'package:finmene/providers/main/main_provider.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/widgets/dialogs/show_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(
      builder: (_, controller, __) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (!didPop) {
              if (controller.indexHistory.length > 1) {
                controller.goBack();
              } else {
                bool confirm = await showConfirmationDialog(
                  context: context,
                  title: StringRes.exitAppTitle,
                  subtitle: StringRes.exitAppSubtitle,
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteHeavy,
                    ),
                    child: const Icon(
                      Icons.logout,
                      size: 30,
                      color: AppColors.tertiary,
                    ),
                  ),
                );
                if (confirm && context.mounted) {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutesName.splashRoute,
                  );
                }
              }
            }
          },
          child: Scaffold(
            extendBody: true,
            body: IndexedStack(index: controller.currentIndex, children: controller.screens),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              elevation: 0,
              shape: const CircleBorder(),
              onPressed: () {},
              child: Icon(Icons.add),
            ),
            bottomNavigationBar: BottomAppBar(
              notchMargin: 5,
              height: 60,
              elevation: 10,
              padding: EdgeInsets.zero,
              shape: const CircularNotchedRectangle(),
              child: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                onTap: controller.changeIndex,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_2), label: 'Profile'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
