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
