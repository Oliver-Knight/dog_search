import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quizz_game_app/Modal/user/user_modal.dart';
import 'package:quizz_game_app/Repo/Database/database_helper.dart';
import 'package:quizz_game_app/util/pages.dart';
import 'package:starlight_utils/starlight_utils.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'auth_bloc_event.dart';
part 'auth_bloc_state.dart';

class AuthBlocBloc extends Bloc<AuthBlocEvent, AuthBlocState> {
  AuthBlocBloc() : super(AuthInitialState()) {
    on<AuthInitialEvent>(_inital);
    on<LoginWithEmailEvent>(_loginWithEmail);
    on<RegisterWithEmailEvent>(_registerWithEmail);
    on<LoginWithGoogleEvent>(_loginWithGoogle);
    on<LogoutEvent>(_logout);
    on<AuthListenerEvent>(_authListerer);
    on<GetUserEvent>(_getUser);
    on<ChangePasswordEvent>(_changePassword);
    on<ChangeEmailEvent>(_changeEmail);
  }

  //todo Change Email
  Future<void> _changeEmail(ChangeEmailEvent event,Emitter<AuthBlocState> emit) async{
     try {
      final UserCredential _userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      await _userCred.user!.updateEmail(event.nemail);
      await DatabaseHelper.instance.changeEmail(event.user);
      emit(ChangeEmailSuccessState(_userCred.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(
            errorMessage: 'Wrong password provided for that user.'));
      } else {
        emit(AuthErrorState(errorMessage: e.code));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
  //todo Change Password
  Future<void> _changePassword(ChangePasswordEvent event,Emitter<AuthBlocState> emit)async {
    try {
      final UserCredential _userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      await _userCred.user!.updatePassword(event.nPassword);
      emit(ChangePasswordSuccessState(_userCred.user!));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(
            errorMessage: 'Wrong password provided for that user.'));
      } else {
        emit(AuthErrorState(errorMessage: e.code));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  //todo GetUser
  void _getUser(GetUserEvent event, Emitter<AuthBlocState> emit) async {
    try {
      UserModal? user = await DatabaseHelper.instance.getUser(event.email);
      if (user != null) {
        emit(GetUserState(mUser: user, user: state.user));
      } else {
        emit(NotGetUserState(error: "No data found!"));
      }
    } catch (e) {
      emit(NotGetUserState(error: e.toString()));
    }
  }

  ///todo Register with Emial
  Future<void> _registerWithEmail(
      RegisterWithEmailEvent event, Emitter<AuthBlocState> emit) async {
    try {
      final _userCred =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (_userCred.user != null) {
        String _role = await getRole(_userCred.user!.email!);
        emit(AuthSuccessState(_userCred.user,_role));
        DatabaseHelper.instance.insertUser(UserModal(
            displayName: _userCred.user?.displayName,
            email: _userCred.user?.email,
            photoUrl: _userCred.user?.photoURL,
            score: 0,
            role: 'admin'));
        StarlightUtils.pushReplacementNamed(WapperScreen);
      } else {
        emit(AuthErrorState(errorMessage: "Unknow Error"));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState(errorMessage: "Your provided password is weak"));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState(
            errorMessage: "The account already exists for that email."));
      } else {
        emit(AuthErrorState(errorMessage: e.code));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
  //end Register with Email

  ///todo Login with Email
  Future<void> _loginWithEmail(
      LoginWithEmailEvent event, Emitter<AuthBlocState> emit) async {
    try {
      final _userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);
        String _role = await getRole(_userCred.user!.email!);
        emit(AuthSuccessState(_userCred.user,_role));
      List<String> _emails = await DatabaseHelper.instance.getExistEmail();
      if(!_emails.contains(_userCred.user!.email!)){
        await DatabaseHelper.instance.insertUser(
            UserModal(
                displayName: _userCred.user?.displayName,
                email: _userCred.user!.email!,
                photoUrl: _userCred.user?.photoURL,
                score: 0,
                role: 'user'),
          );
      }
      StarlightUtils.pushReplacementNamed(WapperScreen);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(
            errorMessage: 'Wrong password provided for that user.'));
      } else {
        emit(AuthErrorState(errorMessage: e.code));
      }
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }
  //end Login with Email

  ///todo Login With Google
  Future<void> _loginWithGoogle(
      LoginWithGoogleEvent event, Emitter<AuthBlocState> emit) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      StarlightUtils.pushReplacementNamed(WapperScreen);
      final UserCredential _firebaseCred =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (_firebaseCred.user != null) {
        String name = _firebaseCred.user!.photoURL!.split('/').last;
        Directory directory = await getApplicationDocumentsDirectory();
        String _directory = join(directory.path, name);
        String? imageId = await ImageDownloader.downloadImage(_firebaseCred.user!.photoURL!,destination: AndroidDestinationType.custom(directory: _directory));
        String _role = await getRole(_firebaseCred.user!.email!);
        emit(AuthSuccessState(_firebaseCred.user,_role));
        List<String> _emailList = await DatabaseHelper.instance.getExistEmail();
        if (!_emailList.contains(_firebaseCred.user?.email)) {
          String? imagePath = await ImageDownloader.findPath(imageId!);
          DatabaseHelper.instance.insertUser(
            UserModal(
                displayName: _firebaseCred.user!.displayName!,
                email: _firebaseCred.user!.email!,
                photoUrl: imagePath!,
                score: 0,
                role: 'user'),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(errorMessage: e.message ?? e.code));
    } catch (e) {
      emit(AuthErrorState(errorMessage: e.toString()));
    }
  }

  //todo Logout
  Future<void> _logout(LogoutEvent event, Emitter<AuthBlocState> emit) async {
    try {
      if (state.user!.providerData[0].providerId == 'google.com') {
        await GoogleSignIn().signOut();
      }
      await FirebaseAuth.instance.signOut();
      emit(AuthLogoutState());
    } on FirebaseAuthException catch (e) {
      emit(
        AuthErrorState(errorMessage: e.message ?? e.code, user: state.user),
      );
    } catch (e) {
      emit(
        AuthErrorState(errorMessage: e.toString(), user: state.user),
      );
    }
    StarlightUtils.pushReplacementNamed(WapperScreen);
  }
  //todo end logout

  //todo listerer Event State
  void _authListerer(AuthListenerEvent event, Emitter<AuthBlocState> emit)async{
    if (event.user == null) {
      emit(AuthLogoutState());
    } else {
      String _role = await getRole(event.user!.email!);
      emit(AuthSuccessState(event.user,_role));
    }
  }

  //end Listener Event State
  //login or logout checking for users
  void _inital(AuthInitialEvent event, Emitter<AuthBlocState> emit) {
    FirebaseAuth.instance.authStateChanges().listen((User? event) {
      add(AuthListenerEvent(user: event));
    });
  }
  Future<String> getRole(String email) async{
    return await DatabaseHelper.instance.getUserRole(email: email);
  }
}
