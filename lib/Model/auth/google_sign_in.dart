import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:freechat_dialogflow/View/main_screen_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();


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
          'ranking': "Newbie",
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
}
