import '../../domain/models/groups.dart';

class GroupState {}

class GroupsLoadingState extends GroupState {}

class GroupsSuccessState extends GroupState {
  final Groups groups;
  GroupsSuccessState(this.groups);
}

class GroupsFailedState extends GroupState {
  final String error;
  GroupsFailedState(this.error);
}
