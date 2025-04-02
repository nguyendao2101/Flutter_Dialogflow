import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/View/chat_view.dart';
import 'package:freechat_dialogflow/Widgets/common/color_extentionn.dart';
import 'package:freechat_dialogflow/Widgets/images/image_extention.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Model/location_model.dart';
import '../Model/weather_model.dart';
import '../ViewModel/user_view_model.dart';
import '../Widgets/common_widget/show_bottom/show_bottom_by_coins.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _cityController = TextEditingController();
  String _temperature = ''; // biến lưu nhiệt độ
  String _description = ''; // biến mô tả thời tiết
  String _icon = ''; // biến miêu tả mã icon thời tiết
  String _errorMessage = ''; //biến để lưu trữ thông báo lỗi nếu có
  final WeatherService _weatherService = WeatherService();
  String location = ' '; // biến lưu vị trí hiện tại
  final controller = Get.put(UserViewModel());
  RxMap<dynamic, dynamic> userData = {}.obs;

  String getCity(String location) {
    // Tách chuỗi location theo dấu phẩy (',') thành một danh sách
    List<String> parts = location.split(',');

    // Lọc phần chứa từ "City"
    for (var part in parts) {
      if (part.contains('City')) {
        // Cắt bỏ phần 'City: ' và trả về tên thành phố
        return part.split(':')[1].trim();
      }
    }
    return ''; // Trả về chuỗi rỗng nếu không tìm thấy City
  }
  

  Future<void> fetchWeather(String city) async {
    try {
      final data = await _weatherService.fetchWeather(city);
      setState(() {
        // cập nhật lại giá trị các biến lưu trữ
        _temperature = data['current']['temp_c'].toString();
        _description = data['current']['condition']['text'];
        _icon = data['current']['condition']['icon'];
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không tìm thấy thời tiết thành phố này';
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userData = controller.userData;
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ChatColor.background,
          iconTheme: IconThemeData(color: ChatColor.gray4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    ImageAssest.drawerHome,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    'ChatMate',
                    style: TextStyle(
                        fontSize: 24,
                        height: 1.75,
                        color: ChatColor.almond,
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      ImageAssest.iconStar,
                      width: 13.89,
                      height: 11.05,
                    ),
                    const SizedBox(
                        width: 5), // Khoảng cách giữa biểu tượng và văn bản
                    Text(controller.userData['money'].toString()),
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: ChatColor.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const ChatScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ChatColor.almond),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            top: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nhấn để trò chuyện',
                                style: TextStyle(
                                    fontSize: 24,
                                    height: 2.25,
                                    color: ChatColor.background,
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.bold),
                              ),
                              Image.asset(
                                ImageAssest.arrowRight,
                                width: 60,
                                height: 52.48,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                ImageAssest.logoHome,
                                height: 40,
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8,),
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: ChatColor.almond2,
                                        borderRadius: const BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: Text('Hãy hỏi tôi bất kỳ câu hỏi nào bạn có. Tôi có thể trả lời tất cả các câu hỏi và trò chuyện với bạn về y tế.', style: TextStyle(fontFamily: 'PlusJakartaSans'),),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          _title('Lịch'),
              const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                width: 330,
                child: SfCalendar(
                  view: CalendarView.month, // Đặt chế độ xem của lịch là dạng tháng.
                  initialSelectedDate: DateTime.now(), // Đặt ngày được chọn ban đầu là ngày hiện tại.

                  headerStyle: CalendarHeaderStyle(
                    textAlign: TextAlign.center, // Canh giữa tiêu đề của tháng.
                    backgroundColor: ChatColor.almond, // Màu nền cho phần tiêu đề tháng.
                    textStyle: TextStyle(
                      fontSize: 20, // Cỡ chữ của tiêu đề tháng.
                      color: ChatColor.background, // Màu chữ của tiêu đề tháng.
                      fontWeight: FontWeight.bold, // Đặt tiêu đề tháng đậm.
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),

                  viewHeaderStyle: ViewHeaderStyle(
                    backgroundColor: ChatColor.gray4, // Màu nền cho tiêu đề của các ngày trong tuần.
                    dayTextStyle: TextStyle(
                      fontSize: 16, // Cỡ chữ của ngày trong tiêu đề tuần.
                      color: ChatColor.background, // Màu chữ của ngày trong tiêu đề tuần.
                      fontFamily: 'PlusJakartaSans',
                    ),
                  ),

                  monthViewSettings: MonthViewSettings(
                    appointmentDisplayMode: MonthAppointmentDisplayMode.indicator, // Hiển thị sự kiện dưới dạng chấm chỉ báo.
                    showTrailingAndLeadingDates: true, // Hiển thị ngày của tháng trước và sau tháng hiện tại.
                    dayFormat: 'EEE', // Định dạng chữ viết tắt của ngày (ví dụ: Thứ 2 -> Mon).
                    appointmentDisplayCount: 2, // Số lượng sự kiện hiển thị tối đa trong một ngày.

                    monthCellStyle: MonthCellStyle(
                      // todayBackgroundColor: ChatColor.almond, // Màu nền cho ô ngày hiện tại.
                      backgroundColor: Colors.transparent, // Màu nền cho các ô khác.
                      leadingDatesBackgroundColor: Colors.transparent, // Màu nền cho các ngày của tháng trước.
                      trailingDatesBackgroundColor: Colors.transparent, // Màu nền cho các ngày của tháng sau.

                      textStyle: TextStyle(
                        color: ChatColor.gray4, // Màu chữ của các ngày trong tháng hiện tại.
                        fontSize: 14, // Cỡ chữ của các ngày trong tháng hiện tại.
                        fontFamily: 'PlusJakartaSans',
                      ),

                      leadingDatesTextStyle: const TextStyle(
                        color: Colors.grey, // Màu chữ của các ngày tháng trước đó (màu xám).
                        fontSize: 14, // Cỡ chữ của các ngày tháng trước đó.
                        fontFamily: 'PlusJakartaSans',
                      ),

                      trailingDatesTextStyle: const TextStyle(
                        color: Colors.grey, // Màu chữ của các ngày tháng sau (màu xám).
                        fontSize: 14, // Cỡ chữ của các ngày tháng sau.
                        fontFamily: 'PlusJakartaSans',
                      ),

                      todayTextStyle: TextStyle(
                        color: ChatColor.background, // Màu chữ cho ngày hôm nay.
                        fontWeight: FontWeight.bold, // Chữ ngày hôm nay sẽ in đậm.
                        fontSize: 16, // Cỡ chữ của ngày hôm nay.
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Padding _title(String title){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: ChatColor.lightGray, fontWeight: FontWeight.bold, fontFamily: 'PlusJakartaSans'),),
          Text('Xem thêm', style: TextStyle(fontSize: 16, color: ChatColor.gray7, fontWeight: FontWeight.bold, fontFamily: 'PlusJakartaSans'),)
        ],
      ),
    );
  }
}
