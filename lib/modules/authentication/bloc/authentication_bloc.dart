import 'dart:async';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_http/base_http.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

const String kAuthStateSaveKey = 'auth_state';
const String kUserIdSaveKey = 'current_user_id';

class User extends Equatable {
  const User(
      {required this.fname,
      required this.lname,
      required this.mname,
      required this.phone,
      required this.userId,
      required this.studId});
  final String userId;
  final String studId;
  final String fname;
  final String mname;
  final String lname;
  final String phone;
  User.fromJson(Map data)
      : userId = data['UserId'],
        studId = data['StudentId'],
        fname = data['FirstName'],
        mname = data['MiddleName'],
        lname = data['LastName'],
        phone = data['MobileNo'];
  toJson() => {
        "UserId": userId,
        'StudentId': studId,
        'FirstName': fname,
        'MiddleName': mname,
        'LastName': lname,
        'MobileNo': phone
      };
  const User.empty(
      {this.studId = '',
      this.mname = '',
      this.userId = '',
      this.fname = '',
      this.lname = '',
      this.phone = ''});

  @override
  List<Object?> get props => [userId, studId, fname, mname, lname, phone];
  User copyWith({
    String? userId,
    String? studId,
    String? fname,
    String? lname,
    String? mname,
    String? phone,
  }) {
    return User(
        userId: userId ?? this.userId,
        studId: studId ?? this.studId,
        fname: fname ?? this.fname,
        lname: lname ?? this.lname,
        mname: mname ?? this.mname,
        phone: phone ?? this.phone);
  }
}

///The authentication bloc.
///Uses a hydrated bloc
///This bloc saves and persists [AuthenticationState] locally
///Requires [AuthenticationRepository] to get auth related data

///AutheticationBloc is currently redsponsible for
///1. checking token and user status and querying them from local storage on launch
///2. saving whenever authentication state changes
///3. lissten to changes i auth state and change state object and emit events
class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  ///The constructor
  ///Setss up listeners.
  ///Checks and changes auth state based on local storage data
  AuthenticationBloc({
    required this.authenticationRepository,
    // required this.userRepository,
  }) : super(const AuthenticationState.unknown()) {
    on<AuthenticationStatusChanged>(_onAuthenticationStatusChanged);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<SigninEvent>(_onSigninEvent);
    on<RegisterFCMEvent>(_onRegisterFCMEvent);
    on<AuthenticationLogoutRequested>(_onAuthenticationLogoutRequested);
    authenticationStatusSubscription = authenticationRepository.status
        .listen((result) => add(AuthenticationStatusChanged(result)));
    _checkAuthState();
  }

  ///!All iVars here should ideally be protected. So that subclasses may acccess
  ///!Consider using the meta package to get @protected anotation
  ///The authentication repository
  final AuthenticationRepository authenticationRepository;

  ///The stream subscription for [AuthenticationResult]
  late StreamSubscription<AuthenticationResult>
      authenticationStatusSubscription;

  ///The user repository.
  ///*Currently unused
  // final UserRepository userRepository;

  ///Overridig close
  ///Cancels subbscriptions
  ///Disposes repositories

  @override
  Future<void> close() {
    authenticationStatusSubscription.cancel();
    authenticationRepository.dispose();
    // userRepository.dispose();
    return super.close();
  }

  ///Convinience function to convert json to instance
  ///[json] the json object
  ///returns [AuthenticationState] instance
  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    return AuthenticationState(
        isLoading: json['isLoading'],
        user: User.fromJson(json['user']),
        fcmToken: json['fcmToken'],
        status: AuthenticationStatus.values
            .firstWhere((e) => e.toString() == json['status']));
  }

  ///Function to convert instance to json object
  ///[state] the state instance
  ///returns a [Map]
  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    return {
      'user': state.user.toJson(),
      'fcmToken': state.fcmToken,
      'status': state.status.toString(),
      'isLoading': state.isLoading
    };
  }

  _onRegisterFCMEvent(
      RegisterFCMEvent event, Emitter<AuthenticationState> emit) async {
    FirebaseMessaging.instance.getToken().then((token) async {
      if (state.fcmToken == '' || state.fcmToken != token) {
        emit(state.copyWith(fcmToken: token));
        final response = await networkClient.post('/login.svc/postdevicedt',
            data: {
              'stud_id': state.user.studId,
              'device_token': token
            }).catchError((onError) {
          print(onError);
        });
      }
    });
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data['url'] != null) {
        // add(DidGetDeeplinkEvent(path: initialMessage.data['url']));
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['url'] != null) {
        // add(DidGetDeeplinkEvent(path: message.data['url']));
      }
    });
  }

  _onSigninEvent(SigninEvent event, Emitter<AuthenticationState> emit) {
    emit(state.copyWith(isLoading: true));
    authenticationRepository.emailLogin(
        email: event.user, password: event.password);
  }

  ///Funtion to check auth state from local storage
  ///Notifies if there is change in auth state
  Future<void> _checkAuthState() async {
    final userId = await HydratedBlocOverrides.current!.storage
            .read(kUserIdSaveKey) as String? ??
        '';

    final Map authState =
        await HydratedBlocOverrides.current!.storage.read(kAuthStateSaveKey) ??
            {};

    if (userId.isNotEmpty && authState.isNotEmpty) {
      final authStatus = AuthenticationStatus.values
          .firstWhere((e) => e.toString() == authState[userId]['status']);

      add(AuthenticationStatusChanged(AuthenticationResult(
          status: authStatus, user: authState[userId]['user'])));
    } else {
      add(AuthenticationStatusChanged(AuthenticationResult(
        status: AuthenticationStatus.unauthenticated,
      )));
    }
  }

  ///!This fuction should ideally be protected. So that subclasses may acccess
  ///!Consider using the meta package to get @protected anotation
  ///Function that saves and persists [AuthenticationState] instance
  ///[model] the state model
  Future<void> save(AuthenticationState model) async {
    final id = model.user.userId;

    await HydratedBlocOverrides.current!.storage.write(kUserIdSaveKey, id);

    final Map authStateStorageMap =
        await HydratedBlocOverrides.current!.storage.read(kAuthStateSaveKey) ??
            {};

    authStateStorageMap[id] = model.toJson();

    await HydratedBlocOverrides.current!.storage
        .write(kAuthStateSaveKey, authStateStorageMap);
  }

  ///Function thatt handles a state chage in [AuthenticationState] instance
  ///[event] the event that caused the state to change
  ///[emit] the latest state as [Emitter<AuthenticaionState>]
  void _onAuthenticationStatusChanged(
    AuthenticationStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.result.status) {
      case AuthenticationStatus.unauthenticated:
        const authState = AuthenticationState.unauthenticated();
        return emit(authState);
      case AuthenticationStatus.failure:
        const authState = AuthenticationState.failure();
        return emit(authState);
      case AuthenticationStatus.authenticated:
        var authState = event.result.user != null
            ? AuthenticationState.authenticated(
                user: User.fromJson(event.result.user!),
              )
            : const AuthenticationState.unauthenticated();

        await save(authState);
        // networkClient.setToken(authState.token);
        return emit(authState);
      default:
        return emit(const AuthenticationState.unknown());
    }
  }

  void _onUpdateUserEvent(
    UpdateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(state.copyWith(
        user: event.user,
      ));
      await save(state);
    } catch (e) {
      emit(state.copyWith(error: 'Could not update user'));
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    emit(const AuthenticationState.unknown());
    HydratedBlocOverrides.current?.storage.clear();
  }
}
