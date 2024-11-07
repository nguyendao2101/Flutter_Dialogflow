import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  final String apiKey =
      '77ef496480144bb294e93632241608'; // API key từ dịch vụ mới
  final String baseUrl = 'https://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    // kết quả trả về là một bản đồ (dictionary) với các khóa và giá trị động.
    final url =
        '$baseUrl/current.json?key=$apiKey&q=$city'; // gửi yêu cầu đến api

    try {
      // thử thực hiện yêu cầu HTTP và xử lý dữ liệu trả về
      final response = await http.get(Uri.parse(url)); // gửi yêu cầu get
      if (response.statusCode == 200) {
        // kiểm tra mã trạng thái phản hồi
        return jsonDecode(response
            .body); // giải mã dữ liệu json từ phản hồi và trả về dưới dạng bản đồ
      } else {
        throw Exception(
            'Lỗi khi lấy dữ liệu thời tiết.'); // nếu không phải 200 đưa ra thông báo
      }
    } catch (e) {
      //bắt lỗi
      throw Exception('Có lỗi xảy ra: $e');
    }
  }
}