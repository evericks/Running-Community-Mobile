import 'package:running_community_mobile/domain/models/tournaments.dart';
import 'package:running_community_mobile/domain/models/user.dart';

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
  final User user;
  TournamentAttendedSuccessState({required this.user});
}

class TournamentAttendedFailedState extends TournamentState {
  final String error;
  TournamentAttendedFailedState({required this.error});
}

class GetTournamentAttendedLoadingState extends TournamentState {}
  
class GetTournamentAttendedSuccessState extends TournamentState {
  final Tournaments tournaments;
  GetTournamentAttendedSuccessState({required this.tournaments});
}

class GetTournamentAttendedFailedState extends TournamentState {
  final String error;
  GetTournamentAttendedFailedState({required this.error});
}

class RequestPaymentTournamentLoadingState extends TournamentState {}

class RequestPaymentTournamentSuccessState extends TournamentState {
  final String paymentUrl;
  RequestPaymentTournamentSuccessState({required this.paymentUrl});
}

class RequestPaymentTournamentFailedState extends TournamentState {
  final String error;
  RequestPaymentTournamentFailedState({required this.error});
}