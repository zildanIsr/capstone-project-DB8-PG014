import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/res/image_res.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/widgets/buttons/button_primary.dart';
import 'package:finmene/utils/widgets/fields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  TextEditingController? emailController;
  TextEditingController? passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _imageAsset(),
              Gap(10),
              _greetingWidget(),
              Gap(50),
              _signInForm(emailController!, passwordController!),
              Gap(8),
              _forgotPasswordButton(),
              Gap(30),
              ButtonPrimary(
                title: StringRes.loginButton,
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  RoutesName.mainRoute,
                ),
              ),
              Gap(30),
              _createAccountButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageAsset() => Image.asset(ImageRes.logoNoBg, height: 250);

  Widget _greetingWidget() => Align(
    alignment: AlignmentGeometry.centerLeft,
    child: RichText(
      text: TextSpan(
        text: '${StringRes.greeting}\n',
        style: context.textTheme.headlineMedium,
        children: <TextSpan>[
          TextSpan(
            text: '${StringRes.wellcomeo}\n',
            style: context.textTheme.headlineMedium,
          ),
          TextSpan(
            text: '${StringRes.applicationName}!\n',
            style: context.textTheme.headlineMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: StringRes.appIntroduction,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    ),
  );

  Widget _signInForm(TextEditingController email, TextEditingController pass) {
    return Column(
      children: [
        RegularTextFormField(controller: email, label: "Email"),
        Gap(12),
        RegularTextFormField(controller: pass, label: "Password"),
      ],
    );
  }

  Widget _forgotPasswordButton() => Align(
    alignment: AlignmentGeometry.centerRight,
    child: GestureDetector(
      onTap: () {},
      child: Text(
        StringRes.forgotPasswordText,
        style: context.textTheme.bodyMedium!.copyWith(
          color: AppColors.blueBrand,
        ),
      ),
    ),
  );

  Widget _createAccountButton() => RichText(
    text: TextSpan(
      text: "Tidak punya akun? ",
      style: context.textTheme.bodyMedium,
      children: <TextSpan>[
        TextSpan(
          text: "Buat akun",
          style: context.textTheme.bodyMedium!.copyWith(
            color: AppColors.blueBrand,
          ),
          onEnter: (event){},
        ),
      ],
    ),
  );
}
