import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extention.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  // Hàm để gửi tin nhắn và nhận phản hồi từ Dialogflow
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({"data": "1", "message": _controller.text});
    });

    // Tạo AuthGoogle và kết nối tới Dialogflow
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/myagent-xoge-e5bc4acd332b.json")
            .build();
    DialogFlow dialogFlow =
        DialogFlow(authGoogle: authGoogle, language: Language.english);

    // Gửi yêu cầu đến Dialogflow và nhận phản hồi
    AIResponse response = await dialogFlow.detectIntent(_controller.text);

    setState(() {
      _messages.add({
        "data": "2",
        "message": response.getMessage() ?? "Lỗi, vui lòng thử lại!"
      });
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      appBar: AppBar(
        backgroundColor: TColor.bg,
        title: Text(
          'Flutter Chatbot',
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: TColor.primaryText28),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(index),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  // Widget để hiển thị tin nhắn
  Widget _buildMessage(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: _messages[index]["data"] == "1"
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8),
            decoration: BoxDecoration(
              color: _messages[index]["data"] == "1"
                  ? Colors.blue
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              _messages[index]["message"] ?? '',
              style: TextStyle(
                color: _messages[index]["data"] == "1"
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget để nhập tin nhắn
  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                  hintText: "Nhập tin nhắn...",
                  hintStyle: TextStyle(color: TColor.primaryText28)),
              style: const TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.green,
            ),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
