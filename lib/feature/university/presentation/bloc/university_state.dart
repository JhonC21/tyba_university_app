part of 'university_bloc.dart';

// State for [_UniversityBloc]
@freezed
class UniversityState with _$UniversityState {
  const factory UniversityState.loading() = _Loading;
  const factory UniversityState.failed() = _Failed;
  const factory UniversityState.loaded({
    required List<University> universities,
    @Default(ListMode.listView) ListMode listMode,
    @Default(1) int currentPage,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
    File? imageFile,
  }) = _Loaded;
}

enum ListMode { listView, gridView }
