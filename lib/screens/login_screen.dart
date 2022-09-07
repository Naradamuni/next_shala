import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:next_shala/modules/authentication/bloc/authentication_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late EdgeInsets devicePadding;
  bool showPassword = false;

  loginSubmit(BuildContext buildContext) async {
    buildContext.read<AuthenticationBloc>().add(SigninEvent(
        user: emailController.text, password: passwordController.text));
  }

  toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  ///function to build Signin UI
  buildSigninUI(BuildContext buildContext, AuthenticationState state) {
    return Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 50.0,
            right: 50.0,
            top: devicePadding.top + 40.0,
            bottom: (MediaQuery.of(context).size.height > 600) ? 50 : 0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (state.error != '')
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    state.error,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              // NExt shala logo and app title
              Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'assets/school-logo.jpg',
                        // color: Color(globalTheme.mainTextColor),
                        height: 100,
                      ),
                      Container(
                          width: 200,
                          padding: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "JSSSMCS Hubli",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontWeight: FontWeight.w800),
                          ))
                    ],
                  )),

              // Login form
              Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "User-ID",
                          hintText: "User-ID",
                          labelStyle: TextStyle(color: Colors.black45),
                          // errorText: emailValidator,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        // onChanged: (value) {
                        //   setEmail(value);
                        // },
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          // override textfield's icon color when selected
                          primaryColor: Colors.black,
                        ),
                        child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: TextFormField(
                              scrollPadding: const EdgeInsets.all(150),
                              controller: passwordController,
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.black45),
                                  hintText: "Password",
                                  labelText: "Password",
                                  // errorText: passwordValidator,
                                  errorMaxLines: 2,
                                  suffixIcon: GestureDetector(
                                      onTap: () {
                                        toggleShowPassword();
                                      },
                                      child: const Icon(Icons.remove_red_eye))),
                              // onChanged: (String value) {
                              //   setPassword(value);
                              // },
                            )),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                            minimumSize:
                                MaterialStateProperty.all(const Size(100, 50)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF964FE8)),
                          ),
                          onPressed: () {
                            loginSubmit(buildContext);
                          },
                          child: const Text("Login"))
                    ],
                  )),
            ]),
      ),
    );
  }

  Widget view(BuildContext buildContext, AuthenticationState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(body: buildSigninUI(buildContext, state));
  }

  @override
  Widget build(BuildContext context) {
    devicePadding = MediaQuery.of(context).padding;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state.status == AuthenticationStatus.authenticated &&
            state.user.userId != '') {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => Navigator.pushReplacementNamed(context, '/home'));
        }
        return view(context, state);
      },
    );
  }
}
