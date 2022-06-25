import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/util/sub_widget.dart';
import 'package:quizz_game_app/views/home_view_user/changePasswordView.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/change_dialog.dart';

class SettingView extends StatefulWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  @override
  void initState() {
    super.initState();
    // _auth.add(LogoutEvent());
    _auth.add(GetUserEvent(email: _auth.state.user!.email!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: TweenAnimationBuilder(
          child: BlocBuilder<AuthBlocBloc, AuthBlocState>(
            builder: (_, state) {
              return Column(children: [
                if (state is GetUserState) ...[
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(left: 10, right: 10, top: 20),
                    color: appbarColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      leading: Container(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 1, color: backgroundColor),
                            shape: BoxShape.circle),
                        child: CircleAvatar(
                          backgroundImage:
                              const AssetImage('images/profile.jpg'),
                          foregroundImage: state.mUser?.photoUrl != null
                              ? FileImage(File(state.mUser!.photoUrl!))
                              : null,
                          backgroundColor: backgroundColor,
                          radius: 30,
                        ),
                      ),
                      title: Text(
                        state.mUser?.displayName ??
                            state.mUser!.email!.split("@").first.toUpperCase(),
                        style: profileName,
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          AnimatedDialog.showAnimateDialog(
                              context: context,
                              alert: ChangeDialog(
                                user: state.mUser!,
                              ));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: backgroundColor,
                        ),
                        splashRadius: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      children: [
                        _settingAction(
                          Icons.language,
                          "Change Language",
                        ),
                        divider(),
                        _settingAction(Icons.lock, "Change Password",
                            ontap: () {
                          Navigator.of(context).pushNamed(ChangePassword);
                        }, sub: const Text("******")),
                        divider(),
                        _settingAction(Icons.email, "Change Email", ontap: () {
                          Navigator.of(context).pushNamed(ChangeEmail);
                        }, sub: Text(_auth.state.user!.email!)),
                      ],
                    ),
                  ),
                ]
              ]);
            },
          ),
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (BuildContext _, double _value, Widget? child) {
            return Opacity(
              opacity: _value,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget _settingAction(IconData ficon, String title,
      {void Function()? ontap, Widget? sub}) {
    return ListTile(
      dense: true,
      onTap: ontap,
      subtitle: sub,
      leading: Icon(
        ficon,
        color: appbarColor,
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
