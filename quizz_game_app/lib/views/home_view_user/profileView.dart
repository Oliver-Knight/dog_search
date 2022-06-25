import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/widget/dialog_widget/animate_dialog.dart';
import 'package:quizz_game_app/widget/dialog_widget/auth_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  final ImagePicker _imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    print("email : ${_auth.state.user?.email!}");
    // _auth.add(LogoutEvent());
    _auth.add(GetUserEvent(email: _auth.state.user!.email!));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<AuthBlocBloc, AuthBlocState>(
        builder: (_, state) {
          return Scaffold(
            backgroundColor: backgroundColor,
            body: TweenAnimationBuilder(
              child: Column(children: [
                if (state is GetUserState) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    height: 200,
                    decoration: const BoxDecoration(
                        color: appbarColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8)),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 5), blurRadius: 5)
                        ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.mUser?.displayName ??
                                    state.mUser!.email!
                                        .split("@")
                                        .first
                                        .toUpperCase(),
                                style: profileName,
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Point : ",
                                    style: scoreStyle,
                                  ),
                                  Text(
                                    state.mUser!.score.toString(),
                                    style: scoreStyle.copyWith(
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 2 / 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: backgroundColor)),
                                child: CircleAvatar(
                                    maxRadius: 50,
                                    minRadius: 30,
                                    backgroundColor: Colors.grey,
                                    backgroundImage:
                                        const AssetImage('images/profile.jpg'),
                                    foregroundImage: state.mUser?.photoUrl != null
                                        ? FileImage(File(state.mUser!.photoUrl!))
                                        : null),
                              ),
                              ElevatedButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(buttonColor)),
                                  onPressed: () async {
                                    AnimatedDialog.showAnimateDialog(
                                        context: context,
                                        alert: _imageDialog(state.mUser!));
                                  },
                                  icon: const Icon(Icons.add_a_photo),
                                  label: state.mUser?.photoUrl == null
                                      ? const Text("Add a Photo")
                                      : const Text("Change Photo"))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: const BoxDecoration(
                                color: secondaryColor,
                                boxShadow: [
                                  BoxShadow(blurRadius: 5, offset: Offset(5, 5))
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Recent",
                                  style: title,
                                ),
                                TextButton(
                                    onPressed: () {}, child: Text("View All"))
                              ],
                            ),
                          ),
                          OutlinedButton.icon(
                              onPressed: () {
                                AnimatedDialog.showAnimateDialog(
                                    context: context,
                                    alert:  QuizAlertDialog(
                                      title: "LogOut",
                                      content: "Do you want to Logout ?",
                                      icon: Icons.security,
                                      logout: true,
                                    ));
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text("Logout"))
                        ],
                      ),
                    ),
                  )
                ],
              ]),
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0,end: 1),
              builder: (BuildContext _,double _value, Widget? child){
                return Opacity(opacity: _value,child: child,);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _imageDialog(UserModal user) {
    return AlertDialog(
      elevation: 20,
      backgroundColor: appbarColor,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Choose Potion",
                style: profileName,
              ),
              IconButton(
                  splashRadius: 20,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: backgroundColor,
                  ))
            ],
          ),
          const Divider(color: backgroundColor),
        ],
      ),
      content: SizedBox(
        height: 130,
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton.icon(
                style: alertButtonStyle.copyWith(
                    minimumSize:
                        MaterialStateProperty.all(const Size(130, 40))),
                onPressed: () async {
                  XFile? _photo =
                      await _imagePicker.pickImage(source: ImageSource.camera);
                  if (_photo == null) Navigator.pop(context);
                  UserModal userModal = user.copyWith(photoUrl: _photo!.path);
                  DatabaseHelper.instance.updatePhoto(userModal);
                  _auth.add(GetUserEvent(email: user.email!));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.photo_camera),
                label: const Text("Camera")),
            ElevatedButton.icon(
                style: alertButtonStyle.copyWith(
                    minimumSize:
                        MaterialStateProperty.all(const Size(130, 40))),
                onPressed: () async {
                  XFile? _photo =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  if (_photo == null) Navigator.pop(context);
                  UserModal userModal = user.copyWith(photoUrl: _photo!.path);
                  DatabaseHelper.instance.updatePhoto(userModal);
                  _auth.add(GetUserEvent(email: user.email!));
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Gallery")),
          ],
        ),
      ),
    );
  }
}
