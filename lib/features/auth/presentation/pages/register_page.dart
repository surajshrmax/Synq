import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/bottom_sheet_dialog.dart';
import 'package:synq/core/widgets/synq_button.dart';
import 'package:synq/core/widgets/synq_text_field.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synq/features/auth/presentation/bloc/auth_event.dart';
import 'package:synq/features/auth/presentation/bloc/auth_state.dart';
import 'package:synq/features/auth/presentation/widgets/login_textfield.dart';
import 'package:synq/features/chat/presentation/pages/chat_page.dart';
import 'package:synq/system_bars_wrapper.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();

    final TextEditingController nameController = TextEditingController();
    final TextEditingController userNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthSuccess ||
          current is AuthError && current.source == Source.register,
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
                      "New here? no worries let's get you registered"
                          .toUpperCase(),
                      style: TextStyle(
                        fontFamily: "Neue",
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                  SynqTextField(
                    hintText: 'Full Name',
                    controller: nameController,
                  ),
                  SizedBox(height: 20.h),
                  SynqTextField(
                    hintText: 'Username',
                    controller: userNameController,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Pick a username, make sure it's unique. It can consists of alphabets, numbers and _.",
                    style: TextStyle(color: textTheme?.secondaryTextColor),
                  ),

                  SizedBox(height: 20.h),
                  SynqTextField(hintText: 'Email', controller: emailController),
                  SizedBox(height: 5.h),
                  Text(
                    "Kindly enter your personal email, we will verify it later.",
                    style: TextStyle(color: textTheme?.secondaryTextColor),
                  ),

                  SizedBox(height: 20.h),
                  SynqTextField(
                    hintText: 'password',
                    controller: passwordController,
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    "Create a strong password",
                    style: TextStyle(color: textTheme?.secondaryTextColor),
                  ),

                  SizedBox(height: 30.h),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, current) =>
                        current is AuthRegisterLoading ||
                        current is AuthError &&
                            current.source == Source.register,
                    builder: (context, state) {
                      return SynqButton(
                        showLoading: state is AuthRegisterLoading,
                        title: 'Continue',
                        onPressed: () {
                          context.read<AuthBloc>().add(
                            RegisterEvent(
                              name: nameController.text,
                              username: userNameController.text,
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
