import 'package:authentication_repository/authentication_repository.dart';
import 'package:base_http/base_http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:next_shala/config/environment.dart';
import 'package:next_shala/config/routing_arg.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';
import 'package:next_shala/modules/authentication/view/auth_view.dart';
import 'package:next_shala/modules/authentication/view/launch_view.dart';
import 'package:next_shala/screens/attendence.dart';
import 'package:next_shala/screens/dashboard.dart';
import 'package:next_shala/screens/events.dart';
import 'package:next_shala/screens/home_page.dart';
import 'package:next_shala/screens/home_work.dart';
import 'package:next_shala/screens/login_screen.dart';
import 'package:next_shala/screens/messages.dart';
import 'package:next_shala/screens/profile.dart';
import 'package:next_shala/screens/time-table.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

///main function to run app
void main() async {
  networkConfig.baseUrl = environment['baseUrl']!;
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  HydratedBlocOverrides.runZoned(
    () => runApp(const MyApp()),
    storage: storage,
  );
}

///Class encapsulating the entire application
class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  State<MyApp> createState() => _MyApp();
}

///Class encapsulating the entire application
class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  ///Function to initialize state of app. Setus up prototyper
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // listenFirbase(context);
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: AuthenticationRepository()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(create: (context) {
                return AuthenticationBloc(
                    authenticationRepository:
                        context.read<AuthenticationRepository>());
              }),
            ],
            child: GetMaterialApp(
              home: const LaunchView(),
              routes: {
                '/app': (context) => const AuthView(
                      authPage: LoginScreen(),
                    ),
                '/login': (context) => const LoginScreen(),
                '/home': (context) => const HomePage(),
                '/dashboard': (context) => const DashboardPage(),
                '/attendence': (context) => const AttendencePage(),
                '/profile': (context) => const ProfilePage(),
                '/home_work': (context) => const HomeWorkPage(),
                '/messages': (context) => const MessagesPage(),
                '/events': (context) => const EventsPage(),
                '/time_table': (context) => const TimeTablePage(),
              },
            )));
  }
}
