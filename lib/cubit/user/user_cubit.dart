import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/user_repo.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState>{
  UserCubit() : super(UserState());
  final UserRepo _userRepo = UserRepo();
  Future<void> login({required String username, required String password}) async {
    emit(LoginLoadingState());
    try {
      await _userRepo.login(username: username, password: password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginFailedState(e.toString()));
    }
  }
}