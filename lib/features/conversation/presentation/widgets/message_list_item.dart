import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';

class MessageListItem extends StatelessWidget {
  final String name;
  final String message;
  final String imageUrl;
  final String time;

  const MessageListItem({
    super.key,
    required this.name,
    required this.message,
    required this.imageUrl,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          Container(
            height: 30.h,
            width: 30.h,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: theme.dividerColor),
            ),
            child: Image.asset("assets/images/demo.jpg", fit: BoxFit.contain),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textTheme?.secondaryTextColor,
                        height: 1,
                      ),
                      textHeightBehavior: TextHeightBehavior(
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textTheme?.secondaryTextColor,
                        height: 1,
                      ),
                      textHeightBehavior: TextHeightBehavior(
                        leadingDistribution: TextLeadingDistribution.even,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 17,
                    color: textTheme?.primaryTextColor,
                    height: 1.3.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
