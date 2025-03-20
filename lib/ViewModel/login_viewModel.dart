// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/fire_base/fire_base_auth.dart';

class LoginViewmodel extends GetxController {
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

  onlogin() {
    FirAuth.signInWithEmailAndPassword(
        emailController.text, passwordController.text);
  }
}
