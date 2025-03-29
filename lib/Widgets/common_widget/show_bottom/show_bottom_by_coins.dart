import 'package:flutter/material.dart';

import '../basic_app_button/basic_app_button.dart';


void showBottomByCoints(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    barrierColor: Colors.black.withOpacity(0.3),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.6,
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xffD9D9D9),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BasicAppButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: 'Block',
                    sizeTitle: 16,
                    radius: 12,
                    colorButton: Colors.white,
                    height: 50,
                    fontW: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}