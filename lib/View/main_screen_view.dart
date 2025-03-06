import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/history_chat_view.dart';
import 'package:freechat_dialogflow/View/home_view.dart';
import 'package:freechat_dialogflow/View/user_view.dart';
import 'package:freechat_dialogflow/ViewModel/main_screen_viewModel.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

class MainScreenView extends StatefulWidget {
  const MainScreenView({super.key});

  @override
  State<MainScreenView> createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectTab = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);

    tabController?.addListener(() {
      selectTab = tabController?.index ?? 0;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainScreenViewmodel());
    MediaQuery.sizeOf(context);
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: ChatColor.background,
      body: TabBarView(
        controller: tabController,
        children: const [HistoryScreen(), HomeView(), SettingsView()],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(color: ChatColor.gray1, boxShadow: const [
              BoxShadow(
                  color: Colors.black38, blurRadius: 5, offset: Offset(0, -3))
            ]),
            child: BottomAppBar(
                color: ChatColor.gray1,
                elevation: 0,
                child: TabBar(
                  controller: tabController,
                  indicatorColor: ChatColor.gray1,
                  indicatorWeight: 1,
                  labelColor: ChatColor.almond,
                  labelStyle: const TextStyle(fontSize: 10),
                  unselectedLabelColor: ChatColor.almond,
                  unselectedLabelStyle: const TextStyle(fontSize: 10),
                  tabs: [
                    Tab(
                      text: 'Lịch sử',
                      icon: Image.asset(
                        selectTab == 0
                            ? ImageAssest.history
                            : ImageAssest.historyUn,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Tab(
                      text: 'Trang chủ',
                      icon: Image.asset(
                        selectTab == 1 ? ImageAssest.home : ImageAssest.homeUn,
                        width: 24,
                        height: 24,
                      ),
                    ),
                    Tab(
                      text: 'Tôi',
                      icon: Image.asset(
                        selectTab == 2 ? ImageAssest.user : ImageAssest.userUn,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
