import 'package:tyba_university_app/core/api/api_endpoint.dart';
import 'package:tyba_university_app/core/const/const.dart';
import 'package:tyba_university_app/core/http/http.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';

// Api class for universities request
class UniversityApi {
  final CoreHttp http;

  UniversityApi({required this.http});

  // Gets a list of universities given a page number
  Future<HttpResult<List<University>>> getUniversities({int page = 1}) async {
    return await http.send(
      Api.universities,
      method: HttpMethod.get,
      parser: (_, json) {
        // Manage pagination
        final allUniversities =
            (json as List).map((e) => University.fromJson(e)).toList();
        final startIndex = (page - 1) * Const.limitPagination;
        if (startIndex >= allUniversities.length) {
          return [];
        }
        final endIndex = startIndex + Const.limitPagination;
        final List<University> universities = allUniversities.sublist(
          startIndex,
          endIndex.clamp(0, allUniversities.length),
        );

        return universities;
      },
    );
  }
}
