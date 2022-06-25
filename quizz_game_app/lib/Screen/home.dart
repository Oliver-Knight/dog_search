import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Bloc/Navigate_bloc/navigatorBloc.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/views/admin_views/home_view_admin/home_view.dart';
import 'package:quizz_game_app/views/home_view_user/settingView.dart';
import 'package:quizz_game_app/widget/home_widget/bottomNavItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/util/color.dart';
import 'package:quizz_game_app/views/home_view_user/homeView.dart';
import 'package:quizz_game_app/views/home_view_user/profileView.dart';
import 'package:lottie/lottie.dart';

List<Widget> homeList = [HomeView(), const ProfileView(), const SettingView()];
List<Widget> adminList = [AdminHomeView(),const ProfileView(), const SettingView()];

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  late final NavigatorCubit _cubit = context.watch<NavigatorCubit>();
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();
  String? _role;
  @override
  Widget build(BuildContext context) {
    if (_role == '(user)') {
      return Scaffold(
        body: homeList[_cubit.state],
        bottomNavigationBar: Container(
          height: 50,
          decoration: const BoxDecoration(
              color: appbarColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(10)),
              boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(5, -2))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BotNavItem(
                index: 0,
                ficon: Icons.sports_esports,
                name: "Games",
              ),
              BotNavItem(
                index: 1,
                ficon: Icons.person,
                name: "Profile",
              ),
              BotNavItem(
                ficon: Icons.settings,
                name: "Setting",
                index: 2,
              ),
            ],
          ),
        ),
      );
    } else if (_role == '(admin)') {
      return Scaffold(
        body: adminList[_cubit.state],
        bottomNavigationBar: Container(
          height: 50,
          decoration: const BoxDecoration(
              color: appbarColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(10)),
              boxShadow: [BoxShadow(blurRadius: 5, offset: Offset(5, -2))]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BotNavItem(
                index: 0,
                ficon: Icons.sports_esports,
                name: "Games",
              ),
              BotNavItem(
                index: 1,
                ficon: Icons.person,
                name: "Profile",
              ),
              BotNavItem(
                ficon: Icons.settings,
                name: "Setting",
                index: 2,
              ),
            ],
          ),
        ),
      );
    } else {
      Future.delayed(const Duration(seconds: 3), () async {
        _role = await DatabaseHelper.instance
            .getUserRole(email: _auth.state.user!.email!);
        setState(() {});
      });
      return Scaffold(
        body: Container(
          color: appbarColor,
          child: Center(
            child: Lottie.asset('asset/welcome.json'),
            // child: CircularProgressIndicator(),
          ),
        ),
      );
    }
  }
}
