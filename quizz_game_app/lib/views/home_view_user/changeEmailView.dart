import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:quizz_game_app/util/validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/views/home_view_user/settingView.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';

class ChangeEmaildView extends StatefulWidget {
  const ChangeEmaildView({Key? key}) : super(key: key);

  @override
  State<ChangeEmaildView> createState() => _ChangeEmaildViewState();
}

class _ChangeEmaildViewState extends State<ChangeEmaildView> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _emailC = TextEditingController();
  final TextEditingController _cPasswordC = TextEditingController();
  final TextEditingController _nEmailC = TextEditingController();

  final FocusNode _nEmailF = FocusNode();
  final FocusNode _cPasswordF = FocusNode();

  bool pSecure = false;
  void changePassword(UserModal user) {
    if (_key.currentState!.validate() == true) {
      _auth.add(ChangeEmailEvent(
          user: user,
          email: _emailC.text,
          password: _cPasswordC.text,
          nemail: _nEmailC.text));
    }
  }

  @override
  void dispose() {
    _emailC.dispose();
    _cPasswordC.dispose();
    _nEmailC.dispose();
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
                height: MediaQuery.of(context).size.height *0.05,
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
                      top: MediaQuery.of(context).size.height * 0.2,
                      bottom: 50),
                  child: const Text(
                    "Change Email",
                    style: title,
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.62,
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
                          controller: _emailC,
                          onEditingComplete: () => _cPasswordF.requestFocus(),
                          validator: (_) => emailValidator(_emailC.text),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: appbarColor,
                              ),
                              hintText: "Email",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: _cPasswordC,
                            focusNode: _cPasswordF,
                            onEditingComplete: () => _nEmailF.requestFocus(),
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
                            controller: _nEmailC,
                            focusNode: _nEmailF,
                            // onEditingComplete: changePassword,
                            validator: (_) => emailValidator(_nEmailC.text),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: appbarColor,
                                ),
                                hintText: "New Email",
                                border: OutlineInputBorder())),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: BlocConsumer<AuthBlocBloc, AuthBlocState>(
                              listener: (context, state) {
                                if (state is AuthErrorState) {
                                  AnimatedDialog.showAnimateDialog(
                                      context: context,
                                      alert: QuizAlertDialog(
                                          title: "Failed to Change Email",
                                          content: state.errorMessage!));
                                }
                                if (state is ChangeEmailSuccessState) {
                                  AnimatedDialog.showAnimateDialog(
                                      context: context,
                                      alert: QuizAlertDialog(
                                        icon: Icons.task_alt,
                                        title: "Email Changed Success",
                                        content:
                                            "Changed your account Email Successfully .",
                                      ));
                                }
                              },
                              builder: (context, state) {
                                return ElevatedButton(
                                    style: buttonStyle,
                                    onPressed: () {
                                      if(state is GetUserState){
                                        UserModal user = state.mUser!.copyWith(email: _nEmailC.text);
                                        changePassword(user);
                                      }
                                    },
                                    child: const Text("Update"));
                              },
                            )),
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
