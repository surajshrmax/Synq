import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/user/domain/usecases/get_friends_use_case.dart';
import 'package:synq/features/user/domain/usecases/get_user_info_use_case.dart';
import 'package:synq/features/user/presentation/bloc/user/user_event.dart';
import 'package:synq/features/user/presentation/bloc/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserInfoUseCase userInfoUseCase;
  final GetFriendsUseCase friendsUseCase;
  UserBloc({required this.userInfoUseCase, required this.friendsUseCase})
    : super(UserStateInitial()) {
    on<GetUserInfoEvent>(_onGetUserInfo);
    on<GetFriends>(_onGetFriends);
  }

  Future<void> _onGetUserInfo(
    GetUserInfoEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserStateGetInfoLoading());
    var response = await userInfoUseCase.call(event.userId);

    response.when(
      success: (data) {
        emit(UserStateInfoLoaded(user: data));
      },
      failure: (error) {
        print("Something went wrong");
      },
    );
  }

  Future<void> _onGetFriends(GetFriends event, Emitter<UserState> emit) async {
    var response = await friendsUseCase.call();

    response.when(
      success: (data) {
        emit(UserStateFriendsLoaded(friends: data.friends));
      },
      failure: (error) {
        print("Something went wrong");
      },
    );
  }
}
