import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';
import 'package:next_shala/utils/fcm.dart';

///A widget that shows a child page (login/signup) and routes based on changes on auth/state
///Uses[AuthenticationBloc] & [AuthenticationState].
/// *Expects context to satisfy the dependencies
///The auth page can be a login or a signup page
///Routs to home on succesful authentication
///Shows alerts when auth is unsucessful
class AuthView extends StatelessWidget {
  ///The constructroe
  const AuthView({
    Key? key,
    required this.authPage,
  }) : super(key: key);

  ///The auth page can be logic or signup
  final Widget authPage;

  ///Render UI
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      // listenWhen: (previous, current) => previous.status != current.status,
      child: authPage,
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            if (state.user.userId != '') {
              context.read<AuthenticationBloc>().add(RegisterFCMEvent());
              WidgetsBinding.instance
                  .addPostFrameCallback((_) => FCM().init(context));
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => Navigator.pushReplacementNamed(context, '/home'));
            }
            break;
          case AuthenticationStatus.failure:
            context.read<AuthenticationBloc>().add(AuthenticationStatusChanged(
                AuthenticationResult(
                    status: AuthenticationStatus.unauthenticated)));
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(content: Text('Authentication Failure')),
              );
            break;
          case AuthenticationStatus.unauthenticated:
            break;
          default:
            break;
        }
      },
    );
  }
}
