import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/auth/domain/entities/user.dart';
import 'package:synq/features/conversation/domain/usecases/search_user_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/search/search_user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/search/search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchUserUseCase useCase;
  Timer? timer;
  SearchUserBloc({required this.useCase}) : super(SearchUserInitialState()) {
    on<StartSearchUserEvent>(_onSearchEvent);
    on<ExecuteSearchEvent>(_onExecuteSearchEvent);
  }

  Future<void> _onSearchEvent(
    StartSearchUserEvent event,
    Emitter<SearchUserState> emit,
  ) async {
    if (event.name.isEmpty) return emit(SearchUserInitialState());
    emit(SearchUserLoadingState());
    timer?.cancel();
    timer = Timer(Duration(seconds: 1), () {
      add(ExecuteSearchEvent(name: event.name));
    });
  }

  Future<void> _onExecuteSearchEvent(
    ExecuteSearchEvent event,
    Emitter<SearchUserState> emit,
  ) async {
    var response = await useCase.call(event.name);
    await response.when(
      success: (res) {
        if (res.isEmpty) {
          emit(SearchUserNotFoundState());
        } else {
          emit(
            SearchUserFoundState(
              users: res
                  .map(
                    (e) => User(
                      id: e.id,
                      name: e.profile!.name!,
                      userName: e.userName!,
                      email: e.email,
                      imageUrl: e.profile!.imageUrl!,
                      isVerified: false,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
      failure: (error) {
        emit(SearchUserNotFoundState());
      },
    );
  }
}
