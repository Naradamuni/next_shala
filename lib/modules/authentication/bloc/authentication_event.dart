part of 'authentication_bloc.dart';

///Abstract class that encapsuates an authentication evet
abstract class AuthenticationEvent extends Equatable {
  ///Constructor
  const AuthenticationEvent();

  ///Equatable override to get props
  @override
  List<Object> get props => [];
}

class SigninEvent extends AuthenticationEvent {
  final String user;
  final String password;

  const SigninEvent({required this.user, required this.password});
}

///A class that ecapsulates a event whe AutheticationState changes
class AuthenticationStatusChanged extends AuthenticationEvent {
  ///Constructor
  const AuthenticationStatusChanged(this.result);

  ///The result
  final AuthenticationResult result;

  ///Equatable override to get props
  @override
  List<Object> get props => [result];
}

///Class for event to update user in auth bloc
class UpdateUserEvent extends AuthenticationEvent {
  ///The constructor
  const UpdateUserEvent(this.user);

  ///The updaed user model
  final User user;

  ///Equatable override to get props
  @override
  List<Object> get props => [user];
}

class DidGetDeeplinkEvent extends AuthenticationEvent {
  final String path;
  final String id;

  const DidGetDeeplinkEvent({required this.path, required this.id});

  ///Equatable override to get props
  @override
  List<Object> get props => [path, id];
}

class RegisterFCMEvent extends AuthenticationEvent {}

///A class that ecapsulates a event when log out iis requested by the usser
class AuthenticationLogoutRequested extends AuthenticationEvent {}
