import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/userController.dart';
import 'package:sm_project/sm/repositories/authRepository.dart';
import 'package:sm_project/sm/utils/utils.dart';

//auth controller provider to control authntication
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepoProvider),
    ref: ref,
  ),
);


//auth state provider to listen for auth state changes
final authStateProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authRepoProvider);
  return authController.authStateChanges;
});

//main auth contoller class
class AuthController extends StateNotifier<bool> {
  final AuthenticationRepository authRepository;
  final Ref ref;

  AuthController({required this.authRepository, required this.ref})
      : super(false);

  Stream<User?> get authStateChanges => authRepository.authStateChanges;


  ///create new account(sign up)
  createNewAccount(
      {required String email,
      required String password,
      required String name,
      required Uint8List profileFile,
      required BuildContext context}) async {
    state = true;
    String message = await authRepository.signup(
      email: email,
      password: password,
      name: name,
      profileFile: profileFile,
    );
    showMessageSnackBar(message: message, context: context);

    state = false;
  }

  ///login
  Future<String> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    String message = await authRepository.login(
      email: email,
      password: password,
    );
    showMessageSnackBar(message: message, context: context);
    
    state = false;

    return message;

  }

  ///sign out current account(so,update currrent Account to null)
  signOut(BuildContext context) async {
    await ref.watch(currentUserProvider.notifier).update((state) => null);
    await authRepository.signOut();
  }
}
