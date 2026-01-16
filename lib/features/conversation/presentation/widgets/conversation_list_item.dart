import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';

class ConversationListItem extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: theme.dividerColor),
        ),
        child: Row(
          spacing: 10.r,
          children: [
            Container(
              height: 50.h,
              width: 50.h,
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: theme.dividerColor),
              ),
              child: Image.asset("assets/images/demo.jpg", fit: BoxFit.cover),
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
                          style: TextStyle(
                            color: textTheme?.secondaryTextColor,
                          ),
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
      ),
    );
  }
}
