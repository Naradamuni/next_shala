part of 'authentication_bloc.dart';

///The authentication state of the app
class AuthenticationState extends Equatable {
  ///The constructor
  const AuthenticationState(
      {this.status = AuthenticationStatus.unknown,
      this.user = const User.empty(),
      this.fcmToken = '',
      this.error = '',
      this.isLoading = false});

  ///Method to create a inistance of authenticated state
  const AuthenticationState.authenticated({required User user})
      : this(status: AuthenticationStatus.authenticated, user: user);

  ///Method to create a insteance of authentication state failure
  const AuthenticationState.failure()
      : this(status: AuthenticationStatus.failure);

  ///Creates a [AuthenticationState] instance from a json object
  ///[map] the json object
  AuthenticationState.fromJson(Map<String, dynamic> map)
      : user = map['user'],
        status = map['status'],
        fcmToken = map['fcmToken'],
        error = map['error'],
        isLoading = map['isLoading'];

  ///Method to create an insstace of authentication state unauthenticated
  const AuthenticationState.unauthenticated()
      : this(status: AuthenticationStatus.unauthenticated);

  ///Method to create an instance of unknown authenticatio state
  const AuthenticationState.unknown() : this();

  ///The error message
  final String error;

  ///The status of authentication
  final AuthenticationStatus status;

  ///The user
  final User user;

  ///The flahg to indicate loading
  final bool isLoading;

  final String fcmToken;

  ///return props, an Equatable @override
  @override
  List<Object> get props => [status, user, error, isLoading, fcmToken];

  ///Creates a [Map<String, dynamic>] from an [AuthenticationState] instance
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'status': status.toString(),
      'fcmToken': fcmToken,
      'error': error,
      'isLoading': isLoading,
    };
  }

  AuthenticationState copyWith({
    User? user,
    String? token,
    AuthenticationStatus? status,
    String? error,
    bool? isLoading,
    String? fcmToken,
  }) {
    return AuthenticationState(
        user: user ?? this.user,
        status: status ?? this.status,
        error: error ?? this.error,
        fcmToken: fcmToken ?? this.fcmToken,
        isLoading: isLoading ?? this.isLoading);
  }
}
