import '../../domain/models/archivements.dart';

class ArchivementState {}

class ArchivementLoadingState extends ArchivementState {}

class ArchivementSuccessState extends ArchivementState {
  final Archivements archivements;
  ArchivementSuccessState(this.archivements);
}

class ArchivementFailedState extends ArchivementState {
  final String error;
  ArchivementFailedState(this.error);
}
