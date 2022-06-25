import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/util/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';

class AuthRegisterView extends StatefulWidget {
  const AuthRegisterView({Key? key}) : super(key: key);

  @override
  State<AuthRegisterView> createState() => _AuthRegisterViewState();
}

class _AuthRegisterViewState extends State<AuthRegisterView> {
  final String url = 'images/Register.png';

  GlobalKey<FormState>? fkey = GlobalKey();

  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController cPasswordC = TextEditingController();

  FocusNode passwordF = FocusNode();
  FocusNode cPasswrodF = FocusNode();

  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();

  bool secure = true;
  bool pSecure = true;

  void _register() {
    if (fkey!.currentState?.validate() == true) {
      _auth.add(
          RegisterWithEmailEvent(email: emailC.text, password: passwordC.text));
    }
  }

  @override
  void dispose() {
    passwordC.dispose();
    cPasswordC.dispose();
    emailC.dispose();
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
                "Register To Our System",
                style: title.copyWith(color: appbarColor),
              ),
              Image.asset(
                url,
                height: 300,
              ),
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
                          validator: (_) => emailValidator(emailC.text),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onEditingComplete: () => passwordF.requestFocus(),
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: appbarColor,
                              ),
                              labelText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: passwordC,
                            focusNode: passwordF,
                            onEditingComplete: () => cPasswrodF.requestFocus(),
                            validator: (_) =>
                                strongPasswordChecker(passwordC.text),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: pSecure ? true : false,
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
                          height: 20,
                        ),
                        TextFormField(
                            controller: cPasswordC,
                            focusNode: cPasswrodF,
                            onEditingComplete: _register,
                            validator: (_) {
                              if (cPasswordC.text.isEmpty)
                                return 'Confirm Password Required';
                              if (cPasswordC.text != passwordC.text)
                                return 'Password Does not match';
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: secure ? true : false,
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    secure = !secure;
                                    setState(() {});
                                  },
                                  icon: secure
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  color: appbarColor,
                                ),
                                prefixIcon: const Icon(
                                  Icons.vpn_key,
                                  color: appbarColor,
                                ),
                                labelText: "Confirm Password",
                                border: const OutlineInputBorder())),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 500,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _register,
                            child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
                              listener: (context, state) {
                                if (state is AuthErrorState) {
                                  AnimatedDialog.showAnimateDialog(
                                      context: context,
                                      alert: QuizAlertDialog(
                                          title: "Register Failed",
                                          content:
                                              state.errorMessage.toString()));
                                }
                              },
                              builder: (context, state) {
                                return const Text("Register");
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
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(AuthLoginScreen);
                                },
                                child: const Text(
                                    "Already Have an account | Sing In",
                                    style: TextStyle(
                                        fontSize: 17, color: appbarColor))),
                          ],
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
