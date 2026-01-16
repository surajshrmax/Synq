import 'package:flutter/material.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_icon_button.dart';
import 'package:synq/features/conversation/presentation/widgets/message_box.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagePage extends StatelessWidget {
  MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    final mediaQuery = MediaQuery.of(context);
    return SystemBarsWrapper(
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(mediaQuery, theme, textTheme),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return MessageListItem(
                    name: 'Suraj',
                    message: 'Hello',
                    imageUrl: '',
                    time: 'Today at 1:21 PM',
                  );
                },
              ),
            ),
            MessageBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    MediaQueryData mediaQuery,
    ThemeData theme,
    AppTextColors? textTheme,
  ) {
    return Container(
      margin: EdgeInsets.only(top: mediaQuery.padding.top),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: theme.dividerColor)),
      ),
      child: Row(
        spacing: 10,
        children: [
          SynqIconButton(icon: Icons.chevron_left, onPressed: () {}),
          Row(
            spacing: 10,
            children: [
              Icon(
                Icons.tag,
                size: 40.sp,
                color: textTheme?.secondaryTextColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'exception504',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'last seen at 7:49 PM',
                    style: TextStyle(
                      color: textTheme?.secondaryTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
