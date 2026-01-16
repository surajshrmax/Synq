import 'package:flutter/material.dart';

class AppTextColors extends ThemeExtension<AppTextColors> {
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color hintTextColor;

  AppTextColors({
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.hintTextColor,
  });

  @override
  ThemeExtension<AppTextColors> copyWith({
    Color? primaryTextColor,
    Color? secondaryTextColor,
    Color? hintTextColor,
  }) {
    throw AppTextColors(
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      hintTextColor: hintTextColor ?? this.hintTextColor,
    );
  }

  @override
  ThemeExtension<AppTextColors> lerp(
    covariant ThemeExtension<AppTextColors>? other,
    double t,
  ) {
    if (other is! AppTextColors) return this;
    return AppTextColors(
      primaryTextColor: Color.lerp(
        primaryTextColor,
        other.primaryTextColor,
        t,
      )!,
      secondaryTextColor: Color.lerp(
        secondaryTextColor,
        other.secondaryTextColor,
        t,
      )!,
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t)!,
    );
  }
}
