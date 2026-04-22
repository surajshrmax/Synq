import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:synq/features/chat/domain/usecases/create_group_use_case.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_event.dart';
import 'package:synq/features/chat/presentation/bloc/group/group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  final CreateGroupUseCase createGroupUseCase;
  GroupBloc({required this.createGroupUseCase}) : super(GroupInitialState()) {
    on<CreateGroupEvent>(_onCreateGroupEvent);
  }

  Future<void> _onCreateGroupEvent(CreateGroupEvent event, Emitter<GroupState> emit) async{
    emit(GroupCreatingState());
    var response = await createGroupUseCase.call(event.name, event.members);
    response.when(success: (data) => emit(GroupCreatedState()), failure: (error) => emit(GroupErrorState()),);
  }
}