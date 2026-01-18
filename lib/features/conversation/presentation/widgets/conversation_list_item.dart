import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';

class ConversationListItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final String title;
  final String? subtitle;
  final String? date;
  final int? unreads;
  final bool isVerified;
  const ConversationListItem({
    super.key,
    this.isVerified = false,
    required this.title,
    this.subtitle,
    this.date,
    this.unreads,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return SynqContainer(
      onPressed: () => onPressed!(),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        spacing: 10.r,
        children: [
          SizedBox(
            height: 50.h,
            width: 50.h,
            child: ClipOval(
              child: Image.asset("assets/images/demo.jpg", fit: BoxFit.cover),
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Visibility(
                          visible: isVerified,
                          child: Icon(
                            Icons.verified,
                            size: 15.sp,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      date ?? '',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: textTheme?.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        subtitle ?? '',
                        style: TextStyle(color: textTheme?.secondaryTextColor),
                      ),
                    ),

                    unreads != null
                        ? Container(
                            height: 25.h,
                            width: 25.h,
                            color: Colors.lightGreenAccent,
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  maxLines: 1,
                                  unreads.toString(),
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
