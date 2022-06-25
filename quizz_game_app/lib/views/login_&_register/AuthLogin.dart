import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/util/validator.dart';
import 'package:quizz_game_app/views/home_view_user/homeView.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthLoginView extends StatefulWidget {
  const AuthLoginView({Key? key}) : super(key: key);

  @override
  State<AuthLoginView> createState() => _AuthLoginViewState();
}

class _AuthLoginViewState extends State<AuthLoginView> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  void _login() {
    if (fkey!.currentState?.validate() == true) {
      _auth.add(
          LoginWithEmailEvent(email: emailC.text, password: passwordC.text));
    }
  }

  GlobalKey<FormState>? fkey = GlobalKey();

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FocusNode emailF = FocusNode();
  FocusNode passwordF = FocusNode();

  bool pSecure = true;
  final String url = 'images/Login.png';

  @override
  void dispose() {
    emailC.dispose();
    passwordC.dispose();
    fkey = null;
    fkey = GlobalKey();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Login To Our System",
                style: title.copyWith(color: appbarColor),
              ),
              Image.asset(url),
              Form(
                  key: fkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailC,
                          focusNode: emailF,
                          onEditingComplete: () => passwordF.requestFocus(),
                          validator: (_) => emailValidator(emailC.text),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: appbarColor,
                              ),
                              labelText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: passwordC,
                            focusNode: passwordF,
                            obscureText: pSecure ? true : false,
                            onEditingComplete: _login,
                            validator: (_) => passwordC.text.isEmpty
                                ? "Password Required"
                                : null,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.vpn_key,
                                  color: appbarColor,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    pSecure = !pSecure;
                                    setState(() {});
                                  },
                                  icon: pSecure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  color: appbarColor,
                                ),
                                labelText: "Password",
                                border: const OutlineInputBorder())),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 500,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              _login();
                            },
                            child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
                              listener: (context, state) {
                                if (state is AuthErrorState) {
                                  if (!state.errorMessage.toString().contains(
                                      'ID token and access token is required')) {
                                    AnimatedDialog.showAnimateDialog(
                                        context: context,
                                        alert: QuizAlertDialog(
                                            title: "Login Failed",
                                            content:
                                                state.errorMessage.toString()));
                                  }
                                }
                              },
                              builder: (context, state) {
                                return const Text("Login");
                              },
                            ),
                            style: buttonStyle.copyWith(
                                elevation: MaterialStateProperty.all(5)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontSize: 17, color: appbarColor),
                                )),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(AuthRegisterScreen);
                                },
                                child: const Text(
                                    "I don't Have account, Sing Up",
                                    style: TextStyle(
                                        fontSize: 17, color: appbarColor))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              color: appbarColor,
                              height: 0.5,
                              width: MediaQuery.of(context).size.width * 0.40,
                            ),
                            const Text(
                              "OR",
                              style: TextStyle(
                                fontSize: 17,
                                color: appbarColor,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              color: appbarColor,
                              height: 0.5,
                              width: MediaQuery.of(context).size.width * 0.40,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),

                        ///google sign in
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                              style: buttonStyle.copyWith(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 191, 55, 37))),
                              onPressed: () {
                                //todo
                                _auth.add(LoginWithGoogleEvent());
                              },
                              icon: const FaIcon(FontAwesomeIcons.google),
                              label: const Text("Login with Google")),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton.icon(
                              style: buttonStyle.copyWith(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0XFF4267B2))),
                              onPressed: () {
                                //todo
                              },
                              icon: const FaIcon(FontAwesomeIcons.facebook),
                              label: const Text(
                                "Login with Facebook",
                              )),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ],
      ),
    ));
  }
}
