import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/chat/data/models/chat_model.dart';
import 'package:synq/features/user/presentation/widgets/profile_image.dart';

class ChatListItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final ChatModel chat;

  const ChatListItem({super.key, required this.chat, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    return SynqContainer(
      onPressed: () => onPressed!(),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      borderColor: theme.scaffoldBackgroundColor,
      child: Row(
        spacing: 10.r,
        children: [
          ProfileImage(letter: chat.user!.profile!.name!.characters.first),

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
                          chat.user!.profile!.name!,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Visibility(
                          visible: false,
                          child: Icon(
                            Icons.verified,
                            size: 15.sp,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),

                    Text(
                      chat.lastMessage?.sendAt.toString() ?? '',
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
                        chat.lastMessage?.content ?? '',
                        style: TextStyle(color: textTheme?.secondaryTextColor),
                      ),
                    ),

                    chat.isGroup != null
                        ? SynqContainer(
                            height: 25.h,
                            width: 25.h,
                            backgroundColor: Colors.lightGreenAccent,
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  maxLines: 1,
                                  '1',
                                  // unreads.toString(),
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
