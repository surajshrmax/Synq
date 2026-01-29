import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_animated_container.dart';
import 'package:synq/core/widgets/synq_icon_button.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_state.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_state.dart';
import 'package:synq/features/conversation/presentation/widgets/message_box.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagePage extends StatefulWidget {
  final String conversationId;
  final String userID;

  final TextEditingController messageController = TextEditingController();
  MessagePage({super.key, required this.conversationId, required this.userID});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    context.read<UserBloc>().add(GetUserInfoEvent(userId: widget.userID));
    context.read<MessageBloc>().add(
      GetAllMessageEvent(conversationId: widget.conversationId),
    );

    context.read<MessageBloc>().add(StartListeningMessageEvent());
    super.initState();
  }

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
              child: BlocBuilder<MessageBloc, MessageState>(
                builder: (context, state) {
                  return state is MessageStateLoaded
                      ? ListView.builder(
                          itemCount: state.messages.length,
                          itemBuilder: (context, index) {
                            var message = state.messages[index];
                            return MessageListItem(
                              name: "Cat",
                              message: message.content,
                              imageUrl: '',
                              time: 'Today at 1:21 PM',
                            );
                          },
                        )
                      : Center(child: Text("No Messages"));
                },
              ),
            ),

            MessageBox(
              onSendButtonPressed: () {
                bool isConversationId = !widget.conversationId.contains("null");
                context.read<MessageBloc>().add(
                  SendMessageEvent(
                    id: isConversationId
                        ? widget.conversationId
                        : widget.userID,
                    type: isConversationId ? IdType.conversation : IdType.user,
                    content: widget.messageController.text,
                  ),
                );
                widget.messageController.text = "";
              },
              onPickButtonPressed: () {},
              messageBoxController: widget.messageController,
            ),
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
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return Text(
                        state is UserStateInfoLoaded
                            ? state.user.profile!.name
                            : "",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
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
