class UserState {}

class LoginLoadingState extends UserState {}

class LoginSuccessState extends UserState {}

class LoginFailedState extends UserState {
  final String error;
  LoginFailedState(this.error);
}
