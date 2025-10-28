import 'package:finmene/providers/auth/firabase_auth_provider.dart';
import 'package:finmene/utils/enums/firabase_auth_enum.dart';
import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/res/image_res.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:finmene/utils/utilities.dart';
import 'package:finmene/utils/views/provider_listener.dart';
import 'package:finmene/utils/widgets/buttons/button_primary.dart';
import 'package:finmene/utils/widgets/fields/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  TextEditingController? emailController;
  TextEditingController? passwordController;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordObscure = true;
  bool isEmailValid = false;
  bool isPasswordValid = false;

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

  onIdentifierChange(String value) {
    setState(() {
      isEmailValid = value.isNotEmpty;
    });
  }

  onPasswordChange(String value) {
    setState(() {
      isPasswordValid = value.length > 5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderListenerWidget<FirabaseAuthProvider>(
        listener: (context, value) {
          if (value.authStatus == FirebaseAuthStatus.authenticating) {
            Utilities.showLoadingDialog(context);
          }
          if (value.authStatus == FirebaseAuthStatus.authenticated) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Navigator.pushReplacementNamed(context, RoutesName.mainRoute);
          }
          if (value.authStatus == FirebaseAuthStatus.error) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Utilities.showSnackbar(context, SnackbarEnum.error, value.message);
          }
        },
        child: Consumer<FirabaseAuthProvider>(
          builder: (_, state, __) {
            return Padding(
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
                    _signInForm(),
                    Gap(8),
                    _forgotPasswordButton(),
                    Gap(30),
                    _buttonLogin(),
                    Gap(30),
                    _createAccountButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _imageAsset() => Image.asset(ImageRes.logoNoBg, height: 250);

  Widget _buttonLogin() => ButtonPrimary(
    title: StringRes.loginButton,
    onPressed: isEmailValid && isPasswordValid
        ? () {
            if (_formKey.currentState!.validate()) {
              context.read<FirabaseAuthProvider>().signInUser(
                emailController!.text.trim(),
                passwordController!.text.trim(),
              );
            }
          }
        : null,
  );

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

  Widget _signInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          RegularTextFormField(
            controller: emailController!,
            label: "Email",
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.next,
            showClearIcon: false,
            onChanged: onIdentifierChange,
            validator: (value) {
              if (emailController!.text.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!emailController!.text.contains('@')) {
                return 'Email tidak valid';
              }
              return null;
            },
          ),
          Gap(14),
          RegularTextFormField(
            controller: passwordController!,
            keyboardType: TextInputType.visiblePassword,
            inputAction: TextInputAction.done,
            label: "Password",
            onChanged: onPasswordChange,
            obscureText: isPasswordObscure,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordObscure ? Icons.visibility_off : Icons.visibility,
              ),
              iconSize: 16,
              onPressed: () {
                setState(() {
                  isPasswordObscure = !isPasswordObscure;
                });
              },
            ),
          ),
        ],
      ),
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
          recognizer: TapGestureRecognizer()
            ..onTap = () => Navigator.pushNamed(context, RoutesName.authSignUp),
        ),
      ],
    ),
  );
}
