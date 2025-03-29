// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Widgets/common/color_extentionn.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser().then((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColor.background,
      appBar: AppBar(
        backgroundColor: ChatColor.background,
        iconTheme: IconThemeData(color: ChatColor.gray4),
        title: Text(
          'Lịch sử trò truyện',
          style: TextStyle(fontSize: 24, color: ChatColor.almond, fontFamily: 'PlusJakartaSans'),
        ),
      ),
      body: _currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : _buildHistoryList(_currentUser!.uid),
    );
  }

  Future<User?> _getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  Widget _buildHistoryList(String userId) {
    return FutureBuilder<DataSnapshot>(
      future: FirebaseDatabase.instance.ref('users/$userId/historyChat').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          Map<dynamic, dynamic>? historyData =
              snapshot.data!.value as Map<dynamic, dynamic>?;
          if (historyData == null || historyData.isEmpty) {
            return Center(
              child: Text(
                'No chat history available.',
                style: TextStyle(color: ChatColor.gray4, fontSize: 16),
              ),
            );
          }

          // Sắp xếp theo thời gian từ cũ đến mới và đảo ngược danh sách
          var sortedKeys = historyData.keys.toList(growable: false)
            ..sort((a, b) {
              DateTime dateA = _parseDateTime(
                  historyData[a]['date'], historyData[a]['time']);
              DateTime dateB = _parseDateTime(
                  historyData[b]['date'], historyData[b]['time']);
              return dateA.compareTo(dateB);
            });

          List<Widget> historyList = sortedKeys
              .map((key) {
                return _buildHistoryItem(userId, key, historyData[key]);
              })
              .toList()
              .reversed
              .toList(); // Đảo ngược danh sách ở đây

          return ListView(
            padding: const EdgeInsets.all(16),
            children: historyList,
          );
        } else {
          return Center(
            child: Text(
              'Failed to load history.',
              style: TextStyle(color: ChatColor.gray4, fontSize: 16),
            ),
          );
        }
      },
    );
  }

  DateTime _parseDateTime(String date, String time) {
    // Đảm bảo tháng và giờ có 2 chữ số
    List<String> dateParts = date.split('-');
    String year = dateParts[0];
    String month = dateParts[1].padLeft(2, '0');
    String day = dateParts[2].padLeft(2, '0');

    List<String> timeParts = time.split(':');
    String hour = timeParts[0].padLeft(2, '0');
    String minute = timeParts[1].padLeft(2, '0');
    String second = timeParts[2].padLeft(2, '0');

    String formattedDateTime = '$year-$month-$day $hour:$minute:$second';
    return DateTime.parse(formattedDateTime);
  }

  Widget _buildHistoryItem(
      String userId, String key, Map<dynamic, dynamic> chatEntry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ChatColor.gray1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${chatEntry['date']}',
                    style: TextStyle(
                      color: ChatColor.almond,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                  Text(
                    'Time: ${chatEntry['time']}',
                    style: TextStyle(
                      color: ChatColor.gray4,
                      fontSize: 14,
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteChatHistory(userId, key);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'You: ${chatEntry['userMessage']}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Bot: ${chatEntry['botMessage']}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontFamily: 'PlusJakartaSans',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteChatHistory(String userId, String key) async {
    await FirebaseDatabase.instance
        .ref('users/$userId/historyChat/$key')
        .remove();
    setState(() {}); // Cập nhật giao diện sau khi xóa
  }
}
