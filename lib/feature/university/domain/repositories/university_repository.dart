import 'package:tyba_university_app/core/either/either.dart';
import 'package:tyba_university_app/core/failure/http_request_failure.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';

// Interface for universities repository
abstract class UniversityRepository {
  Future<Either<HttpRequestFailure, List<University>>> getUniversities(
      {int page = 1});
}
