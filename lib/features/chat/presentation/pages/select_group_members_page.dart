import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:synq/core/widgets/synq_animated_container.dart';
import 'package:synq/core/widgets/synq_text_field.dart';
import 'package:synq/features/auth/domain/entities/user.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_bloc.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_event.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_state.dart';
import 'package:synq/features/chat/presentation/bloc/group/selected_member_cubit.dart';
import 'package:synq/features/user/presentation/bloc/user/user_bloc.dart';
import 'package:synq/features/user/presentation/bloc/user/user_event.dart';
import 'package:synq/features/user/presentation/bloc/user/user_state.dart';
import 'package:synq/features/user/presentation/widgets/user_list_item.dart';
import 'package:synq/system_bars_wrapper.dart';

class SelectGroupMembersPage extends StatefulWidget {
  final String groupName;
  const SelectGroupMembersPage({super.key, required this.groupName});

  @override
  State<SelectGroupMembersPage> createState() => _SelectGroupMembersPageState();
}

class _SelectGroupMembersPageState extends State<SelectGroupMembersPage> {
  List<Member> members = [];
  @override
  void initState() {
    context.read<UserBloc>().add(GetFriends());
    super.initState();
  }

  void createGroup(){
    context.read<GroupBloc>().add(CreateGroupEvent(name: widget.groupName, members: members.map((m) => m.id).toList()));
  }

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return SystemBarsWrapper(
      child: BlocListener<GroupBloc, GroupState>(listener: (context, state) {
        if(state is GroupCreatedState){
          context.go("/home");
        }
      },
      child:
       Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => createGroup(),
          shape: CircleBorder(),

          child: BlocBuilder<GroupBloc, GroupState>(builder: (context, state){
            if(state is GroupCreatingState){
              return SizedBox(height: 30, width: 30, child: CircularProgressIndicator(color: Colors.white,),);
            }
            return HugeIcon(icon: HugeIcons.strokeRoundedTick01);
          })
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(
                  top: mediaQuery.padding.top + 40,
                  left: 15,
                  right: 15,
                  bottom: 0,
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        HugeIcon(icon: HugeIcons.strokeRoundedArrowLeft01),
                        Text("Back"),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Add Members.",
                      style: TextStyle(
                        fontSize: 33,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 30),

                    SynqAnimatedContainer(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                          hintText: "Search",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: BlocBuilder<SelectedMemberCubit, List<Member>>(
                  builder: (context, state) {
                    members = state;
                    return Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: state.map((i) => Chip(
                        label: Text(i.name),
                        onDeleted: () => context.read<SelectedMemberCubit>().removeUser(i.id),
                      )).toList()
                    );
                  },
                ),
              ),
            ),

            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserStateFriendsLoaded) {
                  return SliverList.builder(
                    itemCount: state.friends.length,
                    itemBuilder: (context, index) {
                      var currentUser = state.friends[index];
                      var user = User(
                        id: currentUser.id,
                        name: currentUser.profile!.name!,
                        userName: currentUser.userName!,
                        email: "",
                        imageUrl: "",
                        isVerified: false,
                      );
                      return UserListItem(
                        user: user,
                        onPressed: () {
                          context.read<SelectedMemberCubit>().addUser(
                            user.id,
                            user.name,
                          );
                        },
                      );
                    },
                  );
                } else {
                  return SliverFillRemaining();
                }
              },
            ),
          ],
        ),
      ),
      )
    );
  }
}
