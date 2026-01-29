import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/conversation/domain/usecases/get_user_info_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserInfoUseCase useCase;
  UserBloc({required this.useCase}) : super(UserStateInitial()) {
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onGetUserInfo(
    GetUserInfoEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserStateGetInfoLoading());
    var response = await useCase.call(event.userId);

    response.when(
      success: (data) {
        emit(UserStateInfoLoaded(user: data));
      },
      failure: (error) {
        print("Something went wrong");
      },
    );
  }
}
