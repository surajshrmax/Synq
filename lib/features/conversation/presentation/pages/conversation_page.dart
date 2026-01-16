import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';
// ignore: unused_import
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/features/conversation/presentation/pages/find_user_page.dart';
import 'package:synq/system_bars_wrapper.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SystemBarsWrapper(
      child: Scaffold(body: Column(children: [_buildHeader(context)])),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Synq",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                ),

                SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: CircleAvatar(
                    backgroundColor: textTheme?.secondaryTextColor,
                    child: Text(
                      "S",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FindUserPage()),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Container(
                height: 50.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.r),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: theme.dividerColor),
                ),

                child: Row(
                  spacing: 20,
                  children: [
                    Icon(
                      Icons.search,
                      size: 25.sp,
                      color: textTheme?.secondaryTextColor,
                    ),
                    Text(
                      'Find Friends...',
                      style: TextStyle(
                        color: textTheme?.secondaryTextColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
