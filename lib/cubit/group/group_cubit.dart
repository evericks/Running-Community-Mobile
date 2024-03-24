import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/group_repo.dart';
import '../../utils/get_it.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState>{
  GroupCubit() : super(GroupsLoadingState());
  final GroupRepo _groupRepo = getIt<GroupRepo>();

  Future<void> getGroups({String? name, String? userId, int? pageNumber, int? pageSize}) async {
    emit(GroupsLoadingState());
    try {
      final groups = await _groupRepo.getGroups(name: name, userId: userId, pageNumber: pageNumber, pageSize: pageSize);
      emit(GroupsSuccessState(groups));
    } catch (e) {
      emit(GroupsFailedState(e.toString()));
    }
  }
}