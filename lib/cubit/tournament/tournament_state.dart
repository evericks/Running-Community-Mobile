import 'package:running_community_mobile/domain/models/tournaments.dart';

class TournamentState {}

class TournamentLoadingState extends TournamentState {}

class TournamentSuccessState extends TournamentState {
  final Tournaments tournaments;
  TournamentSuccessState({required this.tournaments});
}

class TournamentFailedState extends TournamentState {
  final String error;
  TournamentFailedState({required this.error});
}

class TournamentDetailLoadingState extends TournamentState {}

class TournamentDetailSuccessState extends TournamentState {
  final Tournament tournament;
  TournamentDetailSuccessState({required this.tournament});
}

class TournamentDetailFailedState extends TournamentState {
  final String error;
  TournamentDetailFailedState({required this.error});
}

class TournamentAttendedLoadingState extends TournamentState {}

class TournamentAttendedSuccessState extends TournamentState {
  final Tournaments tournaments;
  TournamentAttendedSuccessState({required this.tournaments});
}

class TournamentAttendedFailedState extends TournamentState {
  final String error;
  TournamentAttendedFailedState({required this.error});
}
