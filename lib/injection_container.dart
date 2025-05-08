import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:tyba_university_app/core/environment/env.dart';
import 'package:tyba_university_app/core/http/http.dart';
import 'package:tyba_university_app/feature/university/data/datasource/remote/university_api.dart';
import 'package:tyba_university_app/feature/university/data/repositories/university_repository_impl.dart';
import 'package:tyba_university_app/feature/university/domain/repositories/university_repository.dart';
import 'package:tyba_university_app/feature/university/presentation/bloc/university_bloc.dart';

final GetIt sl = GetIt.instance;

/// The `init` function sets up dependency injection for various features, use cases, repositories,
/// datasources, and core components in the application.
Future<void> init() async {
  // Features
  sl.registerFactory(() => UniversityBloc(universityRepository: sl()));
  // Repositories
  sl.registerLazySingleton<UniversityRepository>(
      () => UniversityRepositoryImpl(universityApi: sl()));
  //! Datasources
  sl.registerLazySingleton(() => UniversityApi(http: sl()));
 
  //! Core
  sl.registerLazySingleton(
      () => CoreHttp(Env.api, sl()));
  sl.registerLazySingleton(() => Client());
  sl.registerLazySingleton(() => Dio());
}
