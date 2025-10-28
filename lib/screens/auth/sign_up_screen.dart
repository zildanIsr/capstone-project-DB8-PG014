import 'package:finmene/providers/auth/firabase_auth_provider.dart';
import 'package:finmene/utils/enums/firabase_auth_enum.dart';
import 'package:finmene/utils/enums/snackbar_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/router/routes_name.dart';
import 'package:finmene/utils/utilities.dart';
import 'package:finmene/utils/views/provider_listener.dart';
import 'package:finmene/utils/widgets/buttons/button_primary.dart';
import 'package:finmene/utils/widgets/fields/text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool isConfirmPasswordValid = false;
  bool isPasswordObscure = true;
  bool isConfirmPasswordObscure = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  void emailOnChange(String val) {
    setState(() {
      isEmailValid = val.isNotEmpty;
    });
  }

  void passOnchange(String val) {
    setState(() {
      isPasswordValid = val.isNotEmpty && val.length > 4;
    });
  }

  void confirmPassOnchange(String val) {
    setState(() {
      isConfirmPasswordValid =
          val.isNotEmpty && val.trim() == _passwordController.text.trim();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProviderListenerWidget<FirabaseAuthProvider>(
        listener: (_, value) {
          if (value.authStatus == FirebaseAuthStatus.creatingAccount) {
            Utilities.showLoadingDialog(context);
          }
          if (value.authStatus == FirebaseAuthStatus.accountCreated) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Utilities.showSnackbar(context, SnackbarEnum.success, value.message);
            Navigator.pushReplacementNamed(context, RoutesName.authRoute);
          }
          if (value.authStatus == FirebaseAuthStatus.error) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
            Utilities.showSnackbar(context, SnackbarEnum.error, value.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [_signUpForm(), Gap(50), _buttonRegister()],
          ),
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text("Registrasi Akun Kamu", style: context.textTheme.headlineLarge),
        Gap(50),
        RegularTextFormField(
          controller: _emailController,
          label: "Email",
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          showClearIcon: false,
          onChanged: emailOnChange,
          validator: (value) {
            if (value == null) {
              return 'Email tidak boleh kosong';
            }
            if (!value.contains('@')) {
              return 'Email tidak valid';
            }
            return null;
          },
        ),
        Gap(20),
        RegularTextFormField(
          controller: _passwordController,
          label: "Password",
          keyboardType: TextInputType.visiblePassword,
          inputAction: TextInputAction.next,
          showClearIcon: false,
          onChanged: passOnchange,
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
          validator: (value) {
            RegExp regex = RegExp(
              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
            );
            if (value == null) {
              return 'Password tidak boleh kosong';
            }
            if (!regex.hasMatch(value)) {
              return 'Password minimal satu huruf besar, satu angka, satu spesial karakter, dan 8 karakter';
            }
            return null;
          },
        ),
        Gap(20),
        RegularTextFormField(
          controller: _confirmPasswordController,
          label: "Konfirmasi Password",
          keyboardType: TextInputType.visiblePassword,
          inputAction: TextInputAction.done,
          showClearIcon: false,
          onChanged: confirmPassOnchange,
          obscureText: isConfirmPasswordObscure,
          suffixIcon: IconButton(
            icon: Icon(
              isConfirmPasswordObscure ? Icons.visibility_off : Icons.visibility,
            ),
            iconSize: 16,
            onPressed: () {
              setState(() {
                isConfirmPasswordObscure = !isConfirmPasswordObscure;
              });
            },
          ),
          validator: (value) {
            if (value == null) {
              return 'Password tidak boleh kosong';
            }
            if (value.trim() != _passwordController.text.trim()) {
              return 'Password tidak sesuai';
            }
            return null;
          },
        ),
        Gap(20),
      ],
    );
  }

  Widget _buttonRegister() => ButtonPrimary(
    title: StringRes.registerButton,
    onPressed: isEmailValid && isPasswordValid && isConfirmPasswordValid
        ? () {
            context.read<FirabaseAuthProvider>().createAccount(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
          }
        : null,
  );
}
