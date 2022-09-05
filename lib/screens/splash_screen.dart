import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';
import 'package:next_shala/screens/home_page.dart';
import 'package:next_shala/screens/login_screen.dart';

/// #Summary
/// Call to handles all checks need to be handled before launching main app
/// handles routing suth screens, main app, tutorial screen and
/// granting access permission
class SplashScreen extends StatefulWidget {
  /// The constructor
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// main class for the app
class _SplashScreenState extends State<SplashScreen> {
  bool didLoad = false;
  bool doesHaveSession = false;

  Widget view(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/logo.png',
            height: 80,
            width: 80,
            color: Colors.black,
          ),
          const Text(
            "Next Shala",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status != AuthenticationStatus.authenticated) {
          Route route =
              MaterialPageRoute(builder: (context) => const LoginScreen());
          Navigator.push(context, route);
        }
        if (state.status == AuthenticationStatus.authenticated) {
          Route route =
              MaterialPageRoute(builder: (context) => const HomePage());
          Navigator.push(context, route);
        }
        return view(context);
      },
    );
  }
}
