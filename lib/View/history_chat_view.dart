import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';

class HistoryChatView extends StatefulWidget {
  const HistoryChatView({super.key});

  @override
  State<HistoryChatView> createState() => _HistoryChatViewState();
}

class _HistoryChatViewState extends State<HistoryChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColor.background,
      body: Center(
        child: Text(
          'History',
          style: TextStyle(fontSize: 30, color: ChatColor.almond),
        ),
      ),
    );
  }
}
