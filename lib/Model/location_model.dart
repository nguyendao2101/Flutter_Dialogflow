import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Hàm lấy vị trí hiện tại và thông tin địa chỉ
  Future<String> getCurrentLocationAndAddress() async {
    // Kiểm tra quyền truy cập vị trí
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra xem dịch vụ vị trí có được bật hay không
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Kiểm tra quyền truy cập vị trí
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Nếu quyền bị từ chối, yêu cầu quyền
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }

    // Lấy vị trí hiện tại
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Lấy địa chỉ từ tọa độ
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      // print('from place: ${placemark}');

      // Lấy thông tin thành phố và quốc gia, nếu null thì sẽ dùng giá trị mặc định
      String city = placemark.administrativeArea ?? placemark.subLocality ?? placemark.administrativeArea ?? "Hà Nội";
      String country = placemark.country ?? "Unknown Country";

      // Trả về thông tin địa chỉ và vị trí
      return 'District: ${placemark.subAdministrativeArea}, City: $city, \nCountry: $country';
    } else {
      return 'No address found.';
    }
  }
}
