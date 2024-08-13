// // ignore_for_file: library_private_types_in_public_api, empty_catches, unused_element

// import 'package:dialogflow_flutter/dialogflowFlutter.dart';
// import 'package:dialogflow_flutter/googleAuth.dart';
// import 'package:dialogflow_flutter/language.dart';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:freechat_dialogflow/Widgets/common/color_extention.dart';
// import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
// import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   late stt.SpeechToText _speech;
//   late ScrollController _scrollController;
//   bool _isListening = false;
//   bool _scrollToBotMessage = false; // Biến mới để kiểm soát cuộn

//   @override
//   void initState() {
//     super.initState();
//     _scrollController = ScrollController();
//     _speech = stt.SpeechToText();
//   }

//   void _scrollToBottom() {
//     if (_scrollToBotMessage) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//       setState(() {
//         _scrollToBotMessage = false; // Đặt lại biến sau khi cuộn
//       });
//     }
//   }

//   void _initializeSpeech() async {
//     _speech = stt.SpeechToText();
//     bool available = await _speech.initialize();
//     if (available) {
//     } else {}
//   }

//   void _startListening() async {
//     bool available = await _speech.initialize();
//     if (available) {
//       setState(() {
//         _isListening = true;
//         _controller.clear(); // Xóa nội dung trước khi bắt đầu ghi âm
//       });
//       _speech.listen(onResult: (val) {
//         setState(() {
//           _controller.text = val.recognizedWords;
//         });
//       });
//     } else {}
//   }

//   void _stopListening() {
//     _speech.stop();
//     setState(() => _isListening = false);
//   }

//   void _sendMessage() async {
//     if (_controller.text.isEmpty) return;

//     String messageToSend = _controller.text;
//     _controller.clear();

//     setState(() {
//       _messages.add({"data": "1", "message": messageToSend});
//     });

//     _scrollToBottom();

//     try {
//       AuthGoogle authGoogle =
//           await AuthGoogle(fileJson: "assets/myagent-xoge-e5bc4acd332b.json")
//               .build();
//       DialogFlow dialogFlow =
//           DialogFlow(authGoogle: authGoogle, language: Language.english);

//       AIResponse response = await dialogFlow.detectIntent(messageToSend);

//       setState(() {
//         _messages.add({
//           "data": "2",
//           "message": response.getMessage() ?? "Lỗi, vui lòng thử lại!"
//         });
//         _scrollToBotMessage = true; // Đặt biến để cuộn đến tin nhắn chatbot
//       });

//       _scrollToBottom();
//     } catch (e) {}
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ChatColor.background,
//       appBar: AppBar(
//         backgroundColor: ChatColor.background,
//         iconTheme: IconThemeData(color: ChatColor.gray4),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Chat',
//               style: TextStyle(
//                   fontSize: 24, height: 1.75, color: ChatColor.almond),
//             ),
//             Row(
//               children: [
//                 InkWell(
//                   onTap: () {},
//                   child: Image.asset(
//                     ImageAssest.backQuestion,
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       _messages.clear();
//                     });
//                   },
//                   child: Image.asset(
//                     ImageAssest.trash,
//                     height: 24,
//                     width: 24,
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 20,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: ChatColor.background,
//                     backgroundColor: ChatColor.almond,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 10,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         ImageAssest.iconStar,
//                         width: 13.89,
//                         height: 11.05,
//                       ),
//                       const SizedBox(width: 5),
//                       const Text('20'),
//                     ],
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: const EdgeInsets.all(10.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) => _buildMessage(index),
//             ),
//           ),
//           _buildInputArea(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessage(int index) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10.0),
//       child: Row(
//         mainAxisAlignment: _messages[index]["data"] == "1"
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         children: <Widget>[
//           if (_messages[index]["data"] != "1")
//             Image.asset(
//               ImageAssest.logoApp,
//               height: 24,
//               width: 24,
//             ),
//           const SizedBox(width: 10),
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14.0, vertical: 10.0),
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.8),
//                 decoration: BoxDecoration(
//                   color: ChatColor.gray1,
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 child: Text(
//                   _messages[index]["message"] ?? '',
//                   style: const TextStyle(
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 width: 10,
//               ),
//               Icon(Icons.favorite_border_outlined)
//             ],
//           ),
//           if (_messages[index]["data"] == "1") const SizedBox(width: 10),
//           if (_messages[index]["data"] == "1")
//             Image.asset(
//               ImageAssest.user,
//               height: 24,
//               width: 24,
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInputArea() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10.0),
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: ChatColor.gray1,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: "Nhập tin nhắn...",
//                     hintStyle: TextStyle(color: TColor.primaryText28),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 12),
//                     suffixIcon: Padding(
//                       padding: const EdgeInsets.only(right: 20),
//                       child: InkWell(
//                         onTap: _isListening ? _stopListening : _startListening,
//                         child: Image.asset(
//                           _isListening
//                               ? ImageAssest.microphoneUn
//                               : ImageAssest.microphone,
//                           height: 18.5,
//                           width: 15.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                   textCapitalization: TextCapitalization.sentences,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Image.asset(
//                 ImageAssest.sendMessages,
//                 height: 56,
//                 width: 56,
//               ),
//               onPressed: _sendMessage,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
