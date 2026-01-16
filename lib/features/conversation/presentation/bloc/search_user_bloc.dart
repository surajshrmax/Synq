import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/auth/domain/entities/user.dart';
import 'package:synq/features/conversation/domain/usecases/search_user_use_case.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_event.dart';
import 'package:synq/features/conversation/presentation/bloc/search_user_state.dart';

class SearchUserBloc extends Bloc<SearchUserEvent, SearchUserState> {
  final SearchUserUseCase useCase;
  SearchUserBloc({required this.useCase}) : super(SearchUserInitialState()) {
    on<StartSearchUserEvent>(_onSearchEvent);
  }

  Future<void> _onSearchEvent(
    StartSearchUserEvent event,
    Emitter<SearchUserState> emit,
  ) async {
    var response = await useCase.call(event.name);
    response.when(
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
                      name: e.name,
                      userName: e.userName,
                      email: e.email,
                      imageUrl: e.imageUrl,
                      isVerified: e.isVerified,
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
      failure: (error) {
        print(error.statusCode);
        emit(SearchUserNotFoundState());
      },
    );
  }
}
