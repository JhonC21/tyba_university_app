import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';
import 'package:tyba_university_app/feature/university/domain/repositories/university_repository.dart';

part 'university_event.dart';
part 'university_state.dart';
part 'university_bloc.freezed.dart';

// Bloc for universities management
class UniversityBloc extends Bloc<UniversityEvent, UniversityState> {
  UniversityBloc({required this.universityRepository})
      : super(const _Loading()) {
    on<_InitializeEvent>(_onInitialize);
    on<_LoadMoreEvent>(_onLoadMore);
    on<_UpdateUniversityImageEvent>(_onUpdateImage);
    on<_UpdateStudentCountEvent>(_onUpdateStudentCount);
    on<_ChangeViewModeEvent>(_onChangeViewMode);
  }

  final UniversityRepository universityRepository;
  bool _isFetching = false;

  // Event handlers

  // Handles [_InitializeEvent] by loading the first page of universities.
  //
  // Emits [_Failed] if something went wrong or [_Loaded] if the operation
  // was successful.
  FutureOr<void> _onInitialize(
    _InitializeEvent event,
    Emitter<UniversityState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;

    final result = await universityRepository.getUniversities();

    _isFetching = false;

    result.when(
      left: (failure) => emit(const _Failed()),
      right: (universities) => emit(_Loaded(
        universities: universities,
        currentPage: 1,
        hasReachedMax: universities.isEmpty,
      )),
    );
  }

  // Handles [_LoadMoreEvent] by loading the next page of universities.
  // Emits the current state with [isLoadingMore] set to true, then
  // updates the state with the new page of universities and sets
  // [isLoadingMore] to false. If the new page is empty, sets
  // [hasReachedMax] to true.
  FutureOr<void> _onLoadMore(
    _LoadMoreEvent event,
    Emitter<UniversityState> emit,
  ) async {
    final state = this.state;
    if (state is! _Loaded ||
        _isFetching ||
        state.hasReachedMax ||
        state.isLoadingMore) {
      return;
    }

    _isFetching = true;
    emit(state.copyWith(isLoadingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await universityRepository.getUniversities(page: nextPage);

    _isFetching = false;

    result.when(
      left: (failure) => emit(state.copyWith(isLoadingMore: false)),
      right: (newUniversities) {
        if (newUniversities.isEmpty) {
          emit(state.copyWith(
            hasReachedMax: true,
            isLoadingMore: false,
          ));
        } else {
          emit(state.copyWith(
            universities: [...state.universities, ...newUniversities],
            currentPage: nextPage,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  // Handles [_UpdateUniversityImageEvent].
  // Updates the image of the university with [event.universityName] with
  // [event.imageFile] and emits a new [_Loaded] state with the updated
  // universities.
  FutureOr<void> _onUpdateImage(
    _UpdateUniversityImageEvent event,
    Emitter<UniversityState> emit,
  ) async {
    final state = this.state;
    if (state is! _Loaded) return;

    final updatedUniversities = state.universities.map((univ) {
      if (univ.name == event.universityName) {
        return univ.copyWith(imageFile: event.imageFile);
      }
      return univ;
    }).toList();

    emit(state.copyWith(universities: updatedUniversities));
  }

  // Handles [_UpdateStudentCountEvent].
  // Updates the student count of the university with [event.universityName]
  // with [event.studentCount] and emits a new [_Loaded] state with the updated
  // universities.
  FutureOr<void> _onUpdateStudentCount(
    _UpdateStudentCountEvent event,
    Emitter<UniversityState> emit,
  ) async {
    final state = this.state;
    if (state is! _Loaded) return;

    final updatedUniversities = state.universities.map((univ) {
      if (univ.name == event.universityName) {
        return univ.copyWith(studentCount: event.studentCount);
      }
      return univ;
    }).toList();

    emit(state.copyWith(universities: updatedUniversities));
  }

  // Handles [_ChangeViewModeEvent] by switching the list mode between
  // [ListMode.gridView] and [ListMode.listView].
  // Emits a new [_Loaded] state with the updated [listMode]. If the current
  // state is not [_Loaded], does nothing.
  FutureOr<void> _onChangeViewMode(
    _ChangeViewModeEvent event,
    Emitter<UniversityState> emit,
  ) async {
    final state = this.state;
    if (state is! _Loaded) return;
    emit(state.copyWith(
        listMode: state.listMode == ListMode.gridView
            ? ListMode.listView
            : ListMode.gridView));
  }
}
