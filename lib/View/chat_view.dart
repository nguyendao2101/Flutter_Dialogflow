// ignore_for_file: library_private_types_in_public_api, empty_catches, unused_element, avoid_print
import 'dart:async';
import 'package:dialogflow_flutter/dialogflowFlutter.dart';
import 'package:dialogflow_flutter/googleAuth.dart';
import 'package:dialogflow_flutter/language.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/ViewModel/get_data_view_model.dart';
import 'package:freechat_dialogflow/ViewModel/user_view_model.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:freechat_dialogflow/Widgets/common/color_extention.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import '../Widgets/common_widget/show_bottom/show_bottom_by_coins.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String responseCode = '';
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late stt.SpeechToText _speech;
  late ScrollController _scrollController;
  bool _isListening = false;
  bool _scrollToBotMessage = false;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref(); // Reference to Firebase
  late String _userId; // Late initialization for userId
  final controllerUser = Get.put(UserViewModel());
  final controllerGetData = Get.put(GetDataViewModel());
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _speech = stt.SpeechToText();
    _initializeUserId(); // Fetch the user ID
  }

  Future<void> _checkCanAskQuestion() async {
    bool canAsk = await controllerGetData.canAskQuestion();  // Gọi hàm kiểm tra
    if (canAsk) {
      // Nếu người dùng có thể hỏi câu hỏi, thực hiện hành động tương ứng
      print("Người dùng có thể hỏi câu hỏi.");
      // Thực hiện hành động tiếp theo, ví dụ, mở màn hình chat, v.v.
    } else {
      // Nếu người dùng không thể hỏi câu hỏi, hiển thị thông báo
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thông báo"),
            content: Text("Bạn đã đạt giới hạn câu hỏi trong ngày."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _initializeUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
    } else {
      // Handle user not logged in case
      print("No user logged in.");
    }
  }

  void _scrollToBottom() {
    if (_scrollToBotMessage) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      setState(() {
        _scrollToBotMessage = false;
      });
    }
  }

  void _initializeSpeech() async {
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (available) {
      print('SpeechToText initialized successfully.');
    } else {
      print('SpeechToText initialization failed.');
    }
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _controller.clear();
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _controller.text = val.recognizedWords;
        });
      });
    } else {
      print('Speech recognition not available.');
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String messageToSend = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({"data": "1", "message": messageToSend});
    });

    _scrollToBottom();

    try {
      AuthGoogle authGoogle = await AuthGoogle(
              fileJson: "assets/testchatbot-epwa-46be8e97c02b.json")
          .build();
      DialogFlow dialogFlow =
          DialogFlow(authGoogle: authGoogle, language: Language.english);

      AIResponse response = await dialogFlow.detectIntent(messageToSend);

      setState(() {
        _messages.add({
          "data": "2",
          "message": response.getMessage() ?? "Lỗi, vui lòng thử lại!"
        });
        _scrollToBotMessage = true;
      });

      _scrollToBottom();

      // Save chat history to Firebase
      if (_userId.isNotEmpty) {
        await _saveChatHistory(messageToSend, response.getMessage());
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _saveChatHistory(String userMessage, String? botMessage) async {
    final now = DateTime.now();
    final formattedDate = "${now.year}-${now.month}-${now.day}";
    final formattedTime = "${now.hour}:${now.minute}:${now.second}";

    Map<String, dynamic> chatEntry = {
      'userMessage': userMessage,
      'botMessage': botMessage ?? "Lỗi, vui lòng thử lại!",
      'date': formattedDate,
      'time': formattedTime,
    };

    // Update chat history in Firebase
    DatabaseReference chatHistoryRef =
        _database.child('users/$_userId/historyChat');
    await chatHistoryRef.push().set(chatEntry);
  }

  Future<void> _toggleFavouriteMessage(int index) async {
    String message = _messages[index]["message"] ?? '';

    // Lấy tham chiếu đến danh sách tin nhắn yêu thích của người dùng
    DatabaseReference favRef =
        _database.child('users/$_userId/favouriteMessages');
    DataSnapshot snapshot = await favRef.get();

    // Kiểm tra và chuyển đổi giá trị từ snapshot.value
    List<String> favouriteMessages = [];
    if (snapshot.value != null) {
      try {
        // Kiểm tra kiểu dữ liệu và chuyển đổi giá trị
        favouriteMessages = List<String>.from(snapshot.value as List);
      } catch (e) {
        // Nếu chuyển đổi không thành công, tạo một danh sách rỗng
        favouriteMessages = [];
      }
    }

    // Kiểm tra xem tin nhắn đã nằm trong danh sách yêu thích chưa
    bool isFavourite = favouriteMessages.contains(message);
    if (isFavourite) {
      favouriteMessages.remove(message);
    } else {
      favouriteMessages.add(message);
    }

    // Cập nhật danh sách yêu thích trong Firebase
    await favRef.set(favouriteMessages);

    // Hiển thị thông báo Snackbar
    Get.snackbar(
      'Success',
      isFavourite
          ? 'Đã có trong danh sách yêu thích, nhấn thêm lần nữa để cập nhật lại'
          : 'Đã thêm vào danh sách yêu thích',
      snackPosition: SnackPosition.TOP,
    );

    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ChatColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ChatColor.background,
        iconTheme: IconThemeData(color: ChatColor.gray4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Trò chuyện',
              style: TextStyle(
                  fontSize: 24, height: 1.75, color: ChatColor.almond, fontFamily: 'PlusJakartaSans'),
            ),
            const Spacer(),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    ImageAssest.backQuestion,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      _messages.clear();
                    });
                  },
                  child: Image.asset(
                    ImageAssest.trash,
                    height: 24,
                    width: 24,
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    showBottomByCoints(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: ChatColor.background,
                    backgroundColor: ChatColor.almond,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        ImageAssest.iconStar,
                        width: 13.89,
                        height: 11.05,
                      ),
                      const SizedBox(width: 5),
                      Text(controllerUser.userData['money'].toString(), style: TextStyle(fontFamily: 'PlusJakartaSans'),),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(10.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessage(index),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: _messages[index]["data"] == "1"
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          //if
          if (_messages[index]["data"] != "1")
            Image.asset(
              ImageAssest.logoApp,
              height: 24,
              width: 24,
            ),
          const SizedBox(width: 10),
          //if
          Expanded(
            child: Align(
              alignment: _messages[index]["data"] == "1"
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10.0),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.8),
                      decoration: BoxDecoration(
                        color: ChatColor.gray1,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        _messages[index]["message"] ?? '',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // if
                  if (_messages[index]["data"] != "1")
                    InkWell(
                        onTap: () => _toggleFavouriteMessage(index),
                        child: Image.asset(
                          ImageAssest.addFavouriteMessages,
                          width: 24,
                          height: 24,
                        )),
                  // if
                ],
              ),
            ),
          ),
          // if
          if (_messages[index]["data"] == "1") const SizedBox(width: 10),
          if (_messages[index]["data"] == "1")
            Image.asset(
              ImageAssest.user,
              height: 24,
              width: 24,
            ),
          // if
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ChatColor.gray1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Nhập tin nhắn...",
                    hintStyle: TextStyle(color: TColor.primaryText28),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: InkWell(
                        onTap: _isListening ? _stopListening : _startListening,
                        child: Image.asset(
                          _isListening ? ImageAssest.microphoneUn : ImageAssest.microphone,
                          height: _isListening ? 20.0 : 18.5,
                          width: _isListening ? 24 : 24,
                        ),
                      ),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            IconButton(
              icon: Image.asset(
                ImageAssest.sendMessages,
                height: 56,
                width: 56,
              ),
              onPressed: (){
                _sendMessage();
                _checkCanAskQuestion();
              },
            ),
          ],
        ),
      ),
    );
  }
}
