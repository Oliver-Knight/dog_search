import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/util/style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeDialog extends StatefulWidget {
  UserModal user;
  ChangeDialog({Key? key, required this.user}) : super(key: key);

  @override
  State<ChangeDialog> createState() => _ChangeDialogState();
}

class _ChangeDialogState extends State<ChangeDialog> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  final TextEditingController? _nameC = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  void updateName() {
    if(_key.currentState!.validate() == true){
      UserModal umodal = widget.user.copyWith(displayName: _nameC!.text);
      DatabaseHelper.instance.changeUser(umodal);
      _auth.add(GetUserEvent(email: _auth.state.user!.email!));
      Navigator.pop(context);
    }
    return;
  }

  @override
  void dispose() {
    _nameC?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameC?.text =
        widget.user.displayName ?? widget.user.email!.split('@').first;
    return Form(
      key: _key,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
        backgroundColor: appbarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Change Name",
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
        content: SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextFormField(
                controller: _nameC,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (e){
                  if(_nameC == null || _nameC!.text.isEmpty){
                    return 'Name must be filled';
                  }
                  return null;
                },
                onEditingComplete: updateName,
                style: const TextStyle(color: appbarColor),
                cursorColor: appbarColor,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    prefixIcon: Icon(
                      Icons.person,
                      color: appbarColor,
                    ),
                    hintText: "Name",
                    hintStyle: TextStyle(
                      color: appbarColor,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: backgroundColor,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: alertButtonStyle,
                onPressed: updateName,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
