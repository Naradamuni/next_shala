import 'dart:async';
import 'package:base_http/base_http.dart';

///The types of authetication status
enum AuthenticationStatus {
  ///The status has not yet been determined
  unknown,

  ///status is authenticated
  authenticated,

  ///status when an attempt to autheticate fails
  failure,

  ///status is unauthenticated
  unauthenticated
}

///A class that encapsulates an autheticatio result
class AuthenticationResult {
  ///The error if any
  String? error;

  ///The status
  final AuthenticationStatus status;

  ///The user if any
  Map? user;

  ///The constructor
  AuthenticationResult({
    required this.status,
    this.user,
    this.error,
  });
}

///The authenticatio repository
///Supports emailLogin
class AuthenticationRepository {
  ///The stream conntroller for [AuthenticationResult]
  final _controller = StreamController<AuthenticationResult>();

  ///The stream for [AuthenticationResult]
  Stream<AuthenticationResult> get status async* {
    yield* _controller.stream;
  }

  /// API call to authenticate ad log in with email & password
  /// [email] the email
  /// [password] the password
  /// adds [AuthenticationResult] to StreamController
  Future<void> emailLogin(
      {required String email, required String password}) async {
    try {
      final response = await networkClient
          .post('/login.svc/log_in', data: {'uid': email, 'pwd': password});
      if (response.data['log_inResult']['Status'] == 'Success') {
        _controller.add(AuthenticationResult(
          status: AuthenticationStatus.authenticated,
          user: response.data['log_inResult']['Result'][0],
        ));
      } else {
        _controller.add(AuthenticationResult(
          status: AuthenticationStatus.failure,
          error: "Username or password is wrong",
        ));
      }
    } on CustomException catch (exception) {
      _controller.add(AuthenticationResult(
        status: AuthenticationStatus.failure,
        error: exception.toString(),
      ));
    }
  }

  void dispose() => _controller.close();
}
