import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';
import 'package:next_shala/utils/fcm.dart';

///The main view class for the lauch bloc
///*Splash fragments/componets can be a child of this class
class LaunchView extends StatelessWidget {
  ///The constructor
  const LaunchView({
    Key? key,
  }) : super(key: key);

  ///Override build
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      // listenWhen: (previous, current) => previous.status != current.status,
      child: Container(),
      listener: (context, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            context.read<AuthenticationBloc>().add(RegisterFCMEvent());
              FCM().init(context);
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case AuthenticationStatus.failure:
          case AuthenticationStatus.unauthenticated:
          case AuthenticationStatus.unknown:
            Navigator.pushReplacementNamed(context, '/login');
            break;
        }
      },
    );
  }
}
