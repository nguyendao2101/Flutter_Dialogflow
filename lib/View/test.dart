// // ignore_for_file: library_private_types_in_public_api, unnecessary_brace_in_string_interps
//
// import 'package:flutter/material.dart';
// import 'package:lab1/Widgets/weatherService.dart';
//
// class Lab4 extends StatefulWidget {
//   const Lab4({super.key});
//
//   @override
//   _Lab4State createState() => _Lab4State();
// }
//
// class _Lab4State extends State<Lab4> {
//   final _cityController = TextEditingController();
//   String _temperature = ''; // biến lưu nhiệt độ
//   String _description = ''; // biến mô tả thời tiết
//   String _icon = ''; // biến miêu tả mã icon thời tiết
//   String _errorMessage = ''; //biến để lưu trữ thông báo lỗi nếu có
//
//   final WeatherService _weatherService = WeatherService();
//
//   Future<void> fetchWeather(String city) async {
//     try {
//       final data = await _weatherService.fetchWeather(city);
//       setState(() {
//         // cập nhật lại giá trị các biến lưu trữ
//         _temperature = data['current']['temp_c'].toString();
//         _description = data['current']['condition']['text'];
//         _icon = data['current']['condition']['icon'];
//         _errorMessage = '';
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Không tìm thấy thời tiết thành phố này';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lab 4: Ứng Dụng Thời Tiết với Fetch API'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               // nhập dữ liệu
//               controller: _cityController, // lấy dữ liệu nhập vào
//               decoration: const InputDecoration(
//                 labelText: 'Nhập tên thành phố',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               // gửi yêu cầu lấy dữ liệu thời tiết
//               onPressed: () {
//                 fetchWeather(_cityController.text);
//               },
//               child: const Text('Lấy Dữ Liệu Thời Tiết'),
//             ),
//             const SizedBox(height: 20),
//             if (_temperature.isNotEmpty)
//               Column(
//                 children: [
//                   Text(
//                     'Nhiệt độ: $_temperature°C',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   Text(
//                     'Mô tả: $_description',
//                     style: const TextStyle(fontSize: 24),
//                   ),
//                   Image.network(
//                     'https:${_icon}',
//                   ),
//                 ],
//               ),
//             if (_errorMessage.isNotEmpty)
//               Text(
//                 _errorMessage,
//                 style: const TextStyle(color: Colors.red, fontSize: 24),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }