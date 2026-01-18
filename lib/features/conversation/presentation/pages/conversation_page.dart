import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';
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

                GestureDetector(
                  onTap: () => context.push("/message/null"),
                  child: SizedBox(
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
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          SynqContainer(
            onPressed: () => context.push("/search"),
            height: 50.h,
            margin: EdgeInsets.symmetric(horizontal: 10.r),
            padding: EdgeInsets.symmetric(horizontal: 10.r),
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

          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
