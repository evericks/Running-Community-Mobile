import '../../domain/models/user.dart';

class UserState {}

class LoginLoadingState extends UserState {}

class LoginSuccessState extends UserState {}

class LoginFailedState extends UserState {
  final String error;
  LoginFailedState(this.error);
}

class UserProfileLoadingState extends UserState {}

class UserProfileSuccessState extends UserState {
  final User user;
  UserProfileSuccessState(this.user);
}

class UserProfileFailedState extends UserState{
  final String error;
  UserProfileFailedState(this.error);
}

class SignUpLoadingState extends UserState {}

class SignUpSuccessState extends UserState {}

class SignUpFailedState extends UserState {
  final String error;
  SignUpFailedState(this.error);
}

class UpdateProfileLoadingState extends UserState {}

class UpdateProfileSuccessState extends UserState {}

class UpdateProfileFailedState extends UserState {
  final String error;
  UpdateProfileFailedState(this.error);
}