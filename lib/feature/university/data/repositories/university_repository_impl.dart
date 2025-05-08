import 'package:tyba_university_app/core/either/either.dart';
import 'package:tyba_university_app/core/failure/http_request_failure.dart';
import 'package:tyba_university_app/feature/university/data/datasource/remote/university_api.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';
import 'package:tyba_university_app/feature/university/domain/repositories/university_repository.dart';
import 'package:tyba_university_app/shared/utils/util.dart';

// Implementation of [UniversityRepository]
class UniversityRepositoryImpl implements UniversityRepository {
  UniversityRepositoryImpl({required this.universityApi});
  final UniversityApi universityApi;

  @override
  Future<Either<HttpRequestFailure, List<University>>> getUniversities(
      {int page = 1}) {
    return Util.performHttpRequest(universityApi.getUniversities(page: page));
  }
}
