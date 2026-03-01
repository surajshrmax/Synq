import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/config/theme/app_theme.dart';

class ProfileImage extends StatelessWidget {
  final double height;
  final double width;
  final String letter;
  const ProfileImage({
    super.key,
    required this.letter,
    this.height = 60,
    this.width = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: primaryColor.withAlpha(40),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            // fontFamily: "Inter",
            fontSize: height / 1.5,
            color: textTheme?.secondaryTextColor,
            height: 1,
            fontWeight: FontWeight.bold,
          ),
          textHeightBehavior: TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );
  }
}
