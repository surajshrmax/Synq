import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/chat/domain/usecases/create_group_use_case.dart';
import 'package:synq/features/chat/domain/usecases/get_group_info_use_case.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_event.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase createGroupUseCase;
  final GetGroupInfoUseCase groupInfoUseCase;
  GroupBloc({required this.createGroupUseCase, required this.groupInfoUseCase})
    : super(GroupInitialState()) {
    on<CreateGroupEvent>(_onCreateGroupEvent);
    on<GetGroupInfo>(_onGetGroupInfoEvent);
  }

  Future<void> _onCreateGroupEvent(
    CreateGroupEvent event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupCreatingState());
    var response = await createGroupUseCase.call(event.name, event.members);
    response.when(
      success: (data) => emit(GroupCreatedState()),
      failure: (error) => emit(GroupErrorState(error: error.message)),
    );
  }

  Future<void> _onGetGroupInfoEvent(
    GetGroupInfo event,
    Emitter<GroupState> emit,
  ) async {
    emit(GroupInfoLoadingState());

    var response = await groupInfoUseCase.call(event.groupId);

    response.when(
      success: (data) => emit(GroupInfoLoadedState(group: data)),
      failure: (error) => emit(GroupErrorState(error: error.message)),
    );
  }
}
