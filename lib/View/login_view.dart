import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/signUp_view.dart';
import 'package:freechat_dialogflow/ViewModel/login_viewModel.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginViewmodel());

    return Scaffold(
      backgroundColor: ChatColor.background,
      body: Stack(
        children: [
          SafeArea(
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    Image.asset(
                      ImageAssest.logoApp,
                      height: 100,
                    ),
                    const SizedBox(height: 64),
                    Text(
                      'Hi, Welcom back',
                      style: TextStyle(
                        color: ChatColor.almond,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _formEmail(controller),
                    const SizedBox(height: 16),
                    _formPassword(controller),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontSize: 10,
                              color: ChatColor.almond2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (controller.formKey.currentState?.validate() ==
                                true) {
                              controller.onlogin();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ChatColor.almond),
                          child: const Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => SignUpScreen());
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ChatColor.almond),
                          child: const Text(
                            'Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),
                    _textOrContinueWith(),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          ImageAssest.logoGG,
                          height: 72,
                        ),
                        const SizedBox(width: 20),
                        Image.asset(
                          ImageAssest.logoFB,
                          height: 58,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.8),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Padding _textOrContinueWith() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              'Or continue with',
              style: TextStyle(color: Color(0xFF616161)),
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Padding _formPassword(LoginViewmodel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Obx(
        () => TextFormField(
          controller: controller.passwordController,
          obscureText: controller.isObscured.value,
          decoration: InputDecoration(
            labelText: 'Password',
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: 'Password',
            suffixIcon: GestureDetector(
              onTap: () => controller.toggleObscureText(),
              child: Icon(controller.isObscured.value
                  ? Icons.visibility_off
                  : Icons.visibility),
            ),
          ),
          onChanged: controller.onChangePassword,
          validator: controller.validatorPassword,
        ),
      ),
    );
  }

  Padding _formEmail(LoginViewmodel controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller.emailController,
        obscureText: false,
        decoration: InputDecoration(
          labelText: 'Email',
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: 'Email',
        ),
        onChanged: controller.onChangeUsername,
        validator: controller.validatorUsername,
      ),
    );
  }
}
