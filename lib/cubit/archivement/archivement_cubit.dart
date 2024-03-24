import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/archivement_repo.dart';
import '../../utils/get_it.dart';
import 'archivement_state.dart';

class ArchivementCubit extends Cubit<ArchivementState>{
  ArchivementCubit() : super(ArchivementLoadingState());
  final ArchivementRepo _archivementRepo = getIt<ArchivementRepo>();

  Future<void> getArchivements() async {
    emit(ArchivementLoadingState());
    try {
      final archivements = await _archivementRepo.getArchivements();
      emit(ArchivementSuccessState(archivements));
    } catch (e) {
      emit(ArchivementFailedState(e.toString()));
    }
  }
}