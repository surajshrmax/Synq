import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextField extends Container {
  final String hintText;
  final TextEditingController? controller;
  LoginTextField({super.key, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10.r),
            hintText: hintText,
          ),
        ),
      ),
    );
  }
}
