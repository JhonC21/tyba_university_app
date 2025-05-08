part of 'university_bloc.dart';

// Events for [_UniversityBloc]
@freezed
class UniversityEvent with _$UniversityEvent {
  const factory UniversityEvent.initialize() = _InitializeEvent;
  const factory UniversityEvent.loadMore() = _LoadMoreEvent;
  const factory UniversityEvent.changeViewMode() = _ChangeViewModeEvent;
  const factory UniversityEvent.updateUniversityImage({
    required String universityName,
    required File? imageFile,
  }) = _UpdateUniversityImageEvent;
  const factory UniversityEvent.updateStudentCount({
    required String universityName,
    required int? studentCount,
  }) = _UpdateStudentCountEvent;
  
}
