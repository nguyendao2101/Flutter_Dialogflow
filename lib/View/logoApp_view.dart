import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freechat_dialogflow/ViewModel/logoApp_viewModel.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

class LogoAppView extends StatefulWidget {
  const LogoAppView({super.key});

  @override
  State<LogoAppView> createState() => _LogoAppViewState();
}

class _LogoAppViewState extends State<LogoAppView> {
  late Timer _timer;
  late int _seconds;
  final controller = Get.put(LogoApp());

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    super.initState();
    _seconds = DateTime.now().second; // Lấy số giây hiện tại
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds = DateTime.now().second; // Cập nhật số giây
      });
    });
    controller.loadView();
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy Timer khi widget bị hủy
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColor.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 180,
          ),
          Image.asset(
            ImageAssest.logoApp,
            height: 170.44,
            width: 193.64,
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'ChatMate',
            style: TextStyle(
                color: ChatColor.almond,
                fontSize: 56,
                fontWeight: FontWeight.bold,
                height: 4.125),
          ),
          const SizedBox(
            height: 48,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                (_seconds % 2 == 0)
                    ? ImageAssest.loading2
                    : ImageAssest.loading1,
                height: 24,
                width: 24,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'Loading...',
                style: TextStyle(
                    color: ChatColor.almond,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.375),
              )
            ],
          )
        ],
      ),
    );
  }
}
