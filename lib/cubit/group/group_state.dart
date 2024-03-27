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

class GroupCreateLoadingState extends GroupState {}

class GroupCreateSuccessState extends GroupState {
  final bool status;
  GroupCreateSuccessState(this.status);
}

class GroupCreateFailedState extends GroupState {
  final String error;
  GroupCreateFailedState(this.error);
}