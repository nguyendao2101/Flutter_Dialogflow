import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freechat_dialogflow/Widgets/common_widget/show_bottom/show_bottom_payment_success.dart';
import 'package:get/get.dart';
import 'package:vnpay_flutter/vnpay_flutter.dart';

import '../../../ViewModel/get_data_view_model.dart';

Future<String> onPayment(double amount) async {
  final completer = Completer<String>();
  String responseCode = '';

  final paymentUrl = VNPAYFlutter.instance.generatePaymentUrl(
    url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
    version: '2.0.1',
    tmnCode: 'YLLVXBWY',
    txnRef: DateTime.now().millisecondsSinceEpoch.toString(),
    orderInfo: 'Pay $amount VND',
    amount: amount,
    returnUrl: 'https://sandbox.vnpayment.vn/merchant_webapi/api/transaction',
    ipAdress: '192.168.10.10',
    vnpayHashKey: '1J9MHQHA5NK9C4J3D26CZO1HAPO02IJY',
    vnPayHashType: VNPayHashType.HMACSHA512,
    vnpayExpireDate: DateTime.now().add(const Duration(hours: 1)),
  );

  await VNPAYFlutter.instance.show(
    paymentUrl: paymentUrl,
    onPaymentSuccess: (params) {
      responseCode = params['vnp_ResponseCode'] ?? 'No Response Code';
      print('Response Code on success: $responseCode');
      completer.complete(responseCode);
    },
    onPaymentError: (params) {
      responseCode = 'Error';
      print('Response Code on error: $responseCode');
      completer.complete(responseCode);
    },
  );

  return completer.future;
}

void showBottomByCoints(BuildContext context, ) {
  int selectedOption = 0;
  int money = 50000;
  int coins = 50;
  // String responseCode = '';
  final List<Map<String, dynamic>> upgradeOptions = [
    {'price': '50.000 đ'},
    {'price': '150.000 đ'},
    {'price': '400.000 đ'},
    {'price': '1.500.000 đ'},
  ];
  final controllerGetData = Get.put(GetDataViewModel());

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.3),
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return FractionallySizedBox(
            heightFactor: 0.6,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Nạp ví vào tài khoản của bạn',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(upgradeOptions.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = index;
                            money = int.parse(
                                upgradeOptions[index]['price'].replaceAll(
                                    RegExp(r'\D'), ''));
                            if (money == 50000) {
                              coins = 50;
                            } else if (money == 150000) {
                              coins = 150;
                            } else if (money == 400000) {
                              coins = 400;
                            } else {
                              coins = 1500;
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: selectedOption == index
                                ? Color(0xffDB2127)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            upgradeOptions[index]['price'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: selectedOption == index
                                  ? Colors.white
                                  : Colors.black, fontFamily: 'PlusJakartaSans',
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff1F2D44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14,
                            horizontal: 50),
                      ),
                      onPressed: () async {
                        print('money: $money');
                        String responseCode = await onPayment(money.toDouble());
                        if (responseCode == '00') {
                          controllerGetData.updateMoney(coins);
                          Navigator.pop(context);
                          showPaymentMethod(context);
                        }
                      },

                      child: const Text(
                        'Xác nhận nạp ví',
                        style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'PlusJakartaSans'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

