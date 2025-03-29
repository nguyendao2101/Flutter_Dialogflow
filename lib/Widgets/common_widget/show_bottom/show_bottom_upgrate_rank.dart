import 'package:flutter/material.dart';

void showBottomUpgrateRank(BuildContext context) {
  int selectedOption = 0;
  final List<Map<String, dynamic>> upgradeOptions = [
    {'title': '1 Tuần', 'price': '50 coins'},
    {'title': '1 Tháng', 'price': '150 coins'},
    {'title': '1 Quý', 'price': '400 coins'},
    {'title': '1 Năm', 'price': '1.5K coins'},
  ];

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
                      'Nâng cấp tài khoản Pro',
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
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          decoration: BoxDecoration(
                            color: selectedOption == index ? Color(0xffDB2127) : Colors.white,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                upgradeOptions[index]['title'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: selectedOption == index ? Colors.white : Colors.black, fontFamily: 'PlusJakartaSans',
                                ),
                              ),
                              Text(
                                upgradeOptions[index]['price'],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: selectedOption == index ? Colors.white : Colors.black, fontFamily: 'PlusJakartaSans',
                                ),
                              ),
                            ],
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
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        // Xử lý logic thanh toán
                      },
                      child: const Text(
                        'Xác nhận nâng cấp',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'PlusJakartaSans'),
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