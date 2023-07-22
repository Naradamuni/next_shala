import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: const Color(0xff18203d),
        child: SizedBox(
          // height: 200.0,
          width: MediaQuery.of(context).size.width,
          child: Card(
            color: Colors.white,
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              //set border radius more than 50% of height and width to make circle
            ),
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
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Image.asset(
                              'assets/school-logo.jpg',
                              height: 80,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Text("JSSSMCS Hubli",
                                    textAlign: TextAlign.center,
                                    softWrap: true,
                                    style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)))
                          ],
                        )),

                    // Login form
                    Container(
                        margin: const EdgeInsets.only(top: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(1),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withOpacity(1),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.grey.withOpacity(1),
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 10.0),
                                errorStyle: const TextStyle(height: 0.2),
                                hintText: "UserId",
                                hintStyle: GoogleFonts.lato(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              autofocus: false,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(
                                // override textfield's icon color when selected
                                primaryColor: Colors.black,
                              ),
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(1),
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(1),
                                            width: 1),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: Colors.grey.withOpacity(1),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                      errorStyle: const TextStyle(height: 0.2),
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                      suffixIcon: GestureDetector(
                                          onTap: () {
                                            toggleShowPassword();
                                          },
                                          child: const Icon(
                                              Icons.remove_red_eye))),
                                  autofocus: false,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Center(
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(300, 50)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15))),
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF964FE8)),
                                  ),
                                  onPressed: () {
                                    loginSubmit(buildContext);
                                  },
                                  child: Text(
                                    "LOGIN",
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),
                            )
                          ],
                        )),
                  ]),
            ),
          ),
        ),
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
