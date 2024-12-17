import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/logoApp_view.dart';
import 'package:freechat_dialogflow/firebase_options.dart';
import 'package:get/get.dart';

import 'View/main_screen_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // home: const LogoAppView(),
      home: const MainScreenView(),
    );
  }
}
