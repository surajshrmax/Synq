import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/core/widgets/synq_icon_button.dart';
import 'package:synq/features/auth/data/models/user_model.dart';
import 'package:synq/features/conversation/data/data_source/remote/message_api_service.dart';
import 'package:synq/features/conversation/data/models/message_model.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_event.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_state.dart';
import 'package:synq/features/conversation/presentation/widgets/message_box.dart';
import 'package:synq/features/conversation/presentation/widgets/message_list.dart';
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
  late UserModel user;

  @override
  void initState() {
    context.read<UserBloc>().add(GetUserInfoEvent(userId: widget.userID));
    context.read<MessageBloc>().add(
      GetAllMessageEvent(
        conversationId: widget.conversationId.contains("null")
            ? widget.userID
            : widget.conversationId,
        isConversationId: !widget.conversationId.contains("null"),
      ),
    );

    context.read<MessageBloc>().add(StartListeningMessageEvent());
    super.initState();
  }

  bool showTimeHeader(List<MessageModel> list, int index) {
    if (index == list.length - 1) return true;
    final current = list[index].sendAt.toLocal();
    final next = list[index + 1].sendAt.toLocal();

    return current.year != next.year ||
        current.month != next.month ||
        current.day != next.day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.extension<AppTextColors>();
    final mediaQuery = MediaQuery.of(context);
    return SystemBarsWrapper(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            _buildHeader(mediaQuery, theme, textTheme),
            Expanded(
              child: MessageList(
                onPressed: (id, content) {
                  showMessageOptions(context, id, content);
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
            SizedBox(height: mediaQuery.padding.bottom),
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
                      if (state is UserStateInfoLoaded) {
                        user = state.user;
                        return Text(
                          user.profile!.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return SizedBox();
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

void showMessageOptions(BuildContext context, String id, String content) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    backgroundColor: theme.scaffoldBackgroundColor,
    isScrollControlled: true,
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return AnimatedPadding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
          bottom: MediaQuery.of(context).padding.bottom,
        ),
        duration: Duration(milliseconds: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("This is message options/"),
            SizedBox(height: 30),
            SynqContainer(
              onPressed: () {
                context.read<MessageBoxCubit>().startEditing(id, content);
                Navigator.pop(context);
              },
              backgroundColor: theme.cardColor,
              height: 40,
              child: Center(child: Text("Edit Message")),
            ),
            SizedBox(height: 10),

            SynqContainer(
              onPressed: () {
                context.read<MessageBloc>().add(DeleteMessage(id: id));
                Navigator.pop(context);
              },
              backgroundColor: Colors.redAccent,
              height: 40,
              child: Center(child: Text("Delete")),
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
