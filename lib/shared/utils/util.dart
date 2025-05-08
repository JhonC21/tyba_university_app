import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart';
import 'package:tyba_university_app/core/either/either.dart';
import 'package:tyba_university_app/core/failure/http_request_failure.dart';
import 'package:tyba_university_app/core/http/http.dart';

class Util {
  Util._();

  /// The function `performHttpRequest` takes a `Future` that returns an `HttpResult` and returns a
  /// `Future` that either contains an `HttpRequestFailure` or the data from a successful `HttpSuccess`
  /// result.
  ///
  /// Args:
  ///   future (Future<HttpResult<T>>): A `Future` that represents the asynchronous HTTP request. It is
  /// expected to return an `HttpResult<T>`, where `T` is the type of data expected in the response.
  ///
  /// Returns:
  ///   The function `performHttpRequest` returns a `Future` that resolves to an `Either` object. The
  /// `Either` object can contain either a `HttpRequestFailure` object (if the HTTP request fails) or a
  /// value of type `T` (if the HTTP request is successful).
  static Future<Either<HttpRequestFailure, T>> performHttpRequest<T>(
      Future<HttpResult<T>> future) async {
    final HttpResult<T> result = await future;
    if (result is HttpFailure<T>) {
      HttpRequestFailure? failure;
      if (failDueToNetwork(result)) {
        failure = HttpRequestFailure.network();
      } else if (failDueToParser(result)) {
        failure = HttpRequestFailure.local();
      } else {
        Map<String, dynamic>? value;
        String? msg;
        if (result.data is Map<String, dynamic>) {
          value = result.data as Map<String, dynamic>;
          msg = value['message'];
        }
        switch (result.statusCode) {
          case 404:
            failure = HttpRequestFailure.notFound(msg: msg);
            break;
          case 401:
            failure = HttpRequestFailure.unauthorized(msg: msg);
            break;
          case 403:
            failure = HttpRequestFailure.unauthorized(msg: msg);
            break;
          case 400:
            failure = HttpRequestFailure.badRequest(msg: msg);
            break;
          default:
            failure = HttpRequestFailure.server(msg: msg);
        }
      }

      return Either<HttpRequestFailure, T>.left(failure);
    }
    return Either<HttpRequestFailure, T>.right(
      (result as HttpSuccess<T>).data,
    );
  }

  /// The function checks if a failure is due to a network issue by checking if the failure data is a
  /// SocketException or a ClientException.
  ///
  /// Args:
  ///   failure (HttpFailure<T>): The parameter "failure" is of type HttpFailure<T>, where T is a
  /// generic type.
  ///
  /// Returns:
  ///   a boolean value.
  static bool failDueToNetwork<T>(HttpFailure<T> failure) {
    final Object? data = failure.data;
    if (data is DioException) {
      if (data.error is SocketException) {
        return true;
      }
    }
    return data is SocketException || data is ClientException;
  }

  /// The function checks if the data in an HttpFailure object is not a String, Map, or List.
  ///
  /// Args:
  ///   failure (HttpFailure<T>): The parameter "failure" is of type HttpFailure<T>.
  ///
  /// Returns:
  ///   a boolean value.
  static bool failDueToParser<T>(HttpFailure<T> failure) {
    final Object? data = failure.data;
    return data is! String && data is! Map && data is! List;
  }
}
