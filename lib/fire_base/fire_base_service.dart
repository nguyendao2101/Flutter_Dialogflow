// // lib/services/firebase_service.dart

// import 'package:firebase_database/firebase_database.dart';

// class FirebaseService {
//   final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

//   // Thêm tin nhắn yêu thích vào người dùng
//   Future<void> addFavouriteMessage(String userId, String message) async {
//     final userRef = _databaseRef.child('users').child(userId).child('favouristMessages');
    
//     // Lấy tin nhắn yêu thích hiện tại
//     final snapshot = await userRef.once();
//     List<dynamic> messages = snapshot.value ?? [];

//     // Thêm tin nhắn mới vào danh sách
//     messages.add(message);

//     // Cập nhật dữ liệu lên Firebase
//     await userRef.set(messages);
//   }

//   // Thêm lịch sử chat vào người dùng
//   Future<void> addChatHistory(String userId, String message) async {
//     final userRef = _databaseRef.child('users').child(userId).child('historyChat');

//     // Tạo một ID duy nhất cho tin nhắn lịch sử
//     final messageId = DateTime.now().millisecondsSinceEpoch.toString();
//     final timestamp = DateTime.now().toIso8601String();
    
//     final chatMessage = {
//       'id': messageId,
//       'message': message,
//       'timestamp': timestamp,
//     };

//     // Thêm tin nhắn mới vào lịch sử chat
//     await userRef.child(messageId).set(chatMessage);
//   }
// }
