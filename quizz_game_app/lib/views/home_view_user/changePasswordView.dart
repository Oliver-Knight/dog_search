import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/util/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/views/home_view_user/settingView.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _cPasswordC = TextEditingController();
  final TextEditingController _npasswordC = TextEditingController();

  final FocusNode _nPasswordF = FocusNode();

  bool pSecure = false;
  void changePassword() {
    if (_key.currentState!.validate() == true) {
      _auth.add(ChangePasswordEvent(
          email: _auth.state.user!.email!,
          password: _cPasswordC.text,
          nPassword: _npasswordC.text));
    }
  }
  @override
  void dispose() {
    _cPasswordC.dispose();
    _npasswordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: appbarColor,
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      _auth.add(GetUserEvent(email: _auth.state.user!.email!));
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: backgroundColor,
                    )),
              ),
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.3,
                      bottom: 50),
                  child: const Text(
                    "Change Password",
                    style: title,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
                decoration: const BoxDecoration(
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Colors.white54,
                        offset: Offset(0, -2)
                      )
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _cPasswordC,
                            onEditingComplete: () => _nPasswordF.requestFocus(),
                            validator: (_) =>
                                strongPasswordChecker(_cPasswordC.text),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: pSecure ? false : true,
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
                                hintText: "Current Password",
                                border: const OutlineInputBorder())),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: _npasswordC,
                            focusNode: _nPasswordF,
                            onEditingComplete: changePassword,
                            validator: (_) =>
                                strongPasswordChecker(_npasswordC.text),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: pSecure ? false : true,
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
                                hintText: "New Password",
                                border: const OutlineInputBorder())),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                style: buttonStyle,
                                onPressed: changePassword,
                                child:
                                    BlocConsumer<AuthBlocBloc, AuthBlocState>(
                                  listener: (context, state) {
                                    if (state is AuthErrorState) {
                                      AnimatedDialog.showAnimateDialog(
                                          context: context,
                                          alert: QuizAlertDialog(
                                              title:
                                                  "Failed to Change password",
                                              content: state.errorMessage!));
                                    }
                                    if (state is ChangePasswordSuccessState) {
                                      AnimatedDialog.showAnimateDialog(
                                          context: context,
                                          alert:  QuizAlertDialog(
                                            icon: Icons.task_alt,
                                            title: "Password Changed Success",
                                            content:
                                                "Changed your account password Successfully .",
                                          ));
                                    }
                                  },
                                  builder: (context, state) {
                                    return const Text("Update");
                                  },
                                ))),
                        const SizedBox(height: 20),
                        TextButton(
                            onPressed: () {
                              //todo
                            },
                            child: const Text(
                              "Forogt Password ?",
                              style:
                                  TextStyle(color: appbarColor, fontSize: 17),
                            ))
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
