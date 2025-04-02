import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class GetDataViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  var money = 0.obs; // Giá trị money sẽ được cập nhật ở đây

  @override
  void onInit() {
    super.onInit();
    fetchMoney();
  }

  void fetchMoney() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      print('User ID hiện tại: $userId'); // Kiểm tra xem userId có được lấy đúng không

      DatabaseReference moneyRef = _dbRef.child("users/$userId/money");

      moneyRef.onValue.listen((event) {
        final data = event.snapshot.value;
        if (data != null) {
          money.value = data as int; // Cập nhật giá trị money
          print('Số tiền hiện tại: $money'); // Kiểm tra giá trị money
        } else {
          print('Không tìm thấy dữ liệu số tiền cho user $userId');
        }
      });
    } else {
      print('Không tìm thấy người dùng nào đang đăng nhập.');
    }
  }


  void updateMoney(int addedMoney) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference moneyRef = _dbRef.child("users/$userId/money");

      moneyRef.once().then((DatabaseEvent event) {
        final data = event.snapshot.value;
        int currentMoney = (data != null) ? data as int : 0;
        int updatedMoney = currentMoney + addedMoney;
        moneyRef.set(updatedMoney);
        money.value = updatedMoney; // Cập nhật giá trị money trong app
      });
    }
  }
}
