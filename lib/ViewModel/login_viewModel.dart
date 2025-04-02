// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Model/fire_base/fire_base_auth.dart';
import '../View/main_screen_view.dart';

class LoginViewmodel extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();



  late TextEditingController emailController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();

  RxBool isObscured = true.obs;
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  void toggleObscureText() {
    isObscured.value = !isObscured.value;
  }

  void onChangeUsername(String email) {
    formKey.currentState?.validate();
  }

  void onChangePassword(String password) {
    formKey.currentState?.validate();
  }

  bool containsSpecialCharacters(String text) {
    final allowedSpecialCharacters = RegExp(r'[!#\$%^&*(),?":{}|<>]');
    return allowedSpecialCharacters.hasMatch(text);
  }

  bool containsUppercaseLetter(String text) {
    return RegExp(r'[A-Z]').hasMatch(text);
  }

  bool containsLowercaseLetter(String text) {
    return RegExp(r'[a-z]').hasMatch(text);
  }

  bool containsDigit(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  String? validatorUsername(String? email) {
    if ((email ?? '').isEmpty) {
      return 'Email không được để trống';
    } else if ((email ?? '').length < 6) {
      return 'Email không được nhỏ hơn 6 ký tự';
    } else if (containsSpecialCharacters(email!)) {
      return 'Email không đúng định dạng';
    } else {
      return null;
    }
  }

  String? validatorPassword(String? password) {
    if ((password ?? '').isEmpty) {
      return 'Mật khẩu không được để trống';
    } else if ((password ?? '').length < 6) {
      return 'Mật khẩu không được nhỏ hơn 6 ký tự';
    } else {
      return null;
    }
  }

  // Future<User?> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   if (googleUser == null) {
  //     return null; // Người dùng đã hủy đăng nhập
  //   }
  //
  //   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //   final AuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //
  //   final UserCredential userCredential = await _auth.signInWithCredential(credential);
  //   return userCredential.user;
  // }
  Future<void> signInWithGoogle() async {
    try {
      // 1️⃣ Đăng nhập với Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return; // Người dùng hủy đăng nhập
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 2️⃣ Đăng nhập vào Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // 3️⃣ Lưu thông tin người dùng vào Firebase Realtime Database
        await _dbRef.child('users').child(user.uid).set({
          'email': user.email,
          'fullName': user.displayName ?? "No Name",
          'address': "Unknown",
          'sex': "Unknown",
          'money': 0,
          'ranking': "Normal",
          'dailyQuestions': 0,
          'lastAskedDate': DateTime.now().toIso8601String(),
        });

        // 4️⃣ Chuyển hướng đến MainScreenView
        Get.offAll(() => const MainScreenView());
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  onlogin() {
    FirAuth.signInWithEmailAndPassword(
        emailController.text, passwordController.text);
  }
}
