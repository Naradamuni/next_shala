import 'package:dio/dio.dart';

///An interceptor that adds a bearer token in http header
///adds 'Bearer $token' under 'authorization' key
class TokenInterceptor {
  static List<Map> list = [];

  /// function to add Authorization header to dio
  /// this function adds user access [token] to the authentication header Bearerm
  /// and retuns the config options
  Interceptor getInterceptor(String token) {
    return QueuedInterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers["Authorization"] = 'Bearer $token';
        return handler.next(options);
      },
    );
  }
}

final interceptorConfig = TokenInterceptor();
