import 'dart:convert';
import 'package:http/http.dart';

class CoreHttp {
  final String _baseUrl;
  final Client _client;

  CoreHttp(this._baseUrl, this._client);

  Future<HttpResult<T>> send<T>(
    String path, {
    required T Function(int, dynamic) parser,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Map<String, dynamic> body = const <String, dynamic>{},
  }) async {
    late Request request;
    Response? response;
    try {
      late Uri url;
      if (path.startsWith('http')) {
        url = Uri.parse(path);
      } else {
        if (!path.startsWith('/')) {
          path = '/$path';
        }
        url = Uri.parse('$_baseUrl$path');
      }
      url = url.replace(
        queryParameters: queryParameters,
      );
      request = Request(method.name, url);
      request.headers.addAll(
        <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
          ...headers,
        },
      );
      if (method != HttpMethod.get) {
        request.body = jsonEncode(body);
      }
      final StreamedResponse stream = await _client.send(request);
      response = await Response.fromStream(stream);
      final int statusCode = response.statusCode;
      final dynamic responseBody = _bodyParser(response.body);

      if (statusCode >= 200 && statusCode <= 300) {
        return HttpSuccess<T>(
          statusCode,
          parser(
            statusCode,
            responseBody,
          ),
        );
      }

      if (statusCode == 401) {
        return HttpFailure<T>(
          statusCode,
          'Unauthorized',
        );
      }

      return HttpFailure<T>(
        statusCode,
        responseBody,
      );
    } catch (e) {
      return HttpFailure<T>(
        response?.statusCode,
        e,
      );
    }
  }
}

/// The class `HttpResult` is an abstract class that represents the result of an HTTP request and
/// contains a nullable `statusCode` property.
abstract class HttpResult<T> {
  HttpResult(this.statusCode);
  final int? statusCode;
}

/// The class `HttpSuccess` is a subclass of `HttpResult` that represents a successful HTTP response
/// with a generic data type.
class HttpSuccess<T> extends HttpResult<T> {
  HttpSuccess(super.statusCode, this.data);
  final T data;
}

/// The class `HttpFailure` represents a failed HTTP result with an optional data object.
class HttpFailure<T> extends HttpResult<T> {
  HttpFailure(super.statusCode, this.data);
  final Object? data;
}

// Enum for HTTP methods
enum HttpMethod {
  get,
  post,
  patch,
  put,
  delete,
}

// Helper function to parse the response body
dynamic _bodyParser(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (_) {
    return responseBody;
  }
}
