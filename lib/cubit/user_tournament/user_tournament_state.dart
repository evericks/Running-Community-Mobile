import 'package:running_community_mobile/domain/models/user_tournament.dart';

class UserTournamentState {}

class UserTournamentLoadingState extends UserTournamentState {}

class UserTournamentSuccessState extends UserTournamentState {
  final UsersTournament usersTournament;
  UserTournamentSuccessState({required this.usersTournament});
}

class UserTournamentFailedState extends UserTournamentState {
  final String msg;
  UserTournamentFailedState({required this.msg});
}
