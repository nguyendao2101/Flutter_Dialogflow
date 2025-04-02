import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class GetDataViewModel extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  var money = 0.obs; // Giá trị money sẽ được cập nhật ở đây
  var rank = "Normal".obs;
  var timePro = "".obs;

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
  void updateByMoney(int addedMoney) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference moneyRef = _dbRef.child("users/$userId/money");

      moneyRef.once().then((DatabaseEvent event) {
        final data = event.snapshot.value;
        int currentMoney = (data != null) ? data as int : 0;
        int updatedMoney = currentMoney - addedMoney;
        moneyRef.set(updatedMoney);
        money.value = updatedMoney; // Cập nhật giá trị money trong app
      });
    }
  }
  void updateRank(String duration) async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference userRef = _dbRef.child("users/$userId");

      DateTime now = DateTime.now();
      DateTime expiryDate;

      switch (duration) {
        case "1 Tuần":
          expiryDate = now.add(Duration(days: 7));
          break;
        case "1 Tháng":
          expiryDate = now.add(Duration(days: 30));
          break;
        case "1 Qúy":
          expiryDate = now.add(Duration(days: 90));
          break;
        case "1 Năm":
          expiryDate = now.add(Duration(days: 365));
          break;
        default:
          print("Thời gian không hợp lệ");
          return;
      }

      String formattedExpiryDate = DateFormat('yyyy-MM-dd').format(expiryDate);

      userRef.update({
        "ranking": "Pro",
        "timePro": formattedExpiryDate
      }).then((_) {
        rank.value = "Pro";
        timePro.value = formattedExpiryDate;
        print("Cập nhật rank thành công: Pro đến $formattedExpiryDate");
      }).catchError((error) {
        print("Lỗi khi cập nhật rank: $error");
      });
    }
  }
  Future<bool> canAskQuestion() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      DatabaseReference userRef = _dbRef.child("users/$userId");
      DataSnapshot snapshot = await userRef.get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
          int questionCount = data["dailyQuestions"] ?? 0;
          String lastDate = data["lastAskedDate"] ?? "";
          String userRank = data["rank"] ?? "Normal";

          if (userRank == "Pro") return true;

          if (lastDate != today) {
            userRef.update({
              "dailyQuestions": 1,
              "lastAskedDate": today
            });
            return true;
          } else {
            if (questionCount < 50) {
              userRef.update({
                "dailyQuestions": questionCount + 1
              });
              return true;
            } else {
              return false;
            }
          }
        }
      }
    }
    return false;
  }
}
