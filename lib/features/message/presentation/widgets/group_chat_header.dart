import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_event.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_state.dart';
import 'package:synq/features/user/presentation/widgets/profile_image.dart';

class GroupChatHeader extends StatefulWidget {
  final String groupId;
  const GroupChatHeader({super.key, required this.groupId});

  @override
  State<GroupChatHeader> createState() => _GroupChatHeaderState();
}

class _GroupChatHeaderState extends State<GroupChatHeader> {
  @override
  void initState() {
    context.read<GroupBloc>().add(GetGroupInfo(groupId: widget.groupId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () => context.pop(),
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedArrowLeft01,
                size: 35,
              ),
            ),
            BlocBuilder<GroupBloc, GroupState>(
              builder: (context, state) {
                if (state is GroupInfoLoadedState) {
                  return SizedBox(
                    height: 60,
                    width: 60,
                    child: ProfileImage(
                      letter: state.group.title.characters.first.toUpperCase(),
                    ),
                  );
                } else {
                  return SizedBox(
                    height: 60,
                    width: 60,
                    child: ProfileImage(letter: ""),
                  );
                }
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<GroupBloc, GroupState>(
                  builder: (context, state) {
                    if (state is GroupInfoLoadedState) {
                      return Text(
                        state.group.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    } else {
                      return Text(
                        "Loading...",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }
                  },
                ),
                Row(
                  spacing: 5,
                  children: [
                    HugeIcon(icon: HugeIcons.strokeRoundedUserGroup, size: 16),
                    BlocBuilder<GroupBloc, GroupState>(
                      builder: (context, state) {
                        if (state is GroupInfoLoadedState) {
                          return Text(
                            "${state.group.memeberCount} Members",
                            style: TextStyle(fontSize: 12),
                          );
                        } else {
                          return Text(
                            "Loading...",
                            style: TextStyle(fontSize: 12),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Spacer(),
            HugeIcon(icon: HugeIcons.strokeRoundedSettings03, size: 33),
          ],
        ),
      ),
    );
  }
}
