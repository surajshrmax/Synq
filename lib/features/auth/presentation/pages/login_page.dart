import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/bottom_sheet_dialog.dart';
import 'package:synq/core/widgets/synq_button.dart';
import 'package:synq/core/widgets/synq_text_field.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synq/features/auth/presentation/bloc/auth_event.dart';
import 'package:synq/features/auth/presentation/bloc/auth_state.dart';
import 'package:synq/features/auth/presentation/pages/register_page.dart';
import 'package:synq/features/chat/presentation/pages/chat_page.dart';
import 'package:synq/system_bars_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthSuccess ||
          current is AuthError && current.source == Source.login,
      listener: (context, state) {
        if (state is AuthError) {
          showErrorDialog(context, state.errorMessage);
        } else if (state is AuthSuccess) {
          context.go("/home");
        }
      },
      child: SystemBarsWrapper(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(30.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      "Welcome back, lets get you logged in quickly."
                          .toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Neue",
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 40.h),
                  Text(
                    "Email",
                    style: TextStyle(color: textTheme?.secondaryTextColor),
                  ),

                  SizedBox(height: 10.h),
                  SynqTextField(hintText: 'Email', controller: emailController),
                  SizedBox(height: 30.h),
                  Text(
                    "Password",
                    style: TextStyle(color: textTheme?.secondaryTextColor),
                  ),

                  SizedBox(height: 10.h),
                  SynqTextField(
                    hintText: 'password',
                    controller: passwordController,
                  ),
                  SizedBox(height: 20.h),
                  RichText(
                    text: TextSpan(
                      text: "New here? ",
                      style: TextStyle(color: textTheme?.primaryTextColor),
                      children: [
                        TextSpan(
                          text: "Create New Account",
                          style: TextStyle(
                            color: Colors.orange,
                            fontStyle: FontStyle.italic,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RegisterPage()),
                            ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        current is AuthLoginLoading ||
                        current is AuthError && current.source == Source.login,
                    builder: (context, state) {
                      return SynqButton(
                        showLoading: state is AuthLoginLoading,
                        title: 'Continue',
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            LoginEvent(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
