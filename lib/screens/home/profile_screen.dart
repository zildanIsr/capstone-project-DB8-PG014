import 'package:finmene/providers/auth/firabase_auth_provider.dart';
import 'package:finmene/providers/theme_provider.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/res/image_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/widgets/dash/line_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatarInformation(context),
            Gap(12),
            _buildSettingsOption(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context) {
    return Column(
      children: [
        _toDarkModeSwitch(context),
        LineDivider(),
        ChangeNotifierProvider(
          create: (_) => FirabaseAuthProvider(context.read()),
          builder: (context, _) {
            return ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                context.read<FirabaseAuthProvider>().signOutUser().then((_) {
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(
                      context,
                      RoutesName.authRoute,
                    );
                  }
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _toDarkModeSwitch(BuildContext context) {
    ThemeProvider themeProvider = context.read<ThemeProvider>();
    return SwitchListTile(
      title: Text('Dark Mode'),
      value: themeProvider.themeMode == ThemeMode.dark ? true : false,
      onChanged: (bool value) {
        themeProvider.setThemeMode(
          themeProvider.themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
      secondary: Icon(Icons.brightness_6),
    );
  }

  Widget _buildAvatarInformation(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.all(16),
      width: ctx.widht,
      height: ctx.height * .25,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 60,
            backgroundImage: AssetImage(
              ctx.userProvider.user?.photoUrl! ?? ImageRes.imagePerson,
            ),
          ),
          Gap(12),
          Text(
            ctx.userProvider.user?.name ?? "Nama Pengguna",
            style: ctx.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gap(12),
          Text(
            ctx.userProvider.user?.email ?? "Email Pengguna",
            style: ctx.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
