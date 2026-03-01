import 'package:flutter_bloc/flutter_bloc.dart';

class FabCubit extends Cubit<FabCubitState> {
  FabCubit() : super(FabCubitState(isVisible: false, shouldDismiss: false));

  void showFab() {
    emit(FabCubitState(isVisible: true, shouldDismiss: false));
  }

  void dismiss() {
    emit(FabCubitState(isVisible: false, shouldDismiss: true));
  }
}

class FabCubitState {
  final bool isVisible;
  final bool shouldDismiss;

  const FabCubitState({required this.isVisible, this.shouldDismiss = false});
}
