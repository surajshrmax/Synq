import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/message-re-write/message_re_write_event.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/message/message_box_cubit_state.dart';
import 'package:synq/features/conversation/presentation/bloc/typing/typing_cubit.dart';
import 'package:synq/features/conversation/presentation/bloc/typing/typing_cubit_state.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_state.dart';
import 'package:synq/features/conversation/presentation/widgets/message_box.dart';
import 'package:synq/features/conversation/presentation/widgets/message_re_write_list.dart';
import 'package:synq/system_bars_wrapper.dart';

class MessageReWritePage extends StatefulWidget {
  final String chatId;
  final String userId;

  const MessageReWritePage({
    super.key,
    required this.chatId,
    required this.userId,
  });

  @override
  State<MessageReWritePage> createState() => _MessageReWritePageState();
}

class _MessageReWritePageState extends State<MessageReWritePage> {
  final TextEditingController messageBoxController = TextEditingController();
  final ItemScrollController messageScrollController = ItemScrollController();
  final ItemPositionsListener messageItemPositionListener =
      ItemPositionsListener.create();
  final FocusNode messageBoxFocusNode = FocusNode();
  MessageBoxCubitState messageBoxCubitState = MessageBoxCubitState(
    messageId: "",
    isEditing: false,
  );

  @override
  void initState() {
    context.read<UserBloc>().add(GetUserInfoEvent(userId: widget.userId));
    context.read<MessageReWriteBloc>().add(
      LoadInitialMessages(
        chatId: widget.chatId.contains("null") ? widget.userId : widget.chatId,
        isChatId: !widget.chatId.contains("null"),
      ),
    );
    context.read<MessageReWriteBloc>().add(StartConnection());

    super.initState();
  }

  void sendMessage() {
    bool isChatId = !widget.chatId.contains("null");
    if (messageBoxCubitState.isEditing) {
      context.read<MessageReWriteBloc>().add(
        UpdateMessage(
          id: messageBoxCubitState.messageId,
          content: messageBoxController.text,
        ),
      );
      context.read<MessageBoxCubit>().clear();
    } else if (messageBoxCubitState.isReplying) {
      context.read<MessageReWriteBloc>().add(
        SendMessage(
          id: isChatId ? widget.chatId : widget.userId,
          isChat: isChatId,
          content: messageBoxController.text,
          replyToMessageId: messageBoxCubitState.messageId,
        ),
      );
      context.read<MessageBoxCubit>().clear();
    } else {
      context.read<MessageReWriteBloc>().add(
        SendMessage(
          id: isChatId ? widget.chatId : widget.userId,
          isChat: isChatId,
          content: messageBoxController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return SystemBarsWrapper(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.padding.top),
            _buildHeader(context),
            Expanded(
              child: MessageReWriteList(
                scrollController: messageScrollController,
                itemPositionsListener: messageItemPositionListener,
                onItemPressed: (messsage) {
                  messageBoxFocusNode.unfocus();
                  showMessageOptions(context, messsage.id, messsage.content);
                },
              ),
            ),
            BlocBuilder<TypingCubit, TypingCubitState>(
              buildWhen: (previous, current) =>
                  previous.isTyping != current.isTyping,
              builder: (context, state) => AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: state.isTyping
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        color: primaryColor.withAlpha(20),
                        child: Text(
                          "Dog is typing...",
                          style: TextStyle(fontSize: 14, color: primaryColor),
                        ),
                      )
                    : SizedBox(),
              ),
            ),
            BlocListener<MessageBoxCubit, MessageBoxCubitState>(
              listener: (context, state) => messageBoxCubitState = state,
              child: MessageBox(
                onSendButtonPressed: () {
                  sendMessage();
                  messageBoxController.text = "";
                },
                onPickButtonPressed: () {},
                messageBoxController: messageBoxController,
                messageFocusNode: messageBoxFocusNode,
              ),
            ),
            SizedBox(height: mediaQuery.padding.bottom),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  final theme = Theme.of(context);
  final textTheme = theme.extension<AppTextColors>();
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 40,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 3, horizontal: 6),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(Icons.chevron_left, size: 16, color: Colors.white),
              Text(
                "Back",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        // Row(
        //   children: [
        //     Icon(Icons.chevron_left, color: primaryColor),
        //     Text(
        //       "back",
        //       style: TextStyle(
        //         fontSize: 14,
        //         color: primaryColor,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //   ],
        // ),
        Row(
          spacing: 10,
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                return state is UserStateInfoLoaded
                    ? Text(
                        state.user.profile!.name!,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      )
                    : SizedBox();
              },
            ),
            Text("/", style: TextStyle(fontSize: 25)),
            Row(
              spacing: 5,
              children: [
                Icon(
                  Icons.access_time,
                  color: textTheme?.secondaryTextColor,
                  size: 14,
                ),
                Text(
                  "1 hr",
                  style: TextStyle(
                    fontSize: 14,
                    color: textTheme?.secondaryTextColor,
                  ),
                ),
              ],
            ),
          ],
        ),
        Icon(Icons.more_vert),
      ],
    ),
  );
}

void showMessageOptions(BuildContext context, String id, String content) {
  final theme = Theme.of(context);
  showModalBottomSheet(
    backgroundColor: theme.scaffoldBackgroundColor,
    isScrollControlled: true,
    useRootNavigator: true,
    context: context,
    builder: (context) {
      return SafeArea(
        child: AnimatedPadding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            // bottom: MediaQuery.of(context).padding.bottom,
          ),
          duration: Duration(milliseconds: 150),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("This is message options"),
              SizedBox(height: 30),
              SynqContainer(
                onPressed: () {
                  context.pop();
                  context.read<MessageBoxCubit>().startEditing(id, content);
                },
                backgroundColor: theme.cardColor,
                height: 40,
                child: Center(child: Text("Edit Message")),
              ),
              SizedBox(height: 10),

              SynqContainer(
                onPressed: () {
                  context.pop();
                  context.read<MessageReWriteBloc>().add(DeleteMessage(id: id));
                },
                backgroundColor: Colors.redAccent,
                height: 40,
                child: Center(child: Text("Delete")),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
