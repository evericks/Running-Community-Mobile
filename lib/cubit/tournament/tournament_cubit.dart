import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/tournament_repo.dart';
import '../../utils/get_it.dart';
import 'tournament_state.dart';

class TournamentCubit extends Cubit<TournamentState>{
  TournamentCubit() : super(TournamentState());
  final TournamentRepo _tournamentRepo = getIt.get<TournamentRepo>();

  Future<void> getTournaments({String? title, String? startTime, String? endTime, double? minDistance, double? maxDistance, double? longitude, double? latitude, int? pageSize, int? pageNumber}) async {
    emit(TournamentLoadingState());
    try {
      final tournaments = await _tournamentRepo.getTournaments(
        title: title,
        startTime: startTime,
        endTime: endTime,
        minDistance: minDistance,
        maxDistance: maxDistance,
        longitude: longitude,
        latitude: latitude,
        pageSize: pageSize,
        pageNumber: pageNumber,
      );
      emit(TournamentSuccessState(tournaments: tournaments));
    } catch (e) {
      emit(TournamentFailedState(error: e.toString()));
    }
  }
}