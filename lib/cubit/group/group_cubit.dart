import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/group_repo.dart';
import '../../utils/get_it.dart';
import 'group_state.dart';

class GroupCubit extends Cubit<GroupState>{
  GroupCubit() : super(GroupsLoadingState());
  final GroupRepo _groupRepo = getIt.get<GroupRepo>();

  Future<void> getGroups({String? name, String? userId, int? pageNumber, int? pageSize}) async {
    emit(GroupsLoadingState());
    try {
      final groups = await _groupRepo.getGroups(name: name, userId: userId, pageNumber: pageNumber, pageSize: pageSize);
      emit(GroupsSuccessState(groups));
    } catch (e) {
      emit(GroupsFailedState(e.toString()));
    }
  }

  Future<void> createGroup({required String name, required String description, required String rule, required XFile thumbnail}) async {
    emit(GroupCreateLoadingState());
    try {
      final response = await _groupRepo.createGroup(name: name, description: description, rule: rule, thumbnail: thumbnail);
      if (response == 201) {
        emit(GroupCreateSuccessState(true));
      } else {
        emit(GroupCreateFailedState('Failed to create group'));
      }
    } catch (e) {
      emit(GroupCreateFailedState(e.toString()));
    }
  }

  Future<void> getGroupById(String id) async {
    emit(GetGroupLoadingState());
    try {
      final group = await _groupRepo.getGroupById(id);
      emit(GetGroupSuccessState(group));
    } catch (e) {
      emit(GetGroupFailedState(e.toString()));
    }
  }
}