import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

/// The above class defines different types of HTTP request failures using the freezed package in Dart.
@freezed
 abstract class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.network({String? msg}) = _Network;
  factory HttpRequestFailure.notFound({String? msg}) = _NotFound;
  factory HttpRequestFailure.server({String? msg}) = _Server;
  factory HttpRequestFailure.unauthorized({String? msg}) = _Unauthorized;
  factory HttpRequestFailure.badRequest({String? msg}) = _BadRequest;
  factory HttpRequestFailure.local({String? msg}) = _Local;
}
