// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/login_view.dart';
import 'package:freechat_dialogflow/ViewModel/signUp_viewModel.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

import '../Widgets/common_widget/check_mail/check_mail.dart';

class SignUpScreen extends StatefulWidget {

  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _viewModel = SignupViewModel();

  late String codeMail;



  @override
  Widget build(BuildContext context) {
    codeMail = _viewModel.generateVerificationCode().toString();
    return Scaffold(
      backgroundColor: ChatColor.background,
      appBar: AppBar(
        backgroundColor: ChatColor.background,
        iconTheme: IconThemeData(color: ChatColor.almond),
        title: Text(
          'Đăng ký tài khoản',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ChatColor.almond),
        ),
      ),
      body: Form(
        key: _viewModel.formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 24,
                ),
                Image.asset(
                  ImageAssest.logoApp,
                  height: 100,
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      filled: true,
                      fillColor: ChatColor.gray1,
                    ),
                    style: const TextStyle(color: Colors.white70),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: _viewModel.onChangeUsername,
                    validator: _viewModel.validatorUsername,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mật Khẩu',
                        filled: true,
                        fillColor: ChatColor.gray1,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.isObscured.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _viewModel.toggleObscureText,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white70),
                      obscureText: _viewModel.isObscured.value,
                      onChanged: _viewModel.onChangePassword,
                      validator: _viewModel.validatorPassword,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nhập lại mật khẩu',
                        filled: true,
                        fillColor: ChatColor.gray1,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.isEntryPasswordObscured.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: _viewModel.toggleEntryPasswordObscureText,
                        ),
                      ),
                      style: const TextStyle(color: Colors.white70),
                      obscureText: _viewModel.isEntryPasswordObscured.value,
                      onChanged: _viewModel.onChangeConfirmPassword,
                      validator: _viewModel.validatorConfirmPassword,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Họ và tên',
                      filled: true,
                      fillColor: ChatColor.gray1,
                    ),
                    style: const TextStyle(color: Colors.white70),
                    onChanged: _viewModel.onChangeCheckName,
                    validator: _viewModel.validatorCheck,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ',
                      filled: true,
                      fillColor: ChatColor.gray1,
                    ),
                    style: const TextStyle(color: Colors.white70),
                    onChanged: _viewModel.onChangeCheckAdress,
                    validator: _viewModel.validatorCheck,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Giới tính',
                      filled: true,
                      fillColor: ChatColor.gray1,
                    ),
                    style: const TextStyle(color: Colors.white70),
                    onChanged: _viewModel.onChangeCheckSex,
                    validator: _viewModel.validatorCheck,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    if (_viewModel.isValidSignupForm()) {
                      _viewModel.sendEmail(
                          _viewModel.email, codeMail.toString());
                      print('test ma code1: $codeMail');
                      Get.to(() => CheckMail(
                        email: _viewModel.email,
                        password: _viewModel.password,
                        fullName: _viewModel.hoTen,
                        address: _viewModel.address,
                        sex: _viewModel.sex,
                        verificationCode: codeMail.toString(),
                      ));
                      // _viewModel.isLoading.value = true;
                      // _viewModel.signUp(
                      //   _viewModel.email ?? '',
                      //   _viewModel.password ?? '',
                      //   _viewModel.confirmPassword ?? '',
                      //   _viewModel.hoTen ?? '',
                      //   _viewModel.address ?? '',
                      //   _viewModel.sex ?? '',
                      //   () {
                      //     _viewModel.isLoading.value = false;
                      //     Get.snackbar(
                      //       'Success',
                      //       'Đăng ký thành công',
                      //       snackPosition: SnackPosition.BOTTOM,
                      //     );
                      //
                      //     // Reset form state if needed
                      //     _viewModel.resetForm();
                      //
                      //     // Navigate to Login Screen
                      //     Get.offAll(() => const LoginView());
                      //   },
                      //   (error) {
                      //     _viewModel.isLoading.value = false;
                      //     Get.snackbar(
                      //       'Error',
                      //       error,
                      //       snackPosition: SnackPosition.BOTTOM,
                      //     );
                      //   },
                      // );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ChatColor.almond),
                  child: Text(
                    'Tiếp tục',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ChatColor.background),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (_viewModel.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
