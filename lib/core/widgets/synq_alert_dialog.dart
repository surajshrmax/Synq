import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';

class SynqAlertDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    List<Widget>? items,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: theme.cardColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(color: textTheme?.secondaryTextColor),
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 10,
                  children: items ?? [],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
