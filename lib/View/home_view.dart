import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/chat_view.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ChatColor.background,
          iconTheme: IconThemeData(color: ChatColor.gray4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    ImageAssest.drawerHome,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'ChatMate',
                    style: TextStyle(
                        fontSize: 24,
                        height: 1.75,
                        color: ChatColor.almond,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: ChatColor.background,
                  backgroundColor: ChatColor.almond,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      ImageAssest.iconStar,
                      width: 13.89,
                      height: 11.05,
                    ),
                    const SizedBox(
                        width: 5), // Khoảng cách giữa biểu tượng và văn bản
                    const Text('20'),
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: ChatColor.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 173,
                    width: 396,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ChatColor.almond),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            top: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tap to Chat',
                                style: TextStyle(
                                    fontSize: 32,
                                    height: 2.25,
                                    color: ChatColor.background,
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                ImageAssest.arrowRight,
                                width: 64,
                                height: 52.48,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            ImageAssest.askChatbotQuestion,
                            width: 364,
                            height: 57,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
