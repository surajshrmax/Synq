import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:synq/core/widgets/synq_container.dart';
import 'package:synq/core/widgets/synq_icon_button.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_bloc.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_state.dart';
import 'package:synq/features/conversation/presentation/widgets/conversation_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';

class FindUserPage extends StatelessWidget {
  const FindUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final TextEditingController searchController = TextEditingController();
    Timer? timer;

    Future<void> searchUser(String value) async {
      timer?.cancel();
      timer = Timer(
        Duration(seconds: 2),
        () => context.read<SearchUserBloc>().add(
          StartSearchUserEvent(name: value),
        ),
      );
    }

    return SystemBarsWrapper(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(
            top: mediaQuery.padding.top,
            bottom: mediaQuery.padding.bottom,
            // left: 15.r,
            // right: 15.r,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      SynqIconButton(
                        icon: Icons.chevron_left,
                        onPressed: () {},
                      ),
                      SizedBox(height: 20.h),
                      SynqContainer(
                        child: TextField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.r),
                            border: InputBorder.none,
                            hintText: "Find Friends...",
                            hintStyle: TextStyle(fontSize: 22.sp),
                          ),
                          style: TextStyle(fontSize: 22.sp),

                          onChanged: (value) => searchUser(value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Divider(color: theme.dividerColor)),

              // SizedBox(height: 20.h),
              BlocBuilder<SearchUserBloc, SearchUserState>(
                builder: (context, state) {
                  if (state is SearchUserInitialState) {
                    return SliverFillRemaining(
                      child: Center(child: Text("Search something.")),
                    );
                  }
                  if (state is SearchUserNotFoundState) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text("${searchController.text} not found"),
                      ),
                    );
                  }
                  if (state is SearchUserFoundState) {
                    return SliverList.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        var user = state.users.elementAt(index);
                        return ConversationListItem(
                          title: user.name,
                          subtitle: user.userName,
                          isVerified: user.isVerified,
                        );
                      },
                    );
                  }
                  return SliverToBoxAdapter();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
