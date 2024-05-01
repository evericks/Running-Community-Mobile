import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/user_repo.dart';

import '../../domain/repositories/tournament_repo.dart';
import '../../utils/get_it.dart';
import 'tournament_state.dart';

class TournamentCubit extends Cubit<TournamentState> {
  TournamentCubit() : super(TournamentState());
  final TournamentRepo _tournamentRepo = getIt.get<TournamentRepo>();

  Future<void> getTournaments(
      {String? title, String? status, String? startTime, String? endTime, double? minDistance, double? maxDistance, double? longitude, double? latitude, int? pageSize, int? pageNumber}) async {
    emit(TournamentLoadingState());
    try {
      final tournaments = await _tournamentRepo.getTournaments(
        title: title,
        status: status,
        startTime: startTime,
        endTime: endTime,
        minDistance: minDistance,
        maxDistance: maxDistance,
        longitude: longitude,
        latitude: latitude,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      if (UserRepo.user.id != null) {
        var attendTournament = await _tournamentRepo.getTournamentsAttended();
        tournaments.tournaments!.removeWhere((t) => attendTournament.tournaments!.contains(t));
      }
      emit(TournamentSuccessState(tournaments: tournaments));
    } catch (e) {
      emit(TournamentFailedState(error: e.toString()));
    }
  }

  Future<void> getTournamentById(String id) async {
    emit(TournamentDetailLoadingState());
    try {
      final tournament = await _tournamentRepo.getTournamentById(id);
      emit(TournamentDetailSuccessState(tournament: tournament));
    } catch (e) {
      emit(TournamentDetailFailedState(error: e.toString()));
    }
  }

  Future<void> getTournamentsAttended({String? title, String? status, String? startTime, String? endTime, double? minDistance, double? maxDistance, double? longitude, double? latitude, int? pageSize, int? pageNumber}) async {
    emit(GetTournamentAttendedLoadingState());
    try {
      final tournaments = await _tournamentRepo.getTournamentsAttended( title: title,
        status: status,
        startTime: startTime,
        endTime: endTime,
        minDistance: minDistance,
        maxDistance: maxDistance,
        longitude: longitude,
        latitude: latitude,
        pageSize: pageSize,
        pageNumber: pageNumber,);
      emit(GetTournamentAttendedSuccessState(tournaments: tournaments));
    } catch (e) {
      emit(GetTournamentAttendedFailedState(error: e.toString()));
    }
  }

  Future<void> attendTournament(String tournamentId) async {
    emit(TournamentAttendedLoadingState());
    try {
      var user = await _tournamentRepo.attendTournament(tournamentId);
      emit(TournamentAttendedSuccessState(user: user));
    } catch (e) {
      emit(TournamentAttendedFailedState(error: e.toString()));
    }
  }

  Future<void> loadTournament() async {
    await getTournamentsAttended();
    getTournaments();
  }

  Future<void> requestPaymentTournament({required String tournamentId, required int amount}) async {
    emit(RequestPaymentTournamentLoadingState());
    try {
      var paymentUrl = await _tournamentRepo.requestPaymentTournament(tournamentId: tournamentId, amount: amount);
      emit(RequestPaymentTournamentSuccessState(paymentUrl: paymentUrl));
    } catch (e) {
      emit(RequestPaymentTournamentFailedState(error: e.toString()));
    }
  }
}
