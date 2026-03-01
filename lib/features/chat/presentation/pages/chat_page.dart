import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_event.dart';
import 'package:synq/features/chat/presentation/bloc/chat/chat_state.dart';
import 'package:synq/features/chat/presentation/widgets/chat_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';

class ChatPage extends StatefulWidget {
  final storage = getIt<SecureStorage>();
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadAllChatEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SystemBarsWrapper(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),

            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                return state is ChatStateLoaded
                    ? SliverList.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          var chat = state.conversations[index];
                          var user = chat.user;
                          var lastMessage = chat.lastMessage;
                          return ChatListItem(
                            onPressed: () =>
                                context.push("/message/${chat.id}/${user?.id}"),
                            chat: chat,
                          );
                        },
                      )
                    : SliverFillRemaining(
                        child: Center(child: Text("No Conversation Found")),
                      );
              },
            ),
          ],
        ),
      ),
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
                  onTap: () async {
                    await widget.storage.deleteAllTokens();
                    context.go("/auth/login");
                  },
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
            backgroundColor: theme.cardColor,
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
