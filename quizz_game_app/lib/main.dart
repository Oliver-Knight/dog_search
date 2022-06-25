import 'package:flutter/material.dart';
import 'package:quizz_game_app/Bloc/Auth_bloc/auth_bloc_bloc.dart';
import 'package:quizz_game_app/Bloc/Navigate_bloc/navigatorBloc.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/Screen/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quizz_game_app/Screen/login_register.dart';
import 'package:quizz_game_app/Screen/wapper.dart';
import 'package:quizz_game_app/util/db_table.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/head_quiz_add_view.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/quiz_arguments.dart';
import 'package:quizz_game_app/views/admin_views/quiz_time_view_admin/quiz_question_view.dart';
import 'package:quizz_game_app/views/home_view_user/changeEmailView.dart';
import 'package:quizz_game_app/views/home_view_user/changePasswordView.dart';
import 'package:quizz_game_app/views/login_&_register/AuthLogin.dart';
import 'package:quizz_game_app/views/login_&_register/AuthRegister.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:quizz_game_app/Bloc/Quiz_bloc/quiz_bloc_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseAuth.instance.signOut();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBlocBloc(),
      ),
    ],
    child: const QuizApp(),
  ));
}

class QuizApp extends StatefulWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  State<QuizApp> createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  late final AuthBlocBloc _auth = context.read<AuthBlocBloc>();

  @override
  Widget build(BuildContext context) {
    print("State : ${_auth.state}");
    return MaterialApp(
      navigatorKey: StarlightUtils.navigatorKey,
      onGenerateInitialRoutes: (_) =>
          [MaterialPageRoute(builder: (_) => const Wapper())],
      onGenerateRoute: (RouteSettings setting) {
        Map<String, Widget Function(BuildContext)> routes =
            <String, WidgetBuilder>{
          WapperScreen: (context) => const Wapper(),
          LoginScreen: (context) => const LoginRegister(),
          HomeScreen: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => QuizBlocBloc(),
                  ),
                  BlocProvider(
                    create: (context) => NavigatorCubit(),
                    child: Container(),
                  )
                ],
                child: const AppHome(),
              ),
          AuthLoginScreen: (context) => const AuthLoginView(),
          AuthRegisterScreen: (context) => const AuthRegisterView(),
          ChangePassword: (context) => const ChangePasswordView(),
          ChangeEmail: (context) => const ChangeEmaildView(),
          HeadQuizAdd: (context) => BlocProvider(
                create: (context) => QuizBlocBloc(),
                child: const HeadQuizView(),
              ),
          QuizQuestionAdd: (context) => BlocProvider(
                create: (context) => QuizBlocBloc(),
                child:  QuizQuestionView(args: setting.arguments as QuizQuestionArgs),
              ),
        };
        Widget Function(BuildContext context)? builder = routes[setting.name];
        return MaterialPageRoute(builder: (ctx) => builder!(ctx));
      },
    );
  }
}
