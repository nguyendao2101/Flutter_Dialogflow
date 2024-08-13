import 'package:freechat_dialogflow/View/login_view.dart';
import 'package:get/get.dart';

class LogoApp extends GetxController {
  void loadView() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.to(const LoginView());
    // Get.toNamed(AppRouterName.login);
  }
}
