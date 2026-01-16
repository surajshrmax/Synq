import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:synq/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginFabButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const LoginFabButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          switch (state) {
            case AuthInitial() || AuthError():
              return Icon(Icons.navigate_next);
            case AuthLoading():
              return SizedBox(
                height: 25.h,
                width: 25.h,
                child: CircularProgressIndicator(),
              );
            case AuthSuccess():
              return Icon(Icons.done);
            default:
              return Icon(Icons.navigate_next);
          }
        },
      ),
    );
  }
}
