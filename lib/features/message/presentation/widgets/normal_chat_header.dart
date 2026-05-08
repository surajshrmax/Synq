import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/user/presentation/bloc/user/user_event.dart';
import 'package:synq/features/user/presentation/bloc/user/user_state.dart';
import 'package:synq/features/user/presentation/widgets/profile_image.dart';

class NormalChatHeader extends StatefulWidget {
  final String userId;
  const NormalChatHeader({super.key, required this.userId});

  @override
  State<NormalChatHeader> createState() => _NormalChatHeaderState();
}

class _NormalChatHeaderState extends State<NormalChatHeader> {
  @override
  void initState() {
    context.read<UserBloc>().add(GetUserInfoEvent(userId: widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01, size: 35),
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserStateInfoLoaded) {
                return SizedBox(
                  height: 60,
                  width: 60,
                  child: ProfileImage(
                    letter: state.user.profile!.name!.characters.first
                        .toUpperCase(),
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
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserStateGetInfoLoading) {
                    return Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else if (state is UserStateInfoLoaded) {
                    return Text(
                      state.user.profile!.name!,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Row(
                spacing: 5,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedTimeHalfPass, size: 16),
                  Text("Yesterday at 12:33 PM", style: TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          Spacer(),
          HugeIcon(icon: HugeIcons.strokeRoundedSettings03, size: 33),
        ],
      ),
    );
  }
}
