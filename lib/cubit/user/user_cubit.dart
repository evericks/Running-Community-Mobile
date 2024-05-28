
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import '../../domain/repositories/user_repo.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState>{
  UserCubit() : super(UserState());
  final UserRepo _userRepo = getIt.get<UserRepo>();
  Future<void> login({required String username, required String password}) async {
    emit(LoginLoadingState());
    try {
      await _userRepo.login(username: username, password: password);
      emit(LoginSuccessState());
    } catch (e) {
      emit(LoginFailedState(e.toString()));
    }
  }

  Future<void> getUserProfile() async {
    emit(UserProfileLoadingState());
    try {
      final user = await _userRepo.getUserProfile();
      emit(UserProfileSuccessState(user));
    } catch (e) {
      emit(UserProfileFailedState(e.toString()));
    }
  }

  Future<void> signUp({required String name, required String phone, required String password, required DateTime dob}) async {
    emit(SignUpLoadingState());
    try {
      await _userRepo.signUp(name: name, phone: phone, password: password, dob: dob);
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpFailedState(e.toString()));
    }
  }

  Future<void> updateProfile({required String id, String? name, String? address, DateTime? dob, XFile? avatar, String? password, String? gender}) async {
    emit(UpdateProfileLoadingState());
    try {
      await _userRepo.updateProfile(id: id, name: name, address: address, dob: dob, avatar: avatar, password: password, gender: gender);
      emit(UpdateProfileSuccessState());
    } catch (e) {
      emit(UpdateProfileFailedState(e.toString()));
    }
  }
}