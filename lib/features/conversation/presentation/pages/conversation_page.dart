import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:synq/config/theme/app_text_colors.dart';
import 'package:synq/core/di/service_locator.dart';
import 'package:synq/core/storage/secure_storage.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_event.dart';
import 'package:synq/features/conversation/presentation/bloc/conversation/conversation_state.dart';
import 'package:synq/features/conversation/presentation/widgets/conversation_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';

class ConversationPage extends StatefulWidget {
  final storage = getIt<SecureStorage>();
  ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    context.read<ConversationBloc>().add(LoadAllConversationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SystemBarsWrapper(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context)),

            BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                return state is ConversationStateLoaded
                    ? SliverList.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          var conversation = state.conversations[index];
                          var user = conversation.user;
                          var lastMessage = conversation.lastMessage;
                          return ConversationListItem(
                            onPressed: () => context.push(
                              "/message/${conversation.id}/${user?.id}",
                            ),
                            title: user!.profile!.name,
                            subtitle:
                                "${conversation.id == lastMessage!.senderId ? "You: " : ""}${lastMessage.content}",
                            date: "${lastMessage.sendAt.day.toString()} Jan",
                            unreads: 1,
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

          // TextButton(
          //   onPressed: () async {
          //     var storage = getIt<SecureStorage>();
          //     await storage.deleteAllTokens();
          //   },
          //   child: Text("Logout"),
          // ),
        ],
      ),
    );
  }
}
