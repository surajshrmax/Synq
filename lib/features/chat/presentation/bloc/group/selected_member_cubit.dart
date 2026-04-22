import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedMemberCubit extends Cubit<List<Member>> {
  SelectedMemberCubit() : super(<Member>[]);

  void addUser(String id, String name) {
    var exists = state.any((u) => u.id == id);
    if (exists) return;
    emit([...state, Member(id: id, name: name)]);
  }

  void removeUser(String id) {
    emit(state.where((u) => u.id != id).toList());
  }
}

class Member {
  final String id;
  final String name;

  Member({required this.id, required this.name});
}
