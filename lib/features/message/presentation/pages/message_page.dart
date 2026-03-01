import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/config/theme/app_theme.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/message/presentation/bloc/fab/fab_cubit.dart';
import 'package:synq/features/message/presentation/bloc/message/message_bloc.dart';
import 'package:synq/features/message/presentation/bloc/message/message_event.dart';
import 'package:synq/features/message/presentation/bloc/message-box/message_box_cubit.dart';
import 'package:synq/features/message/presentation/bloc/message-box/message_box_cubit_state.dart';
import 'package:synq/features/message/presentation/bloc/typing/typing_cubit.dart';
import 'package:synq/features/message/presentation/bloc/typing/typing_cubit_state.dart';
import 'package:synq/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/chat/presentation/bloc/user/user_event.dart';
import 'package:synq/features/chat/presentation/bloc/user/user_state.dart';
import 'package:synq/features/message/presentation/widgets/message_box.dart';
import 'package:synq/features/message/presentation/widgets/message_list.dart';
import 'package:synq/system_bars_wrapper.dart';

class MessagePage extends StatefulWidget {
  final String chatId;
  final String userId;

  const MessagePage({super.key, required this.chatId, required this.userId});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController messageBoxController = TextEditingController();
  final AutoScrollController messageScrollController = AutoScrollController();
  final FocusNode messageBoxFocusNode = FocusNode();
  MessageBoxCubitState messageBoxCubitState = MessageBoxCubitState(
    messageId: "",
    isEditing: false,
  );

  bool _isFabVisible = false;
  bool _isFabChangeStateCalled = false;

  @override
  void initState() {
    context.read<UserBloc>().add(GetUserInfoEvent(userId: widget.userId));
    context.read<MessageBloc>().add(
      LoadInitialMessages(
        chatId: widget.chatId.contains("null") ? widget.userId : widget.chatId,
        isChatId: !widget.chatId.contains("null"),
      ),
    );
    context.read<MessageBloc>().add(StartConnection());

    messageScrollController.addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    double minScrollIntent = messageScrollController.position.minScrollExtent;
    double currentPixel = messageScrollController.position.pixels;
    final scrollDir = messageScrollController.position.userScrollDirection;
    bool isScrollingForward = scrollDir == ScrollDirection.forward;

    if (!isScrollingForward &&
        currentPixel > 400 &&
        !_isFabVisible &&
        !_isFabChangeStateCalled) {
      _isFabChangeStateCalled = true;
      context.read<FabCubit>().showFab();
    }

    if (isScrollingForward &&
        currentPixel < minScrollIntent + 30 &&
        _isFabVisible) {
      context.read<FabCubit>().dismiss();
    }
  }

  void sendMessage() {
    bool isChatId = !widget.chatId.contains("null");
    if (messageBoxCubitState.isEditing) {
      context.read<MessageBloc>().add(
        UpdateMessage(
          id: messageBoxCubitState.messageId,
          content: messageBoxController.text,
        ),
      );
      context.read<MessageBoxCubit>().clear();
    } else if (messageBoxCubitState.isReplying) {
      context.read<MessageBloc>().add(
        SendMessage(
          id: isChatId ? widget.chatId : widget.userId,
          isChat: isChatId,
          content: messageBoxController.text,
          replyToMessageId: messageBoxCubitState.messageId,
        ),
      );
      context.read<MessageBoxCubit>().clear();
    } else {
      context.read<MessageBloc>().add(
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
    final textTheme = theme.extension<AppTextColors>();
    return SystemBarsWrapper(
      child: Scaffold(
        floatingActionButton: BlocBuilder<FabCubit, FabCubitState>(
          builder: (context, state) {
            _isFabChangeStateCalled = false;
            _isFabVisible = state.isVisible;
            return AnimatedSlide(
              offset: Offset(0, _isFabVisible ? 0 : 10),
              duration: Duration(seconds: 1),
              child: Padding(
                padding: EdgeInsets.only(bottom: mediaQuery.size.height * 0.15),
                child: FloatingActionButton(
                  onPressed: () async {
                    messageScrollController.jumpTo(0);
                    await Future.delayed(Duration(milliseconds: 50));
                    context.read<FabCubit>().dismiss();
                  },
                  shape: CircleBorder(),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Icon(Icons.keyboard_arrow_down),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.scaffoldBackgroundColor,
                          ),
                          child: FittedBox(
                            child: Text(
                              "99",
                              style: TextStyle(
                                color: textTheme?.primaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.padding.top),
            _buildHeader(context),
            Expanded(
              child: MessageList(
                autoScrollController: messageScrollController,
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
                  context.read<MessageBloc>().add(DeleteMessage(id: id));
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
