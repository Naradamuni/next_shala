import 'package:base_http/src/token_interceptor.dart';
import 'package:dio/dio.dart';
import 'base_http.dart';
import 'network_exceptions.dart';

///The base url fro [NetworkConfig]
final String apiBaseUrl = networkConfig.baseUrl;

///The network config class
///This can be used to cofigure network client
///Supports only base url atm
///Use as a sigleton NetworkConfig.getInstance()
class NetworkConfig {
  ///The base ur
  String baseUrl = 'http://api.nextshala.com';

  ///The single and shared instance
  static NetworkConfig? _sharedInstance;

  ///Static method to create and return single istance
  static NetworkConfig getInstance() {
    _sharedInstance ??= NetworkConfig();
    return _sharedInstance!;
  }
}

///The network client class
///Designed to make api cals with bearer token easier
///Use only [NetworkClient] for all api calls
///Supports get and post
///Throws exceptions as supported by [network_exceptions]
///Use as a singleton [NetworkClient.getInstance()] only
class NetworkClient {
  ///The constructor
  NetworkClient() {
    _dio = Dio(BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: 10 * 1000, // 60 seconds
        receiveTimeout: 10 * 1000 // 60 seconds
        ));
  }

  ///The shared insstance
  static NetworkClient? sharedInstance;

  ///The dio instance. Dio is used interally to make api calls
  late Dio _dio;

  ///Flag to indicate if token is present
  bool _hasToken = false;

  ///Function to create and retur single instance of [NetworkClient]
  static NetworkClient getInstance() {
    sharedInstance ??= NetworkClient();
    return sharedInstance!;
  }

  ///The get function for http GET
  ///[url] the relative url. Absolute url must be configured using [NetworkConfig]
  ///returns response and hadles [DioError]
  Future<dynamic> get(String url) async {
    var response;
    try {
      response = await _dio.get(apiBaseUrl + url);
    } on DioError catch (e) {
      if (e.response != null) {
        checkStatusCode(
            statusCode: e.response!.statusCode!, message: e.response?.data);
      } else {
        throw FetchDataException(
            'Error occured while Communication with Server');
      }
    }
    return response;
  }

  ///The post function for http POST
  ///[url] the relative url. Absolute url must be configured using [NetworkConfig]
  ///returns response and hadles [DioError]
  Future<dynamic> post(String url, {dynamic data}) async {
    var response;
    try {
      response = await _dio.post(apiBaseUrl + url, data: data);
    } on DioError catch (e) {
      if (e.response != null) {
        checkStatusCode(
            statusCode: e.response!.statusCode!, message: e.response?.data);
      } else {
        throw FetchDataException(
            'Error occured while Communication with Server');
      }
    }
    return response;
  }

  ///The post function for http PUT
  ///[url] the relative url. Absolute url must be configured using [NetworkConfig]
  ///returns response and hadles [DioError]
  Future<dynamic> put(String url, dynamic data) async {
    var response;
    try {
      response = await _dio.put(apiBaseUrl + url, data: data);
    } on DioError catch (e) {
      if (e.response != null) {
        checkStatusCode(
            statusCode: e.response!.statusCode!, message: e.response?.data);
      } else {
        throw FetchDataException(
            'Error occured while Communication with Server');
      }
    }
    return response;
  }

  ///Method to set token, like bearer token for auth
  ///Token will be added as 'Beaer $token' under 'authorization' key in header
  ///Does not support changing 'Bearer' string or header key
  Future setToken(String token) async {
    if (!_hasToken) {
      Interceptor options = await TokenInterceptor().getInterceptor(token);
      _dio.interceptors.add(options);
      _hasToken = true;
    }
  }

  ///Method to clear all interceptors
  void clear() {
    _dio.interceptors.clear();
    _dio.clear();
    _hasToken = false;
  }
}
