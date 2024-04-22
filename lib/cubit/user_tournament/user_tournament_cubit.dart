import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:running_community_mobile/domain/repositories/user_tournament_repo.dart';
import 'package:running_community_mobile/utils/get_it.dart';

import 'user_tournament_state.dart';

class UserTournamentCubit extends Cubit<UserTournamentState>{
  UserTournamentCubit() : super(UserTournamentState());
  final UserTournamentRepo _userTournamentRepo = getIt.get<UserTournamentRepo>();

  Future<void> getUsersTournamentCubit({String? tournamentId, String? status, int? pageNumber, int? pageSize}) async {
    emit(UserTournamentLoadingState());
    try {
      var res = await _userTournamentRepo.getUsersTournament(tournamentId: tournamentId, status: status, pageNumber: pageNumber, pageSize: pageSize);
      emit(UserTournamentSuccessState(usersTournament: res));
    } catch (e) {
      emit(UserTournamentFailedState(msg: e.toString()));
    }
  }
}