import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/main_screen_view.dart';
import 'package:get/get.dart';

class FirAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void signUp(
      String email,
      String passWord,
      String entryPassword,
      String hoTen,
      String addRess,
      String sex,
      double? money,
      String? ranking,
      Function onSuccess,
      Function(String) onRegisterError,
      ) {
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: passWord)
        .then((user) {
      if (user.user != null) {
        print("User registered successfully: ${user.user!.uid}");
        _createUser(user.user!.uid, hoTen, addRess, sex, money, ranking, onSuccess);
      }
    }).catchError((err) {
      if (err is FirebaseAuthException) {
        if (err.code == 'weak-password') {
          _showErrorDialog('Mật khẩu quá đơn giản');
        } else if (err.code == 'email-already-in-use') {
          _showErrorDialog('Email này đã tồn tại');
        } else {
          _onSignUpErr(err.code, onRegisterError);
        }
      }
    });
  }

  static Future<void> signInWithEmailAndPassword(String email, String passWord) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: passWord);
      if (credential.user != null) {
        print("User logged in successfully: ${credential.user!.uid}");
        Get.offAll(() => const MainScreenView());
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        _showErrorDialog('Không tìm thấy người dùng với email này');
      } else if (err.code == 'wrong-password') {
        _showErrorDialog('Mật khẩu không đúng');
      } else {
        _showErrorDialog(err.message ?? "Có lỗi xảy ra, vui lòng thử lại.");
      }
    }
  }

  void _createUser(
      String userId,
      String hoTen,
      String addRess,
      String sex,
      double? money,
      String? ranking,
      Function onSuccess) {
    // Đảm bảo giá trị mặc định nếu tham số bị null
    money ??= 0;
    ranking ??= 'Normal';

    var user = {
      'HoTen': hoTen,
      'AddRess': addRess,
      'Sex': sex,
      'money': money,
      'ranking': ranking
    };

    var ref = FirebaseDatabase.instance.ref().child('users');
    ref.child(userId).set(user).then((_) {
      print("User data successfully written to Firebase: $user");
      // Kiểm tra lại dữ liệu vừa ghi
      ref.child(userId).get().then((snapshot) {
        if (snapshot.exists) {
          print("User data in Firebase after write: ${snapshot.value}");
        } else {
          print("Error: User data not found in Firebase.");
        }
      });
      onSuccess();
    }).catchError((err) {
      print("Error writing to Firebase: $err");
    });
  }

  void _onSignUpErr(String code, Function(String) onRegisterError) {
    switch (code) {
      case "ERROR_INVALID_EMAIL":
      case "ERROR_INVALID_CREDENTIAL":
        onRegisterError("Email không hợp lệ");
        break;
      case "ERROR_EMAIL_ALREADY_IN_USE":
        onRegisterError("Email đã tồn tại");
        break;
      case "ERROR_WEAK_PASSWORD":
        onRegisterError("Mật khẩu không đủ mạnh");
        break;
      default:
        onRegisterError("Đăng ký thất bại, vui lòng thử lại");
        break;
    }
  }

  static void _showErrorDialog(String message) {
    Get.dialog(AlertDialog(
      title: const Text('Lỗi'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('OK'),
        )
      ],
    ));
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    print("User signed out successfully.");
  }
}
