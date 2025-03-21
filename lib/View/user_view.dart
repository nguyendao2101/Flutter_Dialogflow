// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freechat_dialogflow/View/login_view.dart';
import 'package:freechat_dialogflow/ViewModel/user_view_model.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/common_widget/basic_app_button/basic_app_button.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final controller = Get.put(UserViewModel());
  // late DatabaseReference _database;
  // late String _userId;
  // Map<String, dynamic> _userData = {};
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _database = FirebaseDatabase.instance.ref();
  //   _initializeUserId();
  // }
  //
  // void _initializeUserId() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     _userId = user.uid;
  //     _getUserData();
  //   } else {}
  // }
  //
  // void _getUserData() async {
  //   DatabaseReference userRef = _database.child('users/$_userId');
  //   DataSnapshot snapshot = await userRef.get();
  //
  //   if (snapshot.exists) {
  //     setState(() {
  //       _userData = Map<String, dynamic>.from(snapshot.value as Map);
  //     });
  //   } else {}
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColor.background,
      appBar: AppBar(
        backgroundColor: ChatColor.background,
        elevation: 0,
        title: Text('Thông tin người dùng',
            style: TextStyle(
                color: ChatColor.almond,
                fontSize: 25,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(),
              const SizedBox(height: 20),
              _buildUserInfoCard(),
              const SizedBox(height: 20),
              _buildFavouriteMessagesCard(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100),
                child: BasicAppButton(onPressed: (){
                    Get.offAll(() => const LoginView());
                }, title: 'LogOut', sizeTitle: 18, height: 44, colorButton: Color(0xffA31D1D), radius: 12,),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width:
          110, // Kích thước tổng thể của hình đại diện (bằng với radius*2 + borderWidth)
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ChatColor.almond, // Màu của viền ngoài
          width: 4.0, // Độ dày của viền ngoài
        ),
      ),
      child: CircleAvatar(
        radius: 50, // Kích thước của hình đại diện
        backgroundImage: AssetImage(ImageAssest.user),
        backgroundColor: ChatColor.background,
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return controller.userData.isNotEmpty
        ? Card(
            color: ChatColor.gray1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoRow('Full Name', controller.userData['fullName']),
                  const Divider(color: Colors.white24),
                  _buildUserInfoRow('Email', controller.userData['email']),
                  const Divider(color: Colors.white24),
                  _buildUserInfoRow('Address', controller.userData['address']),
                  const Divider(color: Colors.white24),
                  _buildUserInfoRow('Sex', controller.userData['sex']),
                  _buildUserInfoRow('Ranking', controller.userData['ranking'].toString()),
                  _buildUserInfoRow('Money', controller.userData['money'].toString()),
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
  }

  Widget _buildUserInfoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: ChatColor.almond,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value ?? '',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavouriteMessagesCard() {
    return controller.userData.isNotEmpty && (controller.userData['favouriteMessages']?.isNotEmpty ?? false)
        ? Card(
      color: ChatColor.gray1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tin nhắn yêu thích',
              style: TextStyle(
                color: ChatColor.almond,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.userData['favouriteMessages'].length,
              separatorBuilder: (context, index) => const Divider(
                color: Colors.white24,
                thickness: 0.5,
              ),
              itemBuilder: (context, index) {
                final message = controller.userData['favouriteMessages'][index];
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                        child: Text(
                          message,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    )
        : const SizedBox.shrink();
  }

}
